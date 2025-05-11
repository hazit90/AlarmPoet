package handlers

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/db"
	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/models"
	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/services"
)

// Package handlers contains the HTTP handlers for the AlarmPoet application.
// This file implements CRUD operations for alarms.

// CreateAlarm handles the creation of a new alarm.
// It expects a JSON payload with alarm details and saves it to the database.
// Responds with HTTP 201 on success.
func CreateAlarm(w http.ResponseWriter, r *http.Request) {
	log.Println("CreateAlarm: Received request to create an alarm")
	var alarm models.Alarm
	if err := json.NewDecoder(r.Body).Decode(&alarm); err != nil {
		log.Printf("CreateAlarm: Invalid input: %v", err)
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}

	if alarm.Latitude == "" || alarm.Longitude == "" {
		log.Println("CreateAlarm: Latitude and Longitude cannot be empty")
		http.Error(w, "Latitude and Longitude cannot be empty", http.StatusBadRequest)
		return
	}

	// Generate a poem based on the alarm's keywords
	poem := services.GeneratePoem(alarm.Keywords)
	alarm.Poem = poem

	log.Printf("CreateAlarm: Saving alarm with time %s and poem %s", alarm.Time, alarm.Poem)
	db.SaveAlarm(alarm)
	w.WriteHeader(http.StatusCreated)
	log.Println("CreateAlarm: Alarm created successfully")
}

// ListAlarms retrieves all alarms from the database.
// Responds with a JSON array of alarms.
func ListAlarms(w http.ResponseWriter, r *http.Request) {
	log.Println("ListAlarms: Received request to list alarms")
	alarms := db.GetAlarms()
	log.Printf("ListAlarms: Retrieved %d alarms", len(alarms))
	json.NewEncoder(w).Encode(alarms)
	log.Println("ListAlarms: Response sent successfully")
}

// DeleteAllAlarms handles requests to delete all alarms.
// Responds with HTTP 200 on success.
func DeleteAllAlarms(w http.ResponseWriter, r *http.Request) {
	log.Println("DeleteAllAlarms: Received request to delete all alarms")
	err := db.DeleteAllAlarms()
	if err != nil {
		log.Printf("DeleteAllAlarms: Failed to delete alarms: %v", err)
		http.Error(w, "Failed to delete alarms", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	log.Println("DeleteAllAlarms: All alarms deleted successfully")
}
