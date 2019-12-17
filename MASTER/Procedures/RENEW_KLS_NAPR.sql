--
-- RENEW_KLS_NAPR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Napr (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_NAPR
    SET (napr_name,napr_mos_id) = (SELECT A.napr,DECODE(a.kod,0,1,2) FROM load_buffer.napr A WHERE A.kod=KLS_NAPR.ID)
    WHERE EXISTS (SELECT * FROM load_buffer.napr B WHERE B.kod=KLS_NAPR.ID);

  INSERT INTO KLS_NAPR (ID,napr_name,napr_mos_id)
   (SELECT C.kod,C.napr,DECODE(c.kod,0,1,2) FROM load_buffer.napr C
    WHERE NOT EXISTS (SELECT * FROM KLS_NAPR D WHERE D.ID=C.kod));
  COMMIT;

END Renew_Kls_Napr;

/

