CREATE DATABASE supplier;
USE supplier;

CREATE TABLE Supplier (
  sid INT PRIMARY KEY,
  sname VARCHAR(100) NOT NULL,
  city VARCHAR(100)
);

CREATE TABLE Part (
  pid INT PRIMARY KEY,
  pname VARCHAR(100) NOT NULL,
  color VARCHAR(50)
);

CREATE TABLE Catalog (
  sid INT,
  pid INT,
  cost DECIMAL(10,2),
  PRIMARY KEY (sid,pid),
  FOREIGN KEY (sid) REFERENCES Supplier(sid),
  FOREIGN KEY (pid) REFERENCES Part(pid)
);

INSERT INTO Supplier VALUES (10001, 'Acme Widget', 'New York');
INSERT INTO Supplier VALUES (10002, 'Johns', 'London');
INSERT INTO Supplier VALUES (10003, 'Reliance', 'Delhi');
INSERT INTO Supplier VALUES (10004, 'Best Supplies', 'Mumbai');

INSERT INTO Part VALUES (20001, 'Book', 'red');
INSERT INTO Part VALUES (20002, 'Pen', 'red');
INSERT INTO Part VALUES (20003, 'Pencil', 'blue');
INSERT INTO Part VALUES (20004, 'Charger', 'green');
INSERT INTO Part VALUES (20005, 'Mobile', 'green');

INSERT INTO Catalog VALUES (10001, 20001, 50.00);
INSERT INTO Catalog VALUES (10002, 20001, 50.00);
INSERT INTO Catalog VALUES (10003, 20001, 40.00);
INSERT INTO Catalog VALUES (10001, 20002, 10.00);
INSERT INTO Catalog VALUES (10002, 20002, 12.00);
INSERT INTO Catalog VALUES (10003, 20002, 8.00);
INSERT INTO Catalog VALUES (10001, 20003, 5.00);
INSERT INTO Catalog VALUES (10002, 20003, 4.00);
INSERT INTO Catalog VALUES (10003, 20003, 7.00);
INSERT INTO Catalog VALUES (10001, 20004, 200.00);
INSERT INTO Catalog VALUES (10001, 20005, 500.00);


-- query-1
SELECT DISTINCT p.pname FROM Part p JOIN Catalog c ON p.pid = c.pid;

-- query-2
SELECT s.sname FROM Supplier s JOIN Catalog c ON s.sid = c.sid GROUP BY s.sid, s.sname HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM Part);


-- query-3
SELECT s.sname FROM Supplier s JOIN Catalog c ON s.sid = c.sid WHERE c.pid IN (SELECT pid FROM Part WHERE color = 'red') GROUP BY s.sid, s.sname HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM Part WHERE color = 'red');

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
-- query-4
SELECT p.pname FROM Part p WHERE p.pid IN (SELECT c.pid FROM Catalog c WHERE c.sid = (SELECT sid FROM Supplier WHERE sname='Acme Widget'))
AND p.pid NOT IN (SELECT c2.pid FROM Catalog c2 WHERE c2.sid <> (SELECT sid FROM Supplier WHERE sname='Acme Widget'));


-- Query-5
SELECT DISTINCT c.sid FROM Catalog c JOIN (SELECT pid, AVG(cost) AS avg_cost FROM Catalog GROUP BY pid) AS a ON c.pid = a.pid WHERE c.cost > a.avg_cost;


-- query-6
WITH max_cost AS (SELECT pid, MAX(cost) AS maxc FROM Catalog GROUP BY pid)
SELECT p.pid, p.pname, s.sname, c.cost FROM max_cost m
JOIN Catalog c ON m.pid = c.pid AND m.maxc = c.cost
JOIN Supplier s ON c.sid = s.sid
JOIN Part p ON p.pid = c.pid ORDER BY p.pid;
