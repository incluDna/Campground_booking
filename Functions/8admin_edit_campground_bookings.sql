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





# Try call open_new_saving_account()
call open_new_saving_account('Babara', '11', 'B', 800.0);
--select editcampgroundbooking(admin_id, c_booking_id, c_booking_statu)
--select editcampgroundbooking(7, 6, 'cancelled'); -- not admin
--select editcampgroundbooking(5, 6, 'cancelled') -- admin
