package db

import (
	"database/sql"
	"testing"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/models"

	"github.com/DATA-DOG/go-sqlmock"
)

var mock sqlmock.Sqlmock

func setupMockDB(t *testing.T) {
	var dbMock *sql.DB
	var err error
	dbMock, mock, err = sqlmock.New()
	if err != nil {
		t.Fatalf("Failed to create mock database: %v", err)
	}
	db = dbMock
}

func TestSaveAndGetAlarmsWithMock(t *testing.T) {
	setupMockDB(t)

	mock.ExpectExec("INSERT INTO alarms").WithArgs("08:00", "37.7749", "-122.4194", sqlmock.AnyArg(), "A poem inspired by: birds").WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectQuery("SELECT id, time, latitude, longitude, keywords, poem FROM alarms").WillReturnRows(
		sqlmock.NewRows([]string{"id", "time", "latitude", "longitude", "keywords", "poem"}).AddRow("1", "08:00", "37.7749", "-122.4194", `{"birds"}`, "A poem inspired by: birds"),
	)

	alarm := models.Alarm{
		ID:        "1",
		Time:      "08:00",
		Latitude:  "37.7749",
		Longitude: "-122.4194",
		Keywords:  []string{"birds"},
	}
	SaveAlarm(alarm)

	alarms := GetAlarms()
	if len(alarms) != 1 {
		t.Errorf("Expected 1 alarm, got %d", len(alarms))
	}

	if alarms[0].Latitude != "37.7749" {
		t.Errorf("Expected Latitude to be 37.7749, got %s", alarms[0].Latitude)
	}

	if alarms[0].Longitude != "-122.4194" {
		t.Errorf("Expected Longitude to be -122.4194, got %s", alarms[0].Longitude)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("There were unfulfilled expectations: %s", err)
	}
}
