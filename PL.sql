# Citation for the following function: Darren Manalastas & Paulene Patrisha Pare
# Date: 5/22/2025
# Adapted from Canvas Modules/PLSQL Assignment:
# Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- -----------------------------
-- DELETE Member               -
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_delete_Member;
DELIMITER //
CREATE PROCEDURE sp_delete_Member(IN m_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        DELETE FROM Members WHERE member_id = m_id;


        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Members for id: ', m_id);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;


    COMMIT;

END //
DELIMITER ;


-- -----------------------------------
-- INSERT Member                     - 
-- -----------------------------------
DROP PROCEDURE IF EXISTS sp_insert_member;
DELIMITER //
CREATE PROCEDURE sp_insert_member(
   IN p_first_name VARCHAR(50),
   IN p_last_name VARCHAR(50),
   IN p_birth_date DATE,
   IN p_email VARCHAR(100),
   IN p_phone_num VARCHAR(15),
   OUT p_NewMemberID INT
)
COMMENT 'Insert member name and return new member ID.'
BEGIN
   INSERT INTO Members (first_name, last_name, birth_date, email, phone_num)
   VALUES (p_first_name, p_last_name, p_birth_date, p_email, p_phone_num);
       SET p_NewMemberID = LAST_INSERT_ID();
END//
DELIMITER ;

-- -----------------------------------
-- INSERT Registration               - 
-- -----------------------------------
DROP PROCEDURE IF EXISTS sp_insert_registration;
DELIMITER //
CREATE PROCEDURE sp_insert_registration(
   IN r_date DATE,
   In r_status VARCHAR(50),
   IN r_member_id INT,
   IN r_schedule_id INT,
   OUT new_rid INT
)
COMMENT 'Insert registration name and return new registration ID.'
BEGIN
   INSERT INTO Registrations (date, status, member_id, schedule_id)
   VALUES (r_date, r_status, r_member_id, r_schedule_id);
    SET new_rid = LAST_INSERT_ID();
END//
DELIMITER ;

-- -----------------------------
-- DELETE Registration         -
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_delete_registration;
DELIMITER //
CREATE PROCEDURE sp_delete_registration(IN r_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        DELETE FROM Registrations WHERE registration_id = r_id;


        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Registrations for id: ', r_id);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;


    COMMIT;

END //
DELIMITER ;

-- -----------------------------
-- Update Registration         -
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_update_registration;
DELIMITER //
CREATE PROCEDURE sp_update_registration(
    IN r_id INT,
    IN s_id INT,
    IN r_status VARCHAR(255)
    )
BEGIN
    UPDATE `Registrations` SET schedule_id = s_id, status = r_status WHERE registration_id = r_id; 


END //
DELIMITER ;

-- -----------------------------
-- Update Members              -
-- -----------------------------
DROP PROCEDURE IF EXISTS sp_update_member;
DELIMITER //
CREATE PROCEDURE sp_update_member(
    IN m_id INT,
    IN m_fname VARCHAR(50),
    IN m_lname VARCHAR(50),
    IN m_bdate DATE,
    IN m_email VARCHAR(100),
    IN m_phone VARCHAR(15)
    )
BEGIN
    UPDATE `Members` 
    SET first_name = m_fname, 
    last_name = m_lname,
    birth_date = m_bdate,
    email = m_email,
    phone_num = m_phone
    WHERE member_id = m_id; 

END //
DELIMITER ;

-- ---------------------------------------
-- INSERT Instructor                     - 
-- ---------------------------------------

DROP PROCEDURE IF EXISTS sp_CreateInstructor;

DELIMITER //
CREATE PROCEDURE sp_CreateInstructor(
    IN i_first_name VARCHAR(50),
    IN i_last_name VARCHAR(50),
    IN i_salary DECIMAL(10,2),
    IN i_birth_date DATE,
    IN i_email VARCHAR(100),
    IN i_phone_num VARCHAR(15),
    OUT i_id INT
)
BEGIN
    -- Insert instructor details into the Instructors table
    INSERT INTO Instructors (first_name, last_name, salary, birth_date, email, phone_num)
    VALUES (i_first_name, i_last_name, i_salary, i_birth_date, i_email, i_phone_num);

    -- Store the ID of the last inserted instructor
    SELECT LAST_INSERT_ID() INTO i_id;

    -- Display the new instructor ID
    SELECT LAST_INSERT_ID() AS 'new_instructor_id';

END //
DELIMITER ;

-- ---------------------------------------
-- DELETE Instructor                     - 
-- ---------------------------------------
DROP PROCEDURE IF EXISTS sp_DeleteInstructor;

DELIMITER //
CREATE PROCEDURE sp_DeleteInstructor(IN p_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the error to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        -- Delete instructor from Instructors table
        DELETE FROM Instructors WHERE instructor_id = p_id;

        -- Check if any row was deleted
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Instructors for id: ', p_id);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- ------------------------------------
-- UPDATE Classes                     - 
-- ------------------------------------
DROP PROCEDURE IF EXISTS sp_UpdateClass;

DELIMITER //
CREATE PROCEDURE sp_UpdateClass(
    IN p_class_id INT,
    IN p_class_name VARCHAR(50),
    IN p_class_type_id INT,
    IN p_description TEXT,
    IN p_start_time TIME,
    IN p_end_time TIME,
    IN p_instructor_id INT,
    IN p_studio_id INT
)
BEGIN
    UPDATE Classes
    SET class_name = p_class_name,
        class_type_id = p_class_type_id,
        description = p_description,
        start_time = p_start_time,
        end_time = p_end_time,
        instructor_id = p_instructor_id,
        studio_id = p_studio_id
    WHERE class_id = p_class_id;
END //
DELIMITER ;

-- ---------------------------------------
-- UPDATE Instructor                     - 
-- ---------------------------------------
DROP PROCEDURE IF EXISTS sp_UpdateInstructor;

DELIMITER //
CREATE PROCEDURE sp_UpdateInstructor(
    IN p_instructor_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    IN p_birth_date DATE,
    IN p_email VARCHAR(100),
    IN p_phone_num VARCHAR(15)
)
BEGIN
    UPDATE Instructors
    SET first_name = p_first_name,
        last_name = p_last_name,
        salary = p_salary,
        birth_date = p_birth_date,
        email = p_email,
        phone_num = p_phone_num
    WHERE instructor_id = p_instructor_id;
END //
DELIMITER ;
