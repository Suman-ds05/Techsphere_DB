CREATE DATABASE techsphere_db;
USE techsphere_db;
CREATE TABLE Employee_Details (
    employeeid INT PRIMARY KEY NOT NULL,
    employeename VARCHAR(100) NOT NULL,
    age INT,
    gender ENUM('Male', 'Female', 'Other'),
    department_id INT NOT NULL,
    job_title VARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10,2),
    manager_id INT,
    location VARCHAR(100),
    performance_score VARCHAR(20),
    certifications TEXT,
    experience_years INT,
    shift ENUM('Day', 'Night'),
    remarks TEXT
);
CREATE TABLE Project_Assignments (
    project_id INT PRIMARY KEY NOT NULL,
    employeeid INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    technologies_used TEXT,
    hours_worked INT,
    FOREIGN KEY (employeeid) REFERENCES Employee_Details(employeeid)
);
CREATE TABLE Attendance_Records (
    record_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    employeeid INT NOT NULL,
    total_hours INT,
    days_present INT,
    overtime_hours INT,
    leave_days INT,
    manager_feedback TEXT,
    FOREIGN KEY (employeeid) REFERENCES Employee_Details(employeeid)
);
CREATE TABLE Training_Programs (
    program_id INT PRIMARY KEY NOT NULL,
    employeeid INT NOT NULL,
    training_name VARCHAR(255) NOT NULL,
    department_id INT NOT NULL,
    completion_date DATE,
    feedback_score DECIMAL(3,2),
    technologies_learned TEXT,
    FOREIGN KEY (employeeid) REFERENCES Employee_Details(employeeid),
    FOREIGN KEY (department_id) REFERENCES Employee_Details(department_id)
);
CREATE TABLE Training_Programs (
    program_id INT PRIMARY KEY NOT NULL,
    employeeid INT NOT NULL,
    training_name VARCHAR(255) NOT NULL,
    completion_date DATE,
    feedback_score DECIMAL(3,2),
    technologies_learned TEXT,
    FOREIGN KEY (employeeid) REFERENCES Employee_Details(employeeid)
);
INSERT INTO Employee_Details (employeeid, employeename, age, gender, department_id, job_title, hire_date, salary, manager_id, location, performance_score, certifications, experience_years, shift, remarks)  
VALUES  
(1, 'Amit Sharma', 30, 'Male', 101, 'Software Engineer', '2020-06-15', 75000.00, 5, 'Bangalore', 'Excellent', 'AWS Certified', 5, 'Day', 'Hardworking'),  
(2, 'Priya Verma', 28, 'Female', 102, 'Data Analyst', '2019-08-21', 65000.00, 6, 'Pune', 'Good', 'SQL Expert', 4, 'Day', 'Detail-oriented'),  
(3, 'Rahul Singh', 35, 'Male', 103, 'Project Manager', '2018-03-10', 90000.00, NULL, 'Mumbai', 'Outstanding', 'PMP Certified', 10, 'Day', 'Great leadership');  
INSERT INTO Project_Assignments (project_id, employeeid, project_name, start_date, end_date, budget, technologies_used, hours_worked)  
VALUES  
(201, 1, 'Cloud Migration', '2023-01-10', '2023-06-30', 500000.00, 'AWS, Python', 1200),  
(202, 2, 'Retail Data Analysis', '2023-03-15', '2023-09-30', 300000.00, 'SQL, Power BI', 950),  
(203, 3, 'Infrastructure Upgrade', '2022-11-05', '2023-05-20', 700000.00, 'Cisco, VMware', 1350);  
INSERT INTO Attendance_Records (employeeid, total_hours, days_present, overtime_hours, leave_days, manager_feedback)  
VALUES  
(1, 160, 20, 10, 2, 'Consistently meets deadlines'),  
(2, 145, 18, 5, 4, 'Needs improvement in time management'),  
(3, 170, 22, 15, 1, 'Excellent leadership and dedication');  
INSERT INTO Training_Programs (program_id, employeeid, training_name, completion_date, feedback_score, technologies_learned)  
VALUES  
(301, 1, 'AWS Cloud Certification', '2023-07-15', 4.8, 'AWS, DevOps'),  
(302, 2, 'Advanced SQL & Data Analytics', '2023-08-20', 4.5, 'SQL, Power BI'),  
(303, 3, 'Project Management Professional (PMP)', '2023-06-10', 4.9, 'Leadership, Agile');  
SELECT * FROM Employee_Details;
SELECT * FROM Project_Assignments;
SELECT * FROM Attendance_Records;
SELECT * FROM Training_Programs;
SELECT employeeid, SUM(total_hours) AS total_hours_worked  
FROM Attendance_Records  
GROUP BY employeeid  
ORDER BY total_hours_worked DESC  
LIMIT 5;
SELECT training_name, AVG(feedback_score) AS avg_feedback  
FROM Training_Programs  
GROUP BY training_name  
ORDER BY avg_feedback DESC;
SELECT project_name,  
       budget,  
       hours_worked,  
       (budget / hours_worked) AS cost_per_hour  
FROM Project_Assignments  
ORDER BY cost_per_hour DESC;
SELECT e.department_id,  
       AVG(a.days_present) AS avg_days_present,  
       AVG(a.leave_days) AS avg_leave_days  
FROM Employee_Details e  
JOIN Attendance_Records a ON e.employeeid = a.employeeid  
GROUP BY e.department_id  
ORDER BY avg_leave_days DESC;
SELECT t.employeeid, t.training_name, t.technologies_learned,  
       p.project_name, p.technologies_used  
FROM Training_Programs t  
JOIN Project_Assignments p ON t.employeeid = p.employeeid  
WHERE t.technologies_learned LIKE CONCAT('%', p.technologies_used, '%');
SELECT e.employeeid, e.employeename, e.performance_score,  
       p.project_name, p.budget  
FROM Employee_Details e  
JOIN Project_Assignments p ON e.employeeid = p.employeeid  
WHERE e.performance_score IN ('Excellent', 'Outstanding')  
ORDER BY p.budget DESC  
LIMIT 5;
SELECT e.employeeid, e.employeename,  
       t.training_name, t.technologies_learned,  
       p.project_name, p.technologies_used  
FROM Employee_Details e  
JOIN Training_Programs t ON e.employeeid = t.employeeid  
JOIN Project_Assignments p ON e.employeeid = p.employeeid  
WHERE t.technologies_learned LIKE CONCAT('%', p.technologies_used, '%')  
ORDER BY p.budget DESC;
SELECT * FROM Employee_Details  
INTO OUTFILE '/var/lib/mysql-files/Employee_Details.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';
SELECT * FROM Employee_Details  
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Employee_Details.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';

SELECT * FROM Project_Assignments  
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project_Assignments.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';
SELECT * FROM Attendance_Records  
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Attendance_Records.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';
SELECT * FROM Training_Programs  
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Training_Programs.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';
