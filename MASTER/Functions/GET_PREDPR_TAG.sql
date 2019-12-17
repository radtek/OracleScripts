--
-- GET_PREDPR_TAG  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Predpr_Tag(name VARCHAR2)
  RETURN VARCHAR2 IS
  s1 VARCHAR2(250);
  s2 VARCHAR2(250);
  s3 VARCHAR2(25);
BEGIN
  s1:=NLS_UPPER(name);

  s1:=TRIM(REPLACE(s1,'"',''));
  s1:=TRIM(REPLACE(s1,'''',''));

  s2:=SUBSTR(s1,-3,3);
  IF s2 IN (' ¿Œ','√œ') THEN
    s1:=SUBSTR(s1,1,LENGTH(s1)-3);
  END IF;	 

  s2:=SUBSTR(s1,-4,4);
  IF s2 IN (' Œ¿Œ',' «¿Œ',' ŒŒŒ',' √”œ') THEN
    s1:=SUBSTR(s1,1,LENGTH(s1)-4);
  END IF;	 
  
  
  s1:=REPLACE(s1,' ','');
  s1:=REPLACE(s1,'.','');
  s1:=REPLACE(s1,',','');
  s1:=REPLACE(s1,'-','');
  RETURN s1;
END;

/

