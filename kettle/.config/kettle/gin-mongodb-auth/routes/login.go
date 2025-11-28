package routes

import (
	"context"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"golang.org/x/crypto/bcrypt"
	"server/models"
	"server/mongodb"
)

// Login route to authenticate users
func LoginRoutes(r *gin.Engine) {
	r.POST("/login", func(c *gin.Context) {
		var loginUser models.User
		if err := c.ShouldBindJSON(&loginUser); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request data"})
			return
		}

		collection := mongodb.Client.Database("mydatabase").Collection("users")

		var existingUser models.User
		err := collection.FindOne(context.Background(), bson.M{"email": loginUser.Email}).Decode(&existingUser)
		if err != nil {
			c.JSON(400, gin.H{"error": "User does not exist"})
			return
		}

		err = bcrypt.CompareHashAndPassword([]byte(existingUser.Password), []byte(loginUser.Password))
		if err != nil {
			c.JSON(400, gin.H{"error": "Invalid password"})
			return
		}

		c.JSON(200, gin.H{
			"message": "Login successful!",
			"user":    existingUser,
		})
	})
}
