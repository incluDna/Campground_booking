-- ** 6. Tent_Bookings Table **
-- เก็บข้อมูลการจองเต็นท์ (ตรงนี้ลูกค้าจองได้หลายเต็นท์)

CREATE TABLE Tent_Bookings (
    C_user_id INT,
    tent_id INT,
    campground_id INT,
    booking_id INT,
    PRIMARY KEY (C_user_id, tent_id,campground_id),
    FOREIGN KEY (C_user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tent_id,campground_id) REFERENCES Tents(tent_id,campground_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES tent_booking_system(booking_id) ON DELETE CASCADE
);

/*
-- test_data
INSERT INTO Tent_Bookings (C_user_id, tent_id, campground_id, booking_id) VALUES
(1, 9, 2, 1),
(1, 3, 2, 2),
(3, 7, 1, 3),
(6, 16, 3, 4);
*/