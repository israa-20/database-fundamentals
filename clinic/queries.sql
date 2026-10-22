-- SQL Server (T-SQL)
-- Sample queries for the Clinic database. Run schema.sql and data.sql first.
USE Clinic;
GO

-- 1. List the admitted patients with their room number and bed number.
SELECT Patient_ID,
       Patient_Name,
       Room_No,
       Bed_No
FROM Patients
WHERE Room_No IS NOT NULL
  AND Bed_No IS NOT NULL;

-- 2. List the beds that are currently empty.
SELECT B.Room_No,
       B.Bed_No
FROM Beds B
LEFT JOIN Patients P
    ON P.Room_No = B.Room_No AND P.Bed_No = B.Bed_No
WHERE P.Patient_ID IS NULL;

-- 3. For each prescription, show the patient name, doctor name, medicine name, date, and dose.
SELECT P.Patient_Name,
       D.Doc_Name,
       M.Med_Name,
       Pre.Presc_Date,
       Pre.Dose
FROM Prescriptions Pre
INNER JOIN Patients P ON P.Patient_ID = Pre.Patient_ID
INNER JOIN Doctors D  ON D.Doc_ID     = Pre.Doc_ID
INNER JOIN Medicines M ON M.Med_Code  = Pre.Med_Code;

-- 4. Which medicines have never been prescribed?
SELECT M.Med_Code,
       M.Med_Name
FROM Medicines M
LEFT JOIN Prescriptions Pre ON Pre.Med_Code = M.Med_Code
WHERE Pre.Med_Code IS NULL;

-- 5. Which patients are not admitted to any bed?
SELECT Patient_ID,
       Patient_Name
FROM Patients
WHERE Bed_No IS NULL;

-- 6. How many beds does each room have?
SELECT Room_No,
       COUNT(Bed_No) AS Bed_Cnt
FROM Beds
GROUP BY Room_No;

-- 7. How many prescriptions has each doctor written, including doctors with none?
SELECT D.Doc_ID,
       D.Doc_Name,
       COUNT(Pre.Med_Code) AS Prescription_Cnt
FROM Doctors D
LEFT OUTER JOIN Prescriptions Pre ON Pre.Doc_ID = D.Doc_ID
GROUP BY D.Doc_ID, D.Doc_Name
ORDER BY Prescription_Cnt DESC;

-- 8. How many different patients has each doctor prescribed to?
--    (only doctors who wrote at least one prescription)
SELECT D.Doc_ID,
       D.Doc_Name,
       COUNT(DISTINCT Pre.Patient_ID) AS Patients_Cnt
FROM Doctors D
INNER JOIN Prescriptions Pre ON Pre.Doc_ID = D.Doc_ID
GROUP BY D.Doc_ID, D.Doc_Name;

-- 9. Which medicines were prescribed to more than one different patient?
SELECT M.Med_Code,
       M.Med_Name,
       COUNT(DISTINCT Pre.Patient_ID) AS Patients_Cnt
FROM Medicines M
INNER JOIN Prescriptions Pre ON Pre.Med_Code = M.Med_Code
GROUP BY M.Med_Code, M.Med_Name
HAVING COUNT(DISTINCT Pre.Patient_ID) > 1;

-- 10. Which medicines cost more than the average medicine price?
SELECT Med_Code,
       Med_Name,
       Price
FROM Medicines
WHERE Price > (
    SELECT AVG(Price)
    FROM Medicines
);

-- 11. Among patients who have at least one prescription,
--     which patients have more prescriptions than the average per patient?
SELECT P.Patient_ID,
       P.Patient_Name,
       COUNT(Pre.Med_Code) AS Total_Prescriptions
FROM Prescriptions Pre
INNER JOIN Patients P ON P.Patient_ID = Pre.Patient_ID
GROUP BY P.Patient_ID, P.Patient_Name
HAVING COUNT(Pre.Med_Code) > (
    SELECT AVG(Cnt * 1.0)
    FROM (
        SELECT COUNT(Med_Code) AS Cnt
        FROM Prescriptions
        GROUP BY Patient_ID
    ) AS Patient_Counts
);

-- 12. Which doctor(s) wrote the most prescriptions?
SELECT D.Doc_ID,
       D.Doc_Name,
       COUNT(Pre.Med_Code) AS Total_Prescriptions
FROM Prescriptions Pre
INNER JOIN Doctors D ON D.Doc_ID = Pre.Doc_ID
GROUP BY D.Doc_ID, D.Doc_Name
HAVING COUNT(Pre.Med_Code) = (
    SELECT MAX(Cnt)
    FROM (
        SELECT COUNT(Med_Code) AS Cnt
        FROM Prescriptions
        GROUP BY Doc_ID
    ) AS Doctor_Counts
);

-- 13. What is the total cost of the medicines prescribed to each patient?
--     (sum the medicine prices over all their prescriptions)
SELECT P.Patient_ID,
       P.Patient_Name,
       SUM(M.Price) AS Total_Cost
FROM Prescriptions Pre
INNER JOIN Patients P  ON P.Patient_ID = Pre.Patient_ID
INNER JOIN Medicines M ON M.Med_Code   = Pre.Med_Code
GROUP BY P.Patient_ID, P.Patient_Name;

-- 14. How old is each patient in years?
SELECT Patient_ID,
       Patient_Name,
       DOB,
       DATEDIFF(year, DOB, GETDATE())
         - CASE
               WHEN DATEADD(year, DATEDIFF(year, DOB, GETDATE()), DOB) > GETDATE()
               THEN 1
               ELSE 0
           END AS Age
FROM Patients;
