package routes

import (
	"context"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"server/models"
	"server/mongodb"
)

// RegisterRoutes to register new users
func RegisterRoutes(r *gin.Engine) {
	r.POST("/register", func(c *gin.Context) {
		var newUser models.User
		if err := c.ShouldBindJSON(&newUser); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request data"})
			return
		}

		collection := mongodb.Client.Database("mydatabase").Collection("users")

		var existingUser models.User
		err := collection.FindOne(context.Background(), bson.M{"email": newUser.Email}).Decode(&existingUser)
		if err == nil {
			c.JSON(400, gin.H{"error": "Email already exists"})
			return
		}

		_, err = collection.InsertOne(context.Background(), newUser)
		if err != nil {
			c.JSON(500, gin.H{"error": "Failed to register user"})
			return
		}

		c.JSON(200, gin.H{
			"message": "User registered successfully!",
		})
	})
}
