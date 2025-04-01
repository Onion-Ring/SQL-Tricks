--SQL Tricks

--Reference aliased column in the WHERE clause

select * 
from (select [name] as n, groupname as gn from humanresources.department) department
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

--Sorting by substrings

select businessentityid, coalesce(title,'None') as title, firstname, modifieddate, substring(firstname,len(firstname)-2,3)
from person.person
order by substring(firstname,len(firstname)-2,3)

--Sorting mixed alphanumeric data (same column)

--Let's create a view where we will mix numeric data (departmentid) and alphabetic data (name)

create view alphanumeric_testview as select concat(departmentid, ' ', [name]) as [data] from humanresources.department

--Order by numeric data:

--It searchs on the DATA column the alphabetic characters and then it removes them, so we will be ordering by numeric
--data
select * from alphanumeric_testview 
order by 
cast(
replace([data],replace(translate([data],'0123456789','##########'),'#',''),'') 
as int)

--Order by alphabetic data:

--We simply remove the numbers from the DATA column
select * from alphanumeric_testview
order by replace(translate([data],'0123456789','##########'), '#', '')

--sorting with null values
--"is_null" column purpose is to separate the null values from the non-null values when sorting
select productid, [name], productsubcategoryid
from (select productid, [name], productsubcategoryid,
	  case when productsubcategoryid is null then 0 else 1 end as is_null
	  from production.[product]) 
	 [product]
order by is_null desc, productsubcategoryid desc

--sorting based on a conditional logic

select productid, locationid, shelf, modifieddate, quantity from [production].[productinventory]
order by shelf, 
		case 			
			when shelf = 'A' then productid
		else 
			case 
				when shelf = 'N/A' then modifieddate 
			else Quantity 
			end 
		end