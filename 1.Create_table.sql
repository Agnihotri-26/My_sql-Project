create database student_management;
use student_management;
create table students (
student_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50)
);

create table courses (
 course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    teacher_name VARCHAR(100)
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    grade VARCHAR(5),

    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    attendance_date DATE,
    status VARCHAR(10),       -- 'Present', 'Absent', 'Late'
    created_at DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
CREATE TABLE fees (
    fee_id INT PRIMARY KEY,
    student_id INT,
    total_amount INT,
    paid_amount INT,
    due_amount INT,
    payment_date DATE,        -- NULL if Unpaid
    payment_status VARCHAR(10), -- 'Paid', 'Partial', 'Unpaid'
    payment_method VARCHAR(10), -- 'Online', 'Cash', 'Card', NULL
    created_at DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
CREATE TABLE exams (
    exam_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    exam_type VARCHAR(10),    -- 'Midterm', 'Final'
    exam_date DATE,
    total_marks INT,
    obtained_marks INT,
    result VARCHAR(10),       -- 'Pass', 'Fail'
    created_at DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
CREATE TABLE student_login (
    login_id INT PRIMARY KEY,
    student_id INT,
    username VARCHAR(50),
    password_hash VARCHAR(100),
    email VARCHAR(100),
    last_login DATETIME,
    login_count INT,
    is_active TINYINT(1),     -- 1 = Active, 0 = Inactive
    created_at DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

