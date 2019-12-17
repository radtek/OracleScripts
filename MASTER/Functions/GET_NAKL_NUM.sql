--
-- GET_NAKL_NUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Nakl_Num
 (nom_dok# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(50);
--  propis# varchar2(4000);
BEGIN
  SELECT MAX(KVIT.NUM_KVIT) INTO val# FROM KVIT
    WHERE KVIT.BILL_ID=nom_dok#;

  RETURN val#;
END Get_Nakl_Num;

/

