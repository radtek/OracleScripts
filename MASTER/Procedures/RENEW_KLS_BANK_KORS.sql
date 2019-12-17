--
-- RENEW_KLS_BANK_KORS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_BANK_KORS (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
BEGIN

  UPDATE kls_bank
    set (bank_name, address, bik, postindex) =
	    (SELECT A.naimb, A.adresb, A.bik, A.pindexb FROM load_buffer.bank_kors A WHERE A.kors_new=kls_bank.kors)
    where exists (SELECT B.kors_new FROM load_buffer.bank_kors B WHERE B.kors_new=kls_bank.kors);

  INSERT INTO kls_bank (kors, bank_name, address, bik, postindex)
    (SELECT C.kors_new, C.naimb, C.adresb, C.bik, C.pindexb FROM load_buffer.bank_kors C
      WHERE not exists (SELECT D.kors FROM kls_bank D WHERE D.kors=C.kors_new));

  COMMIT;

END RENEW_KLS_BANK_KORS;

/

