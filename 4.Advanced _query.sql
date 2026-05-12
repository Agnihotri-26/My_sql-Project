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