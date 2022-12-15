select * from employee;

-- Scalar datatype
declare
v_id number;
begin
for i in 1..5     -- Not possible to run loop as per table records   ---- We are wrong. Its is possible.Lets see in next example
loop
select id into v_id from employee where id=21 ;
dbms_output.put_line(v_id);
end loop;
end;
/

-- Scalar datatype
declare
v_id number;
begin
for i in (select id from employee)    -- See, Its is possible.
loop
dbms_output.put_line(i.id);
end loop;
end;
/

-- %type
declare
v_id employee.id%type;
begin
for i in 1..5
loop
select id into v_id from employee where id=21;   -- Same here.Not possible to run loop as per table records
dbms_output.put_line(v_id);
end loop;
end;
/


-- %rowtype
set serveroutput on;
declare
v_id employee%rowtype;
begin
for i in 1..5    -- Same here.Not possible to run loop as per table records
loop
select * into v_id from employee where id=21 ; 
dbms_output.put_line(v_id.id);
end loop;
end;
/


--  Record datatypes

declare
type t_id is record(l_a employee.id%type ,
                    l_b employee.name%type);
v_id t_id;
begin
for i in 1..5    -- Same here.Not possible to run loop as per table records
loop
select id,name into v_id from employee where id=21;
dbms_output.put_line(v_id.l_a ||'....' ||  v_id.l_b);
end loop;
end;
/

-- To loop through whole table Either go for Cursor or go for Collection
-- First understand Cursors

declare
cursor c_emp is select * from employee;   --declare cursor
v_emp employee%rowtype;
begin 
open c_emp;   --open
loop 
 fetch c_emp into v_emp; --fetch
 exit when c_emp%notfound;
dbms_output.put_line(v_emp.id || '...' ||v_emp.name || '...' ||v_emp.dept_id);
end loop;
end;
/
--- see above you can loop through record in table i.e. whole table data is displayed


-- weak ref cursor

declare
type t_weak_cur_emp is ref cursor;
l_weak_cur_emp t_weak_cur_emp;
v_emp employee%rowtype;
begin
open l_weak_cur_emp for select * from employee;
loop
fetch l_weak_cur_emp into v_emp;
exit when l_weak_cur_emp%notfound;
dbms_output.put_line(v_emp.id || '...'|| v_emp.name);
end loop;
end;
/


-- Strong Ref Cursor

declare
type t_strong_ref_emp is ref cursor return employee%rowtype;
l_strong_ref_emp t_strong_ref_emp;
v_emp employee%rowtype;
begin
open l_strong_ref_emp for select * from employee;
loop
fetch l_strong_ref_emp into v_emp;
exit when l_strong_ref_emp%notfound;
dbms_output.put_line(v_emp.id  || ' Id  has name ' || v_emp.name);
end loop;
end;
/


-- Drawback of Strong ref cursor

declare
type t_strong_ref_emp is ref cursor return employee%rowtype;
l_strong_ref_emp t_strong_ref_emp;
v_emp department%rowtype;   --department row variable
begin
open l_strong_ref_emp for select * from department where id=2;
loop
fetch l_strong_ref_emp into v_emp;
exit when l_strong_ref_emp%notfound;
dbms_output.put_line(v_emp.id  || ' Id  has name ' || v_emp.name);
end loop;
exception when others 
then
dbms_output.put_line('Exception');
end;
/
 ---wrong number of values in the INTO list of a FETCH statement exception comes
 
 
 
 --Working fine with weak ref cursors
 declare
type t_strong_ref_emp is ref cursor ;
l_strong_ref_emp t_strong_ref_emp;
v_emp department%rowtype;   --department row variable
begin
open l_strong_ref_emp for select * from department;
loop
fetch l_strong_ref_emp into v_emp;
exit when l_strong_ref_emp%notfound;
dbms_output.put_line(v_emp.id  || ' Id  has name ' || v_emp.name);
end loop;
exception when others 
then
dbms_output.put_line('Exception');
end;
/



---- Ref cursor advantage  -- We can use same ref cursor for multiple queries
 declare
type t_strong_ref_emp is ref cursor;
l_strong_ref_emp t_strong_ref_emp;
v_dept department%rowtype;   --department row variable
v_emp employee%rowtype;   --employee row variable
begin
open l_strong_ref_emp for select * from department;
loop
fetch l_strong_ref_emp into v_dept;
exit when l_strong_ref_emp%notfound;
dbms_output.put_line(v_dept.id  || ' Dept Id  has name ' || v_dept.name);
end loop;

open l_strong_ref_emp for select * from employee;
loop
fetch l_strong_ref_emp into v_emp;
exit when l_strong_ref_emp%notfound;
dbms_output.put_line(v_emp.id  || 'Employee Id  has name ' || v_emp.name);
end loop;
exception when others 
then
dbms_output.put_line('Exception' || sqlerrm);
end;
/


-- With Normal cursor it is not possible to use it again for multiple queries
  declare
cursor c_emp is select * from department;   -- as query is written at the time of declaration
v_dept department%rowtype;   --department row variable
v_emp employee%rowtype;   --employee row variable
begin
open c_emp ;
loop
fetch c_emp into v_dept;
exit when c_emp%notfound;
dbms_output.put_line(v_dept.id  || ' Dept Id  has name ' || v_dept.name);
end loop;


open c_emp ;
loop
fetch c_emp into v_emp;
exit when c_emp%notfound;
dbms_output.put_line(v_emp.id  || ' Dept Id  has name ' || v_emp.name);
end loop;

exception when others 
then
dbms_output.put_line('Exception' || sqlerrm);
end;
/




-- Collections
-- 1. Varray
-- 2. Nested Table
-- 3. Associated Array

-- Nested Table
declare
type t_emp is table of employee%rowtype;
l_emp t_emp;
CURSOR c_emp is select * from employee;
begin
open c_emp;
loop
fetch c_emp into l_emp;
exit when c_emp%notfound;
end loop;
for i in l_emp.first ..l_emp.last 
loop
dbms_output.put_line(l_emp(i));
end loop;
end;
/