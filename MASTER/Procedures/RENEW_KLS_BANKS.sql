--
-- RENEW_KLS_BANKS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Banks (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
BEGIN

  FOR lcur IN (SELECT * FROM load_buffer.banks) LOOP
    BEGIN
   
	  UPDATE KLS_BANKS
        SET (kors, bank_name, address, bik, postindex) =
	        (SELECT lcur.kors_new, lcur.naimb, lcur.adresb, lcur.bik, lcur.pindexb FROM dual)
       WHERE KLS_BANKS.id=lcur.ID;
	  
	  IF SQL%NOTFOUND THEN 
        INSERT INTO KLS_BANKS (id, kors, bank_name, address, bik, postindex)
             VALUES (lcur.ID, lcur.kors_new, lcur.naimb, lcur.adresb, lcur.bik, lcur.pindexb);
	  END IF;		 
	END;
  END LOOP;
  			 
  COMMIT;

END Renew_Kls_Banks;

/

