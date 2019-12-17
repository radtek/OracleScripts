--
-- RENEW_KLS_MESTO  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_MESTO(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_mesto
    set mesto_name = (SELECT A.name FROM load_buffer.mesto A WHERE A.kod=kls_mesto.id)
    where exists (SELECT B.kod FROM load_buffer.mesto B WHERE B.kod=kls_mesto.ID);

  INSERT INTO kls_mesto (id, mesto_name) (SELECT C.kod, C.name FROM load_buffer.mesto C
    WHERE NOT EXISTS (SELECT D.id FROM kls_mesto D WHERE D.ID=C.KOD));

  COMMIT;

END RENEW_KLS_MESTO;

/

