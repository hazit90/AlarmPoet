package db

import (
	"backend/internal/models"
	"testing"
)

func TestSaveAndGetAlarms(t *testing.T) {
	alarm := models.Alarm{ID: "1", Time: "08:00", Timezone: "UTC", Keywords: []string{"birds"}}
	SaveAlarm(alarm)

	alarms := GetAlarms()
	if len(alarms) != 1 {
		t.Errorf("Expected 1 alarm, got %d", len(alarms))
	}
}

func TestUpdateAndDeleteAlarm(t *testing.T) {
	alarm := models.Alarm{ID: "1", Time: "08:00", Timezone: "UTC", Keywords: []string{"birds"}}
	SaveAlarm(alarm)

	updatedAlarm := models.Alarm{ID: "1", Time: "09:00", Timezone: "UTC", Keywords: []string{"sunrise"}}
	UpdateAlarm("1", updatedAlarm)

	alarms := GetAlarms()
	if alarms[0].Time != "09:00" {
		t.Errorf("Expected updated time to be 09:00, got %s", alarms[0].Time)
	}

	DeleteAlarm("1")
	alarms = GetAlarms()
	if len(alarms) != 0 {
		t.Errorf("Expected 0 alarms, got %d", len(alarms))
	}
}
