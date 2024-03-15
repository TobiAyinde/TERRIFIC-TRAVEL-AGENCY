/*
Travel Agency Dataset
*/

--1. Customer
CREATE TABLE Customer
(
    customer_id serial PRIMARY KEY,
    customer_name varchar (100),
    email text,
    phone varchar (100),
    address varchar (100),
    premium_member boolean
);


--2. Region
CREATE TABLE Region
(
    region_id serial PRIMARY KEY,
    region_name varchar (100),
    city varchar (100),
    country varchar (100),
    airport_code text
);


--3. Hotel
CREATE TABLE Hotel
(
    hotel_id serial PRIMARY KEY,
    hotel_name varchar (100),
    location varchar (100),
    rating decimal
);


--4. Flight
CREATE TABLE Flight
(
    flight_id serial PRIMARY KEY,
    flight_number varchar (100),
    airline text,
    meal_inclusion boolean,
    layover int
);


--5. Booking_Details
CREATE TABLE Booking_Details
(
    booking_id serial PRIMARY KEY,
    customer_id int,
    flight_id int,
    hotel_id int,
    region_id int,
    booking_date date,
    travel_date date,
    hotel_check_in_date date,
    hotel_check_out_date date,
    travel_class varchar (50),
    num_passengers int,
    total_package_usd decimal,
    insurance_booking text,
    booking_channel varchar(20),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (region_id) REFERENCES Region(region_id) ON UPDATE CASCADE ON DELETE CASCADE
);