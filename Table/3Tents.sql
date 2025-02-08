-- ** 3. Tents Table **
-- เก็บข้อมูลเต็นท์

CREATE TABLE Tents (
    campground_id INT,
    tent_id INT NOT NULL,
    tent_size VARCHAR(50) NOT NULL,
    tent_zone VARCHAR(50) NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('available', 'occupied')),
    price DECIMAL(10,2) NOT NULL,

        -- Composite Primary Key (campground_id + tent_id)
    PRIMARY KEY (campground_id, tent_id),
    
    -- Foreign Key Constraint
    FOREIGN KEY (campground_id) REFERENCES Campgrounds(campground_id) ON DELETE CASCADE
);

-- test_data
INSERT INTO Tents (campground_id, tent_id, tent_size, tent_zone, status, price) VALUES 
(1,1, 'SizeSmall', 'Zone1', 'available', 21.54), 
(1,2, 'SizeSmall', 'Zone1', 'available', 67.59),
(1,3, 'SizeMedium', 'Zone1', 'occupied', 41.56),  
(1,4, 'SizeLarge', 'Zone1', 'available', 13.92), 
(1,5, 'SizeSmall', 'Zone2', 'available', 96.26), 
(1,6, 'SizeSmall', 'Zone2', 'available', 45.35), 
(1,7, 'SizeLarge', 'Zone2', 'occupied', 63.64), 
(2,1, 'SizeSmall', 'Zone1', 'available', 67.59), 
(2,2, 'SizeMedium', 'Zone1', 'occupied', 41.56), 
(2,3, 'SizeLarge', 'Zone1', 'occupied', 66.22),
(2,4, 'SizeSmall', 'Zone2', 'available', 67.59), 
(3,1, 'SizeSmall', 'Zone1', 'available', 20.36), 
(3,2,'SizeSmall', 'Zone1', 'occupied', 50.21), 
(3,3,'SizeLarge', 'Zone1', 'occupied', 63.64), 
(3,4,'SizeMedium', 'Zone2', 'occupied', 41.56), 
(3,5,'SizeLarge', 'Zone2', 'occupied', 66.22);
