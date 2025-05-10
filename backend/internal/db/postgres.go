package db

import "backend/internal/models"

// Package db contains the database interaction logic for the AlarmPoet application.
// This file implements in-memory database operations for alarms.

var alarms = []models.Alarm{}

// InitDB initializes the in-memory database.
func InitDB() {}

// SaveAlarm saves a new alarm to the in-memory database.
func SaveAlarm(alarm models.Alarm) {
	alarms = append(alarms, alarm)
}

// GetAlarms retrieves all alarms from the in-memory database.
func GetAlarms() []models.Alarm {
	return alarms
}

// UpdateAlarm updates an existing alarm in the in-memory database.
func UpdateAlarm(id string, updatedAlarm models.Alarm) {
	for i, alarm := range alarms {
		if alarm.ID == id {
			alarms[i] = updatedAlarm
			break
		}
	}
}

// DeleteAlarm removes an alarm from the in-memory database.
func DeleteAlarm(id string) {
	for i, alarm := range alarms {
		if alarm.ID == id {
			alarms = append(alarms[:i], alarms[i+1:]...)
			break
		}
	}
}
