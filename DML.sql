-- Citation for Subquery in SELECT
-- Date: 5/08/2025
-- Adapted from: Microsoft
-- Source URL: https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries?view=sql-server-ver16

-- Citation for Arithmetic Operations in SELECT
-- Date: 05/08/2025
-- Adapted from: W3 Resource
-- Source URL: https://www.w3resource.com/sql/arithmetic-operators/sql-arithmetic-operators.php

-- Citation for Insert, Update and Delete
-- Date: 05/08/2025
-- Adapted from: W3 Schools
-- Source URL: https://www.w3schools.com/sql/sql_delete.asp, https://www.w3schools.com/Sql/sql_update.asp, https://www.w3schools.com/sql/sql_insert.asp

-- Citation for CONCAT and Aliases
-- Date: 05/08/2025
-- Adapted from: W3 Schools
-- Source URL: https://www.w3schools.com/sql/sql_alias.asp

-- Citation for IFNULL
-- Date: 05/08/2025
-- Adapted from: W3 Schools
-- Source URL: https://www.w3schools.com/sql/func_mysql_ifnull.asp

-- Citation for DATE_FORMAT
-- Date: 05/15/2025
-- Adapted from: W3 Schools
-- Source URL: https://www.w3schools.com/mysql/func_mysql_date_format.asp

-- Citation for FORMAT Salary
-- Date: 06/02/2025
-- Adapted from: W3 Schools
-- Source URL: https://www.w3schools.com/mysql/func_mysql_format.asp


----------------------------------
-- READ/SELECT Statements        -  
----------------------------------
-- Classes Entity
SELECT class_id, 
class_name, 
Class_types.type_name as class_type_name, 
description, 
DATE_FORMAT(Classes.start_time, '%h:%i %p') as start_time, 
DATE_FORMAT(Classes.end_time, '%h:%i %p') as end_time,
CONCAT(Instructors.first_name, " ", Instructors.last_name) as instructor_full_name, Studios.studio_name
FROM Classes
INNER JOIN Studios ON Classes.studio_id = Studios.studio_id
INNER JOIN Class_types ON Class_types.class_type_id = Classes.class_type_id
INNER JOIN Instructors ON Classes.instructor_id = Instructors.instructor_id
ORDER BY class_id ASC;

-- Class_types Entity
SELECT class_type_id, type_name
FROM Class_types
ORDER BY class_type_id ASC;

-- Instructors Entity
SELECT instructor_id, first_name, last_name, FORMAT(salary, 2) as salary, DATE_FORMAT(birth_date, "%m-%d-%Y") as birth_date, email, phone_num
FROM Instructors
ORDER BY instructor_id ASC;

-- Members Entity
SELECT member_id, first_name, last_name, DATE_FORMAT(birth_date, "%m-%d-%Y") as birth_date, email, phone_num
FROM Members
ORDER BY member_id ASC;

-- Registrations Entity
SELECT Registrations.registration_id, 
DATE_FORMAT(Registrations.date, "%m-%d-%Y") as registration_date, 
CONCAT(Members.first_name, " ", Members.last_name) as member_full_name, CONCAT(Scheduled_classes.date_of_class, ", ", DATE_FORMAT(Classes.start_time, '%h:%i %p'),
" - ", Classes.class_name) as class_schedule,
Registrations.status as registration_status
FROM Registrations
INNER JOIN Members ON Registrations.member_id = Members.member_id
INNER JOIN Scheduled_classes ON Registrations.schedule_id = Scheduled_classes.schedule_id
INNER JOIN Classes ON Scheduled_classes.class_id = Classes.class_id
ORDER BY registration_id ASC;

-- Scheduled_classes Entity
SELECT schedule_id, 
DATE_FORMAT(date_of_class, "%m-%d-%Y") as date_of_class,
Classes.class_name,
CONCAT(Instructors.first_name, " ", Instructors.last_name) as instructor_full_name,
Studios.studio_name,
DATE_FORMAT(Classes.start_time, '%h:%i %p') as start_time,
Studios.max_capacity as max_capacity,
(SELECT COUNT(registration_id) FROM Registrations WHERE Registrations.schedule_id = Scheduled_classes.schedule_id) as spots_filled,
Studios.max_capacity - (SELECT COUNT(registration_id) FROM Registrations WHERE Registrations.schedule_id = Scheduled_classes.schedule_id) as spots_available,
Scheduled_classes.status as class_status
FROM Scheduled_classes
INNER JOIN Classes ON Scheduled_classes.class_id = Classes.class_id
INNER JOIN Studios ON Classes.studio_id = Studios.studio_id
INNER JOIN Instructors ON Instructors.instructor_id = IFNULL(Scheduled_classes.substitute_id, Classes.instructor_id)
ORDER BY schedule_id ASC;

-- Studios Entity
SELECT studio_id, studio_name, max_capacity
FROM Studios
ORDER BY studio_id;


------------------------------------
-- Create/INSERT Statements        -  
------------------------------------
-- Insert a New Member                                                               
INSERT INTO Members (first_name, last_name, birth_date, email, phone)
VALUES (@firstName, @lastName, @birthDate, @email, @phone);

-- Insert a New Instructor
INSERT INTO Instructors (first_name, last_name, salary, birth_date, email, phone_num) 
VALUES (@first_name, @last_name, @salary, @birth_date, @email, @phone_num);

-- Insert new registration 
SET @member_id = (
	SELECT member_id
      FROM Members 
	WHERE first_name = @memberName
	AND last_name = @lastName
); 

SET @schedule_id = (
	SELECT schedule_id
	FROM Scheduled_classes
	WHERE class_id = (
		SELECT class_id 
		FROM Classes 
		WHERE class_name = @className
	)
); 

INSERT INTO Registrations (date, time, status, member_id, schedule_id)
VALUES (@date, @time, @status, @member_id, @schedule_id);


------------------------------------
-- UPDATE Statements               -  
------------------------------------
-- Update an existing Member 
UPDATE Members
SET first_name = @new_first_name,
    last_name = @new_last_name,
    birth_date = @new_birth_date,
    email = @new_email,
    phone_num = @new_phone_num
WHERE member_id = @member_id;

-- Update an existing Instructor
UPDATE Instructors
SET first_name = @new_first_name,
    last_name = @new_last_name,
    salary = @new_salary,
    birth_date = @new_birth_date,
    email = @new_email,
    phone_num = @new_phone_num
WHERE instructor_id = @instructor_id;

-- Update an existing Registration
UPDATE Registrations
SET date = @new_date,
    status = @new_status,
    member_id = @new_member_id,
    schedule_id = @new_schedule_id
WHERE registration_id = @registration_id;

-- Update an existing Class                                                                                                    
UPDATE Classes
SET class_name = @new_class_name, 
	class_type_id = @new_class_type_id, 
	instructor_id = @new_instructor_id,
      studio_id = @new_studio_id,
      description = @new_description,
      start_time = @new_start_time,
      end_time = @new_end_time
WHERE class_id = @class_id; 


------------------------------------
-- DELETE Statements               -  
------------------------------------
-- Delete a Member 
DELETE FROM Members
WHERE member_id = @member_id;

-- Delete a Registration
DELETE FROM Registrations
WHERE registration_id = @registration_id;

-- Delete an Instructor
DELETE FROM Instructors
WHERE instructor_id = @instructor_id;