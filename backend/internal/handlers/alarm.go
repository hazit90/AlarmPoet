package handlers

import (
	"backend/internal/db"
	"backend/internal/models"
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

// Package handlers contains the HTTP handlers for the AlarmPoet application.
// This file implements CRUD operations for alarms.

// CreateAlarm handles the creation of a new alarm.
// It expects a JSON payload with alarm details and saves it to the database.
// Responds with HTTP 201 on success.
func CreateAlarm(w http.ResponseWriter, r *http.Request) {
	var alarm models.Alarm
	if err := json.NewDecoder(r.Body).Decode(&alarm); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	db.SaveAlarm(alarm)
	w.WriteHeader(http.StatusCreated)
}

// ListAlarms retrieves all alarms from the database.
// Responds with a JSON array of alarms.
func ListAlarms(w http.ResponseWriter, r *http.Request) {
	alarms := db.GetAlarms()
	json.NewEncoder(w).Encode(alarms)
}

// UpdateAlarm updates an existing alarm identified by its ID.
// It expects a JSON payload with updated alarm details.
// Responds with HTTP 200 on success.
func UpdateAlarm(w http.ResponseWriter, r *http.Request) {
	var alarm models.Alarm
	if err := json.NewDecoder(r.Body).Decode(&alarm); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}
	vars := mux.Vars(r)
	alarmID := vars["alarm_id"]
	db.UpdateAlarm(alarmID, alarm)
	w.WriteHeader(http.StatusOK)
}

// DeleteAlarm deletes an alarm identified by its ID.
// Responds with HTTP 204 on success.
func DeleteAlarm(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	alarmID := vars["alarm_id"]
	db.DeleteAlarm(alarmID)
	w.WriteHeader(http.StatusNoContent)
}
