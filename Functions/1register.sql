-- 1. The system shall allow a user to register by specifying the name, telephone number, email, and password.  


CREATE OR REPLACE FUNCTION register(
    p_first_name VARCHAR(100)  ,
    p_middle_name VARCHAR(100),
    p_last_name VARCHAR(100)  ,
    p_email VARCHAR(100)   ,
    p_password VARCHAR(255)  ,
    p_phone VARCHAR(15)  
)
RETURNS TEXT AS --แก้ void เป็น text รันได้
$$
declare 
id_count integer := 0;
BEGIN
    -- ตรวจสอบว่าอีเมลถูกใช้แล้วหรือไม่
    IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email is already registered';
    END IF;

    -- แทรกผู้ใช้ใหม่ลงใน Users Table
	

    INSERT INTO Users (first_name, middle_name, last_name, email, password, phone, role)
    VALUES (p_first_name, p_middle_name, p_last_name, p_email, p_password, p_phone, 'customer');
    -- ให้ role ตั้งต้น 'customer' (เพราะ admin Gen ใช้เอง)

    RETURN 'Registered successfully';
END;
$$
LANGUAGE plpgsql;




-- วิธีเรียกใช้
-- SELECT register('rai', 'in', 'ram', 'rai@example.com', 'root1234', '0877880314');
-- SELECT register('atipat', 'beau', 'brchk', 'beau@example.com', '43214321', '0909090');
