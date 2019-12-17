--
-- GET_ADDR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_ADDR(reg_id NUMBER, postindex VARCHAR2, city VARCHAR2, address VARCHAR2, region VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2 IS
  s1 VARCHAR2(250);
  s2 VARCHAR2(250);
  s3 VARCHAR2(25);
  s4 VARCHAR2(250);
BEGIN
  if (postindex IS NULL) OR (TO_NUMBER(postindex)<10)then
    s3 := '';
  else
    s3 := ' ' || postindex;
  end if;

   
  if ((region IS NULL) or reg_id=110 or reg_id=111 or city='Í.ÍÎÂÃÎÐÎÄ' or city='ÍÈÆÍÈÉ-ÍÎÂÃÎÐÎÄ' or city='Ã. ÍÈÆÍÈÉ ÍÎÂÃÎÐÎÄ') then
    s4 := '';
  else
    s4 := ' ' || region;
  end if;

  
  if (city IS NULL) then
    s1 := '';
  else
    if (s4 || ' ' = ' ') then
      s1 := ' ' || city;
	else  
      s1 := ',' || city;
	end if;  
  end if;

  if (address IS NULL) then
    s2 := '';
  else
    if (s1 || ' ' = ' ') and (s4 || ' ' = ' ') then
      s2 := ' ' || address;
	else
      s2 := ',' || address;
	end if;
  end if;

  RETURN RTrim(LTrim(s3 || s4 || s1 || s2));
End;

/

