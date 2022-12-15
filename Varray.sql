select * from employee;

declare
arr_size int:=0;
type t_emp is varray(10) of varchar2(30);
l_emp t_emp:=t_emp();
counter number:=0;

begin
select count(*) into arr_size from employee;

l_emp.extend(arr_size);
for i in  (select name from employee)
loop
counter:=counter+1;
l_emp(counter):=i.name;
dbms_output.put_line(l_emp(counter));
end loop;

dbms_output.put_line(l_emp.limit);

dbms_output.put_line(l_emp.count);
l_emp.trim(3);
dbms_output.put_line(l_emp.count);

dbms_output.put_line(l_emp.first);

dbms_output.put_line(l_emp.last);

dbms_output.put_line(l_emp.prior(4));

dbms_output.put_line(l_emp.next(8));

end;
/


--MultiDimensional Varrays
declare
type t_elm is varray(3) of number;
l_em t_elm:=t_elm(); 

type t_matrix is varray(3) of t_elm;
l_matrix t_matrix :=t_matrix(null,null,null);

begin
l_em.extend(3);

l_em(1):=1;
l_em(2):=2;
l_em(3):=3;

l_matrix(1):=t_elm(1,2,3);
l_matrix(2):=t_elm(11,12,13);
l_matrix(3):=t_elm(21,22,23);


for i in 1..3 loop
for j in 1..3 loop
dbms_output.put_line('.....'||l_matrix(i)(j));
end loop;
end loop;

end;
/