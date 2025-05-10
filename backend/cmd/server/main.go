package main

import (
	"backend/internal/handlers"
	"github.com/gorilla/mux"
	"net/http"
)

// Package main is the entry point for the AlarmPoet backend server.
// It sets up the HTTP server and routes for the application.

func main() {
	// main initializes the HTTP server and starts listening for requests.
	r := mux.NewRouter()

	// Alarm routes
	r.HandleFunc("/v1/alarms", handlers.CreateAlarm).Methods("POST")
	r.HandleFunc("/v1/alarms", handlers.ListAlarms).Methods("GET")
	r.HandleFunc("/v1/alarms/{alarm_id}", handlers.UpdateAlarm).Methods("PUT")
	r.HandleFunc("/v1/alarms/{alarm_id}", handlers.DeleteAlarm).Methods("DELETE")

	// Poem generation route
	r.HandleFunc("/v1/poems/generate", handlers.GeneratePoem).Methods("POST")

	http.ListenAndServe(":8080", r)
}
