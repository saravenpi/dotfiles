package main

import (
	"log"
	"os"

	"webserver/routes" // Replace with your actual module name

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Setup routes
	routes.SetupPingRoute(r)

	// Get port from environment variable or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Start server
	if err := r.Run(":" + port); err != nil {
		log.Fatal("Failed to start server: ", err)
	}
}
