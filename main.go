package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/trevorgrabham/pos/reservationsystem/database"
)

func main() {
	db := database.GetDB();
	var firstName, lastName, phone, email sql.NullString
	err := db.QueryRow("select first_name, last_name, phone_number, email from clients").Scan(&firstName, &lastName, &phone, &email)
	if err != nil { log.Fatal(err) }
	if firstName.Valid {
		fmt.Printf("first_name = %s\n", firstName.String)
	} else { fmt.Println("first_name = NULL")}
	if lastName.Valid {
		fmt.Printf("last_name = %s\n", lastName.String)
	} else { fmt.Println("last_name = NULL")}
	if phone.Valid {
		fmt.Printf("phone = %s\n", phone.String)
	} else { fmt.Println("phone = NULL")}
	if email.Valid {
		fmt.Printf("email = %s\n", email.String)
	} else { fmt.Println("email = NULL")}
}