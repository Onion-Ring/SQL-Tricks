--Stack rowsets

	--UNION ALL combines rows from multiple row sources into one result set (include duplicates)
	--If you want to filter out duplicates then use UNION (don't use it instead of UNION ALL unless you have to)

	select empname, deptno from employee where deptno = 20
	union all 
	select '-----------------------------',null
	union all
	select deptname, deptno from department


--Combining related rows from different tables

	--using explicit JOIN (most recommended)
	select d.deptname, d.deptlocation, e.empname from department d inner join employee e on e.deptno = d.deptno
	where d.deptno = 10

	--using implicit JOIN (be careful with CROSS JOIN)
	select d.deptname, d.deptlocation, e.empname from department d, employee e where e.deptno = d.deptno
	and d.deptno = 10


--Finding rows in common between two tables

	create view vw_employeeProgrammers
	as select empname, job, salary 
		from employee 
		where job = 'PROGRAMMER'

	--implicit JOIN
	select e.*
	from employee e, vw_employeeProgrammers v 
	where e.empname = v.empname
	and e.job = v.job
	and e.salary = v.salary

	--explicit JOIN
	select e.*
	from employee e
	inner join  vw_employeeProgrammers v  on  (e.empname = v.empname
	and e.job = v.job
	and e.salary = v.salary)


--Finding rows from one table that do not exist in another

	--Using NOT IN + subquery
	select deptno 
	from department
	where deptno not in (select deptno 
						 from employee)

	--Using EXCEPT
	select deptno from department 
	except
	select deptno from employee


--Retrieving rows from one table that don't correspond to rows in another table

	-- using LEFT JOIN (will return all the row from the left table and the matches from the right table)
	select d.* from department d
	left join employee e
	on d.deptno = e.deptno
	where e.deptno is null

	-- using RIGHT JOIN (will return all the row from the right table and the matches from the left table)
	select d.* from employee e
	right join department d
	on d.deptno = e.deptno
	where e.deptno is null


--Adding joins without reduce the results from other joins
	
	--The first JOIN show all the employees and the department location where they work
	--we also need to show how many employees received a bonus and how many not, so we
	--need to join employee_bonus table, but given only 3 employees received a bonus, if we use INNER JOIN 
	--this will reduce the number of employees, showing only the employees that received a bonus
	--therefore, we have to use LEFT JOIN to get all the rows from the left table (employee) and the matches 
	--from the right table (employee_bonus)
	select e.empname, d.deptlocation, eb.receivedate from employee e 
	inner join department d on d.deptno = e.deptno
	left join employee_bonus eb on eb.empno = e.empno 
	order by case when eb.receivedate is null  then
				d.deptlocation 
			 else 
				convert(NVARCHAR, eb.receivedate, 23)
			end		
			
	--Using scalar subquery
	select e.empname, d.deptlocation, (select receivedate from employee_bonus eb where eb.empno = e.empno) as received from employee e
	inner join department d on d.deptno = e.deptno