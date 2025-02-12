package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/trevorgrabham/pos/reservationsystem"
)

var db *sql.DB
func GetDB() *sql.DB { return db }

func init() {
	err := godotenv.Load()
	if err != nil { log.Fatalf("loading env variables: %v", err) }
	cfg := mysql.Config{
		User:   os.Getenv("DBUSER"),
		Passwd: os.Getenv("DBPASS"),
		Net:    "tcp",
		Addr:   os.Getenv("DBADDR"),
		DBName: os.Getenv("DBNAME"),
	}
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatalf("opening %s: %v", os.Getenv("DBNAME"), err)
	}
	err = db.Ping()
	if err != nil {
		log.Fatalf("pinging %s: %v", os.Getenv("DBNAME"), err)
	}
}

// GetAvailability(from, to) returns all available time slots in the date range [from, to].
//
// If to.After(from) == false then nil is returned.
// 
// Availability is determined using settings from settings.json. 
// Specifically the `time-slot-granularity`, `duration-quota`, `max-sittings-per-slot`, and `offer-shorter-reservations` fields.
func GetAvailability(from, to time.Time, numPeople int) []reservationsystem.Reservation {
	// TODO: if from is after to then return nil
	// TODO: if from == to then just check a single 'date' else get the time intervals from the settings db and loop over date, adding the interval until date > to
	var date time.Time
	rows, err := db.Query(`
	SELECT GROUP_CONCAT(layout_requirements.table_id) AS 'tables', layouts.max_seats AS 'max seats' 
	FROM layout_requirements JOIN layouts ON layout_requirements.layout_id = layouts.id JOIN tables ON tables.id = layout_requirements.table_id
	WHERE layouts.max_seats = ? AND layouts.id NOT IN (
  	SELECT layout_id FROM layout_requirements WHERE table_id IN (
    	SELECT table_number FROM reservations WHERE NOT ( -- reservation doesn't collide if it either finishes before the start time, or starts after the end time
    	DATE_ADD(reservations.date_and_time, INTERVAL reservations.duration MINUTE) <= ? OR -- reservation finishes before the new start time
    	DATE_ADD(? , INTERVAL (SELECT minutes FROM time_quotas WHERE number_people = ?) MINUTE) <= reservations.date_and_time) -- reservation starts after the new one ends
	)) GROUP BY 'max seats', layout_id, tables.section, tables.seating_type ORDER BY tables.section, ABS(layouts.max_seats - layouts.optimal_seats) ASC, tables.seating_type`, numPeople, date, date, numPeople)
	// TODO: if we didn't get any results, then check one time interval before 'for' and one after 'to' to see if we have anything close. If still nothing then return nil
	if err != nil { log.Fatal(err) }
	fmt.Println(rows)
	return nil
}

// TODO: 
// finish flushing out the GetAvailability func
// we should transition away from a maximum number of resos per time slot and use a list of available tables instead