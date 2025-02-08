-- ** 9. Tent_Facilities Table **
-- เก็บข้อมูล tent facilities (เก็บเป็น Boolean ถ้ามีเพิ่มเติมก็ Text ยาวๆ ช่องเดียว)

CREATE TABLE Tent_Facilities (
    campground_id INT,
    tent_id INT,
    Facilities  VARCHAR(100),
	PRIMARY KEY (campground_id, tent_id, facilities),  -- Composite primary key
    FOREIGN KEY (campground_id, tent_id)
        REFERENCES Tents(campground_id, tent_id)
        ON DELETE CASCADE
);

/*
-- test_data
INSERT INTO Tent_Facilities (campground_id, tent_id, Facilities) VALUES
(1, 1, 'Fan'),
(1, 1, 'Mattress'),
(1, 2, 'Blanket'),
(1, 3, 'Fan'),
(1, 4, 'Light'),
(1, 5, 'Fan'),
(1, 6, 'Fan'),
(1, 7, 'Fan'),
(2, 8, 'Sleeping Bag'),
(2, 9, 'Camping Table'),
(2, 9, 'Fan'),
(2, 10, 'Heater'),
(2, 11, 'Light'),
(3, 12, 'Light'),
(3, 12, 'Fan'),
(3, 13, 'Fan'),
(3, 14, 'Blanket'),
(3, 15, 'Camping Table');
(3, 16, 'Light'),
*/
