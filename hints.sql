select * from employee;

update employee e set id=56 where e.id=22;

--1. Based on optimization

-- for better throughput
explain plan for 
select /* ALL_ROWS */ count(*) from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
left join address_perf_check  apc
on (epc.adr_id= apc.adr_id); 

select * from table(dbms_xplan.display);

-- FIRST_ROWS for better response
explain plan for 
select /* FIRST_ROWS(10) */ count(*) from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
left join address_perf_check  apc
on (epc.adr_id= apc.adr_id); 

select * from table(dbms_xplan.display);


----- GATHER_PLAN_STATISTICS----
explain plan for 
select   /*+ GATHER_PLAN_STATISTICS*/ epc.*, dpc.*, apc.* from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
left join address_perf_check  apc
on (epc.adr_id= apc.adr_id);


select * from table(dbms_xplan.display_cursor(sql_id=>'1n0smfthvg8ys',format=>'ALLSTATS LAST +cost +bytes'));

SELECT * FROM V$SQL_PLAN WHERE SQL_ID='1k2x64st0wan4';