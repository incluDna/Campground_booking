-- 1. The system shall allow a user to register by specifying the name, telephone number, email, and password.  


CREATE OR REPLACE FUNCTION register(
    p_first_name VARCHAR(100)  ,
    p_middle_name VARCHAR(100),
    p_last_name VARCHAR(100)  ,
    p_email VARCHAR(100)   ,
    p_password VARCHAR(255)  ,
    p_phone VARCHAR(15)  
)
RETURNS TEXT AS --แก้ void เป็น text รันได้
$$
declare 
id_count integer := 0;
BEGIN
    -- ตรวจสอบว่าอีเมลถูกใช้แล้วหรือไม่
    IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email is already registered';
    END IF;

    -- แทรกผู้ใช้ใหม่ลงใน Users Table
	

    INSERT INTO Users (first_name, middle_name, last_name, email, password, phone, role)
    VALUES (p_first_name, p_middle_name, p_last_name, p_email, p_password, p_phone, 'customer');
    -- ให้ role ตั้งต้น 'customer' (เพราะ admin Gen ใช้เอง)

    RETURN 'Registered successfully';
END;
$$
LANGUAGE plpgsql;

-- 2. After registration, the user becomes a registered user, and the system shall allow the user to log in to use the system by specifying the email and password. The system shall allow a registered user to log out. 
-- 2.1 เข้าสู่ระบบ


CREATE OR REPLACE FUNCTION login_user(
    p_email VARCHAR(100),
    p_password VARCHAR(255)
)
RETURNS TEXT AS
$$
DECLARE
    v_user_id INT;
    v_stored_password VARCHAR(255);
    v_token UUID;
BEGIN
    -- ตรวจสอบว่ามีอีเลมใน Users Table
    SELECT password INTO v_stored_password
    FROM Users
    WHERE email = p_email;
    
    -- ถ้าไม่เจอก็ฟ้อง
    IF NOT FOUND THEN
        RETURN 'Invalid email address';
    END IF;
    
    -- ถ้ารหัสผ่านไม่ตรงก็ฟ้อง
    IF v_stored_password != p_password THEN
	RETURN 'Invalid password';
    END IF;
    
    -- create token for session --
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";

     v_token := gen_random_uuid();  -- ต้องเปิดใช้ extension pgcrypto หรือใช้ uuid_generate_v4()

    -- บันทึก Token ลงในตาราง Sessions
    INSERT INTO Sessions (user_id, token)
    VALUES (v_user_id, v_token);

    -- ส่งคืน Token ให้ผู้ใช้
    RETURN v_token::TEXT;

    -- ****
        -- ยังไม่ทำการแยกของ user กับ admin
    -- ****

    RETURN 'Login successful';

END;
$$
LANGUAGE plpgsql;

-- 2. After registration, the user becomes a registered user, and the system shall allow the user to log in to use the system by specifying the email and password. The system shall allow a registered user to log out. 
-- 2.2 ออกจากระบบ


CREATE OR REPLACE FUNCTION logout_user(
    p_token UUID
)
RETURNS TEXT AS
$$
DECLARE
    v_session_id INT;
BEGIN
    -- ตรวจสอบว่า token นี้มีอยู่ในตาราง Sessions หรือไม่
    SELECT session_id INTO v_session_id
    FROM Sessions
    WHERE token = p_token;

    -- ถ้าไม่เจอ token
    IF NOT FOUND THEN
        RETURN 'Invalid session or already logged out';
    END IF;

    -- ลบ session ออกจากตาราง
    DELETE FROM Sessions
    WHERE session_id = v_session_id;

    RETURN 'Logout successful';
END;
$$
LANGUAGE plpgsql;




-- 3. After login, the system shall allow the registered user to book up to 3 nights by specifying the date and the preferred campground. The campground list is also provided to the user. A campground information includes the campground name, address, and telephone number. 
-- 3.2 ฟังก์ชั่นการจองเต้น


CREATE OR REPLACE FUNCTION booking_tent(
    p_user_id INT,
    p_tent_id INT,
    p_campground_id INT,
    p_check_in DATE,
    p_check_out DATE
)
RETURNS TEXT AS
$$
DECLARE
    v_booking_id INT;
    v_status VARCHAR(20);  -- เพื่อเก็บสถานะของเต็นท์
    v_nights INT;          -- เพื่อตรวจสอบจำนวนคืนที่จอง
BEGIN
    -- ตรวจสอบจำนวนคืนที่จอง (ต้องไม่เกิน 3 คืน)
    SELECT (p_check_out - p_check_in) INTO v_nights;
    IF v_nights > 3 THEN
        RETURN 'You can only book a tent for up to 3 nights.';
    END IF;

    -- ตรวจสอบสถานะของเต็นท์ก่อน
    SELECT status INTO v_status
    FROM tents
    WHERE tent_id = p_tent_id;

    -- ถ้าสถานะเป็น 'occupied' จะไม่สามารถจองได้
    IF v_status = 'occupied' THEN
        RETURN 'This tent is already occupied. Please choose another tent.';
    END IF;

    -- ✅ INSERT ข้อมูลลงใน tent_booking_system พร้อมรับ booking_id ที่ถูกสร้างขึ้น
    INSERT INTO tent_booking_system (booking_status, booking_date, check_in_date, check_out_date)
    VALUES ('confirmed', CURRENT_DATE, p_check_in, p_check_out)
    RETURNING booking_id INTO v_booking_id;

    -- ✅ INSERT ข้อมูลลงใน tent_bookings (เชื่อม user, tent, campground กับ booking_id)
    INSERT INTO tent_bookings (C_user_id, tent_id, campground_id, booking_id)
    VALUES (p_user_id, p_tent_id, p_campground_id, v_booking_id);

    -- ✅ อัพเดตสถานะเต็นท์เป็น 'occupied'
    UPDATE tents
    SET status = 'occupied'
    WHERE tent_id = p_tent_id;

    -- ✅ แจ้งให้ลูกค้าทราบว่าจองสำเร็จ
    RETURN format('Tent booking successful! Your booking ID is %s', v_booking_id);
END;
$$
LANGUAGE plpgsql;




--4. The system shall allow the registered user to view his campground bookings.


CREATE OR REPLACE FUNCTION user_view_bookings(p_user_id INT)
RETURNS TABLE (
    booking_id INT,
    booking_status VARCHAR(20),
    booking_date DATE,
    check_in_date DATE,
    check_out_date DATE,
    user_id INT,
    tent_id INT,
    campground_id INT,
    campground_name VARCHAR(255),
    campground_location VARCHAR(255)
) AS
$$
BEGIN
    RETURN QUERY
    SELECT 
        tbs.booking_id, 
        tbs.booking_status, 
        tbs.booking_date, 
        tbs.check_in_date, 
        tbs.check_out_date,
        tb.c_user_id,
        tb.tent_id,
        tb.campground_id,
        c.name AS campground_name,   -- ดึงชื่อแคมป์
        c.location AS campground_location  -- ดึงที่ตั้งแคมป์
    FROM tent_booking_system tbs
    JOIN tent_bookings tb ON tbs.booking_id = tb.booking_id
    JOIN campgrounds c ON tb.campground_id = c.campground_id  -- JOIN กับตาราง campground
    WHERE tb.c_user_id = p_user_id;
END;
$$
LANGUAGE plpgsql;








-- 5. The system shall allow the registered user to edit his campground bookings. 

CREATE OR REPLACE FUNCTION edit_booking_dates(
            -- ID ของการจองที่ต้องการแก้ไข
    p_user_id INT,
    p_booking_id INT,           -- ผู้ใช้ที่เป็นเจ้าของการจอง
    p_new_check_in DATE,     -- วันเช็คอินใหม่
    p_new_check_out DATE     -- วันเช็คเอาท์ใหม่
)
RETURNS TEXT AS $$
DECLARE
    v_nights INT;            -- ตัวแปรเก็บจำนวนคืนที่จอง
    v_existing_booking INT;  -- ตรวจสอบว่ามีการจองของ user นี้อยู่หรือไม่
BEGIN
    -- ตรวจสอบจำนวนคืนที่จอง (ต้องไม่เกิน 3 คืน)
    SELECT (p_new_check_out - p_new_check_in) INTO v_nights;
    IF v_nights > 3 THEN
        RETURN 'Error: You can only book a tent for up to 3 nights.';
    END IF;

    -- ตรวจสอบว่า booking_id นี้เป็นของ user จริงหรือไม่
    SELECT COUNT(*) INTO v_existing_booking
    FROM Tent_Booking_System tbs
    JOIN Tent_Bookings tb ON tbs.booking_id = tb.booking_id
    WHERE tb.booking_id = p_booking_id AND tb.C_user_id = p_user_id;

    IF v_existing_booking = 0 THEN
        RETURN 'Error: Booking not found or does not belong to this user.';
    END IF;

    -- อัปเดตวันที่เช็คอินและเช็คเอาท์
    UPDATE Tent_Booking_System
    SET check_in_date = p_new_check_in, check_out_date = p_new_check_out
    WHERE booking_id = p_booking_id;

    RETURN 'Booking dates updated successfully!';
END;
$$ LANGUAGE plpgsql;


-- 6. The system shall allow the registered user to delete his tent bookings.


CREATE OR REPLACE FUNCTION cancel_tent_booking(
    p_user_id INT,
    p_booking_id INT
)
RETURNS TEXT AS
$$
DECLARE
    v_user_id INT;
    v_tent_id INT;
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tent_bookings WHERE booking_id = p_booking_id AND C_user_id = p_user_id) THEN
        RETURN 'User_id invalid.';
    END IF;

    -- ตรวจสอบว่า booking_id ที่ระบุมีการจองอยู่ในระบบหรือไม่
    IF NOT EXISTS (SELECT 1 FROM tent_booking_system WHERE booking_id = p_booking_id) THEN
        RETURN 'Booking ID not found.';
    END IF;

    -- ดึง tent_id ที่ถูกจองมาจากการจอง
    SELECT tent_id INTO v_tent_id
    FROM tent_bookings
    WHERE booking_id = p_booking_id;

    -- ลบข้อมูลการจองจากทั้ง 2 ตาราง tent_bookings และ tent_booking_system
    DELETE FROM tent_bookings WHERE booking_id = p_booking_id and C_user_id = p_user_id;
    DELETE FROM tent_booking_system WHERE booking_id = p_booking_id;

    -- อัพเดตสถานะของเต็นท์กลับเป็น 'available'
    UPDATE tents
    SET status = 'available'
    WHERE tent_id = v_tent_id;

    -- แจ้งผลการยกเลิกการจอง
    RETURN 'Tent booking canceled and status updated to available.';
END;
$$
LANGUAGE plpgsql;



-- 7. The system shall allow the admin to view any campground bookings.

CREATE OR REPLACE FUNCTION admin_view_bookings()
RETURNS TABLE(
    booking_id INT,
    user_id INT,
    first_name VARCHAR(100),
	middle_name VARCHAR(100),
	last_name VARCHAR(100),
	campground_id INT,
    campground_name VARCHAR(100), 
	booking_date DATE,
    check_in_date DATE, 
    check_out_date DATE,
	tent_id INT,
    booking_status VARCHAR(20)
) AS
$$
BEGIN
    RETURN QUERY
    SELECT 
    	tbs.booking_id,
		u.user_id,
		u.first_name,
		u.middle_name,
		u.last_name,
    	tb.campground_id,
		c.name,
		tbs.booking_date,
		tbs.check_in_date, 
    	tbs.check_out_date,
		tb.tent_id,
		tbs.booking_status
	FROM tent_booking_system tbs
	JOIN tent_bookings tb ON tbs.booking_id = tb.booking_id
	JOIN campgrounds c ON tb.campground_id = c.campground_id
	JOIN users u ON tb.c_user_id = u.user_id;
END;
$$
LANGUAGE plpgsql;

--8.The system shall allow the admin to edit any campground bookings.


CREATE OR REPLACE FUNCTION EditCampgroundBooking (
    admin_id INT,
    c_booking_id INT,
    c_booking_status VARCHAR(10)
)
RETURNS TEXT AS
$$
DECLARE
    user_what_role int ;          
BEGIN
    -- Check if the booking status is valid
    IF c_booking_status NOT IN ('confirmed', 'cancelled') THEN
        RAISE EXCEPTION 'Invalid booking status. Use "confirmed" or "cancelled".';
    END IF;

    -- Check if the user is an admin
    SELECT COUNT(*) into user_what_role FROM Users WHERE user_id = admin_id and role='admin';
    IF  ( user_what_role !=0 ) THEN
        
        -- Update the booking status
        UPDATE tent_booking_system
        SET booking_status = c_booking_status
        WHERE booking_id = c_booking_id;

        INSERT INTO Manage_Booking (booking_id, A_user_id, Time_stamp)
        VALUES (c_booking_id,admin_id, NOW());
        
        -- Optionally, check if the update was successful
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Booking ID % not found.', c_booking_id;
        END IF;

    ELSE
        -- Raise an error if the user is not an admin
        RAISE EXCEPTION 'Access Denied: User % is not an admin.', admin_id;
    END IF;
RETURN c_booking_status || ' booking successful!';
END;
$$ LANGUAGE plpgsql;







--9.The system shall allow the admin to delete any campground bookings.
CREATE OR REPLACE FUNCTION DeleteCampgroundBooking (
    admin_id INT,
    c_booking_id INT
)
RETURNS TEXT AS
$$
BEGIN
    -- Check if the user is an admin
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = admin_id AND role = 'admin') THEN
    
        INSERT INTO Manage_Booking (booking_id, A_user_id, Time_stamp)
        VALUES (c_booking_id,admin_id, NOW());

        -- Delete from tent_bookings first if there's a foreign key dependency
        DELETE FROM tent_bookings
        WHERE booking_id = c_booking_id;

        -- Then delete from tent_booking_system
        DELETE FROM tent_booking_system 
        WHERE booking_id = c_booking_id;
        
        

    ELSE
        -- Raise an error if the user is not an admin
        RAISE EXCEPTION 'Access Denied';
    END IF;
RETURN 'Delete booking of customer number '|| c_booking_id || ' SUCCESSFULL';
END;
$$ LANGUAGE plpgsql;


