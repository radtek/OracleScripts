--
-- RENEW_KLS_GROUPDOG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_GROUPDOG (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_groupdog
    set (groupdog_name,fin_name1,fin_name2) = (SELECT A.name,A.fin_name1,A.fin_name2 FROM load_buffer.group_ A WHERE A.kod=kls_groupdog.id)
    where exists (SELECT B.kod FROM load_buffer.group_ B WHERE B.kod=kls_groupdog.id);

  INSERT INTO kls_groupdog (id,groupdog_name,fin_name1,fin_name2)
   (SELECT C.kod,C.name,C.fin_name1,C.fin_name2 FROM load_buffer.group_ C
    WHERE not exists (SELECT D.id FROM kls_groupdog D WHERE D.id=C.kod));
  COMMIT;

END RENEW_KLS_GROUPDOG;

/

