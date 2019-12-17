--
-- GET_PHONE  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_PHONE(phone VARCHAR2, fax VARCHAR2)
  RETURN VARCHAR2 IS
  s1 VARCHAR2(250);
  s2 VARCHAR2(250);
BEGIN
  if (phone IS NULL) then
    s1 := '';
  else
    s1 := ' ' || phone;
  end if;

  if (fax IS NULL) then
    s2 := '';
  else
    if s1 || ' ' = ' ' then
      s2 := ' ' || fax;
	else  
      s2 := ',' || fax;
	end if;  
  end if;
  
  RETURN RTrim(LTrim(s1 || s2));  
End;

/

