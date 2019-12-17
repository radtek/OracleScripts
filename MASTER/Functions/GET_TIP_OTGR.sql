--
-- GET_TIP_OTGR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Tip_Otgr
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
  	  SELECT MIN(ID) INTO val# FROM KLS_LOAD_TYPE
        WHERE load_mos_id=kod_moscow#;
    EXCEPTION
      WHEN OTHERS THEN
	    val#:=0;
	END;			
    RETURN val#;
  END IF;	 
END Get_Tip_Otgr;

/

