--
-- RENEW_KLS_PROD_GR_KONS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Prod_gr_kons (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_PROD_GR_KONS
    SET (ABBR, NAME)
	  = (SELECT A.PROD_GRP,A.PROD_GRP
  	     FROM load_buffer.kod_grp A WHERE A.prod_kod=KLS_PROD_GR_KONS.id_gr)
    WHERE EXISTS (SELECT NULL FROM load_buffer.kod_grp A WHERE A.prod_kod=KLS_PROD_GR_KONS.id_gr);

  INSERT INTO KLS_PROD_GR_KONS (ID_GR, ABBR, NAME)
	(SELECT  A.PROD_kod,A.prod_grp,A.prod_grp
  	   FROM load_buffer.kod_grp A
      WHERE NOT EXISTS (SELECT NULL FROM KLS_PROD_GR_KONS C WHERE C.id_gr=A.prod_kod));

  COMMIT;
  	   
END Renew_Kls_Prod_gr_kons;

/

