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

--DeleteCampgroundBooking(admin_id ,c_booking_id )
-- select DeleteCampgroundBooking(1 ,6 ) --not admin
-- select DeleteCampgroundBooking(5 ,6 ) --admin
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
