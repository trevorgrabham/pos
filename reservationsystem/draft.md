## General Idea

A web server for the reservation system.

The main parts will be the server which will be the source of truth for all of the data, the interface which will be contacting the server and will act as the view of the data for any employees of the company, and the client side which will allow for clients to view their own reservation information, create a reservation, or change/cancel a resrevation.

#### Endpoints

- add reservation
- cancel reservation
- request reservations within a date range
- request all reservations for a given client
- find all available time slots for a given date range
- htmx for the front end for testing

#### Storage

For persistant storage, this must be handled on the server side. We will use a database for this.

Persistant storage can also be done on the interface for use offline. For testing this will likely be done using indexedDB on the interface browser, but in production we can look into either a sqlite DB or internal file storage if we create an application. Adding persistant storage on the interface allows for offline reads, and it allows us to have the flexibility to be able to either close the reservation API if we are offline or leaving it open (in most cases we should probably leave it closed by default (not allow more new reservations to come in, but we could maybe allow for cancellations)).

For data manipulation on the server side, we should keep track of any new reservations or cancellations that have happened since we last sent the data to the interface. We can wipe this list whenever the data is sent. This means that we keep this list in memory, but we should be able to move it to long term storage in the case that this list becomes too long. If we don't allow for reservation changes when the interface is offline then this list just allows us to keep the data for the client side to see, but in the case that we do, this list will be waiting to be sent to the interface when it comes back online.
TODO: should look into server sent events to detect whether the interface is online.

#### Reservation Data

- status (booked, cancelled, pending, etc.)
- client
- date
- time
- number of people
- duration
- optional client side notes
- optional business side notes
- other tags? maybe?
