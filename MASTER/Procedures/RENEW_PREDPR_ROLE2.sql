--
-- RENEW_PREDPR_ROLE2  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_PREDPR_ROLE2 (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  INSERT INTO predpr_role (predpr_id,kls_role_id,fox_kod)
   (SELECT C.kod_predpr,2,C.kod FROM load_buffer.pererab C
    WHERE C.kod_predpr<>0 AND not exists (SELECT * FROM predpr_role D WHERE D.predpr_id=C.kod_predpr AND D.kls_role_id=2 AND D.fox_kod=C.KOD));
  COMMIT;

  DELETE FROM predpr_role WHERE predpr_role.KLS_ROLE_ID=2 AND
    NOT EXISTS (SELECT * from load_buffer.pererab E WHERE E.kod_predpr = predpr_role.PREDPR_ID and predpr_role.kls_role_id=2 and E.kod=predpr_role.FOX_KOD AND E.kod_predpr<>0);
  COMMIT;

  INSERT INTO predpr_role (predpr_id,kls_role_id,fox_kod)
	(SELECT DISTINCT 0,2,0 FROM load_buffer.pererab
      WHERE not exists (SELECT * FROM predpr_role E where E.predpr_id=0 and E.kls_role_id=2 and E.fox_kod=0));

END RENEW_PREDPR_ROLE2;

/

