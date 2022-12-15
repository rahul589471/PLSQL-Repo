explain plan for sELECT * FROM EMPLOYEE;
-- Result will be "Explained"

--Now check



-- Use this method to generate explain plan if query is very slow
select * from table(dbms_xplan.display);

--Plan hash value: 2119105728
 --
--------------------------------------------------------------------------------
--| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT  |          |     8 |    80 |     2   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS FULL| EMPLOYEE |     8 |    80 |     2   (0)| 00:00:01 |
------------------------------------------------------------------------------


select * from dba_constraints where table_name='EMPLOYEE';

SELECT INDEX_NAME, INDEX_TYPE,NUM_ROWS,SAMPLE_SIZE FROM DBA_INDEXES WHERE table_name='EMPLOYEE';


explain plan for sELECT * FROM EMPLOYEE WHERE ID=21;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--Plan hash value: 2119105728
 
------------------------------------------------------------------------------
--| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT  |          |     1 |    10 |     2   (0)| 00:00:01 |
--|*  1 |  TABLE ACCESS FULL| EMPLOYEE |     1 |    10 |     2   (0)| 00:00:01 |
------------------------------------------------------------------------------
 
--Predicate Information (identified by operation id):

drop table dept_perf_check;
drop table emp_perf_check;
drop table address_perf_check;

create table dept_perf_check (dept_id number, dept_name varchar2(50));

CREATE TABLE emp_perf_check(emp_id number , emp_name varchar2(50) , dept_id number, adr_id number);

create table address_perf_check(adr_id number , adr_name varchar2(500));


insert into dept_perf_check 
select level, 'DEPT' || LEVEL
FROM DUAL CONNECT BY LEVEL <100000;

insert into emp_perf_check 
select level, 'EMP' || LEVEL ,LEVEL , level
FROM DUAL CONNECT BY LEVEL <100000;

insert into address_perf_check 
select level, 'ADDR' || LEVEL
FROM DUAL CONNECT BY LEVEL <100000;

COMMIT;



select substr('Rahul',level,1) from dual
connect by level <=length('Rahul');


select * from dept_perf_check;
select * from address_perf_check;
select * from emp_perf_check;

explain plan for 
select * from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
left join address_perf_check  apc
on (epc.adr_id= apc.adr_id);



select * from table(dbms_xplan.display);

-- Plan hash value: 2081688406
 
-----------------------------------------------------------------------------------------------------
--| Id  | Operation              | Name               | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT       |                    | 73997 |    26M|       |  2839   (1)| 00:00:01 |
--|*  1 |  HASH JOIN OUTER       |                    | 73997 |    26M|  8528K|  2839   (1)| 00:00:01 |
--|*  2 |   HASH JOIN RIGHT OUTER|                    | 73997 |  7659K|  5456K|   730   (1)| 00:00:01 |
--|   3 |    TABLE ACCESS FULL   | DEPT_PERF_CHECK    |   107K|  4195K|       |    78   (3)| 00:00:01 |
--|   4 |    TABLE ACCESS FULL   | EMP_PERF_CHECK     | 73996 |  4769K|       |   111   (1)| 00:00:01 |
--|   5 |   TABLE ACCESS FULL    | ADDRESS_PERF_CHECK |   123K|    31M|       |    78   (3)| 00:00:01 |
-------------------------------------------------------------------------------------------------------
 
--Predicate Information (identified by operation id):
---------------------------------------------------
 
 --  1 - access("EPC"."ADR_ID"="APC"."ADR_ID"(+))
 --  2 - access("EPC"."DEPT_ID"="DPC"."DEPT_ID"(+))
 
 
 create  index idx_dept_perf on dept_perf_check(dept_id);
 
 explain plan for 
select * from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
where epc.dept_id =1000;

select * from table(dbms_xplan.display);

--| Id  | Operation                             | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                      |                    |     4 |  1484 |   192   (3)| 00:00:01 |
--|*  1 |  HASH JOIN OUTER                      |                    |     4 |  1484 |   192   (3)| 00:00:01 |
--|*  2 |   HASH JOIN OUTER                     |                    |     4 |   424 |   114   (2)| 00:00:01 |
--|*  3 |    TABLE ACCESS FULL                  | EMP_PERF_CHECK     |     4 |   264 |   112   (2)| 00:00:01 |
--|   4 |    TABLE ACCESS BY INDEX ROWID BATCHED| DEPT_PERF_CHECK    |     1 |    40 |     2   (0)| 00:00:01 |
--|*  5 |     INDEX RANGE SCAN                  | IDX_DEPT_PERF      |     1 |       |     1   (0)| 00:00:01 |
--|   6 |   TABLE ACCESS FULL                   | ADDRESS_PERF_CHECK |   123K|    31M|    78   (3)| 00:00:01 |
------------------------------------------------------------------------------------------------------------
 
--Predicate Information (identified by operation id):
-- Predicate Information (identified by operation id):
---------------------------------------------------
 
--   1 - access("EPC"."ADR_ID"="APC"."ADR_ID"(+))
--   2 - access("EPC"."DEPT_ID"="DPC"."DEPT_ID"(+))
 --  3 - filter("EPC"."DEPT_ID"=1000)
 --  5 - access("DPC"."DEPT_ID"(+)=1000)
 
--Note
-----
 --  - dynamic statistics used: dynamic sampling (level=2)


-- Autotrace option is easy when query is not sooo slow
--Let suppose query take 55 mins,then we need to wait for 55 mins to generate explain 

set autotrace on;
--Autotrace Enabled
--Shows the execution plan as well as statistics of the statement.

select * from  emp_perf_check epc
left join dept_perf_check  dpc
on
(epc.dept_id=dpc.dept_id)
where epc.dept_id =1000;  