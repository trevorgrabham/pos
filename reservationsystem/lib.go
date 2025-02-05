package reservationsystem

import "time"

type ReservationList interface {
	Between(start, end time.Time) []Day
	Add(reso Reservation) error 
	Cancel(reso Reservation) error 
}

type Reservation struct {
	ClientID uint32
	Start    time.Time
	Duration uint32
	// Quote    float64
	// MetaData
}

// type MetaData struct {
// }

type Day struct {
	Reservations []Reservation
	Open         bool
}

// CheckWeekOf(day time.Time) []Day