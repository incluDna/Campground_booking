-- 2. After registration, the user becomes a registered user, and the system shall allow the user to log in to use the system by specifying the email and password. The system shall allow a registered user to log out. 
-- 2.2 ออกจากระบบ


CREATE OR REPLACE FUNCTION logout_user(
    p_token UUID
)
RETURNS TEXT AS
$$
DECLARE
    v_session_id INT;
BEGIN
    -- ตรวจสอบว่า token นี้มีอยู่ในตาราง Sessions หรือไม่
    SELECT session_id INTO v_session_id
    FROM Sessions
    WHERE token = p_token;

    -- ถ้าไม่เจอ token
    IF NOT FOUND THEN
        RETURN 'Invalid session or already logged out';
    END IF;

    -- ลบ session ออกจากตาราง
    DELETE FROM Sessions
    WHERE session_id = v_session_id;

    RETURN 'Logout successful';
END;
$$
LANGUAGE plpgsql;


-- SELECT logout_user(token(uuid));



