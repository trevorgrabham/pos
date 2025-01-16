package db

import (
	"database/sql"
	"log"
	"os"

	"github.com/go-sql-driver/mysql"
)

var db *mysql.DB

func init() {
	cfg := mysql.Config{
		User:   os.Getenv("DBUSER"),
		Passwd: os.Getenv("DBPASS"),
		New:    "tcp",
		Addr:   os.Getenv("DBADDR"),
		DBName: os.Getenv("DBNAME"),
	}
	db, err := sql.Open("mysql", cfg.FormatDSN())
	if err != nil { log.Fatalf("opening %s: %v", os.Getenv("DBNAME"), err) }
	err = db.Ping()
	if err != nil { log.Fatalf("pinging %s: %v", os.Getenv("DBNAME"), err) }
}