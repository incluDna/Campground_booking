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

--SELECT edit_booking_dates(3, 6, '2025-02-13', '2025-02-15');
--edit_booking_dates
