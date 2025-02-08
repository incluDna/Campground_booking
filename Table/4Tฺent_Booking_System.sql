-- ** 4. Tent_Booking_System Table **
-- เก็บข้อมูลการจองเต็นท์

CREATE TABLE Tent_Booking_System (
    booking_id SERIAL PRIMARY KEY,
    booking_status VARCHAR(10) NOT NULL CHECK (booking_status IN ('confirmed', 'cancelled')),
    booking_date DATE,
    check_in_date DATE,
    check_out_date DATE

);

/*
-- test_data
INSERT INTO Tent_Booking_System (booking_id, booking_status, booking_date, check_in_date, check_out_date) VALUES
(1, 'confirmed', '2025-01-01', '2025-02-01', '2025-02-05'),
(2, 'cancelled', '2025-01-10', '2025-02-03', '2025-02-06'),
(3, 'confirmed', '2025-01-11', '2025-02-05', '2025-02-07'),
(4, 'confirmed', '2025-01-15', '2025-02-07', '2025-02-08');
*/