set xact_abort on;
set nocount on;

begin transaction;

begin try
	
	if not exists (select * from sysobjects where [name]='department' and xtype='U')
		create table department (
			deptno int not null,
			deptname nvarchar(100) not null,
			deptlocation nvarchar(200) not null,
			constraint pk_dept primary key (deptno)
		);

	if not exists (select * from sysobjects where [name]='employee' and xtype='U')
		create table employee (
			empno int not null,
			empname nvarchar(100) not null,
			job nvarchar(70) not null,
			manager int,
			hiredate date,
			salary int,
			commission int,
			deptno int not null,
			constraint pk_emp primary key (empno),
			constraint fk_dept foreign key (deptno) references department(deptno),
			constraint chk_salary check (salary >= 1000)		
		);

	if not exists (select * from sysobjects where [name]='employee_bonus' and xtype='U')	
		create table employee_bonus (
			empno int not null,
			receivedate date not null,
			bonustype int,
			constraint fk_emp foreign key (empno) references employee(empno)
		);
	
	insert into department values (10,'IT','CALIFORNIA');
	insert into department values (20,'RESEARCH','DALLAS');
	insert into department values (30,'SALES','OHIO');
	insert into department values (40,'OPERATIONS','DETROIT');

	insert into employee values (1,'ALLEN','PROGRAMMER',4,'04-14-2004',1300,100,10);
	insert into employee values (2,'MARK','ANALYST',8,'03-23-2000',1500,null,20);
	insert into employee values (3,'NOLAN','SALESMAN',14,'06-14-2007',1300,null,30);
	insert into employee values (4,'EVE','MANAGER',12,'05-12-2000',1200,null,20);
	insert into employee values (5,'CECIL','PROGRAMMER',4,'12-04-2002',1600,75,10);
	insert into employee values (6,'JOSEPH','SALESMAN',4,'10-06-2006',1400,200,30);
	insert into employee values (7,'JONATHAN','ANALYST',14,'10-30-2010',1300,0,20);
	insert into employee values (8,'DONALD','MANAGER',12,'02-24-2000',1000,null,20);
	insert into employee values (9,'JOHNNY','SALESMAN',12,'10-02-2002',1200,150,30);
	insert into employee values (10,'MILLER','ANALYST',12,'09-26-2019',1600,null,20);
	insert into employee values (11,'NATALIE','PROGRAMMER',8,'07-17-2004',1000,null,10);
	insert into employee values (12,'WALTER','MANAGER',14,'01-07-2022',1700,null,20);
	insert into employee values (13,'BRUCE','ANALYST',14,'07-01-2025',1400,null,20);
	insert into employee values (14,'ADAMS','MANAGER',4,'06-14-2016',1800,null,20);

	insert into employee_bonus values (4,'08-12-2004',1);
	insert into employee_bonus values (7,'12-04-2011',2);
	insert into employee_bonus values (11,'09-30-2019',3);

    commit transaction;
	print 'Data inserted successfully'
end try
begin catch    
    rollback transaction;
	print 'Error while inserting rows:'    
    print error_message();
    print error_number();
    print error_severity();
    print error_line();
end catch;