-- SQL Server (T-SQL)
-- Sample queries for the Library database. Run schema.sql and data.sql first.
USE Library;
GO

-- 1. Members who live in Giza
SELECT Mem_ID, Mem_Name
FROM Member
WHERE City = 'Giza';

-- 2. All members ordered by Issue_Dt, newest first
SELECT *
FROM Member
ORDER BY Issue_Dt DESC;

-- 3. Authors who have no website
SELECT *
FROM Author
WHERE Website IS NULL;

-- 4. Books whose title contains the word SQL
SELECT *
FROM Book
WHERE Title LIKE '%SQL%';

-- 5. Each book with the names of its authors
SELECT b.Title,
       a.Author_Name
FROM Book_Author ba
INNER JOIN Author a
  ON a.Author_ID = ba.Author_ID
INNER JOIN Book b   
  ON b.ISBN      = ba.ISBN;

-- 6. Each member with their phone numbers (members without phones do not appear)
SELECT m.Mem_Name,
       mp.Phone_No
FROM Member m
INNER JOIN Member_Phone mp
  ON mp.Mem_ID = m.Mem_ID;

-- 7. Same as 6, but members without phones appear too
SELECT m.Mem_Name,
       mp.Phone_No
FROM Member m
LEFT OUTER JOIN Member_Phone mp 
  ON mp.Mem_ID = m.Mem_ID;

-- 8. All loans of "Learning SQL Server" with member name and loan date
SELECT m.Mem_Name,
       br.Loan_Dt
FROM Borrow br
INNER JOIN Member m 
  ON m.Mem_ID = br.Mem_ID
INNER JOIN Book b   
  ON b.ISBN   = br.ISBN
WHERE b.Title = 'Learning SQL Server';

-- 9. Books that have never been borrowed
SELECT b.ISBN,
       b.Title
FROM Book b
LEFT OUTER JOIN Borrow br 
  ON br.ISBN = b.ISBN
WHERE br.ISBN IS NULL;

-- 10. Number of authors per book
SELECT b.ISBN,
       b.Title,
       COUNT(*) AS Author_Count
FROM Book_Author ba
INNER JOIN Book b
  ON b.ISBN = ba.ISBN
GROUP BY b.ISBN, b.Title;

-- 11. Authors who wrote more than one book
SELECT a.Author_ID,
       a.Author_Name,
       COUNT(*) AS Book_Count
FROM Book_Author ba
INNER JOIN Author a 
  ON a.Author_ID = ba.Author_ID
GROUP BY a.Author_ID, a.Author_Name
HAVING COUNT(*) > 1;

-- 12. Number of members in each city
SELECT City,
       COUNT(*) AS Member_Count
FROM Member
GROUP BY City;

-- 13. The date of the latest loan for each member
SELECT m.Mem_ID,
       m.Mem_Name,
       MAX(br.Loan_Dt) AS Latest_Loan_Dt
FROM Borrow br
INNER JOIN Member m 
  ON m.Mem_ID = br.Mem_ID
GROUP BY m.Mem_ID, m.Mem_Name;

-- 14. Each member with the number of loans, including members with zero
SELECT m.Mem_ID,
       m.Mem_Name,
       COUNT(br.ISBN) AS Loan_Count
FROM Member m
LEFT OUTER JOIN Borrow br 
  ON br.Mem_ID = m.Mem_ID
GROUP BY m.Mem_ID, m.Mem_Name;

-- 15. Members who borrowed "Introduction to Databases" (IN with a subquery)
SELECT *
FROM Member
WHERE Mem_ID IN (
    SELECT Mem_ID
    FROM Borrow
    WHERE ISBN IN (
        SELECT ISBN
        FROM Book
        WHERE Title = 'Introduction to Databases'
    )
);

-- 16. Members who currently have an unreturned book
SELECT *
FROM Member
WHERE Mem_ID IN (
    SELECT Mem_ID
    FROM Borrow
    WHERE Return_Dt IS NULL
);

-- 17. The member with the oldest membership card
SELECT *
FROM Member
WHERE Issue_Dt = (
    SELECT MIN(Issue_Dt)
    FROM Member
);

-- 18. For each returned loan, how many days it lasted
SELECT m.Mem_Name,
       b.Title,
       br.Loan_Dt,
       DATEDIFF(day, br.Loan_Dt, br.Return_Dt) AS Days_Kept
FROM Borrow br
INNER JOIN Member m 
  ON m.Mem_ID = br.Mem_ID
INNER JOIN Book b  
  ON b.ISBN   = br.ISBN
WHERE br.Return_Dt IS NOT NULL;

-- 19. Members who borrowed more books than the average number of loans per member
SELECT m.Mem_ID,
       m.Mem_Name,
       COUNT(*) AS Loan_Count
FROM Borrow br
INNER JOIN Member m 
  ON m.Mem_ID = br.Mem_ID
GROUP BY m.Mem_ID, m.Mem_Name
HAVING COUNT(*) > (
    SELECT AVG(Cnt * 1.0)
    FROM (
        SELECT COUNT(*) AS Cnt
        FROM Borrow
        GROUP BY Mem_ID
    ) AS Loans_Per_Member
);
