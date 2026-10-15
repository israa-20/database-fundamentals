-- SQL Server (T-SQL)
CREATE DATABASE Library;
GO
USE Library;
GO
    
CREATE TABLE Member (
    Mem_ID    INT PRIMARY KEY,
    Mem_Name  VARCHAR(50) NOT NULL,
    Street    VARCHAR(100),
    City      VARCHAR(50),
    Card_No   INT NOT NULL UNIQUE,
    Issue_Dt  DATE NOT NULL
);

CREATE TABLE Member_Phone (
    Mem_ID    INT,
    Phone_No  VARCHAR(15),
    PRIMARY KEY (Mem_ID, Phone_No),
    CONSTRAINT FK_Member_MP FOREIGN KEY (Mem_ID) REFERENCES Member(Mem_ID)
);

CREATE TABLE Book (
    ISBN   VARCHAR(13) PRIMARY KEY,
    Title  VARCHAR(100) NOT NULL
);

CREATE TABLE Author (
    Author_ID    INT PRIMARY KEY,
    Author_Name  VARCHAR(50) NOT NULL,
    DOB          DATE,
    Website      VARCHAR(100)
);

CREATE TABLE Author_Phone (
    Author_ID  INT,
    Phone_No   VARCHAR(15),
    PRIMARY KEY (Author_ID, Phone_No),
    CONSTRAINT FK_Author_AP FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID)
);

CREATE TABLE Borrow (
    Mem_ID     INT,
    ISBN       VARCHAR(13),
    Loan_Dt    DATE,
    Return_Dt  DATE,
    PRIMARY KEY (Mem_ID, ISBN, Loan_Dt),
    CONSTRAINT FK_Member_Borrow FOREIGN KEY (Mem_ID) REFERENCES Member(Mem_ID),
    CONSTRAINT FK_Book_Borrow FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
    CONSTRAINT CK_Return_After_Loan CHECK (Return_Dt >= Loan_Dt)
);

CREATE TABLE Book_Author (
    ISBN       VARCHAR(13),
    Author_ID  INT,
    PRIMARY KEY (ISBN, Author_ID),
    CONSTRAINT FK_Book_BA FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
    CONSTRAINT FK_Author_BA FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID)
);
