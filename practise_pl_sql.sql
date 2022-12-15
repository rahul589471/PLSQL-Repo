declare
v_id number;
v_incentive number;
begin
v_id:= &v_id;

select salary*commision_pct into v_incentive from employee where id=v_id;
dbms_output.put_line('Incentive of' || v_id || ' is ' || v_incentive);
end;
/

SET SERVEROUTPUT ON;
 --Write a PL/SQL block to show a reserved word can be used as a user-define identifier.
DECLARE
  "DECLARE" varchar2(25) := 'This is UPPERCASE';
  "Declare" varchar2(25) := 'This is Proper Case';
  "declare" varchar2(25) := 'This is lowercase';
BEGIN
  DBMS_Output.Put_Line("DECLARE");
  DBMS_Output.Put_Line("Declare");
  DBMS_Output.Put_Line("declare");
END;
/

-- PL/SQL block to Neglect Double Quotation Marks in Reserved Word Identifier
DECLARE
 -- "WORLD" varchar2(20) := 'world';  -- WORLD is not a reserved word
  "DECLARE" varchar2(20) := 'declare';  -- DECLARE is a reserved word
BEGIN
 -- DBMS_Output.Put_Line(World);      -- Double quotation marks are optional
  DBMS_Output.Put_Line(DECLARE);      -- Double quotation marks are required
end;
/

alter table employee add salary number;


SELECT * FROM EMPLOYEE;


DESC EMPLOYEE;

----- ADJUST SALARY OF EMP
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE PROC_EMP_SAL_ADJUST(EMP_ID NUMBER,
EMP_SAL in out NUMBER,
ADDLESS NUMBER)
AS
BEGIN
EMP_SAL := EMP_SAL + addless;
END;
/

DECLARE
v_id number ;
v_sal number;
BEGIN
v_id:=&v_id;
select nvl(salary,0) into v_sal from employee where id=v_id;
  DBMS_Output.Put_Line('OLD SALARY OF EMPLOYEE IS : ' ||  (V_SAL));      


PROC_EMP_SAL_ADJUST(v_id, v_sal,1000);
update employee set salary=v_sal where id=v_id;
commit;
  DBMS_Output.Put_Line('NEW SALARY OF EMPLOYEE IS : ' ||   (V_SAL));      

EXCEPTION WHEN OTHERS
THEN
  DBMS_Output.Put_Line('EXCEPTION COMES:');   
    DBMS_Output.Put_Line(SQLCODE);      
    DBMS_Output.Put_Line(SQLERRM);      


END;
/

DECLARE
  emp_dept_id department.id%TYPE;
 CURSOR cur_dept IS
  SELECT * 
  FROM department
  ORDER BY name;
 CURSOR cur_emp IS
  SELECT * 
  FROM employee
  WHERE dept_id = emp_dept_id;
  
BEGIN
    FOR r_dept IN cur_dept
    LOOP
      emp_dept_id := r_dept.id;
      DBMS_OUTPUT.PUT_LINE('----------------------------------');
      DBMS_OUTPUT.PUT_LINE('Department Name : '||r_dept.name);
      DBMS_OUTPUT.PUT_LINE('----------------------------------');
           FOR r_emp IN cur_emp 
           LOOP
             DBMS_OUTPUT.PUT_LINE('Employee: '||r_emp.name);
           END LOOP;   
    END LOOP;
END;
 /