package models

type Alarm struct {
	ID        string   `json:"id"`
	Time      string   `json:"time"`
	Latitude  string   `json:"latitude"`
	Longitude string   `json:"longitude"`
	Keywords  []string `json:"keywords"`
	Poem      string   `json:"poem"`
}
