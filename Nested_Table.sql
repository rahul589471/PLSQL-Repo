SELECT DISTINCT NAM FROM (
select 'B' AS NAM from dual
union all
select 'A'from dual
union all
select 'A'from dual) ;

-- Difference from Varray is upper size is not fixed

declare
type t_emp is table of VARCHAR2(30) ;   -- see we are limitied here to one datatype
l_emp t_emp:=t_emp();
counter number:=1;
tab_size number:=0;
begin
select count(*) into tab_size from employee;
l_emp.extend(tab_size);
for i in (select name from employee)
loop
l_emp(counter):=i.name;
dbms_output.put_line(l_emp(counter));
counter:=counter+1;

end loop;
end;
/

set serveroutput on;
-- TO take all columns of table
declare
--type t_emp is table of employee%rowtype;
type t_v1 is table of employee.id%type;
l_emp t_v1:=t_v1();

v_a number;

counter number:=1;
tab_size number:=0;

c1 sys_refcursor;

begin
select count(*) into tab_size from employee;

open c1 for select id from employee order by id desc;
loop
fetch c1 into v_a;
l_emp.extend;
l_emp(l_emp.last):=v_a;

exit when c1%notfound;

end loop;

for i in l_emp.first..l_emp.last
loop
   dbms_output.put_line(l_emp(i));
end loop;

end;
/