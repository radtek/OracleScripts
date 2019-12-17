--
-- ORA_CHAR_TO_NUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.ORA_CHAR_TO_NUM(pChar VARCHAR2, pFormat VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
s VARCHAR2(200);
f VARCHAR2(200);
res NUMBER;
BEGIN
  IF pChar||' ' = ' ' THEN
    RETURN 0;
  END IF;

  s:=REPLACE(pChar,' ','');
  s:=REPLACE(s,',','.');
  f:=REPLACE(pFormat,',','.');
  
  BEGIN
    IF pFormat||' '=' ' THEN
      res:=TO_NUMBER(s);
	ELSE
      res:=TO_NUMBER(s,f);
	END IF;
  EXCEPTION
	WHEN OTHERS THEN
	  res:=0;
  END;
  IF res=0 THEN
    s:=REPLACE(pChar,' ','');
    s:=REPLACE(s,'.',',');
    f:=REPLACE(pFormat,'.',',');
    BEGIN
      IF pFormat||' '=' ' THEN
        res:=TO_NUMBER(s);
  	  ELSE
        res:=TO_NUMBER(s,f);
	  END IF;
    EXCEPTION
	  WHEN OTHERS THEN
	    res:=0;
    END;
  END IF;	
  
/*  BEGIN
    res:=REPLACE(pChar,',','.');
    IF pFormat||' '=' ' THEN
      RETURN TO_NUMBER(res);
	ELSE
      RETURN TO_NUMBER(res,pFormat);
	END IF;
  EXCEPTION
	WHEN OTHERS THEN
	  NULL;
  END;*/
/*  BEGIN
    res:=REPLACE(pChar,'.',',');
    IF pFormat||' '=' ' THEN
      RETURN TO_NUMBER(res);
	ELSE
      RETURN TO_NUMBER(res,pFormat);
	END IF;
  EXCEPTION
	WHEN OTHERS THEN
	  NULL;
  END;*/
  RETURN res;
END;

/

