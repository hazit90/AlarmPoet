package utils

import (
	"encoding/json"
	"net/http"
)

// SendJSONResponse sends a JSON response with the given data and status code.
func SendJSONResponse(w http.ResponseWriter, data interface{}, statusCode int) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(data)
}

// SendErrorResponse sends an error response with the given message and status code.
func SendErrorResponse(w http.ResponseWriter, message string, statusCode int) {
	SendJSONResponse(w, map[string]string{"error": message}, statusCode)
}
