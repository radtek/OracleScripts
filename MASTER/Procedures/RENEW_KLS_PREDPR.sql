--
-- RENEW_KLS_PREDPR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Predpr (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  vBankID NUMBER;
  vID_CLASS NUMBER;
BEGIN

  Renew_Kls_Banks (DATE_BEG,DATE_END);
--  Renew_Kls_Bank_Kors (DATE_BEG,DATE_END);

  UPDATE load_buffer.predpr SET holding = 41 WHERE holding=0 OR holding IS NULL;
  UPDATE load_buffer.predpr SET pertype = 10 WHERE pertype=0 OR pertype IS NULL;

  COMMIT;

  FOR lcur IN (SELECT * FROM load_buffer.predpr) LOOP

    IF lcur.kors_new IS NULL THEN
	  vBankID:=NULL;
	ELSE  
      BEGIN
        SELECT MAX(ID) INTO vBankID
	      FROM KLS_BANKS
	     WHERE kors=RTRIM(LTRIM(lcur.KORS_NEW))
	       AND NVL(bank_name,' ')=NLS_UPPER(NVL(lcur.NAIMB,' '))
  		   AND NVL(ADDRESS,' ')=NLS_UPPER(NVL(lcur.ADRESB,' '))
		   AND NVL(POSTINDEX,0)=NVL(lcur.PINDEXB,0);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          vBankID:=600000+lcur.kod;
	  END;
	END IF;  	  

	vID_CLASS:=TO_NUMBER(NVL(lcur.id_class,'9999999900'));
    UPDATE KLS_PREDPR
      SET (predpr_name, short_name, postindex_j, postindex_p, address_j, address_p, 
	       city_j, city_p, phone, fax, inn, okpo, okonh, email, bank_kors, region_id, holding_id, pertype_id, rs, 
		   banks_id, gd_kod,states_id,class_id,EX_SVID,is_block,okved,kpp,region_p_id,ksss_predpr_id,sf_name) =
          (SELECT lcur.naim, lcur.naim_k, lcur.pindex, lcur.pindex_p, lcur.adres, lcur.adres_p, 
		          lcur.gorod, lcur.gorod_p, lcur.telefon, lcur.fax, lcur.okpo, lcur.kokpo, lcur.kokonx, 
				  lcur.email, RTRIM(LTRIM(lcur.kors_new)), lcur.kobl, lcur.holding, lcur.pertype, lcur.rs_new, 
				  vBankID,lcur.gdkod,lcur.kstr,vID_CLASS,lcur.EX_SVID,lcur.is_block,lcur.okved,lcur.kpp,lcur.kobl_p,lcur.kod_ksss,DECODE(lcur.SF_NAME,NULL,lcur.naim,lcur.SF_NAME)
           FROM dual)
      WHERE KLS_PREDPR.ID=lcur.kod;
    
	IF SQL%NOTFOUND THEN
      INSERT INTO KLS_PREDPR 
	      (ID,predpr_name, short_name, postindex_j, postindex_p, address_j, address_p, 
	       city_j, city_p, phone, fax, inn, okpo, okonh, email, bank_kors, region_id, holding_id, pertype_id, rs, 
		   banks_id, gd_kod,states_id,class_id,EX_SVID,is_block,okved,kpp,region_p_id,ksss_predpr_id,sf_name) 
          VALUES (lcur.kod,lcur.naim, lcur.naim_k, lcur.pindex, lcur.pindex_p, lcur.adres, lcur.adres_p, 
		          lcur.gorod, lcur.gorod_p, lcur.telefon, lcur.fax, lcur.okpo, lcur.kokpo, lcur.kokonx, 
				  lcur.email, RTRIM(LTRIM(lcur.kors_new)), lcur.kobl, lcur.holding, lcur.pertype, lcur.rs_new, 
				  vBankID,lcur.gdkod,lcur.kstr,vID_CLASS,lcur.EX_SVID,lcur.is_block,lcur.okved,lcur.kpp,lcur.kobl_p,lcur.kod_ksss,
				  DECODE(lcur.SF_NAME,NULL,lcur.naim,lcur.SF_NAME));
    END IF; 
  
  END LOOP;
  
  COMMIT;
  
  Renew_Stan_Predpr (DATE_BEG, DATE_END);

  COMMIT;

END Renew_Kls_Predpr;

/

