package routes

import (
	"github.com/gin-gonic/gin"
)

// SetupPingRoute registers the ping route in the given router
func SetupPingRoute(r *gin.Engine) {
	r.GET("/ping", handlePing)
}

func handlePing(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "pong",
	})
}
