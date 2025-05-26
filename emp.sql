
-- Create EMP table
CREATE TABLE EMP (
    EMPNO INT PRIMARY KEY NOT NULL,
    ENAME VARCHAR(50),
    JOB VARCHAR(20) DEFAULT 'Clerk',
    MGR INT,
    HIREDATE DATE,
    SAL DECIMAL(10, 2) CHECK (SAL > 0),
    COMM DECIMAL(10, 2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);

-- Create DEPT table
CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
);

-- Create JOB_GRADES table
CREATE TABLE JOB_GRADES (
    GRADE INT PRIMARY KEY,
    LOW_SAL DECIMAL(10, 2),
    HIGH_SAL DECIMAL(10, 2)
);

-- Queries
-- 1. List the names and salary of employees whose salary is greater than 1000:
SELECT ENAME, SAL
FROM EMP
WHERE SAL > 1000;

-- 2. List details of employees who joined before the end of September 1981:
SELECT *
FROM EMP
WHERE HIREDATE < '1981-09-30';

-- 3. List employee names having 'I' as the second character:
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '_I%';

-- 4. List employee name, salary, allowances, P.F., and net salary with aliases:
SELECT 
    ENAME AS "Employee Name",
    SAL AS "Salary",
    SAL * 0.4 AS "Allowances",
    SAL * 0.1 AS "P.F.",
    SAL + (SAL * 0.4) - (SAL * 0.1) AS "Net Salary"
FROM EMP;

-- 5. List employee names with designations who do not report to anybody:
SELECT ENAME, JOB
FROM EMP
WHERE MGR IS NULL;

-- 6. List EMPNO, ENAME, and SAL in ascending order of salary:
SELECT EMPNO, ENAME, SAL
FROM EMP
ORDER BY SAL ASC;

-- 7. Count the number of jobs available in the organization:
SELECT COUNT(DISTINCT JOB) AS "Number of Jobs"
FROM EMP;

-- 8. Determine the total payable salary for the "Salesman" category:
SELECT SUM(SAL) AS "Total Payable Salary"
FROM EMP
WHERE JOB = 'Salesman';

-- 9. List average monthly salary for each job within each department:
SELECT DEPTNO, JOB, AVG(SAL) AS "Average Salary"
FROM EMP
GROUP BY DEPTNO, JOB;

-- 10. Display EMPNAME, SALARY, and DEPTNAME for employees:
SELECT EMP.ENAME, EMP.SAL, DEPT.DNAME
FROM EMP
JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO;

-- 11. Display last name, salary, and corresponding grade:
SELECT ENAME AS "Last Name", SAL, GRADE
FROM EMP
JOIN JOB_GRADES ON SAL BETWEEN LOW_SAL AND HIGH_SAL;

-- 12. Display employee name and manager name in the format Emp reports to Mgr:
SELECT E1.ENAME AS "Employee", E2.ENAME AS "Manager"
FROM EMP E1
LEFT JOIN EMP E2 ON E1.MGR = E2.EMPNO;

-- 13. Display EMPNAME and total salary (SAL + COMM):
SELECT ENAME, SAL + COALESCE(COMM, 0) AS "Total Salary"
FROM EMP;

-- 14. Display EMPNAME and SAL for employees with odd EMPNO:
SELECT ENAME, SAL
FROM EMP
WHERE EMPNO % 2 = 1;

-- 15. Display EMPNAME and rank of salary organization-wide and within the department:
SELECT 
    ENAME,
    RANK() OVER (ORDER BY SAL DESC) AS "Org Rank",
    RANK() OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS "Dept Rank"
FROM EMP;

-- 16. Display the top 3 employees based on salary:
SELECT ENAME
FROM EMP
ORDER BY SAL DESC
FETCH FIRST 3 ROWS ONLY;

-- 17. Display employee with the highest salary in each department:
SELECT ENAME, DEPTNO, SAL
FROM EMP
WHERE SAL IN (
    SELECT MAX(SAL)
    FROM EMP
    GROUP BY DEPTNO
);
