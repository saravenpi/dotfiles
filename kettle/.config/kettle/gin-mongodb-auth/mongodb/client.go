package mongodb

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"log"
)

var Client *mongo.Client

// Connect to MongoDB
func Init() {
	var err error
	Client, err = mongo.NewClient(options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		log.Fatal(err)
	}

	err = Client.Connect(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("MongoDB connected")
}
