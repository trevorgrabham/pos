CREATE DATABASE IF NOT EXISTS reservation_system;

USE reservation_system;

-- CREATES 
CREATE TABLE IF NOT EXISTS tables (
  id INT PRIMARY KEY NOT NULL,
  section ENUM('dining room', 'lounge', 'bar'),
  seating_type ENUM('booth', 'table', 'bar')
);

INSERT INTO tables (id, section, seating_type)
SELECT * FROM (SELECT 0 as id, NULL as section, NULL as seating_type) AS temp 
WHERE NOT EXISTS (SELECT 1 FROM tables WHERE section IS NULL AND seating_type IS NULL)
LIMIT 1;

CREATE TABLE IF NOT EXISTS layouts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  max_seats INT NOT NULL,
  optimal_seats INT NOT NULL
);

CREATE TABLE IF NOT EXISTS layout_requirements (
  layout_id INT NOT NULL,
  table_id INT NOT NULL,
  PRIMARY KEY (layout_id, table_id),
  FOREIGN KEY (layout_id) REFERENCES layouts(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (table_id) REFERENCES tables(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

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
  table_number INT NOT NULL,
  client INT NOT NULL,
  date_and_time DATETIME NOT NULL,
  duration INT NOT NULL,
  number_people SMALLINT NOT NULL,
  reservation_status ENUM('Pending', 'Booked', 'Confirmed', 'Cancelled', 'No Show') NOT NULL,
  client_notes VARCHAR(1024),
  business_notes VARCHAR(1024),
  FOREIGN KEY (table_number) REFERENCES tables(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (client) REFERENCES clients(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS reservation_tags (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reservation INT NOT NULL, 
  tag ENUM('VIP', 'First Visit', 'Date Night', 'Birthday', 'Anniversary') NOT NULL, -- can still add more possible tags here
  FOREIGN KEY (reservation) REFERENCES reservations(id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS time_quotas (
  number_people INT NOT NULL UNIQUE,
  minutes INT NOT NULL
);

-- INSERTS

INSERT INTO tables (id, section, seating_type) VALUES 
(1, 'dining room', 'table'), (2, 'dining room', 'table'), (3, 'dining room', 'table'), (4, 'dining room', 'table'), (5, 'dining room', 'table'), (6, 'dining room', 'table'), (7, 'dining room', 'table'), 
(10, 'dining room', 'booth'), (11, 'dining room', 'booth'), (12, 'dining room', 'booth'), (13, 'dining room', 'booth'), (14, 'dining room', 'booth'), (15, 'dining room', 'booth'), 
(20, 'lounge', 'table'), (21, 'lounge', 'table'), (22, 'lounge', 'table'), (23, 'lounge', 'table'), (24, 'lounge', 'table'), (25, 'lounge', 'table'), 
(26, 'lounge', 'table'), (27, 'lounge', 'table'), (28, 'lounge', 'table'), 
(29, 'lounge', 'table'), (30, 'lounge', 'table'), (31, 'lounge', 'table'), (32, 'lounge', 'table'), (33, 'lounge', 'table'), (34, 'lounge', 'table'),
(40, 'bar', 'bar'), (41, 'bar', 'bar'), (42, 'bar', 'bar'), (43, 'bar', 'bar'), (44, 'bar', 'bar'), (45, 'bar', 'bar'), (46, 'bar', 'bar'), (47, 'bar', 'bar'), (48, 'bar', 'bar'), (49, 'bar', 'bar'), (50, 'bar', 'bar');

INSERT INTO layouts (max_seats, optimal_seats) VALUES 
-- Dining room
(1, 3), (2, 3), (3, 3), (4, 3), -- table 1/2
(1, 2), (2, 2), -- table 3
(1, 2), (2, 2), -- table 4
(1, 2), (2, 2), -- table 5
(1, 3), (2, 3), (3, 3), (4, 3), -- table 6/7
(1, 4), (2, 4), (3, 4), (4, 4), (5, 4), (6, 4), -- table 10
(1, 4), (2, 4), (3, 4), (4, 4), (5, 4), (6, 4), -- table 11
(1, 4), (2, 4), (3, 4), (4, 4), (5, 4), (6, 4), -- table 12 
(1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8), (7, 8), (8, 8), (9, 8), (10, 8), -- table 13 
(1, 3), (2, 3), (3, 3), (4, 3), (5, 3), (6, 3), -- table 14 
(1, 3), (2, 3), (3, 3), (4, 3), (5, 3), (6, 3), -- table 15
-- Lounge 
(1, 2), (2, 2), -- table 21
(1, 2), (2, 2), -- table 22
(1, 2), (2, 2), -- table 23
(1, 2), (2, 2), -- table 24
(1, 2), (2, 2), -- table 25
(1, 2), (2, 2), -- table 27
(1, 2), (2, 2), -- table 28
(1, 2), (2, 2), -- table 29
(1, 2), (2, 2), -- table 30
(1, 2), (2, 2), -- table 31
(1, 2), (2, 2), -- table 32
(1, 2), (2, 2), -- table 33
(3, 4), (4, 4), -- table 20/21
(5, 6), (6, 6), (7, 6), -- table 20/21/22 
(8, 8), (9, 8), -- table 20/21/22/23 
(3, 4), (4, 4), -- table 22/23 
(9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15,12), (16, 12), -- table 20/21/22/23/24/25
(3, 4), (4, 4), -- table 24/25
(3, 5), (4, 5), (5, 5), (6, 5), -- table 26/27/28 
(3, 4), (4, 4), -- table 29/30
(5, 6), (6, 6), (7, 6), -- table 29/30/31
(3, 4), (4, 4), -- table 31/32
(3, 4), (4, 4), -- table 33/34
(5, 6), (6, 6), (7, 6), -- table 32/33/34
(8, 8), (9, 8), -- table 31/32/33/34
(9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15,12), (16, 12); -- table 29/30/31/32/33/34


INSERT INTO layout_requirements (layout_id, table_id) VALUES 
(1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (3, 2), (4, 1), (4, 2), -- table 1/2 
(5, 3), (6, 3), -- table 3 
(7, 4), (8, 4), -- table 4 
(9, 5), (10, 5), -- table 5
(11, 6), (11, 7), (12, 6), (12, 7), (13, 6), (13, 7), (14, 6), (14, 7), -- table 6/7
(15, 10), (16, 10), (17, 10), (18, 10), (19, 10), (20, 10), -- table 10
(21, 11), (22, 11), (23, 11), (24, 11), (25, 11), (26, 11), -- table 11 
(27, 12), (28, 12), (29, 12), (30, 12), (31, 12), (32, 12), -- table 12 
(33, 13), (34, 13), (35, 13), (36, 13), (37, 13), (38, 13), (39, 13), (40, 13), (41, 13), (42, 13), -- table 13 
(43, 14), (44, 14), (45, 14), (46, 14), (47, 14), (48, 14), -- table 14
(49, 15), (50, 15), (51, 15), (52, 15), (53, 15), (54, 15), -- table 15
(55, 21), (56, 21), -- table 21
(57, 22), (58, 22), -- table 22 
(59, 23), (60, 23), -- table 23 
(61, 24), (62, 24), -- table 24 
(63, 25), (64, 24), -- table 25
(65, 27), (66, 27), -- table 27
(67, 28), (68, 28), -- table 28
(69, 29), (70, 29), -- table 29
(71, 30), (72, 30), -- table 30
(73, 31), (74, 31), -- table 31
(75, 32), (76, 32), -- table 32 
(77, 33), (78, 33), -- table 33 
(79, 20), (79, 21), (80, 20), (80, 21), -- table 20/21 
(81, 20), (12, 21), (81, 22), (82, 20), (82, 21), (82, 22), (83, 20), (83, 21), (83, 22), -- table 20/21/22
(84, 20), (84, 21), (84, 22), (84, 23), (85, 20), (85, 21), (85, 22), (85, 23), -- table 20/21/22/23
(86, 22), (86, 23), (87, 22), (87, 23), -- table 22/23
(88, 20), (88, 21), (88, 22), (88, 23), (88, 24), (88, 25), (89, 20), (89, 21), (89, 22), (89, 23), (89, 24), (89, 25), 
(90, 20), (90, 21), (90, 22), (90, 23), (90, 24), (90, 25), (91, 20), (91, 21), (91, 22), (91, 23), (91, 24), (91, 25), 
(92, 20), (92, 21), (92, 22), (92, 23), (92, 24), (92, 25), (93, 20), (93, 21), (93, 22), (93, 23), (93, 24), (93, 25), 
(94, 20), (94, 21), (94, 22), (94, 23), (94, 24), (94, 25), (95, 20), (95, 21), (95, 22), (95, 23), (95, 24), (95, 25), -- table 20/21/22/23/24/25
(96, 24), (96, 25), (97, 24), (97, 25), -- table 24/25
(98, 26), (98, 27), (98, 28), (99, 26), (99, 27), (99, 28), (100, 26), (100, 27), (100, 28), (101, 26), (101, 27), (101, 28), -- table 26/27/28
(102, 29), (102, 30), (103, 29), (103, 30), -- table 29/30 
(104, 29), (104, 30), (104, 31), (105, 29), (105, 30), (105, 31), (106, 29), (106, 30), (106, 31), -- table 29/30/31 
(107, 31), (107, 32), (108, 31), (108, 32), -- table 31/32 
(109, 33), (109, 34), (110,33), (110, 34), -- table 33/34 
(111, 32), (111, 33), (111, 34), (112, 32), (112, 33), (112, 34), (113, 32), (113, 33), (113, 34), -- table 32/33/34
(114, 31), (114, 32), (114, 33), (114, 34), (115, 31), (115, 32), (115, 33), (115, 34), -- table 31/32/33/34
(116, 29), (116, 30), (116, 31), (116, 32), (116, 33), (116, 34), (117, 29), (117, 30), (117, 31), (117, 32), (117, 33), (117, 34), 
(118, 29), (118, 30), (118, 31), (118, 32), (118, 33), (118, 34), (119, 29), (119, 30), (119, 31), (119, 32), (119, 33), (119, 34), 
(120, 29), (120, 30), (120, 31), (120, 32), (120, 33), (120, 34), (121, 29), (121, 30), (121, 31), (121, 32), (121, 33), (121, 34), 
(122, 29), (122, 30), (122, 31), (122, 32), (122, 33), (122, 34), (123, 29), (123, 30), (123, 31), (123, 32), (123, 33), (123, 34); -- table 29/30/31/32/33/34

INSERT INTO time_quotas (number_people, minutes) VALUES
(1, 120), (2, 120), -- 2h for 1-2 tops
(3, 150), (4, 150), -- 2h30m for 3-4 tops
(5, 180), (6, 180), (7,180), (8, 180), -- 3h for 5-8 tops
(9, 240); -- anything larger than an 8 top is 4h

-- INSERT INTO reservations (table_number, client, date_and_time, duration, number_people, reservation_status) VALUES (10, 1, '2025-02-11 19:00:00', 150, 4, 'Booked');
-- INSERT INTO reservations (table_number, client, date_and_time, duration, number_people, reservation_status) VALUES (21, 1, '2025-02-11 16:00:00', 120, 2, 'Booked');

-- SELECT GROUP_CONCAT(layout_requirements.table_id) AS 'tables', layouts.max_seats AS 'max seats' 
-- FROM layout_requirements JOIN layouts ON layout_requirements.layout_id = layouts.id JOIN tables ON tables.id = layout_requirements.table_id
-- WHERE layouts.max_seats = 4 AND layouts.id NOT IN (
--   SELECT layout_id FROM layout_requirements WHERE table_id IN (
--     SELECT table_number FROM reservations WHERE NOT ( -- reservation doesn't collide if it either finishes before the start time, or starts after the end time
--     DATE_ADD(reservations.date_and_time, INTERVAL reservations.duration MINUTE) <= '2025-02-11 17:00:00' OR -- reservation finishes before the new start time
--     DATE_ADD('2025-02-11 17:00:00', INTERVAL (SELECT minutes FROM time_quotas WHERE number_people = 4) MINUTE) <= reservations.date_and_time) -- reservation starts after the new one ends
-- )) GROUP BY 'max seats', layout_id, tables.section, tables.seating_type ORDER BY tables.section, ABS(layouts.max_seats - layouts.optimal_seats) ASC, tables.seating_type
-- LIMIT 5; 

-- SELECT layouts.max_seats, layout_id, GROUP_CONCAT(table_id ORDER BY table_id) as 'table #' FROM layout_requirements JOIN layouts ON layouts.id = layout_requirements.layout_id JOIN tables ON tables.id = layout_requirements.table_id WHERE tables.section = 'lounge' GROUP BY max_seats, layout_id ORDER BY max_seats DESC, ABS(layouts.max_seats - layouts.optimal_seats) ASC;-- 


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