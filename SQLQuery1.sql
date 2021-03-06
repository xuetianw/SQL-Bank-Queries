--querry 1

--1)First name and last name of customers whose income is over $80,000, order by last name, then first name.

select C.firstName, C.lastName
FROM Customer C
WHERE C.income > 80000
order by C.lastName, C.firstName


--querry 2
--2)Branch name, account number and balance of accounts with balances over $115,000 held at branches with budgets
--greater than $2,000,000, order by branch name, then account number.

select *
from Account A, Branch b
where A.balance > 115000 and b.branchNumber = A.branchNumber AND b.branchName in 
	( select b.branchName
	from Branch b
	where b.budget > 2000000
	)
order by branchName, A.accNumber


select *

from Account a, Branch b

where a.branchNumber = b.branchnumber and

balance > 115000 and budget > 2000000

order by b.branchname, a.accnumber

--Queries
--3)First name, last name, and income of customers whose income is at least twice the income of any customer named
--Charles Smith, order by last name then first name.

select *
from Customer c, Customer CS
where CS.firstName = 'Charles' and CS.lastName = 'Smith' and c.income > 2 * CS.income
order by c.firstName, c.lastName

select *

from Customer c

where income > any

(select income * 2

from Customer

where firstName = 'Charles' and lastName = 'Smith')

order by c.lastName, c.firstname

--4)Customer ID, income, account numbers and branch numbers of customers with income greater than 90,000 who own
--an account at either the London or Latveria branches, order by customer ID then account number. The result should
--contain all the account numbers of customers who meet the criteria, even if the account itself is not held at London
--or Latveria.

SELECT c.CustomerID, income, a.accNumber,A.branchnumber
FROM customer C, owns o, Account A
where c.income > 90000 and A.accNumber=o.accNumber and c.customerID=o.customerID and o.CustomerID in
	(SELECT CustomerID
	FROM owns o, Account A, Branch B
	where (B.branchName='London' or B.branchName='Latveria') and A.branchNumber =B.branchNumber and A.accNumber=o.accNumber
	)
ORDER BY customerID,accnumber

--second way

SELECT c.CustomerID, income, a.accNumber,A.branchnumber
FROM customer C, owns o, Account A
where c.income > 90000 and A.accNumber=o.accNumber and c.customerID=o.customerID and o.CustomerID in
	(SELECT DISTINCT CustomerID
	FROM owns o, Account A, Branch B
	where (B.branchName='London') and A.branchNumber =B.branchNumber and A.accNumber=o.accNumber
	
	union
	
	SELECT CustomerID
	FROM owns o, Account A, Branch B
	where (B.branchName='Latveria') and A.branchNumber =B.branchNumber and A.accNumber=o.accNumber

	)
ORDER BY customerID,accnumber



--5)Customer ID, types, account numbers and balances of business (type bus) and savings (type sav) accounts owned by
--customers who own at least one business account and at least one savings account, order by customer ID, then
--type, then account number.

select o.customerID, a.type, o.accnumber, a.balance
from owns o, Account a
where o.accnumber = a.accnumber and (a.type = 'sav' or a.type = 'bus') and o.customerID in

(select o1.customerID
from owns o1, Account a1
where o1.accnumber = a1.accnumber and a1.type = 'sav'

intersect

select o2.customerID
from owns o2, Account a2
where o2.accnumber = a2.accnumber and a2.type = 'bus')


----6)SIN, branch name, salary and salary 􀤕 manager􀤕s salary (that is, salary of the employee minus the salary of the
----employee􀬛s manager) of all employees, order by descending (salary 􀬛 manager salary).


select SIN, B2.branchName, E1.salary, manager.salary - E1.salary AS 'manager''ssdiff'
from Branch B2, Employee E1, 
(Select E.salary, B.branchNumber
FROM Branch B left outer join Employee E on B.managerSIN = E.sin) AS manager
where E1.branchNumber = B2.branchNumber and manager.branchNumber = B2.branchNumber and E1.branchNumber = manager.branchNumber

--second way

SELECT E.sin, X.branchName, E.salary, E.salary-X.salary as 'salary – manager’s salary'
FROM Employee E, (SELECT BB.branchNumber, BB.branchName, EE.salary
				  FROM Branch BB, Employee EE
				  WHERE EE.sin=BB.managerSIN and EE.branchNumber=BB.branchNumber) AS X
WHERE E.branchNumber=X.BranchNumber


----7)Customer ID of customers who have an account at the Berlin branch, who do not own an account at the London
----branch and who do not co-own an account with another customer who owns an account at the London branch,
----order by customer ID. The result should not contain duplicate customer IDs.

--(SELECT o.customerID
--FROM Owns O, Account A, Branch B
--WHERE A.accNumber=o.accNumber and B.branchNumber=A.branchNumber and B.branchName='Berlin')
--EXCEPT
--(SELECT o.customerID
--FROM Owns O, Account A, Branch B
--WHERE A.accNumber=o.accNumber and B.branchNumber=A.branchNumber and B.branchName='London')
--EXCEPT
--(SELECT o.customerID
--FROM Owns O, Owns o1
--where o.accNumber=o1.accNumber and o.customerID<>o1.customerID and o1.customerID in 
--      (SELECT o.customerID
--	   FROM Owns O, Account A, Branch B
--	   WHERE A.accNumber=o.accNumber and B.branchNumber=A.branchNumber and B.branchName='London'))
--ORDER BY customerID




----8)SIN, last name, and salary of employees who earn more than $80,000, if they are managers show the branch name of
----their branch in a fourth column (which should be NULL for most employees), order by salary in decreasing order.
----You must use an outer join in your solu􀆟on (which is the easiest way to do it).

--SELECT E.sin, E.lastName, E.salary, B.branchName
--FROM Employee E left outer join Branch B on (E.sin=B.managerSIN) and E.branchNumber=B.branchNumber
--where e.salary > 80000
--ORDER BY E.salary DESC


----9)Exactly as ques􀆟on eight, except that your query cannot include any join opera􀆟on.


--(SELECT E.sin, E.lastName, E.salary, NULL
--FROM Employee E, Branch B
--WHERE E.branchNumber=B.branchNumber AND E.sin<>B.managerSIN and e.salary > 80000)
--UNION
--(SELECT E.sin, E.lastName, E.salary, B.branchName
--FROM Employee E, Branch B
--WHERE E.branchNumber=B.branchNumber AND E.sin=B.managerSIN and e.salary > 80000)
--ORDER BY E.salary DESC


----10) Customer ID, last name and birth dates of customers who own accounts in all of the branches that Adam Rivera
----owns accounts in, order by customer ID.

--SELECT C.customerID, C.lastName, C.birthDate
--FROM Customer C
--WHERE NOT EXISTS
--((SELECT B.branchNumber
--  FROM Branch B, Owns O, Account A, Customer C1
--  WHERE C1.customerID=O.customerID and A.accNumber=O.accNumber and A.branchNumber=B.branchNumber and C1.firstName='Adam' and C1.lastName='Rivera')
--  EXCEPT
-- (SELECT B.branchNumber
--  FROM Branch B, Owns O, Account A
--  WHERE C.customerID=O.customerID and A.accNumber=O.accNumber and A.branchNumber=B.branchNumber))


--select c.customerid, c.lastname, c.birthdate
--from customer c where not exists
--(
--(select distinct ara.branchnumber
-- from customer ar, owns aro, account ara
-- where ar.customerid = aro.customerid and aro.accnumber = ara.accnumber
-- and ar.firstname = 'adam' and ar.lastname = 'rivera')
 
-- except
 
--(select distinct a.branchnumber
-- from owns o, account a
-- where o.accnumber = a.accnumber and o.customerid = c.customerid)
--)
--order by c.customerid

----11) SIN, first name, last name and salary of the highest paid employee (or employees) of the Berlin branch, order by
----sin.



--SELECT E.sin, E.firstName, E.lastName, E.salary
--FROM Employee E, Branch B
--WHERE B.branchName='Berlin' and E.branchNumber=B.branchNumber and E.salary=(SELECT max(EE.salary)
--																			FROM Employee EE, Branch BB
--																			WHERE EE.branchNumber=BB.branchNumber and BB.branchName='Berlin')
--ORDER BY E.sin
--select e.sin, e.firstname, e.lastname, e.salary
--from Employee e inner join Branch b on e.branchNumber = b.branchNumber
--where b.branchName = 'berlin' and e.salary =
--(select max(berlin.salary)
--from (select salary from Employee e inner join Branch b
--on e.branchNumber = b.branchNumber
--where b.branchName = 'berlin') as berlin)

----12) Sum of the employee salaries (a single number) at the Latveria branch.


--select sum(E.salary)AS SUM_Salary, B.branchName
--FROM employee E,branch B
--where B.BranchName='Latveria' AND E.branchNumber=B.branchNumber

--select sum(salary) as sum_salaries

--from branch b, employee e

--where b.branchnumber = e.branchnumber and b.branchname = 'latveria'


----13) Count of the number of different first names of employees working at the London branch and a count of the
----number of employees working at the London branch (two numbers in a single row).

--select COUNT(distinct e.firstname) as count_names, count(e.sin) as count_sin

--from Employee e inner join Branch b on e.branchnumber = b.branchNumber

--where b.branchName = 'london'

----14) Branch name, and minimum, maximum and average salary of the employees at each branch, order by branch
----name.

--SELECT Branchname, min(E.salary), max(E.salary), avg (E.salary)
--FROM Employee E, Branch B
--Where E.branchNumber=b.branchNumber
--GROUP BY B.branchname
--order by branchname

----15) Customer ID, first name and last name of customers who own accounts at a minimum of two different branches,
----order by customer ID.

--SELECT c.customerID,c.firstname,c.lastname
--FROM customer c, owns o, Account a
--where c.customerID=o.customerID and o.accNumber=a.accNumber
--GROUP BY c.customerID,c.firstname,c.lastname
--having count(distinct a.branchNumber)>=2
--order by c.customerID


--select c.customerid, c.firstname, c.lastname

--from customer c where c.customerid in

--(select b2.customerid from

--(select distinct o.customerid, a.branchnumber

-- from owns o, Account a

-- where o.accNumber = a.accnumber) as b2

-- group by b2.customerid

--having count(*) >= 2)

-- order by c.customerid

--16) Average income of customers older than 50 and average income of customers younger than 50, the result must
--have two named columns, with one row, in one result set (hint: look up T-SQL 􀆟me and date func􀆟ons).
--17) Customer ID, last name, first name, income, and average account balance of customers who have at least three
--accounts, and whose last names begin with Jo and contain an s (e.g. Johnson) or whose first names begin with A
--and have a vowel as the le􀆩er just before the last le􀆩er (e.g. Aaron), order by customer ID. Note that this will be
--much easier if you look up LIKE wildcards in the MSDN T-SQL documenta􀆟on. Also note - to appear in the result
--customers must have at least three accounts and sa􀆟sfy one (or both) of the name condi􀆟ons.
--18) Account number, balance, sum of transac􀆟on amounts, and balance - transac􀆟on sum for accounts in the New York
--branch that have at least ten transac􀆟ons, order by account number.
--19) Branch name, account type, and average transac􀆟on amount of each account type for each branch for branches
--that have at least 50 accounts of any type, order by branch name, then account type.
--20) Branch name, account type, account number, transac􀆟on number and amount of transac􀆟ons of accounts where
--the average transac􀆟on amount is greater than three 􀆟mes the (overall) average transac􀆟on amount of accounts of
--that type. For example, if the average transac􀆟on amount of all business accounts is $2,000 then return
--transac􀆟ons from business accounts where the average transac􀆟on amount for that account is greater than $6,000.
--Order by branch name, then account type, account number and finally transac􀆟on number. Note that all
--transac􀆟ons of qualifying accounts should be returned even if they are less than the average amount of the account
--type.