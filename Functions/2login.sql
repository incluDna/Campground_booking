-- 2. After registration, the user becomes a registered user, and the system shall allow the user to log in to use the system by specifying the email and password. The system shall allow a registered user to log out. 
-- 2.1 เข้าสู่ระบบ


CREATE OR REPLACE FUNCTION login_user(
    p_email VARCHAR(100),
    p_password VARCHAR(255)
)
RETURNS TEXT AS
$$
DECLARE
    v_user_id INT;
    v_stored_password VARCHAR(255);
    v_token UUID;
BEGIN
    -- ตรวจสอบว่ามีอีเลมใน Users Table
    SELECT password INTO v_stored_password
    FROM Users
    WHERE email = p_email;
    
    -- ถ้าไม่เจอก็ฟ้อง
    IF NOT FOUND THEN
        RETURN 'Invalid email address';
    END IF;
    
    -- ถ้ารหัสผ่านไม่ตรงก็ฟ้อง
    IF v_stored_password != p_password THEN
	RETURN 'Invalid password';
    END IF;
    
    -- create token for session --
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";

     v_token := gen_random_uuid();  -- ต้องเปิดใช้ extension pgcrypto หรือใช้ uuid_generate_v4()

    -- บันทึก Token ลงในตาราง Sessions
    INSERT INTO Sessions (user_id, token)
    VALUES (v_user_id, v_token);

    -- ส่งคืน Token ให้ผู้ใช้
    RETURN v_token::TEXT;

    -- ****
        -- ยังไม่ทำการแยกของ user กับ admin
    -- ****

    RETURN 'Login successful';

END;
$$
LANGUAGE plpgsql;



-- วิธีเรียกใช้
-- SELECT login(kai@example.com', 'root1234');
