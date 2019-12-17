--
-- GET_LIST_PROGRAM_USERS  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_List_program_users
 (org# VARCHAR2, app# VARCHAR2, dep# VARCHAR2, sl# VARCHAR2)
RETURN VARCHAR2
AS
  val# VARCHAR2(512);

  CURSOR temp IS
    SELECT DISTINCT FIO
	FROM program_users WHERE organization=org# AND department=dep# AND application=app# AND sl=sl#
    order by fio;

  dest temp%ROWTYPE;

BEGIN

  val#:='';
  OPEN temp;
  LOOP
    FETCH temp INTO dest;
    EXIT WHEN temp%NOTFOUND;

    val#:=val#||', '||dest.fio;
  END LOOP;
  
  RETURN SUBSTR(LTRIM(RTRIM(SUBSTR(val#,2))),1,220);
END Get_List_program_users; 
/

