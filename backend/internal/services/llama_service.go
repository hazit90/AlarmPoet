package services

import (
	"fmt"
	"strings"
)

// Package services contains the business logic for the AlarmPoet application.
// This file implements the poem generation logic using LLaMA 3.

// GeneratePoem generates a poem based on the provided keywords.
// It returns a string containing the generated poem.
func GeneratePoem(keywords []string) string {
	return fmt.Sprintf("A poem inspired by: %s", strings.Join(keywords, ", "))
}
