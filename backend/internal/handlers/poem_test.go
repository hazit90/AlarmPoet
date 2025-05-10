package handlers

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestGeneratePoem(t *testing.T) {
	req := httptest.NewRequest("POST", "/v1/poems/generate", strings.NewReader(`{"keywords":["mountains"]}`))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	GeneratePoem(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, w.Code)
	}
}
