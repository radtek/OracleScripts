--
-- GET_LIST_NAKL_NUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_List_Nakl_Num
 (nom_dok# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(512);

  CURSOR temp IS
    SELECT DISTINCT TO_CHAR(NVL(NUM_KVIT,0)) AS NUM_KVIT
	FROM V_KVIT_ALL WHERE BILL_ID=nom_dok# ORDER BY num_kvit;

  dest temp%ROWTYPE;

BEGIN

  val#:='';
  OPEN temp;
  LOOP
    FETCH temp INTO dest;
    EXIT WHEN temp%NOTFOUND;

    val#:=val#||' '||dest.num_kvit;
  END LOOP;
  
  RETURN SUBSTR(LTRIM(RTRIM(val#)),1,220);
END Get_List_Nakl_Num; 
/

