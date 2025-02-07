package reservationsystem

import "time"

type Storage interface {
	Save(data []byte) bool
	Load() ([]byte, error)
}

type ReservationStatus uint8
const (
	Pending ReservationStatus = iota
	Booked
	Confirmed
	Cancelled
	NoShow
)

type Reservation struct {
	Status 				ReservationStatus
	ClientID 			uint32
	Date 					time.Time
	Start    			time.Time
	Duration 			uint32
	NumPeople 		uint16
	ClientNotes 	string
	BusinessNotes string
	// Quote    float64
	// MetaData
}

// type MetaData struct {
// }

type Day struct {
	Reservations []Reservation
	Open         bool
}

func init() {

}