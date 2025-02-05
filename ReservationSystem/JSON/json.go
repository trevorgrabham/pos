package json

import (
	"time"
)

type JSONReservations struct {
	data []reservationsystem.Day 
}

func (j *JSONReservations) Between(start, end time.Time) []reservationsystem.Day