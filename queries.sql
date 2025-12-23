create database
  vehicle_rental_system
CREATE TABLE
  Users (
    user_id INT PRIMARY KEY,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Customer')),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) DEFAULT 'default_pass',
    phone VARCHAR(20)
  );

CREATE TABLE
  Vehicles (
    vehicle_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type
      VARCHAR(20) NOT NULL CHECK (
        type
          IN ('car', 'bike', 'truck')
      ),
      model VARCHAR(50),
      registration_number VARCHAR(50) UNIQUE NOT NULL,
      rental_price DECIMAL(10, 2) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'rented', 'maintenance'))
  );

CREATE TABLE
  Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (
      status IN ('pending', 'confirmed', 'completed', 'cancelled')
    ),
    total_cost DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users (user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id)
  );

SELECT
  b.booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  b.start_date,
  b.end_date,
  b.status
FROM
  Bookings b
  INNER JOIN Users u ON b.user_id = u.user_id
  INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id;

SELECT
  *
FROM
  Vehicles v
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Bookings b
    WHERE
      b.vehicle_id = v.vehicle_id 
  ) order by v.vehicle_id asc;



SELECT
  *
FROM
  Vehicles
WHERE
type
  = 'car'
  AND status = 'available';

SELECT
  v.name AS vehicle_name,
  COUNT(b.booking_id) AS total_bookings
FROM
  Vehicles v
  JOIN Bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY
  v.name
HAVING
  COUNT(b.booking_id) > 2;