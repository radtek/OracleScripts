--
-- RENEW_KLS_NAPR_MOS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Napr_mos (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_NAPR_MOS
    SET NAME = (SELECT A.napr_name FROM load_buffer.trans_napr A WHERE A.napr=KLS_NAPR_MOS.ID)
    WHERE EXISTS (SELECT NULL FROM load_buffer.trans_napr B WHERE B.napr=KLS_NAPR_MOS.ID);

  INSERT INTO KLS_NAPR_MOS (ID,NAME)
   (SELECT C.napr,C.napr_name FROM load_buffer.trans_napr C
    WHERE NOT EXISTS (SELECT NULL FROM KLS_NAPR_MOS D WHERE D.ID=C.napr));
  COMMIT;

END Renew_Kls_Napr_mos;

/

