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


-- test
SELECT * from admin_view_bookings();

-- test
SELECT * from admin_view_bookings();

-- SELECT * FROM admin_view_bookings();


-- CREATE OR REPLACE FUNCTION admin_view_campground_bookings(
--     p_admin_id INT
-- )
-- RETURNS TABLE (
--     booking_id INT,
--     user_id INT,
--     campground_name VARCHAR(100),
--     booking_status VARCHAR(10),
--     booking_date DATE,
--     check_in_date DATE,
--     check_out_date DATE
-- ) AS $$
-- BEGIN
--     -- ตรวจสอบว่า p_admin_id ที่ส่งเข้ามาคือ Admin จริง ๆ หรือไม่
--     IF NOT EXISTS (SELECT 1 FROM Users WHERE Users.user_id = p_admin_id AND Users.role = 'admin') THEN
--         RAISE EXCEPTION 'Only admins can view campground bookings!';
--     END IF;

--     -- ดึงข้อมูลการจองทั้งหมดสำหรับ Admin
--     RETURN QUERY
--     SELECT 
--         tb.booking_id, 
--         tb.user_id,  
--         c.name AS campground_name, 
--         tbs.booking_status, 
--         tbs.booking_date::DATE,
--         tbs.check_in_date::DATE,
--         tbs.check_out_date::DATE
--     FROM Tent_Bookings tb
--     JOIN Campgrounds c ON tb.campground_id = c.campground_id
--     JOIN Tent_Booking_System tbs ON tb.booking_id = tbs.booking_id
--     ORDER BY tbs.booking_date DESC;

-- END;
-- $$ LANGUAGE plpgsql;

-- -- วิธีเรียกใช้

-- -- 1. เพิ่มข้อมูลใน Table "Users"
--     -- Admin
-- INSERT INTO Users (first_name, last_name, email, password, phone, role)
-- VALUES
-- ('Admin', 'User', 'admin@example.com', 'password123', '0123456789', 'admin');
--     -- Customer
-- INSERT INTO Users (first_name, last_name, email, password, phone, role)
-- VALUES
-- ('John', 'Doe', 'john.doe@example.com', 'password123', '0987654321', 'user');

-- -- 2. เพิ่มข้อมูลใน Table "Campgrounds"
-- INSERT INTO Campgrounds (name, location, phone, map_url, open_time, close_time)
-- VALUES
-- ('Sunny Campground', 'Pattaya', '034123456', 'https://example.com/map', '08:00', '20:00');

-- -- 3. เพิ่มข้อมูลใน Table "Tent_Booking_System"
-- INSERT INTO Tent_Booking_System (booking_id, booking_status, booking_date, check_in_date, check_out_date)
-- VALUES
-- (1, 'confirmed', '2025-01-01', '2025-02-01', '2025-02-05'),
-- (2, 'confirmed', '2025-01-10', '2025-02-03', '2025-02-06');

-- -- 4. เพิ่มข้อมูลใน Table "Tents"
-- INSERT INTO Tents (campground_id, tent_size, tent_zone, status, price)
-- VALUES
-- (1, 'Small', 'Zone A', 'available', 500.00),
-- (1, 'Medium', 'Zone B', 'occupied', 700.00);
-- (1, 'Large', 'Zone A', 'available', 100.00);

-- -- 5. เพิ่มข้อมูลใน Table "Tent_Bookings"
--     -- ทดสอบโดยใช้ user_id = 9 (user)
--     -- ทดสอบโดยใช้ tent_id = 101, 102
-- INSERT INTO Tent_Bookings (user_id, campground_id, tent_id, booking_id)
-- VALUES
-- (9, 1, 101, 1), -- Customer 'John' (user_id = 9) จองเต็นท์ที่ค่าย Sunny
-- (9, 1, 102, 2); -- Customer 'John' (user_id = 9) จองเต็นท์อีกหลังที่ค่าย Sunny

-- -- 6. ทดสอบ Function
--     -- ดู user_id ของ admin
--     -- SELECT * FROM Users WHERE role = 'admin';
--     -- ทดสอบโดยใช้ user_id = 7 (admin)
-- SELECT * FROM admin_view_campground_bookings(7);
