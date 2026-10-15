-- SQL Server (T-SQL)
CREATE DATABASE University;
GO
USE University;
GO

CREATE TABLE Department (
    Dept_No        INT PRIMARY KEY,
    Dept_Name      VARCHAR(50) NOT NULL,
    Head_Ins_ID    INT,
    Head_Start_Dt  DATE
);

CREATE TABLE Instructor (
    Ins_ID    INT PRIMARY KEY,
    Ins_Name  VARCHAR(50) NOT NULL,
    Dept_No   INT NOT NULL,
    CONSTRAINT FK_Ins_Dept FOREIGN KEY (Dept_No) REFERENCES Department(Dept_No)
);

CREATE TABLE Student (
    St_ID    INT PRIMARY KEY,
    St_Name  VARCHAR(50) NOT NULL,
    DOB      DATE NOT NULL,
    Dept_No  INT NOT NULL,
    CONSTRAINT FK_St_Dept FOREIGN KEY (Dept_No) REFERENCES Department(Dept_No)
);

CREATE TABLE Course (
    Crs_Code  INT PRIMARY KEY,
    Title     VARCHAR(50) NOT NULL,
    Hrs       INT NOT NULL,
    CONSTRAINT CK_Course_Hrs CHECK (Hrs > 0)
);

CREATE TABLE Prerequisite (
    Crs_Code     INT,
    Prereq_Code  INT,
    PRIMARY KEY (Crs_Code, Prereq_Code),
    CONSTRAINT FK_Pre_Crs    FOREIGN KEY (Crs_Code)    REFERENCES Course(Crs_Code),
    CONSTRAINT FK_Pre_Prereq FOREIGN KEY (Prereq_Code) REFERENCES Course(Crs_Code),
    CONSTRAINT CK_Pre_NotSelf CHECK (Crs_Code <> Prereq_Code)
);

CREATE TABLE Section (
    Sect_No     INT,
    Crs_Code    INT,
    Room        INT,
    Start_Time  TIME,
    PRIMARY KEY (Crs_Code, Sect_No),
    CONSTRAINT FK_Sec_Crs FOREIGN KEY (Crs_Code) REFERENCES Course(Crs_Code)
);

CREATE TABLE Enrollment (
    St_ID     INT,
    Sect_No   INT,
    Crs_Code  INT,
    Grade     INT,
    PRIMARY KEY (St_ID, Crs_Code, Sect_No),
    CONSTRAINT FK_Enr_St  FOREIGN KEY (St_ID) REFERENCES Student(St_ID),
    CONSTRAINT FK_Enr_Sec FOREIGN KEY (Crs_Code, Sect_No) REFERENCES Section(Crs_Code, Sect_No),
    CONSTRAINT CK_Enr_Grade CHECK (Grade BETWEEN 0 AND 100)
);

ALTER TABLE Department
    ADD CONSTRAINT FK_Dept_Head FOREIGN KEY (Head_Ins_ID) REFERENCES Instructor(Ins_ID);

CREATE UNIQUE INDEX UX_Dept_Head
    ON Department (Head_Ins_ID)
    WHERE Head_Ins_ID IS NOT NULL;
