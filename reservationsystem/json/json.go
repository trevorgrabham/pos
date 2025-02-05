package json

import (
	"time"

	"github.com/trevorgrabham/pos/reservationsystem"
)

type JSONReservations struct {
	data []reservationsystem.Day 
}

func (j *JSONReservations) Between(start, end time.Time) []reservationsystem.Day