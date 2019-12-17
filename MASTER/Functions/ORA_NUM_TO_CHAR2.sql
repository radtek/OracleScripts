--
-- ORA_NUM_TO_CHAR2  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.ORA_NUM_TO_CHAR2(pNum NUMBER, pFormat VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 AS
f VARCHAR2(200);
res VARCHAR2(200);
BEGIN
  IF pNum IS NULL or pNum=0 THEN
    RETURN '0';
  END IF;

  f:=REPLACE(pFormat,'.',',');
  
  BEGIN
    IF pFormat||' '=' ' THEN
      res:=REPLACE(TO_CHAR(pNum),'.',',');
	ELSE
      res:=REPLACE(TO_CHAR(pNum,f),'.',',');
	END IF;
  EXCEPTION
	WHEN OTHERS THEN
	  res:='0';
  END;
  res:=Trim(res);
  if SUBSTR(res,1,1)=',' then 
    res:='0'||res;  
  end if;	
  if SUBSTR(res,1,2)='-,' then 
    res:='-0,'||SUBSTR(res,3);  
  end if;	
  RETURN res;
END ORA_NUM_TO_CHAR2;

/

