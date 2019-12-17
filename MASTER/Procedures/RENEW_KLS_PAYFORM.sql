--
-- RENEW_KLS_PAYFORM  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_PAYFORM (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='')IS
BEGIN
  UPDATE kls_payform
    set payform_name = (SELECT nm_o FROM load_buffer.for_o WHERE load_buffer.for_o.kod_o=kls_payform.id)
    where exists (SELECT kod_o FROM load_buffer.for_o where load_buffer.for_o.kod_o=kls_payform.id);

  INSERT INTO kls_payform (id,payform_name)
   (SELECT C.kod_o,C.nm_o FROM load_buffer.for_o C
    WHERE not exists (SELECT D.id FROM kls_payform D where D.id=C.kod_o));
  COMMIT;

END RENEW_KLS_PAYFORM;

/

