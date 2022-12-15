@D:\App\db_home\rdbms\admin\proftab.sql;  
-- To create plsql_profile_runs , plsql_profile_unit and plsql_profile_data tables

select * from dba_tables where table_name like 'PLSQL%PROFILE%';

select * from all_tables where table_name like 'PLSQL%PROFILE%';


select * from PLSQL_PROFILER_RUNS;
select * from PLSQL_PROFILER_UNITS;
select * from PLSQL_PROFILER_DATA;

select * from employee;

create or replace procedure proc_c
AS
lv_agg_names varchar2(50);
begin
for i in 1..50 
loop
select listagg(name,',') within group(order by name) into lv_agg_names from employee;
end loop;
end;
/

create or replace procedure proc_b
AS
lv_date date;
begin
for i in 1..50
loop
select sysdate into lv_date from dual;
proc_c;
end loop;
end;
/

create or replace procedure proc_a
AS
lv_count number;
begin
for i in 1..50 
loop
select count(*) into lv_count from all_tables;
proc_b;
end loop;
end;
/


--- Start Profiler , Run pl.sql code and stop profiler
exec dbms_profiler.start_profiler;
exec proc_a;
exec dbms_profiler.stop_profiler;


--- Analayze Performance
select * from PLSQL_PROFILER_RUNS;
select * from PLSQL_PROFILER_UNITS;
select * from PLSQL_PROFILER_DATA;


select ppr.run_total_time,ppu.unit_type,ppu.unit_name ,ppd.line#  ,ppd.total_occur,
ppd.total_time,
(ppd.total_time/1000000000) tot_time_in_sec,
ppd.min_time, ppd.max_time  from PLSQL_PROFILER_RUNS  ppr
join PLSQL_PROFILER_UNITS ppu
on (ppr.runid=ppu.runid)
join PLSQL_PROFILER_DATA ppd
on  (ppr.runid=ppu.runid)
order by ppd.total_time desc;