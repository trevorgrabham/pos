package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

var db *sql.DB

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
	fmt.Println(cfg)
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatalf("opening %s: %v", os.Getenv("DBNAME"), err)
	}
	err = db.Ping()
	if err != nil {
		log.Fatalf("pinging %s: %v", os.Getenv("DBNAME"), err)
	}
}

func GetDB() *sql.DB { return db }