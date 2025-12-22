-- Handauthored by Paulene Patrisha Pare and Darren Manalastas
-- Corresponds to the CS340 Portfolio Project
-- Stored Procedure for DDL

-- Citation for use of AI Tools:
-- Date: 2025-05-22 
-- Prompts used to generate Sample data:
-- "give me 3 sample data for table with the following columns, first_name, last_name, DOB, email, phone_num"
-- "ok give me 5 more but this time, classtype(Boxing, Pilates, Dance, Tinikling, Yoga), class_name (give distinct names but make it creative), day_of_week, description, start_time and end_time"
-- "ok give me another 5 but this time staff_id(I01 - I05), first_name, last_name, salary, birth_date, email, phone_num"
-- AI Source URL: https://chatgpt.com/

-- Citation for the following function: Darren Manalastas & Paulene Patrisha Pare
-- Date: 5/22/2025
-- Adapted from Canvas Modules:
-- Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-pl-slash-sql-part-2-stored-procedures-for-cud?module_item_id=25352959
-- Used Sample DDL provided in Canvas as reference:
-- Source URL: https://canvas.oregonstate.edu/courses/1999601/assignments/10006390?module_item_id=25352972

DROP PROCEDURE IF EXISTS sp_load_gymdb; 

DELIMITER //

CREATE PROCEDURE sp_load_gymdb()
BEGIN 

    -- Disable FK checks during drops/inserts 
    SET FOREIGN_KEY_CHECKS = 0;

    -- --------------------------------------------------------------------
    -- Table 'Members': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Members table 
    DROP TABLE IF EXISTS Members;

    CREATE TABLE Members (
        member_id int AUTO_INCREMENT PRIMARY KEY,
        first_name varchar(50) NOT NULL,
        last_name varchar(50) NOT NULL,
        birth_date DATE NOT NULL,
        email varchar(100) NOT NULL UNIQUE,
        phone_num varchar(15) NOT NULL UNIQUE
    );

    -- Insert data into Members table 
    INSERT INTO Members(first_name, last_name, birth_date, email, phone_num)
    VALUES ('Darren', 'Manalastas', '1998-11-11', 'darrenm@yahoo.com', '111-111-1111'),
    ('Paulene', 'Pare', '1998-04-19', 'paulenep@yahoo.com', '222-222-2222'),
    ('Maya', 'Thompson', '2000-07-12', 'maya.thompson@yahoo.com', '333-333-3333'),
    ('Leo', 'Ramirez', '1994-11-03', 'leo.ramirez@yahoo.com', '444-444-4444'),
    ('Alina', 'Chen', '1998-03-27', 'alina.chen@yahoo.com', '555-555-5555');

    -- --------------------------------------------------------------------
    -- Table 'Instructors': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Instructors table 
    DROP TABLE IF EXISTS Instructors; 

    CREATE TABLE Instructors (
        instructor_id int AUTO_INCREMENT PRIMARY KEY,
        first_name varchar(50) NOT NULL,
        last_name varchar(50) NOT NULL,
        salary DECIMAL(10,2) NOT NULL,
        birth_date DATE NOT NULL,
        email varchar(100) NOT NULL UNIQUE,
        phone_num varchar(15) NOT NULL UNIQUE
        );

     -- Insert data into Instructors table 
    INSERT INTO Instructors(first_name, last_name, salary, birth_date, email, phone_num)
    VALUES ('Jordan', 'Reyes', 24000.00, '1987-03-15', 'jordan.reyes@onefitness.com', '212-555-1832'),
    ('Sienna', 'Brooks', 25000.00, '1990-08-22', 'sienna.brooks@onefitness.com', '917-555-2648'),
    ('Marcus', 'Nguyen', 23000.00, '1985-11-06', 'marcus.nguyen@onefitness.com', '646-555-7371'),
    ('Layla', 'Patel', 5000.00, '1992-01-30', 'layla.patel@onefitness.com', '718-555-4902'),
    ('Elijah', 'Kim', 24000.00, '1988-06-18', 'elijah.kim@onefitness.com', '347-555-8120'),
    ('Chloe', 'Martinez', 25000.00, '1993-05-10', 'chloe.martinez@onefitness.com', '332-555-0923');

    -- --------------------------------------------------------------------
    -- Table 'Class_types': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Class_types table 
    DROP TABLE IF EXISTS Class_types; 

    CREATE TABLE Class_types (
        class_type_id int AUTO_INCREMENT PRIMARY KEY,
        type_name varchar(30) NOT NULL
    );
    
    -- Insert data into Class_types table 
    INSERT INTO Class_types(type_name)
    VALUES ('Boxing'),
    ('Pilates'),
    ('Dance'),
    ('Tinikling'),
    ('Yoga');

    -- --------------------------------------------------------------------
    -- Table 'Studios': to store member information 
    -- --------------------------------------------------------------------

    -- Drop and Recreate Studios table 
    DROP TABLE IF EXISTS Studios; 

    CREATE TABLE Studios (
        studio_id int AUTO_INCREMENT PRIMARY KEY,
        studio_name varchar(30) NOT NULL,
        max_capacity int NOT NULL
    );

    -- Insert data into Studios table 
    INSERT INTO Studios(studio_name, max_capacity)
    VALUES ('Studio A', 25),
    ('Studio B', 15),
    ('Studio C', 30),
    ('Studio D', 25),
    ('Studio E', 30);

    -- --------------------------------------------------------------------
    -- Table 'Classes': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Classes table 
    DROP TABLE IF EXISTS Classes; 

    CREATE TABLE Classes (
        class_id int AUTO_INCREMENT PRIMARY KEY,
        class_type_id int NOT NULL,
        class_name varchar(50) NOT NULL,
        description TEXT NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        instructor_id int NOT NULL,
        studio_id int NOT NULL,
        FOREIGN KEY (class_type_id) REFERENCES Class_types(class_type_id) ON DELETE CASCADE,
        FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id) ON DELETE CASCADE,
        FOREIGN KEY (studio_id) REFERENCES Studios(studio_id)
    );

    -- Insert data into Classes table 
    INSERT INTO Classes (class_type_id, class_name, description, start_time, end_time, instructor_id, studio_id)
    VALUES
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Boxing'), 'Knockout Burn', 'A high-intensity boxing class focused on cardio and power.', '18:00', '19:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Jordan' AND last_name = 'Reyes'), 1),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Pilates'), 'Core Elevation', 'A mat-based session targeting core strength and posture', '08:00', '09:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Sienna' AND last_name = 'Brooks'), 2),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Dance'), 'Rhythm & Flow', 'A fusion dance workout mixing hip-hop and Afrobeat styles', '19:30', '20:30', (SELECT instructor_id FROM Instructors WHERE first_name = 'Elijah' AND last_name = 'Kim'), 3),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Tinikling'), 'Bamboo Beats', 'Traditional Filipino Tinikling dance with a modern twist', '17:00', '18:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Chloe' AND last_name = 'Martinez'), 4),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Yoga'), 'Sunrise Stillness', 'Gentle sunrise yoga for breathwork and mindfulness', '07:00', '08:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Marcus' AND last_name = 'Nguyen'), 5),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Boxing'), 'Knockout Burn Advanced', 'Advanced level boxing class focused on technique and sparring', '18:00', '19:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Jordan' AND last_name = 'Reyes'), 1),
    ((SELECT class_type_id FROM Class_types WHERE type_name = 'Pilates'), 'Pilates Sculpt', 'Mat Pilates combined with weights to sculpt and tone your body', '16:00', '17:00', (SELECT instructor_id FROM Instructors WHERE first_name = 'Layla' AND last_name = 'Patel'), 2);

    -- --------------------------------------------------------------------
    -- Table 'Scheduled_classes': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Scheduled_classes table 
    DROP TABLE IF EXISTS Scheduled_classes; 

    CREATE TABLE Scheduled_classes (
        schedule_id int AUTO_INCREMENT PRIMARY KEY,
        date_of_class DATE NOT NULL,
        status varchar(30) NOT NULL,
        class_id int NOT NULL,
        substitute_id int,
        FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE,
        FOREIGN KEY (substitute_id) REFERENCES Instructors(instructor_id) ON DELETE CASCADE
    );

    --  Insert data into Scheduled_classes table 
    INSERT INTO Scheduled_classes (date_of_class, status, class_id, substitute_id)
    VALUES
    ('2025-04-10', 'active', (SELECT class_id FROM Classes WHERE class_name = 'Knockout Burn'), NULL),
    ('2025-04-10', 'active', (SELECT class_id FROM Classes WHERE class_name = 'Core Elevation'), NULL),
    ('2025-04-10', 'cancelled', (SELECT class_id FROM Classes WHERE class_name = 'Rhythm & Flow'), NULL),
    ('2025-04-10', 'substitute', (SELECT class_id FROM Classes WHERE class_name = 'Bamboo Beats'), (SELECT instructor_id FROM Instructors WHERE first_name = 'Jordan' AND last_name = 'Reyes')),
    ('2025-04-11', 'active', (SELECT class_id FROM Classes WHERE class_name = 'Sunrise Stillness'), NULL),
    ('2025-04-11', 'cancelled', (SELECT class_id FROM Classes WHERE class_name = 'Knockout Burn Advanced' LIMIT 1), NULL),
    ('2025-04-11', 'active', (SELECT class_id FROM Classes WHERE class_name = 'Pilates Sculpt'), NULL),
    ('2025-04-12', 'substitute', (SELECT class_id FROM Classes WHERE class_name = 'Knockout Burn'), (SELECT instructor_id FROM Instructors WHERE first_name = 'Marcus' AND last_name = 'Nguyen'));

    -- --------------------------------------------------------------------
    -- Table 'Registrations': to store member information 
    -- --------------------------------------------------------------------
    
    -- Drop and Recreate Registrations table 
    DROP TABLE IF EXISTS Registrations; 

    CREATE TABLE Registrations (
        registration_id int AUTO_INCREMENT PRIMARY KEY,
        date DATE NOT NULL,
        status varchar(50) NOT NULL,
        member_id int NOT NULL,
        schedule_id int NOT NULL,
        FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
        FOREIGN KEY (schedule_id) REFERENCES Scheduled_classes(schedule_id) ON DELETE CASCADE
    );

    -- Insert data into Registrations table 
    INSERT INTO Registrations (date, status, member_id, schedule_id)
    VALUES
    ('2025-04-10', 'no show', (SELECT member_id FROM Members WHERE first_name = 'Darren' AND last_name = 'Manalastas'), (SELECT schedule_id FROM Scheduled_classes WHERE date_of_class = '2025-04-10' AND class_id = (SELECT class_id FROM Classes WHERE class_name = 'Rhythm & Flow'))),
    ('2025-04-11', 'registered', (SELECT member_id FROM Members WHERE first_name = 'Maya' AND last_name = 'Thompson'), (SELECT schedule_id FROM Scheduled_classes WHERE date_of_class = '2025-04-10' AND class_id = (SELECT class_id FROM Classes WHERE class_name = 'Core Elevation'))),
    ('2025-04-12', 'attended', (SELECT member_id FROM Members WHERE first_name = 'Darren' AND last_name = 'Manalastas'), (SELECT schedule_id FROM Scheduled_classes WHERE date_of_class = '2025-04-10' AND class_id = (SELECT class_id FROM Classes WHERE class_name = 'Bamboo Beats'))),
    ('2025-04-13', 'late', (SELECT member_id FROM Members WHERE first_name = 'Leo' AND last_name = 'Ramirez'), (SELECT schedule_id FROM Scheduled_classes WHERE date_of_class = '2025-04-10' AND class_id = (SELECT class_id FROM Classes WHERE class_name = 'Knockout Burn'))),
    ('2025-04-14',  'cancelled', (SELECT member_id FROM Members WHERE first_name = 'Leo' AND last_name = 'Ramirez'), (SELECT schedule_id FROM Scheduled_classes WHERE date_of_class = '2025-04-10' AND class_id = (SELECT class_id FROM Classes WHERE class_name = 'Core Elevation')));

    SET FOREIGN_KEY_CHECKS=1; 
END //

DELIMITER ; 