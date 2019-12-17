--
-- GET_USL_OPL_FROM_PAY_TYPE  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Usl_Opl_From_Pay_Type(ssPayType VARCHAR2) RETURN NUMBER IS
  npay_day NUMBER;
  usl_opl_id# NUMBER;
BEGIN
  -- Определяем отсрочку
  IF ssPayType LIKE 'ПРЕДОПЛАТА 100%' THEN
    npay_day := -1;
  ELSE
    IF INSTR (ssPayType, 'ПО ФАКТУ') <> 0 THEN
	  BEGIN
        npay_day := TO_NUMBER (SUBSTR (ssPayType, 9));
	  EXCEPTION
	    WHEN OTHERS THEN
	    npay_day := -1; 
	  END;
    ELSE
      npay_day := -1;
    END IF;
  END IF;
  IF npay_day<=0 THEN
    RETURN 1;
  END IF;	
  IF npay_day=45 THEN
    RETURN 18;
  END IF;	
  BEGIN
    SELECT MIN(ID) INTO usl_opl_id#
      FROM KLS_USL_OPL
   	WHERE kol_dn=npay_day;
  EXCEPTION
    WHEN OTHERS THEN
	  usl_opl_id#:=0;
  END;
  RETURN usl_opl_id#;
END Get_Usl_Opl_From_Pay_Type;

/

