-- SQL Server (T-SQL)
CREATE DATABASE Clinic;
GO
USE Clinic;
GO

CREATE TABLE Rooms (
    Room_No  INT PRIMARY KEY,
    Floor    INT NOT NULL
);

CREATE TABLE Beds (
    Room_No  INT,
    Bed_No   INT,
    PRIMARY KEY (Room_No, Bed_No),
    CONSTRAINT FK_Beds_Rooms FOREIGN KEY (Room_No) REFERENCES Rooms(Room_No)
);

CREATE TABLE Patients (
    Patient_ID    INT PRIMARY KEY,
    Patient_Name  VARCHAR(100) NOT NULL,
    DOB           DATE,
    Street        VARCHAR(100),
    City          VARCHAR(50),
    Zone          VARCHAR(50),
    Room_No       INT,
    Bed_No        INT,
    CONSTRAINT FK_Patients_Beds FOREIGN KEY (Room_No, Bed_No) REFERENCES Beds(Room_No, Bed_No),
    CONSTRAINT CK_Patients_Bed CHECK (
        (Room_No IS NULL AND Bed_No IS NULL)
        OR (Room_No IS NOT NULL AND Bed_No IS NOT NULL)
    )
);

-- One patient per bed. A filtered index is used because most patients
-- are not admitted (NULL), and a plain UNIQUE allows only one NULL in SQL Server.
CREATE UNIQUE NONCLUSTERED INDEX UX_Patients_Bed
    ON Patients (Room_No, Bed_No)
    WHERE Room_No IS NOT NULL AND Bed_No IS NOT NULL;

CREATE TABLE Patient_Phones (
    Patient_ID  INT,
    Phone_No    VARCHAR(20),
    PRIMARY KEY (Patient_ID, Phone_No),
    CONSTRAINT FK_Phones_Patients FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

CREATE TABLE Doctors (
    Doc_ID     INT PRIMARY KEY,
    Doc_Name   VARCHAR(100) NOT NULL,
    Specialty  VARCHAR(100)
);

CREATE TABLE Medicines (
    Med_Code  INT PRIMARY KEY,
    Med_Name  VARCHAR(100) NOT NULL,
    Price     DECIMAL(10, 2) NOT NULL,
    CONSTRAINT CK_Medicines_Price CHECK (Price > 0)
);

CREATE TABLE Prescriptions (
    Doc_ID      INT,
    Patient_ID  INT,
    Med_Code    INT,
    Presc_Date  DATE,
    Dose        VARCHAR(50) NOT NULL,
    PRIMARY KEY (Doc_ID, Patient_ID, Med_Code, Presc_Date),
    CONSTRAINT FK_Presc_Doctors   FOREIGN KEY (Doc_ID)     REFERENCES Doctors(Doc_ID),
    CONSTRAINT FK_Presc_Patients  FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    CONSTRAINT FK_Presc_Medicines FOREIGN KEY (Med_Code)   REFERENCES Medicines(Med_Code)
);
