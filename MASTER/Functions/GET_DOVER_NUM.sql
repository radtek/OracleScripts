--
-- GET_DOVER_NUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Dover_Num
 (nom_dok# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(50);
--  propis# varchar2(4000);
BEGIN
  SELECT MAX(KVIT.NUM_DOVER) INTO val# FROM KVIT
    WHERE KVIT.BILL_ID=nom_dok#;

  RETURN val#;
END Get_Dover_Num;

/

