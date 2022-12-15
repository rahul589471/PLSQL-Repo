-- This is like a key value pair

declare
type t_color_code is table of varchar(30) index by varchar2(10);
l_color_code t_color_code;   -- Difference is we don't need to initialize Associative array

l_code varchar2(30);
begin
l_color_code('blue'):='000,001,002';
l_color_code('red'):='001,001,002';
l_color_code('orange'):='002,001,002';
l_color_code('green'):='003,001,002';

dbms_output.put_line(l_color_code.first);
dbms_output.put_line(l_color_code.last);

l_code:=l_color_code.first;

while l_code is not null
loop
dbms_output.put_line(l_code || ' has code ' || l_color_code(l_code));
l_code:=l_color_code.next(l_code);
end loop;

end;
/
