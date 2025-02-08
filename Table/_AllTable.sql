CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('admin', 'customer')) 
);

CREATE TABLE Campgrounds (
    campground_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    map_url TEXT,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL
);

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


CREATE TABLE Tent_Booking_System (
    booking_id SERIAL PRIMARY KEY,
    booking_status VARCHAR(10) NOT NULL CHECK (booking_status IN ('confirmed', 'cancelled')),
    booking_date DATE,
    check_in_date DATE,
    check_out_date DATE

);

CREATE TABLE Manage_Booking (
    booking_id INT,
    A_user_id INT,
    Time_stamp TIME,
    PRIMARY KEY (booking_id, A_user_id,Time_stamp),
    FOREIGN KEY (booking_id) REFERENCES Tent_Booking_System(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (A_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

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

CREATE TABLE Manage_Tent (
    tent_id INT,
    A_user_id INT,
    campground_id INT,
    Time_stamp TIME,
       PRIMARY KEY (campground_id, tent_id, A_user_id),  -- Composite primary key to uniquely identify each management relation

    FOREIGN KEY (campground_id, tent_id)  -- Reference to weak entity Tent
        REFERENCES Tents(campground_id, tent_id)
        ON DELETE CASCADE,

    FOREIGN KEY (A_user_id)  -- Reference to User
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE Campground_Facilities (
    campground_id INT,
    facilities  VARCHAR(100),
    PRIMARY KEY (campground_id, facilities),  -- Composite primary key
    FOREIGN KEY (campground_id) REFERENCES Campgrounds(campground_id) ON DELETE CASCADE
   
    
);


CREATE TABLE Tent_Facilities (
    campground_id INT,
    tent_id INT,
    Facilities  VARCHAR(100),
	PRIMARY KEY (campground_id, tent_id, facilities),  -- Composite primary key
    FOREIGN KEY (campground_id, tent_id)
        REFERENCES Tents(campground_id, tent_id)
        ON DELETE CASCADE
);


CREATE TABLE Sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    token UUID UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expired_at TIMESTAMP
);
