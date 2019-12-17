--
-- RENEW_KLS_HOLDING  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_HOLDING (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_holding
    SET (holding_name, boss) = (SELECT A.name, A.boss FROM load_buffer.holding A WHERE A.id=kls_holding.ID)
    WHERE exists (SELECT B.id FROM load_buffer.holding B WHERE B.ID=kls_holding.ID);

  INSERT INTO kls_holding (id, holding_name, boss) (SELECT C.id, C.name, C.boss FROM load_buffer.holding C
    WHERE not exists (SELECT D.id FROM kls_holding D WHERE D.ID=C.ID));

  COMMIT;

END RENEW_KLS_HOLDING;

/

