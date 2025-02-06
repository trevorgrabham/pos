## General Idea

A web server for the reservation system

#### Endpoints

- add reservation
- cancel reservation
- request reservations within a date range
- request all reservations for a given client
- htmx for the front end for testing

#### Storage

If we can get the size of the reservation data, we should be able to store all of the reservations within main memory (trying to keep within a couple GB or so).

We can support multiple forms of persistant storage, allowing for JSON for testing and a database for production.

#### Reservation Data

- client
- date
- time
- number of people
- duration
- optional client side notes
- optional business side notes
- other tags? maybe?
