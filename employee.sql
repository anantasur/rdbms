CREATE TABLE office(id NUMBER(5) PRIMARY KEY, name VARCHAR(50) NOT NULL, address1 VARCHAR(200),
 address2 VARCHAR(200), city VARCHAR(200));

CREATE TABLE department(id NUMBER(5) PRIMARY KEY, name VARCHAR(50) NOT NULL);

CREATE TABLE employee(id NUMBER(5) PRIMARY KEY, name VARCHAR(50), email_id VARCHAR(100),
acc_no NUMBER(10), dept_id NUMBER(5), gender CHAR(1),  homeOffice_id NUMBER(5),
FOREIGN KEY (dept_id) REFERENCES department(id),
FOREIGN KEY (homeOffice_id) REFERENCES office(id),
CONSTRAINT employee_unique UNIQUE (id, email_id, acc_no));

CREATE SEQUENCE emp_id START WITH 100;

SELECT emp_id.nextval FROM DUAL;

INSERT INTO EMPLOYEE VALUES(emp_id.nextval, 'KRATI', 'kratij@thoughtworks.com', 7654322341, 100, 'F', 05);
INSERT INTO EMPLOYEE VALUES(emp_id.nextval, 'ANANTHU', 'ananthurv@thoughtworks.com', 7654322342, 100, 'M', 05);
INSERT INTO EMPLOYEE VALUES(emp_id.nextval, 'DOLLY', 'dolly@thoughtworks.com', 7654322432, 100, 'F', 03 );
INSERT INTO EMPLOYEE VALUES(emp_id.nextval, 'KAUSTAV', 'kaustav@thoughtworks.com', 7654322444, 100, 'M', 03 );

INSERT INTO OFFICE VALUES(01, 'BANGALORE', 'ACR MANSION','147/F, 8th Main, 3rd Block', 'Koramangala');
INSERT INTO OFFICE VALUES(02, 'PUNE', 'Binarius Building Deepak Complex','National Games Road', ' Yerawada');
INSERT INTO OFFICE VALUES(03, 'GURGAON', '6th Floor, Tower B', 'Building No. 14 ','DLF Cyber City Phase III');
INSERT INTO OFFICE VALUES(04, 'HYDERABAD', 'Apurupa Silpi','Beside H.P. Petrol Bunk', 'Gachibowli');
INSERT INTO OFFICE VALUES(05, 'CHENNAI', 'Ascendas International Tech Park','Zenith - 9th Floor Tharamani Road', 'Tharamani');

INSERT INTO DEPARTMENT VALUES(100, 'STEP');
