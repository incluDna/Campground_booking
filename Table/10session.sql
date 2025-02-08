-- ** 10. Sessions Table **
-- เก็บข้อมูล sessions login / logout


CREATE TABLE Sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    token UUID UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expired_at TIMESTAMP
);

-- autogen when login by registered account --
