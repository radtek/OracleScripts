--
-- GET_OPL_PLAT_NUMS  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.get_opl_plat_nums
 (dog_id# number, date_plat# date)
return varchar2
as
CURSOR temp IS
 SELECT LTRIM(RTRIM(opl.NOM_POR)) AS nom_por FROM opl
    WHERE dog_id=dog_id# AND data_por=date_plat#
    ORDER BY 1;

 dest temp%ROWTYPE;
 val# varchar2(150);
--  propis# varchar2(4000);
BEGIN
  OPEN temp;
  val#:='';
  LOOP
    FETCH temp INTO dest;
    EXIT WHEN temp%NOTFOUND;
	IF LENGTH(Val#)>0 THEN
  	  val#:=val# || ',';
	END IF;
	val#:=val# || dest.nom_por;
  END LOOP;
  return val#;
end get_opl_plat_nums;

/

