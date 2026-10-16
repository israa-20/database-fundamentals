-- SQL Server (T-SQL)
-- Sample data for the Library database. Run schema.sql first.
USE Library;
GO

INSERT INTO Member (Mem_ID, Mem_Name, Street, City, Card_No, Issue_Dt) VALUES
(1, 'Ahmed Mohamed Ali',   '15 Nile Street',    'Cairo',      100101, '2023-01-15'),
(2, 'Sara Hassan Ibrahim', '22 Tahrir Square',  'Giza',       100102, '2023-03-10'),
(3, 'Omar Khaled Said',    '8 Corniche Road',   'Alexandria', 100103, '2023-05-22'),
(4, 'Mona Adel Fathy',     '45 El-Horreya St',  'Mansoura',   100104, '2023-07-08'),
(5, 'Youssef Samir Nabil', '12 October Street', 'Luxor',      100105, '2023-09-30'),
(6, 'Nour Tarek Amin',     '30 Pyramids St',    'Giza',       100106, '2024-01-01'); -- has no loans

INSERT INTO Member_Phone (Mem_ID, Phone_No) VALUES
(1, '01000000001'),
(1, '01000000002'),  -- member 1 has two phone numbers (multi-valued)
(2, '01000000003'),
(3, '01000000004'),
(4, '01000000005'),
(5, '01000000006');

INSERT INTO Book (ISBN, Title) VALUES
('9780000000001', 'Introduction to Databases'),
('9780000000002', 'Learning SQL Server'),
('9780000000003', 'Computer Networks Basics'),
('9780000000004', 'Python for Beginners'),
('9780000000005', 'Data Modeling in Practice');

INSERT INTO Author (Author_ID, Author_Name, DOB, Website) VALUES
(1, 'Layla Hassan', '1975-04-12', 'https://example.com/layla'),
(2, 'Karim Nabil',  '1980-09-23', NULL),
(3, 'Dina Fathy',   '1968-11-05', 'https://example.com/dina'),
(4, 'Tamer Said',   '1985-02-17', NULL),
(5, 'Hana Adel',    '1990-07-30', 'https://example.com/hana');

INSERT INTO Author_Phone (Author_ID, Phone_No) VALUES
(1, '01000000011'),
(2, '01000000012'),
(3, '01000000013'),
(4, '01000000014'),
(5, '01000000015');

INSERT INTO Borrow (Mem_ID, ISBN, Loan_Dt, Return_Dt) VALUES
(1, '9780000000001', '2024-01-10', '2024-01-24'),
(1, '9780000000002', '2024-06-01', NULL),          -- not returned yet
(2, '9780000000002', '2024-02-05', '2024-02-19'),
(2, '9780000000002', '2024-08-01', '2024-08-15'),  -- same member, same book, different date
(3, '9780000000003', '2024-03-12', '2024-03-26'),
(4, '9780000000004', '2024-04-08', '2024-04-22'),
(5, '9780000000005', '2024-05-15', '2024-05-29');

INSERT INTO Book_Author (ISBN, Author_ID) VALUES
('9780000000001', 1),  -- this book has two authors
('9780000000001', 2),
('9780000000002', 3),
('9780000000003', 4),
('9780000000004', 5),
('9780000000005', 3);
GO

/* These statements should FAIL. Run them one at a time to test the constraints.
INSERT INTO Borrow VALUES (99, '9780000000001', '2024-09-01', NULL);         -- member 99 does not exist (FK)
INSERT INTO Borrow VALUES (1, '9780000000001', '2024-09-10', '2024-09-01');  -- returned before loan (CHECK)
INSERT INTO Member VALUES (7, 'Test', 'Street', 'Cairo', 100101, '2024-01-01'); -- duplicate Card_No (UNIQUE)
DELETE FROM Member WHERE Mem_ID = 1;                                          -- member has loans (FK)
*/
