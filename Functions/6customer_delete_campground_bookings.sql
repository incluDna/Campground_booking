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

-- วิธีเรียกใช้
--SELECT cancel_tent_booking(booking_id);
