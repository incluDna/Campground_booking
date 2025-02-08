-- ** 5. Manage_Booking Table **
-- เก็บข้อมูลการจองของ customer

CREATE TABLE Manage_Booking (
    booking_id INT,
    A_user_id INT,
    Time_stamp TIME,
    PRIMARY KEY (booking_id, A_user_id,Time_stamp),
    FOREIGN KEY (booking_id) REFERENCES Tent_Booking_System(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (A_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

/*
-- test_data
INSERT INTO Manage_Booking (booking_id, A_user_id, Time_stamp) VALUES
(1, 1, '13:00'),
(2, 1, '14:00'),
(3, 3, '21:00'),
(4, 6, '10:00');
*/
