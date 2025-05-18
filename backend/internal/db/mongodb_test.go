package db

import (
	"context"
	"testing"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/models"
	"go.mongodb.org/mongo-driver/bson"
)

type MockCollection struct {
	data []models.Alarm
}

func (mc *MockCollection) InsertOne(ctx context.Context, alarm models.Alarm) error {
	mc.data = append(mc.data, alarm)
	return nil
}

func (mc *MockCollection) Find(ctx context.Context, filter interface{}) ([]models.Alarm, error) {
	return mc.data, nil
}

func TestSaveAndGetAlarmsWithMock(t *testing.T) {
	mockCollection := &MockCollection{}

	// Mock data
	alarm := models.Alarm{
		ID:        "1",
		Time:      "08:00",
		Latitude:  "37.7749",
		Longitude: "-122.4194",
		Keywords:  []string{"birds"},
		Poem:      "A poem inspired by: birds",
	}

	// Insert mock data
	err := mockCollection.InsertOne(context.TODO(), alarm)
	if err != nil {
		t.Fatalf("Failed to insert mock alarm: %v", err)
	}

	// Retrieve data
	alarms, err := mockCollection.Find(context.TODO(), bson.M{})
	if err != nil {
		t.Fatalf("Failed to retrieve alarms: %v", err)
	}

	if len(alarms) != 1 {
		t.Errorf("Expected 1 alarm, got %d", len(alarms))
	}

	if alarms[0].Latitude != "37.7749" {
		t.Errorf("Expected Latitude to be 37.7749, got %s", alarms[0].Latitude)
	}

	if alarms[0].Longitude != "-122.4194" {
		t.Errorf("Expected Longitude to be -122.4194, got %s", alarms[0].Longitude)
	}
}
