-- ** 8. Campground_Facilities Table **
-- เก็บข้อมูล campground facilities (เก็บเป็น Boolean ถ้ามีเพิ่มเติมก็ Text ยาวๆ ช่องเดียว)

CREATE TABLE Campground_Facilities (
    campground_id INT,
    facilities  VARCHAR(100),
    PRIMARY KEY (campground_id, facilities),  -- Composite primary key
    FOREIGN KEY (campground_id) REFERENCES Campgrounds(campground_id) ON DELETE CASCADE
   
    
);

/*
-- test_data
INSERT INTO Campground_Facilities (campground_id, Facilities) VALUES
(1, 'Restroom'),
(1, 'Parking'),
(1, 'WiFi'),
(1, 'Fire Pit'),
(2, 'Restroom'),
(2, 'Shower'),
(2, 'Electric Outlet'),
(3, 'Parking'),
(3, 'WiFi'),
(3, 'Campfire Area');
*/
