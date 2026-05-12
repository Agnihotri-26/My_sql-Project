

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