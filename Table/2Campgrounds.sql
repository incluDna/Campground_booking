-- ** 2. Campgrounds Table **
-- เก็บข้อมูล campgrounds 

CREATE TABLE Campgrounds (
    campground_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    map_url TEXT,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL
);

-- test_data
INSERT INTO Campgrounds (name, location, phone, map_url, open_time, close_time) VALUES
('Sunny Campground', 'Chiangmai', '0987654321', 'http://map1.com', '08:00', '20:00'), 
('Rainy Campground', 'Bangkok', '0987654322', 'http://map2.com', '08:00', '21:00'),
('Winter Campground', 'Songkhla', '0987654323', 'http://map3.com', '09:00', '23:00');
