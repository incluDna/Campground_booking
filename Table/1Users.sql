-- ** 1. Users Table **
-- เก็บข้อมูล user เป็น customer และ admin

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

-- test_data
INSERT INTO Users (first_name, middle_name, last_name, email, password, phone, role) VALUES 
('Aitsayaphan','Sigma','Limmuangnil','aitsayaphan@example.com','hashedpassword1','0234567891','customer'),
('Aphiwich','Sigma','Sangpet','aphiwich@example.com','hashedpassword2','0234567892','admin'),
('Atipat','Sigma','Buranavatanachoke','atipat@example.com','hashedpassword3','0234567893','customer'),
('Sirikarn','Sigma','Fugsrimuang','sirikarn@example.com','hashedpassword4','0234567894','customer'),
('Penpitcha','Sigma','Piyawaranont','penpitcha@example.com','hashedpassword5','0234567895','admin'),
('Pasit','Sigma','Bunsophon','pasit@example.com','hashedpassword6','0234567896','customer');
