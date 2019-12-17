--
-- RENEW_KLS_OWNERSHIP  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_OWNERSHIP (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_ownership
    set ownership_name = (SELECT A.naim FROM load_buffer.sobstv A WHERE A.kod=kls_ownership.id)
    where exists (SELECT B.kod FROM load_buffer.sobstv B WHERE B.kod=kls_ownership.id);

  INSERT INTO kls_ownership (id,ownership_name)
   (SELECT C.kod,C.naim FROM load_buffer.sobstv C
    WHERE not exists (SELECT D.id FROM kls_ownership D WHERE D.id=C.kod));
  COMMIT;

END RENEW_KLS_OWNERSHIP;

/

