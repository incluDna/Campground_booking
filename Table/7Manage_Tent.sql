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