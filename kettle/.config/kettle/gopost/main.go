package main

import (
	"log"
	"os"

	"webserver/database"
	"webserver/routes"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	dbErr := database.Init()
	if dbErr != nil {
		log.Fatal("Failed to connect to database: ", dbErr)
	}
	r := gin.Default()

	// CORS configuration
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"}
	config.AllowMethods = []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}
	config.ExposeHeaders = []string{"Content-Length"}
	config.AllowCredentials = true
	r.Use(cors.New(config))

	// Setup routes
	routes.SetupPingRoute(r)
	routes.SetupAuthRoutes(r)

	// Get port from environment variable or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Start server
	err := r.Run(":" + port)
	if err != nil {
		log.Fatal("Failed to start server: ", err)
	}
}
