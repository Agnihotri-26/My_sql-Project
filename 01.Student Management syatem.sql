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
-- ** Basic Queries **
-- Q1. Show all students.
 select * from Students;
 
-- Q2. Show only name and city of all students.
select name, city
from students;

-- Q3. Find all female students.
select name 
from students
where gender = 'female';

-- Q4. Find students whose age is greater than 21.
select *
from students 
where age > 21;

-- Q5. Show all courses and their teachers.
select course_name, teacher_name
from courses;

-- Q6. Find the student with student_id = 15.
select name 
from students
where student_id =15;

-- Q7. Show all enrollments where marks are greater than 80.
select * from enrollments
where marks > 80;

-- Q8. Find all students who live in 'Lucknow'.
select * from students
where city ='lucknow';

-- Q9. Show all students sorted by age (youngest first).
select * from students
order by age ;

-- Q10. Count total number of students.
select count(*) from students;

-- ** Intermediate Queries  **
-- Q11. Show name and marks of each student using JOIN.
select s.name, e.marks, e.grade
from students s
join enrollments e
on s.student_id = e.student_id;

-- Q12. Show student name, course name, and marks together.
select s.name, c.course_name, e.marks
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on c.course_id = e.course_id;

-- Q13. Find all students who got grade 'A'.
select s.name, e.grade
from students s
join enrollments e
on s.student_id = e.student_id
where e.grade ='A';

-- Q14. Find average marks for each course.
select avg(e.marks), c.course_name as avg_marks
from courses c
join enrollments e
on c.course_id = e.course_id
group by c.course_name;

-- Q15. Count how many students are enrolled in each course.
select count(e.student_id), c.course_name as total_student
from courses c
join enrollments e
on c.course_id = e.course_id
group by c.course_name;

-- Q16. Find the highest marks scored in each course.
select c.course_name, max(e.marks) 
from enrollments e
join courses c
on c.course_id = e.course_id
group by c.course_name
order by c.course_name desc;

-- ** ADVANCED QUERIES **
-- Q17. Find students who scored below 50 (failing students) with their course name.
select s.name, c.course_name, e.marks, e.grade as fail_student
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on c.course_id = e.course_id
WHERE e.marks < 50
ORDER BY e.marks ASC;

-- Q18. Find the top 5 students with the highest marks across all courses.
select s.name, c.course_name, e.marks, e.grade as highest_marks
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on c.course_id =e.course_id
order by e.marks desc
limit 5;

-- Q19. Find courses where the average marks are above 75.
select c.course_name, avg(e.marks) as avg_marks
from courses c
join enrollments e
on c.course_id = e.course_id
group by c.course_name
having avg(e.marks) > 75 ;

-- Q20. Show city-wise count of students and average age, only for cities with more than 1 student.
SELECT city, COUNT(*) AS total_students, AVG(age) AS avg_age
from students
group by city
HAVING COUNT(*) > 1
ORDER BY total_students DESC;

-- Level 2 Features
-- attendance table
-- fees table
-- exam table
-- student login system
-- timestamps (created_at)

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

-- Q1. Show all students whose fee payment is still Unpaid.
select s.name, f.payment_status as fees_stutas
from students s
join fees f
on s.student_id = f.student_id
where f.payment_status = 'Unpaid';

-- Q2. Show all attendance records where the student was Absent.
select s.name, a.attendance_date, a.status as abs_record
from students s
join attendance a
on s.student_id = a.student_id
where a.status = 'Absent';

-- Q3. Find all students who failed in any exam.
select s.name, c.course_name, e.exam_type, e.obtained_marks, e.result
from students s
join exams e
on s.student_id = e.student_id
join courses c
on c.course_id = e.course_id
where e.result ='Fail';

-- Q4. Show all inactive student login accounts (is_active = 0).
select s.name, sl.username, sl.email, sl.last_login, sl.login_count
from students s
join student_login sl
on s.student_id = sl.student_id
where is_active = 0;

-- Q5. Show students who paid fees using 'Online' method.
select s.name, f.paid_amount,f.payment_date, f.payment_method
from students s
join fees f
on s.student_id = f.student_id
where f.payment_method = 'Online';

-- Q6. Count how many students have each fee payment status.
select count(*), payment_status AS total_students
from fees
group by payment_status;

-- Q7. Find the total amount collected vs total due across all students.
SELECT 
    SUM(paid_amount) AS total_collected,
    SUM(due_amount) AS total_due,
    SUM(total_amount) AS grand_total
FROM fees;

-- Q8. Find attendance percentage for each student.

select s.name, count(a.attendance_id) AS total_classes,
SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
ROUND(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id), 2) AS attendance_present
from students s
join attendance a
on s.student_id= a.student_id
group by a.student_id, s.name;

-- 9. Compare Midterm vs Final average marks for each course.
select c.course_name, e.exam_type, 
ROUND(AVG(e.obtained_marks), 2) AS avg_marks
from courses c
join exams e
on c.course_id = e.course_id
group by c.course_name, e.exam_type
order by c.course_name;

-- Q10. Find students who have both Unpaid fees AND failed an exam.
SELECT DISTINCT s.name, s.city,
f.payment_status, e.result
from students s
join fees f
on s.student_id = f.student_id
join exams e
on s.student_id =e.student_id
where payment_status = 'Unpaid' AND result = 'Fail';

-- Q11. Show students who logged in more than 15 times (most active users).

select s.name, sl.email,sl.last_login, sl.login_count
from students s
join student_login sl
on s.student_id = sl.student_id
where sl.login_count > 15
ORDER BY sl.login_count DESC;

-- Q12. Show the pass/fail count for each course in Final exam.
select c.course_name,
    SUM(CASE WHEN e.result = 'Pass' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN e.result = 'Fail' THEN 1 ELSE 0 END) AS failed
FROM courses c
JOIN exams e 
ON c.course_id = e.course_id
WHERE e.exam_type = 'Final'
GROUP BY c.course_name;

-- Q13. Find students whose attendance was 'Late' at least once.
select s.name, a.status, s.city
from students s
join attendance a
on s.student_id = a.student_id
where a.status ='Late';

-- Q14. Show total fees collected per payment method.

select count(*) as transaction, sum(paid_amount) as total_collected, payment_method
from fees
where payment_method is not null
GROUP BY payment_method
ORDER BY total_collected DESC;

-- Q15. Find students created (registered) in the first week of January 2024.
select s.name, sl.username, sl.email, sl.created_at
from students  s
join student_login sl
on s.student_id = sl.student_id
where sl.created_at between '2024-01-01' AND '2024-01-07';

-- Q16. Find students who are BOTH absent in attendance AND failed in exam (using subquery)

select s.name, s.city
from students s
where student_id in (
select student_id from attendance where status = 'absent'
)
and student_id in (
select student_id
from exams
where result = 'fail'); 

-- Q18. Full student report card — name, course, enrollment marks, exam marks, attendance status, fee status all in one query.

select s.name, c.course_name, en.marks as enroll_marks, e.total_marks, e.obtained_marks, a.status, f.payment_status
from students s
join enrollments en
on s.student_id = en.student_id
join courses c
on c.course_id = en.course_id
join exams e
on e.student_id = s.student_id and e.course_id = c.course_id
join attendance a
on a.student_id = s.student_id and a.course_id = c.course_id
join fees f
on s.student_id =f.student_id
where e.obtained_marks >85
order by course_name;

-- Q19. Find students whose login account is inactive but fees are paid (data inconsistency check).

select s.name, sl.username, sl.email, sl.is_active, f.payment_status
from students s
join student_login sl
on s.student_id=sl.student_id
join fees f
on s.student_id=f.student_id
where sl.is_active = 0 and f.payment_status ='Paid';

-- Q20. Find the student with the highest obtained marks in each exam type using subquery.

select s.name, e.obtained_marks, e.exam_type, c.course_name
from exams e
join students s
on e.student_id=s.student_id
join courses c
on e.course_id=c.course_id
where e.obtained_marks =(
	select max(e2.obtained_marks)
    from exams e2
    where e2.exam_type = e.exam_type);

-- Q21. Show month-wise fee collection report using DATE functions.







