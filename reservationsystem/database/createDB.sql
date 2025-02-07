CREATE DATABASE IF NOT EXISTS reservation_system;

USE reservation_system;

CREATE TABLE IF NOT EXISTS clients (
  id INT AUTO_INCREMENT PRIMARY KEY,  
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  phone_number VARCHAR(16),
  email VARCHAR(128) UNIQUE
);

INSERT INTO clients (first_name, last_name, phone_number, email) 
SELECT * FROM (SELECT 'Walk' AS first_name, 'In' AS last_name, NULL AS phone_number, NULL AS email) AS temp
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE first_name = 'Walk' AND last_name = 'In' AND phone_number IS NULL AND email IS NULL)
LIMIT 1;

CREATE TABLE IF NOT EXISTS reservations (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  client INT NOT NULL,
  `when` DATETIME NOT NULL,
  duration INT NOT NULL,
  number_people SMALLINT NOT NULL,
  `status` ENUM('Pending', 'Booked', 'Confirmed', 'Cancelled', 'No Show') NOT NULL,
  client_notes VARCHAR(1024),
  business_notes VARCHAR(1024),
  FOREIGN KEY (client) REFERENCES clients(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS reservation_tags (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reservation INT NOT NULL, 
  -- can still add more possible tags here
  tag ENUM('VIP', 'First Visit', 'Date Night', 'Birthday', 'Anniversary') NOT NULL,
  FOREIGN KEY (reservation) REFERENCES reservations(id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- CREATE TABLE account_data (
--   id INT AUTO_INCREMENT PRIMARY KEY,
--   client_id INT,
--   date_created DATE NOT NULL,
--   total_transactions INT DEFAULT 0,
--   total_spend DECIMAL(10,2) DEFAULT 0.00,
--   next_transaction INT DEFAULT NULL,
--   last_transaction INT DEFAULT NULL,
--   no_shows INT DEFAULT 0,
--   cancellations INT DEFAULT 0,
--   FOREIGN KEY (client_id) REFERENCES clients(id)
--     ON DELETE CASCADE 
--     ON UPDATE CASCADE,
--   FOREIGN KEY (next_transaction) REFERENCES transactions(id)
--     ON DELETE SET NULL 
--     ON UPDATE CASCADE,
--   FOREIGN KEY (last_transaction) REFERENCES transactions(id)
--     ON DELETE SET NULL 
--     ON UPDATE CASCADE
-- );