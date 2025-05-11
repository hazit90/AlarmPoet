package handlers

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestCreateAlarm(t *testing.T) {
	req := httptest.NewRequest("POST", "/v1/alarms", strings.NewReader(`{"id":"1","time":"08:00","timezone":"UTC","keywords":["birds"]}`))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	CreateAlarm(w, req)

	if w.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, w.Code)
	}

	if !strings.Contains(w.Body.String(), "poem") {
		t.Errorf("Expected response to include 'poem', got %s", w.Body.String())
	}
}

func TestListAlarms(t *testing.T) {
	req := httptest.NewRequest("GET", "/v1/alarms", nil)
	w := httptest.NewRecorder()

	ListAlarms(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, w.Code)
	}
}
