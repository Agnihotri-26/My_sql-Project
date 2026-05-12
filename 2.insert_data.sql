-- Insert data and run basic query (all data in .csv file)
-- SELECT * FROM student_management.students;
-- SELECT * FROM student_management.courses;
-- SELECT * FROM student_management.enrollments;

-- =============================================
-- FILE: 02_insert_data.sql
-- Load data from CSV files into all tables
-- Run from MySQL Workbench after 01_create_tables.sql
-- =============================================

USE student_management;

-- Disable foreign key checks during import
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/your-folder/students.csv'
INTO TABLE students
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/courses.csv'
INTO TABLE courses
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/enrollment.csv'
INTO TABLE enrollment
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/attendance.csv'
INTO TABLE attendance
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/fees.csv'
INTO TABLE fees
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/exam.csv'
INTO TABLE exams
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/your-folder/exam.csv'
INTO TABLE student_login
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
