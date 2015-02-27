
conn / as sysdba

PROMPT 'Creating Tablespaces'

-- Create tablespaces
CREATE TABLESPACE ts_emp_system DATAFILE 'C:\ORACLEXE\APP\ORACLE\ORADATA\XE\emp_system_01.dbf' SIZE 200M AUTOEXTEND ON;
PROMPT '.... Tablespace creation completed.'


DROP USER emp_user CASCADE;

-- Creating users
PROMPT 'Creating user'
CREATE USER emp_user IDENTIFIED BY password DEFAULT TABLESPACE ts_emp_system QUOTA UNLIMITED ON ts_emp_system;
GRANT CREATE SESSION TO emp_user;
GRANT RESOURCE TO emp_user;
PROMPT '.... User created with required privileges'

-- Connect as the schema user
PROMPT 'Connecting as Employee user'
conn emp_user/password

-- Cleanup object before creating
/* Uncomment when necessary */
-- DROP TABLE department CASCADE CONSTRAINTS;
-- DROP TABLE employee CASCADE CONSTRAINTS;
-- DROP SEQUENCE seq_emp_id;


-- Create Employee table
CREATE TABLE employee (
id			NUMBER(10),
name		VARCHAR(50) NOT NULL,
pan_number	VARCHAR(10) NOT NULL UNIQUE,
gender		CHAR(1),
cell_phone	VARCHAR(15),
CONSTRAINT emp_pk PRIMARY KEY(id),
CONSTRAINT emp_gender_chk CHECK(gender IN ('M', 'F') )
);

-- Create Department table - an example to create a table in a desired tablespace
CREATE TABLE department (
id			NUMBER(10),
dept_name	VARCHAR(50),
CONSTRAINT dept_pk PRIMARY KEY(id)
) TABLESPACE ts_emp_system;

-- Create constraints
ALTER TABLE department ADD CONSTRAINT dept_name_u UNIQUE(dept_name);

-- Sequence
CREATE SEQUENCE seq_emp_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- Let us add SALARY column to employee table
ALTER TABLE employee ADD (salary number(10) );
ALTER TABLE employee ADD (dept_id NUMBER(10) );

INSERT INTO department VALUES (2001,'PRODUCTION');
-- Insert sample data
INSERT INTO department VALUES (2002,'SALES');
INSERT INTO department VALUES (2003,'MARKETING');
INSERT INTO department VALUES (2004,'SUPPORT');

COMMIT;

INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAA','ABCXX1000Z','M',9999900001,20000,2002);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAB','ABCXX1001Z','M',9999900002,18500,2001);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAC','ABCXX1002Z','F',9999900003,63000,2001);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAD','ABCXX1003Z','M',9999900004,7500,2003);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAE','ABCXX1004Z','F',9999900005,30000,2002);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAF','ABCXX1005Z','F',9999900006,24000,2001);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAF','ABCXX1006Z','F',9999900007,52000,2002);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAG','ABCXX1007Z','M',9999900008,14000,2003);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAH','ABCXX1008Z','M',9999900009,18500,2003);
INSERT INTO employee VALUES (seq_emp_id.nextval,'AAAI','ABCXX1009Z','M',9999900010,18500,2001);
INSERT INTO employee (id,name,pan_number,gender,cell_phone,salary) VALUES (seq_emp_id.nextval,'AAAJ','ABCXX1010Z','F',9999900011,19500);

COMMIT;

-- SELECT COUNT(id) FROM EMPLOYEE WHERE salary>60000;
-- SELECT COUNT(id) FROM EMPLOYEE WHERE salary>20000 AND gender='M';
-- SELECT * FROM EMPLOYEE WHERE ROWNUM < 2;
-- SELECT id,ROWNUM FROM EMPLOYEE;
-- SELECT id,ROWNUM FROM EMPLOYEE ORDER BY id;
-- SELECT id,ROWNUM FROM EMPLOYEE ORDER BY id DESC;
-- SELECT id,ROWNUM FROM EMPLOYEE WHERE gender='F';

-- SELECT id,dept_id,name FROM EMPLOYEE;

-- SELECT e.id,e.name,d.dept_name FROM EMPLOYEE e, department d WHERE e.dept_id = d.id;

-- SELECT * FROM EMPLOYEE e JOIN department d ON (e.dept_id = d.id);

-->CROSS JOIN<--
-- SELECT E.id, E.name, D.dept_name FROM EMPLOYEE E, department D;
-- SELECT E.* 
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name= 'PRODUCTION';

-- SELECT SUM(E.salary) 
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name= 'SALES' AND E.gender = 'F';

-- SELECT AVG(E.salary) 
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name= 'MARKETING' AND E.gender = 'M';

-- SELECT AVG(E.salary) 
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name= 'MARKETING' OR D.dept_name= 'SALES';

-- SELECT E.name, D.dept_name 
--  FROM EMPLOYEE E RIGHT OUTER JOIN department D 
--  ON(E.dept_id = D.id) ;

-- SELECT E.name, D.dept_name 
--  FROM EMPLOYEE E FULL OUTER JOIN department D 
--  ON(E.dept_id = D.id) ;

-- SELECT E.id, E.name, D.dept_name
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name IN ('SALES','PRODUCTION');


-- SELECT E.id
-- 	FROM EMPLOYEE E JOIN department D 
-- 	ON(E.dept_id = D.id) 
-- 	WHERE D.dept_name NOT IN ('SALES','PRODUCTION');

/*SELECT E.*
	FROM EMPLOYEE E JOIN department D 
	ON(E.dept_id = D.id) 
	WHERE D.dept_name IN ('PRODUCTION');*/

GRANT CREATE VIEW TO emp_user;

CREATE VIEW PRODUCTION_EMPLOYEES AS SELECT E.*
	FROM EMPLOYEE E JOIN department D 
	ON(E.dept_id = D.id) 
	WHERE D.dept_name IN ('PRODUCTION');


-- SELECT * FROM PRODUCTION_EMPLOYEES;

CONNECT / AS sysdba
DROP USER reporter;
CREATE USER reporter IDENTIFIED BY password DEFAULT TABLESPACE ts_emp_system QUOTA UNLIMITED ON ts_emp_system;
GRANT CREATE SESSION TO reporter;
GRANT RESOURCE TO reporter;

conn emp_user/password;
GRANT SELECT ON PRODUCTION_EMPLOYEES TO reporter;

CONNECT reporter/password;
SELECT * FROM emp_user.PRODUCTION_EMPLOYEES;

CREATE SYNONYM prod_emp 
   FOR emp_user.PRODUCTION_EMPLOYEES;

--CREATE OR REPLACE VIEW

--union
-- select id,name from employee where dept_id in (2001) UNION select id,name from employee where dept_id in (2002);

-- select name from PRODUCTION_EMPLOYEES 
-- union all
-- select name from sales_EMPLOYEES ;

-- select name from PRODUCTION_EMPLOYEES 
-- intersect
-- select name from sales_EMPLOYEES ;

-- ALTER TABLE employee ADD (MANAGER number(10) );

-- ALTER TABLE employee
-- ADD FOREIGN KEY (manager) 
-- REFERENCES employee(id);

-- select * from user_constraints;

-- SELECT constraint_name,constraint_type 
-- FROM user_constraints WHERE TABLE_NAME = 'EMPLOYEE';

-- SELECT constraint_name,constraint_type 
-- FROM user_constraints;

-- ALTER TABLE employee DROP COLUMN manager;

--add column manager
@D:\_Drive\_WORKSPACE\rdbmsWorkspace\rdbms\dbscript;

-- CREATE TABLE MANAGERS AS SELECT E.ID, E.NAME FROM EMPLOYEE E;

-- SELECT E.ID AS EMPLOYEE_ID, E.NAME AS EMPLOYEE_NAME, M.NAME AS MANAGER_NAME FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MGR_ID=M.ID ORDER BY E.ID;

-- SELECT E.ID AS EMPLOYEE_ID, E.NAME AS EMPLOYEE_NAME, M.NAME AS MANAGER_NAME, D.DEPT_NAME AS DEPARTMENT
-- FROM EMPLOYEE E ,MANAGERS M ,DEPARTMENT D WHERE E.MGR_ID=M.ID AND E.DEPT_ID = D.ID;

-- SELECT E.ID AS EMPLOYEE_ID, E.NAME AS EMPLOYEE_NAME, M.NAME AS MANAGER_NAME, D.DEPT_NAME AS DEPARTMENT
-- FROM EMPLOYEE E LEFT OUTER JOIN MANAGERS M ON (E.MGR_ID = M.ID) LEFT OUTER JOIN DEPARTMENT D ON(E.DEPT_ID = D.ID);