--
-- GET_AKCIZ_SVID  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Akciz_Svid
 (kod_plat# NUMBER, prod_group_id# NUMBER, date_sf# DATE, no_akciz# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(512);

  CURSOR temp IS
    SELECT 
	  'No ' || 
	  kls_predpr_akciz.EX_SVID_PREF || 
	  ' ' || 
  	  kls_predpr_akciz.EX_SVID_NUMB ||
	  ' срок действия с ' ||
	  TO_CHAR(kls_predpr_akciz.DATE_BEG,'dd.mm.yyyy') ||
	  'г. по ' ||
	  TO_CHAR(kls_predpr_akciz.DATE_END,'dd.mm.yyyy') ||
	  'г.'
  	    AS NUM_svid
	FROM 
	  kls_predpr_akciz WHERE kls_predpr_akciz.PLAT_ID=kod_plat# and 
	  kls_predpr_akciz.PROD_GROUPS_ID=prod_group_id# and
	  date_sf# BETWEEN kls_predpr_akciz.DATE_BEG and kls_predpr_akciz.DATE_END;
	  
  dest temp%ROWTYPE;

BEGIN

  val#:='';
  OPEN temp;
  LOOP
    FETCH temp INTO dest;
    EXIT WHEN temp%NOTFOUND;

    val#:=val#||' '||dest.num_svid;
  END LOOP;
  IF (LTRIM(RTRIM(val#))='') AND (No_Akciz#=1) AND (date_sf#>=TO_DATE('01.01.2005','dd.mm.yyyy')) THEN
    val#:=val# || ' Продано без акциза, но нет свидетельства!';
  END IF;
  RETURN LTRIM(RTRIM(val#));
END Get_Akciz_Svid;

/

