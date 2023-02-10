DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS enclosures;


CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    capacity int,
    closedForMaintenance BOOLEAN
);
INSERT INTO enclosures(name, capacity, closedForMaintenance) VALUES('Wild cats', 20, false);
INSERT INTO enclosures(name, capacity, closedForMaintenance) VALUES('Mammals', 30, false);
INSERT INTO enclosures(name, capacity, closedForMaintenance) VALUES('Macropods', 10, true);
INSERT INTO enclosures(name, capacity, closedForMaintenance) VALUES('Wild cats', 20, false);
INSERT INTO enclosures(name, capacity, closedForMaintenance) VALUES('Mammals', 30, false);

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    type VARCHAR(50),
    age INT,
    enclosure_id INT REFERENCES enclosures(id)
);

INSERT INTO animals (name, type, age, enclosure_id) VALUES('Tony', 'Tiger', 59, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES('Pony', 'Horse', 35, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES('Cony', 'Kangaroo', 40, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES('Sony', 'Lion', 40, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES('Bambi', 'Deer', 3, 5);


CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    employeeNumber INT
);

INSERT INTO staff(name, employeeNumber) VALUES('Captain Rik', 12345);
INSERT INTO staff(name, employeeNumber) VALUES('Savana', 69876);
INSERT INTO staff(name, employeeNumber) VALUES('Ed', 98765);
INSERT INTO staff(name, employeeNumber) VALUES('Colin', 65786);

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    employeeID INT REFERENCES staff(id),
    enclosureID INT REFERENCES enclosures(id),
    day VARCHAR(50)
);

INSERT INTO assignments(employeeID, enclosureID, day) VALUES(1, 1, 'Tuesday');
INSERT INTO assignments(employeeID, enclosureID, day) VALUES(1, 4, 'Tuesday');
INSERT INTO assignments(employeeID, enclosureID, day) VALUES(2, 5, 'Tuesday');
INSERT INTO assignments(employeeID, enclosureID, day) VALUES(4, 3, 'Tuesday');
INSERT INTO assignments(employeeID, enclosureID, day) VALUES(3, 2, 'Tuesday');
INSERT INTO assignments(employeeID, enclosureID, day) VALUES(4, 4, 'Tuesday');

--The names of the animals in a given enclosure

SELECT animals.name, enclosures.name FROM enclosures JOIN animals ON enclosures.id = animals.enclosure_id ;

--The names of the staff working in a given enclosure

SELECT staff.name, enclosures.name FROM staff
INNER JOIN assignments ON staff.id = assignments.employeeId
INNER JOIN enclosures ON assignments.enclosureId = enclosures.id;

--The names of staff working in enclosures which are closed for maintenance

SELECT staff.name, enclosures.name FROM staff
INNER JOIN assignments ON staff.id = assignments.employeeId
INNER JOIN enclosures ON assignments.enclosureId = enclosures.id
WHERE enclosures.closedformaintenance = true;

--The name of the enclosure where the oldest animal lives. If there are two animals who are the same age choose the first one alphabetically.

SELECT enclosures.name, animals.name, animals.age FROM animals 
INNER JOIN enclosures ON enclosures.id = animals.enclosure_id
ORDER BY animals.age DESC LIMIT 1;

--The number of different animal types a given keeper has been assigned to work with.

SELECT staff.name, COUNT(DISTINCT animals.type) FROM staff
INNER JOIN assignments 
ON staff.id = employeeId
INNER JOIN enclosures
ON enclosures.id = assignments.enclosureID
INNER JOIN animals 
ON enclosures.id = animals.enclosure_id 
GROUP BY staff.name;

--The number of different keepers who have been assigned to work in a given enclosure

SELECT COUNT(DISTINCT staff.name), enclosures.name FROM staff
INNER JOIN assignments 
ON staff.id = assignments.employeeID
INNER JOIN enclosures
ON enclosures.id = assignments.enclosureID
GROUP BY enclosures.name;

-- The names of the other animals sharing an enclosure with a given animal (eg. find the names of all the animals sharing the big cat field with Tony)
SELECT name FROM animals
WHERE enclosures_id = 
(SELECT enclosures_id FROM animals 
WHERE name = 'Bambi');
