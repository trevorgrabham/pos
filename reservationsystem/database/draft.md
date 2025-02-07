## General Idea

Create a database for persistant storage of all of the reservation data.

We will create a **_blank_** client for walk-in reservations.

## Tables

#### Client

id
: `INT PRIMARY KEY AUTO INCREMENT`

first name
: `VARCHAR(64) NOT NULL`

last name
: `VARCHAR(64) NOT NULL`

phone number
: `VARCHAR(16) NOT NULL`

email
: `VARCHAR(128) UNIQUE`

#### Reservations

id
: `INT PRIMARY KEY AUTO INCREMENT`

client
: `INT NOT NULL` _and_ `FOREIGN KEY (client) REFERENCES clients(id)`

when (`date` and `time`)
: `DATETIME NOT NULL`

duration (mins)
: `INT NOT NULL` _(use the max value for no time limit)_

number_people
: `SMALLINT NOT NULL`

status
: `ENUM('Pending', 'Booked', 'Confirmed', 'Cancelled', 'No Show') NOT NULL`

client_notes
: `VARCHAR(1023)`

business_notes
: `VARCHAR(1023)`

#### Reservation Tags

id
: `INT PRIMARY KEY AUTO INCREMENT`

reservation
: `INT NOT NULL` _and_ `FOREIGN KEY (reservation) REFERENCES reservations(id)`

tag
: `ENUM('VIP', 'First Visit', 'Date Night', 'Birthday', 'Anniversary', etc) NOT NULL`
