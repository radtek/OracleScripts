--
-- RENEW_KLS_USER  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_USER(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_user
    set user_name = (SELECT A.fio FROM load_buffer.ident A WHERE A.kod=kls_user.id)
    where exists (SELECT B.kod FROM load_buffer.ident B WHERE B.kod=kls_user.id);

  INSERT INTO kls_user (id, user_name) (SELECT C.kod, C.fio FROM load_buffer.ident C
    WHERE not exists (SELECT D.id FROM kls_user D WHERE D.ID=C.KOD));

--  DELETE FROM kls_user WHERE not exists (SELECT E.kod FROM load_buffer.ident E WHERE E.kod=kls_user.ID);

  COMMIT;

END RENEW_KLS_user;

/

