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


--เรียกใช้
-- SELECT * FROM user_view_bookings(user_id);
SELECT * FROM user_view_bookings(6);

