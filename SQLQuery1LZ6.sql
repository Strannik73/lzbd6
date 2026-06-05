create database User_Actions
use User_Actions

USE master;
ALTER DATABASE User_Actions 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE;
DROP DATABASE User_Actions;

create table User_Logs(
	id INT IDENTITY(100000000,1),
	username TEXT not null,
	user_actions TEXT not null,
	action_date DATE not null,
	action_time TIME not null,
	action_result TEXT not null
	)

SET NOCOUNT ON;

WITH Tally AS (
    SELECT TOP 1000000
        rn = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v1(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v2(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v3(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v4(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v5(n)
    CROSS JOIN (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v6(n)
),
Randomized AS (
    SELECT
        rn,
        rand_val = ABS(CHECKSUM(NEWID()))
    FROM Tally
)
INSERT INTO User_Logs WITH (TABLOCK) (username, user_actions, action_date, action_time, action_result)
SELECT
    'user_' + RIGHT('00000' + CAST(rand_val % 99999 AS VARCHAR(5)), 5),
    
    CASE rand_val % 8
        WHEN 0 THEN 'LOGIN'      WHEN 1 THEN 'LOGOUT'
        WHEN 2 THEN 'UPDATE'     WHEN 3 THEN 'DELETE'
        WHEN 4 THEN 'VIEW'       WHEN 5 THEN 'CREATE'
        WHEN 6 THEN 'EXPORT'     WHEN 7 THEN 'IMPORT'
        ELSE 'UNKNOWN'           
    END,
    DATEADD(DAY, rand_val % 365, '2025-01-01'),
    
    DATEADD(SECOND, rand_val % 86400, CAST('00:00:00' AS TIME)),
    
    CASE rand_val % 5
        WHEN 0 THEN 'SUCCESS'        WHEN 1 THEN 'FAILED'
        WHEN 2 THEN 'PENDING'        WHEN 3 THEN 'TIMEOUT'
        WHEN 4 THEN 'ACCESS_DENIED'
        ELSE 'ERROR'                
    END
FROM Randomized;

select * from User_Logs