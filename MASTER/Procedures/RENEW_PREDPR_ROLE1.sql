--
-- RENEW_PREDPR_ROLE1  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_PREDPR_ROLE1 (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  INSERT INTO predpr_role (predpr_id,kls_role_id,fox_kod)
   (SELECT C.kod_predpr,1,C.kod_sob FROM load_buffer.spr_sob C
    WHERE C.kod_predpr<>0 AND not exists (SELECT * FROM predpr_role D WHERE D.predpr_id=C.kod_predpr AND D.kls_role_id=1 AND D.fox_kod=C.KOD_SOB));
  COMMIT;

  DELETE FROM predpr_role WHERE predpr_role.KLS_ROLE_ID=1 AND
    NOT EXISTS (SELECT * from load_buffer.spr_sob E WHERE E.kod_predpr = predpr_role.PREDPR_ID and predpr_role.kls_role_id=1 and E.kod_sob=predpr_role.FOX_KOD AND E.kod_predpr<>0);
  COMMIT;

END RENEW_PREDPR_ROLE1;

/

