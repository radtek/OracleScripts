--
-- RENEW_KLS_USL_OPL  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_usl_opl (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_usl_opl
    set (name,kol_dn) = (SELECT A.nain_opl,a.kol_dn FROM load_buffer.usl_opl A WHERE A.kod_opl=kls_usl_opl.id)
    where exists (SELECT B.kod_opl FROM load_buffer.usl_opl B where B.kod_opl=kls_usl_opl.id);

  INSERT INTO kls_usl_opl (SELECT C.kod_opl, C.nain_opl, C.kol_dn FROM load_buffer.usl_opl C
    WHERE not exists (SELECT D.id FROM kls_usl_opl D where D.id=C.kod_opl));
  COMMIT;

END RENEW_KLS_usl_opl;

/

