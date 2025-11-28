package main

import (
	"log"
	"os"
	"server/mongodb"
	"server/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func getPortFromEnv() string {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	return port
}

func main() {
	var port string = getPortFromEnv()

	mongodb.Init()
	r := gin.Default()

	routes.PingRoutes(r)
	routes.LoginRoutes(r)
	routes.RegisterRoutes(r)

	err := r.Run(":" + port)
	if err != nil {
		panic(err)
	}
}
