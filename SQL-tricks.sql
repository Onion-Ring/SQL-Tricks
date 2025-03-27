--SQL Tricks

--Reference aliased column in the WHERE clause

select * 
from (select [name] as n, groupname as gn from HumanResources.Department) tmp
where gn = 'Sales and Marketing'

--Concatenate columns

select [name] + ' department belongs to group ' + groupname as msg
from humanresources.department 

--Conditional logic in SELECT statements

select [name], productnumber,reorderpoint,
case when reorderpoint < 750 then 'critic'
	 when reorderpoint >= 750 then 'safe'
end as [reorderpoint_status]
from production.[product]

--Limiting rows returned

select top 14 * 
from production.[product]

--Returning n random records

select top 10 * 
from production.[product] order by newid()

--coalescing (returning non null values in place of those nulls)

-- using coalesce() function

select productid, [name], coalesce(color , 'None') as color
from production.[product] 

--using conditional on select

select productid, [name],
case when color is null then 'None'
	 else color  
end as color
from production.[product]

--Searching patterns (LIKE operator with SQL wildcard ("%" for multiple characters and "_" for one character))
--This will select all the rows which groupname start with Sales
select * 
from humanresources.department
where groupname like 'Sales%'