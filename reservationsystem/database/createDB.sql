CREATE TABLE clients (
  id INT AUTO_INCREMENT PRIMARY KEY,  
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  phone_number VARCHAR(16),
  email VARCHAR(128)
);

CREATE TABLE transactions (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  `date` DATE NOT NULL, 
  `time` TIME NOT NULL,
  duration TIME
);

CREATE TABLE account_data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT,
  date_created DATE NOT NULL,
  total_transactions INT DEFAULT 0,
  total_spend DECIMAL(10,2) DEFAULT 0.00,
  next_transaction INT DEFAULT NULL,
  last_transaction INT DEFAULT NULL,
  no_shows INT DEFAULT 0,
  cancellations INT DEFAULT 0,
  FOREIGN KEY (client_id) REFERENCES clients(id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  FOREIGN KEY (next_transaction) REFERENCES transactions(id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE,
  FOREIGN KEY (last_transaction) REFERENCES transactions(id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);