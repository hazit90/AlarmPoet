package db

import (
	"database/sql"
	"log"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/models"

	"github.com/lib/pq"
	_ "github.com/lib/pq"
)

// Package db contains the database interaction logic for the AlarmPoet application.
// This file implements PostgreSQL database operations for alarms.

var db *sql.DB

// InitDB initializes the PostgreSQL database.
func InitDB() error {
	var err error
	connStr := "user=yourusername password=yourpassword dbname=alarm_poet sslmode=disable"
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}

	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS alarms (
		id SERIAL PRIMARY KEY,
		time TEXT NOT NULL,
		latitude FLOAT NOT NULL,
		longitude FLOAT NOT NULL,
		keywords TEXT[],
		poem TEXT
	)`)
	if err != nil {
		log.Fatalf("Failed to create alarms table: %v", err)
	}
	return err
}

// SaveAlarm saves a new alarm to the PostgreSQL database.
func SaveAlarm(alarm models.Alarm) {
	InitDB()

	sqlResult, err := db.Exec(`INSERT INTO alarms (time, latitude, longitude, keywords, poem) VALUES ($1, $2, $3, $4, $5)`,
		alarm.Time, alarm.Latitude, alarm.Longitude, pq.Array(alarm.Keywords), alarm.Poem)
	if err != nil {
		log.Printf("Failed to save alarm: %v, %v", sqlResult, err)
	}
}

// GetAlarms retrieves all alarms from the PostgreSQL database.
func GetAlarms() []models.Alarm {
	InitDB()
	rows, err := db.Query(`SELECT id, time, latitude, longitude, keywords, poem FROM alarms`)
	if err != nil {
		log.Printf("Failed to retrieve alarms: %v", err)
		return nil
	}
	defer rows.Close()

	var alarms []models.Alarm
	for rows.Next() {
		var alarm models.Alarm
		var keywords []string
		if err := rows.Scan(&alarm.ID, &alarm.Time, &alarm.Latitude, &alarm.Longitude, pq.Array(&keywords), &alarm.Poem); err != nil {
			log.Printf("Failed to scan alarm: %v", err)
			continue
		}
		alarm.Keywords = keywords
		alarms = append(alarms, alarm)
	}

	return alarms
}

// DeleteAllAlarms deletes all alarms from the PostgreSQL database.
func DeleteAllAlarms() error {
	InitDB()
	_, err := db.Exec(`DELETE FROM alarms`)
	if err != nil {
		log.Printf("Failed to delete all alarms: %v", err)
		return err
	}
	log.Println("All alarms deleted successfully")
	return nil
}
