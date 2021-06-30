CREATE DATABASE vets_clinic;
USE vets_clinic;

/*CREATION OF TABLES */
CREATE TABLE pets (pet_id INT NOT NULL, 
pet_name VARCHAR(50), 
age INT, 
breed VARCHAR(50), 
owner_id INT NOT NULL);

CREATE TABLE owners (owner_id INT NOT NULL,
owners_name VARCHAR(50), 
address VARCHAR(50),
phone_number INT(11),
outstanding_balance DECIMAL (6, 2));

CREATE TABLE vets (vets_id INT NOT NULL,
vets_name VARCHAR(50));

CREATE TABLE appointments (appointmentid INT NOT NULL,
appointment_date date,
appointment_time time,
pet_id INT NOT NULL,
vet_id INT NOT NULL,
treatment_id INT NOT NULL);

CREATE TABLE treatments (treatment_name VARCHAR(50),
treatment_id INT NOT NULL,
treatment_price DECIMAL (6,2));

/*BEFORE TRIGGER TO CAPITALISE PETS NAME*/
DELIMITER //

CREATE TRIGGER captalise_pet_name
BEFORE INSERT on pets
FOR EACH ROW
BEGIN
SET NEW.pet_name = concat(UPPER(SUBSTRING(NEW.pet_name,1,1)),
LOWER(SUBSTRING(NEW.pet_name FROM 2)));

END //

DELIMITER ;

/*BEFORE TRIGGER TO CAPITALISE OWNERS NAME*/
DELIMITER //

CREATE TRIGGER captalise_owner_name
BEFORE INSERT on owners
FOR EACH ROW
BEGIN
SET NEW.owners_name = concat(UPPER(SUBSTRING(NEW.owners_name,1,1)),
LOWER(SUBSTRING(NEW.owners_name FROM 2)));

END //

DELIMITER ;

 /*INSERTING VALUES INTO TABLES*/
 
INSERT INTO vets (vets_name, vets_id)
VALUES
('Dr Duffy', 1),
('Dr Cundall', 2),
('Dr Buchan', 3);

INSERT INTO pets (pet_id, pet_name, age, breed, owner_id)
VALUES
(1, 'lily', 6, 'cat', 1),
(2, 'snuggles', 5, 'ferret', 2),
(3, 'trouble', 5, 'ferret', 2),
(4, 'rowan', 13, 'cat', 3),
(5, 'atlas', 1, 'ferret', 4),
(6, 'derick', 1, 'ferret', 4),
(7, 'kiwi', 1, 'ferret', 5),
(8, 'maybel', 1, 'dog', 6),
(9, 'bluebell', 3, 'rabbit', 7),
(10, 'bracken', 3, 'rabbit', 7),
(11, 'tyr', 7, 'dog', 8),
(12, 'tosco', 10, 'cat', 8),
(13, 'topsy', 2, 'rabbit', 8),
(14, 'tim', 2, 'rabbit', 8),
(15, 'alfie', 1, 'horse', 9),
(16, 'diva', 2, 'horse', 9),
(17, 'tommy', 2, 'pony', 9),
(18, 'hianna', 1, 'dog', 9),
(19, 'rocky', 5, 'horse', 10),
(20, 'bertie', 12, 'horse', 10),
(21, 'eli', 10, 'horse', 10),
(22, 'poppy', 4, 'cat', 10),
(23, 'ellie', 2, 'dog', 11),
(24, 'maple', 2, 'dog', 12),
(25, 'syrup', 1, 'cat', 12),
(26, 'hazel', 1, 'dog', 12);

INSERT INTO owners (owner_id, owners_name, address, phone_number, outstanding_balance)
VALUES 
(1, 'katy', 'scarborough', 0723145215, 308.00),
(2, 'andrew', 'scarborough', 01262677440, 100.00),
(3, 'susan', 'scarborough', 01723450157, 508.00),
(4, 'gianna', 'scarborough', 01723677440, 0.00),
(5, 'aarron', 'filey', 01262403005, 0.00),
(6, 'gabby', 'filey', 0792345678, 144.50),
(7, 'annys', 'scarborough', 0786542156, 44.50),
(8,  'gemma', 'filey', 095432165, 44.50),
(9, 'alex', 'filey', 01232123467, 10.00),
(10, 'lynne', 'driffield', 0985432156, 0.00),
(11, 'gillian', 'driffield', 456821561, 89.00),
(12, 'katie', 'childers', 267234567, 0.00);

INSERT INTO treatments (treatment_name, treatment_id, treatment_price)
VALUES
('dental clean', 1, 308.00),
('surgery', 2, 589.00),
('x-ray', 3, 289.00),
('consultation', 4, 10.00),
('hormonemedication', 5, 100.00),
('castrate', 6, 59.00),
('spaying', 7, 89.00),
('microchipping', 8, 11.00),
('boosterjab', 9, 44.50);

INSERT INTO appointments (appointmentid, appointment_date,appointment_time,pet_id,vet_id,treatment_id)
VALUES
(362114, '2021-06-03', '14:00', 1, 1, 1),
(36211430, '2021-06-03', '14:30', 2, 2, 5),
(4621830, '2021-06-04', '08:30', 4, 1, 2),
(46211015, '2021-06-04', '10:15', 8, 3, 7),
(46211300, '2021-06-04', '13:00', 21, 2, 3);

SELECT * FROM vets;
SELECT * FROM treatments;
SELECT * FROM pets;
SELECT * FROM owners;
SELECT * FROM appointments;

/* FUNCTION WHICH CHECKS IF OUTSTANDING BALANCE*/
DELIMITER // 
CREATE FUNCTION outstanding_balance_for_treatment(
outstanding_balance DECIMAL (6, 2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
DECLARE BALANCE_CHANGE VARCHAR(20);
IF outstanding_balance >= 0.00 THEN
SET BALANCE_CHANGE = 'Outstanding';
END IF;
RETURN (BALANCE_CHANGE);
END // outstanding_balance
DELIMITER ;

/* QUERY WHICH SHOWS OWNERS WHO HAVE OUTSTANDING BALANCE 
USING THE STORED FUNCTION*/
SELECT owner_id,
owners_name,
outstanding_balance,
outstanding_balance_for_treatment(outstanding_balance)
FROM 
owners o
WHERE outstanding_balance_for_treatment(outstanding_balance) = 'Outstanding';

/*LEFT JOIN TO MATCH PETS TO OWNERS BY OWNER ID*/
SELECT
p.pet_id,
p.pet_name,
o.owners_name
FROM pets p
LEFT JOIN
owners o
ON
p.owner_id =
o.owner_id;

/*SUBQUERY WHICH RETURNS PET, OWNER, APPOINTMENT, AND TREATMENT
DETAILS FOR A SPECIFIED APPOINTMENT DATE*/

SELECT p.pet_name, o.owners_name, p.age, p.breed, a.appointment_date, a.appointment_time, t.treatment_name
FROM pets p, owners o, appointments a, treatments t
where a.appointment_date = '2021-06-03'
and p.pet_id = a.pet_id
and t.treatment_id = a.treatment_id
and p.owner_id = o.owner_id;

/*STORED PROCEDURE THAT INSERTS PET DETAILS INTO THE PETS TABLE*/

DELIMITER **
CREATE PROCEDURE InsertPetDetails(
IN pet_id1 INT,
IN pets_name1 VARCHAR(50),
IN age1 INT,
IN breed1 VARCHAR(50),
IN owner_id1 INT)
BEGIN 
INSERT INTO pets (pet_id, pet_name, age, breed, owner_id)
VALUES (pet_id1, pets_name1, age1, breed1, owner_id1);

END**
DELIMITER ;

CALL InsertPetDetails(27, 'Ollie', 5, 'horse', 10); 

/* GROUP BY ADDRESS TO SEE WHERE MOST CUSTOMERS ARE BASED THAT 
VISIT THE PRACTICE*/
SELECT COUNT(o.address),
o.address
FROM owners o
GROUP BY o.address
HAVING COUNT(o.address) >= 3;
