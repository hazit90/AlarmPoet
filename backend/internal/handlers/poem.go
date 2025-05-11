package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/rohgupta/alarm/AlarmPoet/backend/internal/services"
)

// Package handlers contains the HTTP handlers for the AlarmPoet application.
// This file implements the poem generation logic.

type PoemRequest struct {
	Keywords []string `json:"keywords"`
}

type PoemResponse struct {
	Poem string `json:"poem"`
}

// GeneratePoem handles the generation of a poem based on user-provided keywords.
// It expects a JSON payload with keywords and responds with a generated poem.
// Responds with HTTP 200 on success.
func GeneratePoem(w http.ResponseWriter, r *http.Request) error {
	var req PoemRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return err
	}
	poem := services.GeneratePoem(req.Keywords)
	resp := PoemResponse{Poem: poem}
	json.NewEncoder(w).Encode(resp)
	return nil
}
