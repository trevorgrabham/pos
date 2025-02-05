package json

import (
	"time"

	"github.com/trevorgrabham/POS/reservationsystem"
)

type JSONReservations struct {
	data []reservationsystem.Day 
}

func (j *JSONReservations) Between(start, end time.Time) []reservationsystem.Day