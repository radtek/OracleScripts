--
-- RENEW_KLS_GOSPROG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_GOSPROG (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_gosprog
    set gosprog_name = (SELECT name FROM load_buffer.program WHERE id=kod)
    where exists (SELECT kod FROM load_buffer.program where id=kod);

  INSERT INTO kls_gosprog (id,gosprog_name)
   (SELECT kod,name FROM load_buffer.program
    WHERE not exists (SELECT id FROM kls_gosprog where id=kod));

  COMMIT;

END RENEW_KLS_GOSPROG;

/

