/*
Travel Agency Dataset
*/


/* 1.Correct travel_class in booking_details*/

-- Update 'First Class'
UPDATE booking_details
SET travel_class = 'First Class'
WHERE LOWER(travel_class) ILIKE '%frst%' OR LOWER(travel_class) LIKE '%1st%';

-- Update 'Business'
UPDATE booking_details
SET travel_class = 'Business'
WHERE LOWER(travel_class) = 'busi';

-- Update 'Economy'
UPDATE booking_details
SET travel_class = 'Economy'
WHERE LOWER(travel_class) = 'econ';


/*2. Updating insurance_booking with right boolean in Customers Table*/

-- Update 'Yyess' and 'Y' to 'Yes'
UPDATE booking_details
SET insurance_booking = 'Yes'
WHERE (insurance_booking) IN ('Yyees', 'Y');

-- Update 'N' and 'None' to 'No'
UPDATE booking_details
SET insurance_booking = 'No'
WHERE (insurance_booking) IN ('N', 'None');


/*3. Updating email with placeholder in Customers Table*/

UPDATE customer SET email = 'placeholder@example.com' WHERE email IS NULL OR email = '';


/*4. Deleting duplicates in Customers Table*/

DELETE FROM customer
WHERE customer_id NOT IN (
    SELECT MIN(customer_id) AS min_id
    FROM customer
    GROUP BY phone
);


/*4. Deleting duplicates in Customers Table*/

UPDATE customer
SET phone = CONCAT(
    SUBSTRING(phone FROM 1 FOR 3),
    '-',
    SUBSTRING(phone FROM 4 FOR 3),
    '-',
    SUBSTRING(phone FROM 7 FOR 4)
);


/*5. Changing abbriviated country name to fullname in Region Table*/

UPDATE region
SET country = 
    CASE 
        WHEN country = 'USA' THEN 'United States'
        WHEN country = 'UK' THEN 'United Kingdom'
        ELSE country
    END;