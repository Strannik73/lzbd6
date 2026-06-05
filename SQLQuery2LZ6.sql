use User_Actions
select min(action_date) from User_Logs
select max(action_date) from User_Logs


alter database User_Actions add filegroup Sector_frag
go
alter database User_Actions add file(
	name = 'Sector_frag_2023',
	filename = 'D:\ь\Sector_frag_month.ndf') to filegroup Sector_frag
go

create partition function pf_Sector_year(date)
as range right for values (
'2025-01-01',
'2025-02-01',
'2025-03-01',
'2025-04-01',
'2025-05-01',
'2025-06-01',
'2025-07-01',
'2025-08-01',
'2025-09-01',
'2025-10-01',
'2025-11-01',
'2025-12-01'
)
-- part1: < '2024-01-01'
-- '2024-01-01' <= part2: < '2025-01-01'
-- part3: >= '2025-01-01'
go

create partition scheme ps_Sector_frag
as partition pf_Sector_year to (
Sector_frag, Sector_frag, Sector_frag,
Sector_frag, Sector_frag, Sector_frag,
Sector_frag, Sector_frag, Sector_frag,
Sector_frag, Sector_frag, Sector_frag, Sector_frag)
go

create table Logs_frag(
	id int identity(100000000,1),
	username text not null,
	user_action text not null,
	action_date date not null,
	action_time time not null,
	action_result text not null,

	constraint pk_logs primary key clustered (id, action_date)
) on ps_Sector_frag(action_date)

select count(*) from Logs_frag

insert into Logs_frag (username, user_action, action_date, action_time, action_result) 
	select username, user_actions, action_date, action_time, action_result from User_Logs

select count(*) from Logs_frag

select * from User_Logs
select * from Logs_frag 
truncate table Logs_frag with (partitions(3)) 
select count(*) from Logs_frag

select * from Logs_frag
where $partition.pf_Sector_year(action_date) = 2