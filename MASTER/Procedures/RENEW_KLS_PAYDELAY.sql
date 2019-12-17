--
-- RENEW_KLS_PAYDELAY  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_PAYDELAY (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='')IS
BEGIN

  UPDATE kls_paydelay
    set (paydelay_name,short_name) = (SELECT A.n_otsr,A.nk_otsr FROM load_buffer.f_otsr A WHERE A.kod=kls_paydelay.id)
  where exists (SELECT B.kod FROM load_buffer.f_otsr B where B.kod=kls_paydelay.id );

  INSERT INTO kls_paydelay (id,paydelay_name,short_name) (SELECT C.kod,C.n_otsr,C.nk_otsr FROM load_buffer.f_otsr C
    WHERE not exists (SELECT D.id FROM kls_paydelay D where D.id=C.kod));
  COMMIT;

END RENEW_KLS_PAYDELAY;
/

