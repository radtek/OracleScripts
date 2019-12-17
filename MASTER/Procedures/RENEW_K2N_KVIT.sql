--
-- RENEW_K2N_KVIT  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_K2N_KVIT (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  INSERT INTO ktu_2_npo_pref_kvit (pref_name)
   (SELECT C.pref_name FROM load_buffer.k2n_kvit C
    WHERE not exists (SELECT * FROM ktu_2_npo_pref_kvit D where D.pref_name=C.pref_name));

  COMMIT;

END RENEW_K2N_KVIT;

/

