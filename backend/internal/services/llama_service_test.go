package services

import "testing"

func TestGeneratePoem(t *testing.T) {
	keywords := []string{"sunrise", "ocean"}
	poem := GeneratePoem(keywords)

	if poem == "" {
		t.Errorf("Expected a poem, got an empty string")
	}
}
