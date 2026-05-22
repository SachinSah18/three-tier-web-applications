CREATE DATABASE IF NOT EXISTS employee_db;
USE employee_db;

CREATE TABLE IF NOT EXISTS employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender ENUM('Male', 'Female', 'Other') NOT NULL,
  phone VARCHAR(15) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  address VARCHAR(255) NOT NULL,
  joining_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO employees (name, date_of_birth, gender, phone, email, address, joining_date)
VALUES
  ('Aarav Sharma', '2001-04-10', 'Male', '9876543210', 'aarav.sharma@example.com', 'Jaipur, Rajasthan', '2025-07-01'),
  ('Neha Verma', '2000-09-22', 'Female', '9876501234', 'neha.verma@example.com', 'Delhi, India', '2025-08-12')
ON DUPLICATE KEY UPDATE email = VALUES(email);
