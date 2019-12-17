--
-- GET_DATE_OTSRPLAT  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_DATE_OTSRPLAT
 (pDATE_KVIT DATE, pKOL_DN NUMBER, pONLY_WORK NUMBER DEFAULT 0)
RETURN DATE
AS
  vRES DATE;
BEGIN
  IF pONLY_WORK = 1 THEN
    BEGIN
	  select max(value) into vRES 
	  from (select value from kls_dates a where is_work=1 and value>pDATE_KVIT order by value) where rownum<=pKOL_DN;
	EXCEPTION
	  WHEN OTHERS THEN
	    vRES:=pDATE_KVIT+pKOL_DN;
	END;
  ELSE
    vRES:=pDATE_KVIT+pKOL_DN;
  END IF;	
  
  RETURN vRES;
END; 

/

