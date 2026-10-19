-- SQL Server (T-SQL)
-- Sample queries for the University database. Run schema.sql and data.sql first.
USE University;
GO

-- 1. Students born after 2003-01-01
SELECT *
FROM Student
WHERE DOB > '2003-01-01';

-- 2. Departments that have no head yet
SELECT *
FROM Department
WHERE Head_Ins_ID IS NULL;

-- 3. Sections that start before 12:00
SELECT *
FROM Section
WHERE Start_Time < '12:00';

-- 4. Each student with their department name
SELECT S.St_Name,
       D.Dept_Name
FROM Student S
INNER JOIN Department D ON D.Dept_No = S.Dept_No;

-- 5. Each department with its head's name and start date (only departments that have a head)
SELECT D.Dept_Name,
       D.Head_Start_Dt,
       I.Ins_Name AS Head_Name
FROM Department D
INNER JOIN Instructor I ON I.Ins_ID = D.Head_Ins_ID;

-- 6. Same as 5, but all departments must appear
SELECT D.Dept_Name,
       D.Head_Start_Dt,
       I.Ins_Name AS Head_Name
FROM Department D
LEFT OUTER JOIN Instructor I ON I.Ins_ID = D.Head_Ins_ID;

-- 7. Each course with the titles of its prerequisites
SELECT C.Title AS Course_Title,
       P.Title AS Prerequisite_Title
FROM Course C
LEFT JOIN Prerequisite PR ON PR.Crs_Code = C.Crs_Code
LEFT JOIN Course P        ON P.Crs_Code  = PR.Prereq_Code;

-- 8. Each enrollment with student name, course title, and grade
SELECT S.St_Name,
       C.Title,
       E.Grade
FROM Enrollment E
INNER JOIN Student S ON S.St_ID    = E.St_ID
INNER JOIN Course C  ON C.Crs_Code = E.Crs_Code;

-- 9. Courses that have no sections
SELECT C.Crs_Code,
       C.Title
FROM Course C
LEFT OUTER JOIN Section S ON S.Crs_Code = C.Crs_Code
WHERE S.Sect_No IS NULL;

-- 10. Students who are not enrolled in any course
SELECT S.St_ID,
       S.St_Name
FROM Student S
LEFT JOIN Enrollment E ON E.St_ID = S.St_ID
WHERE E.St_ID IS NULL;

-- 11. Number of students per department
SELECT D.Dept_No,
       D.Dept_Name,
       COUNT(S.St_ID) AS Student_Cnt
FROM Student S
INNER JOIN Department D ON D.Dept_No = S.Dept_No
GROUP BY D.Dept_No, D.Dept_Name
ORDER BY Student_Cnt;

-- 12. Average grade per course
SELECT C.Crs_Code,
       C.Title,
       CAST(AVG(E.Grade * 1.0) AS DECIMAL(5,1)) AS Avg_Grade
FROM Course C
INNER JOIN Enrollment E ON E.Crs_Code = C.Crs_Code
GROUP BY C.Crs_Code, C.Title
ORDER BY Avg_Grade;

-- 13. Number of enrollments per student, including students with zero
SELECT S.St_ID,
       S.St_Name,
       COUNT(E.St_ID) AS Enrollments_Cnt
FROM Student S
LEFT JOIN Enrollment E ON E.St_ID = S.St_ID
GROUP BY S.St_ID, S.St_Name;

-- 14. Courses with more than 2 enrolled students
SELECT E.Crs_Code,
       C.Title,
       COUNT(E.St_ID) AS Students_Count
FROM Enrollment E
INNER JOIN Course C ON C.Crs_Code = E.Crs_Code
GROUP BY E.Crs_Code, C.Title
HAVING COUNT(E.St_ID) > 2;

-- 15. Students who have at least one grade above the overall average grade (use IN)
SELECT S.St_ID,
       S.St_Name
FROM Student S
WHERE S.St_ID IN (
    SELECT E.St_ID
    FROM Enrollment E
    WHERE E.Grade > (
        SELECT AVG(Grade * 1.0)
        FROM Enrollment
    )
);

-- 16. Departments with more students than the average number of students per department
SELECT Dept_No,
       Dept_Name
FROM Department
WHERE Dept_No IN (
    SELECT Dept_No
    FROM Student
    GROUP BY Dept_No
    HAVING COUNT(St_ID) > (
        SELECT AVG(Cnt * 1.0)
        FROM (
            SELECT COUNT(St_ID) AS Cnt
            FROM Student
            GROUP BY Dept_No
        ) AS Dept_Counts
    )
);

-- 17. The student(s) with the highest grade
SELECT S.St_ID,
       S.St_Name,
       E.Grade
FROM Student S
INNER JOIN Enrollment E ON E.St_ID = S.St_ID
WHERE E.Grade = (
    SELECT MAX(Grade)
    FROM Enrollment
);

-- 18. Courses that are a prerequisite for at least one other course
SELECT C.Crs_Code,
       C.Title
FROM Course C
WHERE C.Crs_Code IN (
    SELECT P.Prereq_Code
    FROM Prerequisite P
);
