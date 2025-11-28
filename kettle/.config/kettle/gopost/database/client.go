package database

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// DB represents a database connection
var DB *gorm.DB

// Init initializes the global database connection
func Init() error {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: Error loading .env file: %v", err)
	}

	// Get environment variables using standard PostgreSQL names
	host := os.Getenv("PGHOST")
	port := os.Getenv("PGPORT")
	user := os.Getenv("PGUSER")
	password := os.Getenv("PGPASSWORD")
	dbname := os.Getenv("PGDATABASE")

	// Debug: Print environment variables (remove in production)
	log.Printf("Database configuration: host=%s, port=%s, user=%s, dbname=%s",
		host, port, user, dbname)

	// Check if required environment variables are set
	if host == "" || port == "" || user == "" || password == "" || dbname == "" {
		return fmt.Errorf("missing required environment variables: PGHOST=%s, PGPORT=%s, PGUSER=%s, PGDATABASE=%s",
			host, port, user, dbname)
	}

	// Construct DSN (Data Source Name)
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable TimeZone=UTC",
		host, port, user, password, dbname)

	// Try to connect with some additional options
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		// You can add GORM configuration options here if needed
	})
	if err != nil {
		return fmt.Errorf("error connecting to the database: %w", err)
	}

	// Test the connection
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("error getting underlying sql.DB: %w", err)
	}

	err = sqlDB.Ping()
	if err != nil {
		return fmt.Errorf("error pinging database: %w", err)
	}

	log.Println("Successfully connected to the database")

	DB = db
	return nil
}

// Close closes the database connection
func Close() error {
	if DB != nil {
		sqlDB, err := DB.DB()
		if err != nil {
			return err
		}
		return sqlDB.Close()
	}
	return nil
}
