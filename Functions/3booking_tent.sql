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



-------------
-- เพิ่มข้อมูลลงเต้นท์ก่อน
INSERT INTO Tents (campground_id, tent_size, tent_zone, status, price) --extra_facilities,
VALUES 
(1, '2-person', 'A', 'available', 500), --'Near lake',
(1, '4-person', 'B', 'available', 800), --'Mountain view',
(1, '6-person', 'C', 'available', 1200); --'Near waterfall',

-- ทำการจอง (ต้องแน่ใจว่ามี user_id, tent_id, campground_id นั้นจริงๆก่อน แล้วค่อยจอง)
-- SELECT booking_tent(user_id, tent_id, campground_id, check_in_date, check_out_date);
SELECT booking_tent(6, 5, 1, '2025-02-10', '2025-02-12');

--เรียกดูทั้งหมด (ต.ย.)
SELECT 
    tbs.booking_id, 
    tbs.booking_status, 
    tbs.booking_date, 
    tbs.check_in_date, 
    tbs.check_out_date,
    tb.user_id,
    tb.tent_id,
    tb.campground_id
FROM tent_booking_system tbs
JOIN tent_bookings tb ON tbs.booking_id = tb.booking_id
WHERE tb.user_id = 6;
