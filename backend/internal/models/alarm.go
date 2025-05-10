package models

type Alarm struct {
	ID       string   `json:"id"`
	Time     string   `json:"time"`
	Timezone string   `json:"timezone"`
	Keywords []string `json:"keywords"`
}
