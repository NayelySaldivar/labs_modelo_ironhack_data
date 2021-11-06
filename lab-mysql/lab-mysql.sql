CREATE DATABASE lab_mysql;
USE lab_mysql;
CREATE TABLE invoices (invoice_number INT, date DATE, vin VARCHAR(20), customer_id VARCHAR(20), staff_id INT);
CREATE TABLE salespersons (staff_id INT, name VARCHAR(20), store VARCHAR(20));
CREATE TABLE customers ( customer_id VARCHAR(20), name VARCHAR(20), phone_numer VARCHAR(20), email VARCHAR(20), address VARCHAR(20), city VARCHAR(20), state VARCHAR(20), country VARCHAR(20), postalcode CHAR(6));
CREATE TABLE cars ( vin VARCHAR(20), manufacturer VARCHAR(20), model VARCHAR(20), year INT, color VARCHAR(20));

