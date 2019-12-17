--
-- GET_REGION  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Region
 (kod_moscow# NUMBER)
RETURN NUMBER
AS
  val# NUMBER;
--  propis# varchar2(4000);
BEGIN
  IF kod_moscow#=0 THEN
    RETURN 0;
  ELSE	 
    BEGIN
  	  SELECT MAX(ID) INTO val# FROM KLS_REGION
        WHERE TO_NUMBER(KLS_REGION.KOD_MOSCOW)=kod_moscow#;
    EXCEPTION
      WHEN OTHERS THEN
	    val#:=0;
	END;			
    RETURN val#;
  END IF;	 
END Get_Region;

/

