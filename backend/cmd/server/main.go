package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/db"
	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/handlers"
)

// Package main is the entry point for the AlarmPoet backend server.
// It sets up the HTTP server and routes for the application.

func main() {
	// main initializes the HTTP server and starts listening for requests.

	// Initialize the database
	if err := db.InitDB(); err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}

	// Ensure the database connection is closed on shutdown
	defer db.CloseDB()

	r := mux.NewRouter()

	// Alarm routes
	r.HandleFunc("/v1/alarms", handlers.CreateAlarm).Methods("POST")
	r.HandleFunc("/v1/alarms", handlers.ListAlarms).Methods("GET")
	r.HandleFunc("/v1/alarms/delete", handlers.DeleteAllAlarms).Methods("POST")

	http.ListenAndServe(":8080", r)
}
