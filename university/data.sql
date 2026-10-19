-- SQL Server (T-SQL)
-- Sample data for the University database. Run schema.sql first.
USE University;
GO

-- Departments (heads are assigned later, after instructors exist)
INSERT INTO Department (Dept_No, Dept_Name) VALUES
(1, 'Computer Science'),
(2, 'Information Technology'),
(3, 'Electronics');

INSERT INTO Instructor (Ins_ID, Ins_Name, Dept_No) VALUES
(1, 'Dr. Hala Samir',   1),
(2, 'Dr. Amr Fouad',    1),
(3, 'Dr. Rania Gamal',  2),
(4, 'Dr. Walid Nour',   3);

INSERT INTO Student (St_ID, St_Name, DOB, Dept_No) VALUES
(1, 'Karim Adel',    '2003-05-10', 1),
(2, 'Laila Yasser',  '2002-11-23', 1),
(3, 'Mostafa Ehab',  '2003-02-14', 2),
(4, 'Salma Reda',    '2004-07-30', 2),
(5, 'Tarek Sobhy',   '2002-09-09', 3),
(6, 'Dalia Hany',    '2003-12-01', 1);  -- not enrolled in anything

INSERT INTO Course (Crs_Code, Title, Hrs) VALUES
(101, 'Programming Basics',   3),
(102, 'Data Structures',      3),
(103, 'Databases',            3),
(104, 'Computer Networks',    4),
(105, 'Advanced Databases',   3);  -- has no sections

INSERT INTO Prerequisite (Crs_Code, Prereq_Code) VALUES
(102, 101),
(103, 101),
(105, 103),
(105, 102);  -- course 105 has two prerequisites

INSERT INTO Section (Sect_No, Crs_Code, Room, Start_Time) VALUES
(1, 101, 10, '09:00'),
(2, 101, 11, '11:00'),
(1, 102, 12, '09:00'),
(1, 103, 10, '13:00'),
(1, 104, 13, '10:00');

INSERT INTO Enrollment (St_ID, Sect_No, Crs_Code, Grade) VALUES
(1, 1, 101, 85),
(1, 1, 102, 78),
(1, 1, 103, 92),
(2, 2, 101, 66),
(2, 1, 103, 74),
(3, 1, 101, 90),
(3, 1, 104, 88),
(4, 2, 101, 55),
(4, 1, 104, NULL),  -- grade not entered yet
(5, 1, 102, 81);

-- Department heads: assigned after instructors exist (circular reference)
UPDATE Department SET Head_Ins_ID = 1, Head_Start_Dt = '2020-09-01' WHERE Dept_No = 1;
UPDATE Department SET Head_Ins_ID = 3, Head_Start_Dt = '2021-02-01' WHERE Dept_No = 2;
-- Electronics (3) has no head on purpose
GO

/* These statements should FAIL. Run them one at a time to test the constraints.
INSERT INTO Student VALUES (7, 'Test', '2003-01-01', 99);          -- department 99 does not exist (FK)
INSERT INTO Enrollment VALUES (1, 5, 101, 80);                     -- section 5 of course 101 does not exist (composite FK)
INSERT INTO Enrollment VALUES (2, 1, 101, 150);                    -- grade above 100 (CHECK)
INSERT INTO Prerequisite VALUES (101, 101);                        -- a course cannot require itself (CHECK)
UPDATE Department SET Head_Ins_ID = 1 WHERE Dept_No = 3;           -- instructor 1 already heads department 1 (unique index)
DELETE FROM Department WHERE Dept_No = 1;                          -- department has students (FK)
*/
