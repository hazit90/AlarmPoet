package db

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// MongoDB client and collection
var client *mongo.Client
var alarmCollection *mongo.Collection

// InitDB initializes the MongoDB client and connects to the alarms collection.
func InitDB() error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	uri := os.Getenv("MONGODB_URI")
	if uri == "" {
		uri = "mongodb://localhost:27017" // fallback for local dev
	}

	var err error
	client, err = mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		log.Fatalf("InitDB: Failed to connect to MongoDB: %v", err)
		return err
	}

	// Verify the connection
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatalf("InitDB: Failed to ping MongoDB: %v", err)
		return err
	}

	log.Println("InitDB: Successfully connected to MongoDB")

	// Set the alarms collection
	db := client.Database("alarm_poet")
	alarmCollection = db.Collection("alarms")
	return nil
}

// SaveAlarm saves a new alarm to the MongoDB database.
func SaveAlarm(alarm models.Alarm) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := alarmCollection.InsertOne(ctx, alarm)
	if err != nil {
		log.Printf("Failed to save alarm: %v", err)
	}
}

// GetAlarms retrieves all alarms from the MongoDB database.
func GetAlarms() []models.Alarm {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	cursor, err := alarmCollection.Find(ctx, bson.M{})
	if err != nil {
		log.Printf("Failed to retrieve alarms: %v", err)
		return nil
	}
	defer cursor.Close(ctx)

	var alarms []models.Alarm
	for cursor.Next(ctx) {
		var alarm models.Alarm
		if err := cursor.Decode(&alarm); err != nil {
			log.Printf("Failed to decode alarm: %v", err)
			continue
		}
		alarms = append(alarms, alarm)
	}

	if err := cursor.Err(); err != nil {
		log.Printf("Cursor error: %v", err)
	}

	return alarms
}

// DeleteAllAlarms deletes all alarms from the MongoDB database.
func DeleteAllAlarms() error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := alarmCollection.DeleteMany(ctx, bson.M{})
	if err != nil {
		log.Printf("Failed to delete all alarms: %v", err)
		return err
	}
	log.Println("All alarms deleted successfully")
	return nil
}

// CloseDB closes the MongoDB client connection gracefully.
func CloseDB() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := client.Disconnect(ctx); err != nil {
		log.Printf("CloseDB: Failed to close MongoDB connection: %v", err)
	} else {
		log.Println("CloseDB: MongoDB connection closed successfully")
	}
}
