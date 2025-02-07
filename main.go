package main

import (
	"log"

	_ "github.com/trevorgrabham/pos/reservationsystem"
	"github.com/trevorgrabham/pos/reservationsystem/database"
)

func main() {
	rows, err := database.DB.Query("select * from clients")
	if err != nil { log.Fatal(err) }
	defer rows.Close()
}