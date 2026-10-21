-- SQL Server (T-SQL)
-- Sample data for the Clinic database. Run schema.sql first.
USE Clinic;
GO

INSERT INTO Rooms (Room_No, Floor) VALUES
(101, 1), (102, 1), (201, 2);

INSERT INTO Beds (Room_No, Bed_No) VALUES
(101, 1), (101, 2), (101, 3),
(102, 1), (102, 2),
(201, 1), (201, 2);

INSERT INTO Patients (Patient_ID, Patient_Name, DOB, Street, City, Zone, Room_No, Bed_No) VALUES
(1, 'Ahmed Ali',    '1990-05-15', 'Street 1', 'Cairo', 'Zone A', 101,  1),
(2, 'Sara Hassan',  '1985-08-20', 'Street 2', 'Giza',  'Zone B', 101,  2),
(3, 'Omar Khaled',  '2000-01-10', 'Street 3', 'Cairo', 'Zone C', 102,  1),
(4, 'Mona Youssef', '1978-11-30', 'Street 4', 'Alex',  'Zone D', 201,  1),
(5, 'Khaled Nabil', '1995-03-25', 'Street 5', 'Cairo', 'Zone A', NULL, NULL),  -- not admitted
(6, 'Nour Adel',    '1992-07-14', 'Street 6', 'Giza',  'Zone B', NULL, NULL);  -- not admitted

INSERT INTO Patient_Phones (Patient_ID, Phone_No) VALUES
(1, '01011111111'),
(1, '01222222222'),  -- patient 1 has two phone numbers
(2, '01033333333'),
(3, '01144444444'),
(4, '01255555555'),
(5, '01066666666'),
(6, '01177777777');

INSERT INTO Doctors (Doc_ID, Doc_Name, Specialty) VALUES
(101, 'Dr. Tarek',  'Cardiology'),
(102, 'Dr. Hana',   'Pediatrics'),
(103, 'Dr. Yaser',  'Orthopedics'),
(104, 'Dr. Mariam', 'Dermatology');   -- has no prescriptions

INSERT INTO Medicines (Med_Code, Med_Name, Price) VALUES
(1, 'Panadol',   15.50),
(2, 'Augmentin', 85.00),
(3, 'Congestal', 25.00),
(4, 'Insulin',  120.00);   -- never prescribed

INSERT INTO Prescriptions (Doc_ID, Patient_ID, Med_Code, Presc_Date, Dose) VALUES
(101, 1, 1, '2023-10-01', '1 Tablet'),
(101, 1, 2, '2023-10-01', '1 Tablet'),
(102, 2, 3, '2023-10-02', '2 Spoons'),
(103, 3, 1, '2023-10-03', '1 Tablet'),
(102, 4, 2, '2023-10-04', '1 Tablet'),
(103, 2, 1, '2023-10-05', '1 Tablet'),
(101, 1, 1, '2023-10-10', '2 Tablets'),  -- same doctor, patient, medicine as row 1, different date
(101, 1, 1, '2023-10-17', '1 Tablet');
GO

/* These statements should FAIL. Run them one at a time to test the constraints.
INSERT INTO Patients (Patient_ID, Patient_Name, Room_No, Bed_No) VALUES (7, 'Test', 999, 1);   -- bed does not exist (composite FK)
INSERT INTO Patients (Patient_ID, Patient_Name, Room_No, Bed_No) VALUES (8, 'Test', 101, 1);   -- bed already occupied (filtered unique index)
INSERT INTO Patients (Patient_ID, Patient_Name, Room_No, Bed_No) VALUES (9, 'Test', 101, NULL); -- room without bed (CHECK)
INSERT INTO Prescriptions VALUES (101, 2, 99, '2023-10-20', '1 Tablet');                       -- medicine 99 does not exist (FK)
INSERT INTO Prescriptions VALUES (101, 1, 1, '2023-10-01', '1 Tablet');                        -- duplicate primary key
INSERT INTO Beds (Room_No, Bed_No) VALUES (888, 1);                                            -- room 888 does not exist (FK)
INSERT INTO Medicines VALUES (5, 'Test', -10);                                                 -- negative price (CHECK)
*/
