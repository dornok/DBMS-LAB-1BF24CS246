CREATE DATABASE IF NOT EXISTS EmployeeData;
USE EmployeeData;
CREATE TABLE Dept (
    DeptNo INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DLOC VARCHAR(50)
);

CREATE TABLE Employee (
    EmpNo INT PRIMARY KEY,
    EName VARCHAR(50),
    Mgr_No INT,
    HireDate DATE,
    Salary FLOAT,
    DeptNo INT,
    FOREIGN KEY (DeptNo) REFERENCES Dept(DeptNo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Project (
    Pno INT PRIMARY KEY,
    Pname VARCHAR(50),
    Ploc VARCHAR(50)
);

CREATE TABLE Assigned_To (
    EmpNo INT PRIMARY KEY,
    Pno INT PRIMARY KEY,
    Job_Role VARCHAR(50),
    FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Pno) REFERENCES Project(Pno) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Incentive (
    EmpNo INT PRIMARY KEY,
    Incentive_Date DATE,
    Incentive_Amount FLOAT,
    FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo)
);
INSERT INTO Dept VALUES
(10, 'HR', 'Bengaluru'),
(20, 'Finance', 'Hyderabad'),
(30, 'IT', 'Mysuru'),
(40, 'Sales', 'Chennai'),
(50, 'R&D', 'Bengaluru');

INSERT INTO Employee VALUES
(101, 'Ravi', 201, '2020-01-15', 45000, 10),
(102, 'Priya', 202, '2019-03-22', 50000, 20),
(103, 'Anil', 203, '2018-07-18', 55000, 30),
(104, 'Kiran', 204, '2021-05-11', 47000, 40),
(105, 'Deepa', 205, '2022-09-01', 48000, 50),
(106, 'Rahul', 201, '2020-02-10', 52000, 10);

INSERT INTO Project VALUES
(1, 'Alpha', 'Bengaluru'),
(2, 'Beta', 'Hyderabad'),
(3, 'Gamma', 'Mysuru'),
(4, 'Delta', 'Chennai'),
(5, 'Nima', 'Pune');

INSERT INTO Assigned_To VALUES
(101, 1, 'Developer'),
(102, 2, 'Analyst'),
(103, 3, 'Tester'),
(104, 4, 'Sales Executive'),
(105, 5, 'Researcher'),
(106, 1, 'Developer');

INSERT INTO Incentive VALUES
(101, '2023-04-15', 5000),
(102, '2023-06-10', 6000),
(105, '2023-08-25', 4000);


-- query-1
SELECT EmpNo FROM Employee 
WHERE DeptNo IN (
		SELECT DeptNo
		FROM Dept
		WHERE DLOC IN ('Bengaluru', 'Hyderabad', 'Mysuru')
);

-- query-2 for incent
SELECT EmpNo FROM Employee WHERE EmpNo NOT IN (SELECT EmpNo FROM Incentive);

-- query-3 similar to loc emp
SELECT E.ENAME, E.EMPNO, D.DNAME, A.JOB_ROLE, D.DLOC AS Department_Location, P.PLOC AS Project_Location FROM EMPLOYEE E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN ASSIGNED_TO A ON E.EMPNO = A.EMPNO
JOIN PROJECT P ON A.PNO = P.PNO
WHERE D.DLOC = P.PLOC;