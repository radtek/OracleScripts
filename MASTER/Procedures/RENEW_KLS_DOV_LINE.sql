--
-- RENEW_KLS_DOV_LINE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Dov_Line (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE KLS_DOV_LINE
    SET (VES,PROD_ID_NPR,DOVER_ID) =
	    (SELECT A.VES,A.KOD_NPR,A.ID_DOVER FROM load_buffer.DOV_LINE A
		  WHERE A.ID_DOV_LIN=KLS_DOV_LINE.id)
  WHERE IS_LOADED=1 
    AND EXISTS (SELECT load_buffer.DOV_LINE.ID_DOV_LIN FROM load_buffer.DOV_LINE
                 WHERE load_buffer.DOV_LINE.ID_DOV_LIN=KLS_DOV_LINE.id);

  COMMIT;

  INSERT INTO KLS_DOV_LINE (ID,VES,PROD_ID_NPR,DOVER_ID,IS_LOADED)
    (SELECT C.ID_DOV_LIN,C.VES,C.KOD_NPR,C.ID_DOVER,1 FROM load_buffer.DOV_LINE C
      WHERE NOT EXISTS (SELECT KLS_DOV_LINE.id FROM KLS_DOV_LINE WHERE KLS_DOV_LINE.id=C.ID_DOV_LIN AND IS_LOADED=1));

  COMMIT;

  DELETE FROM KLS_DOV_LINE WHERE IS_LOADED=1 AND NOT EXISTS (SELECT E.ID_DOV_LIN FROM load_buffer.DOV_LINE E WHERE E.ID_DOV_LIN = KLS_DOV_LINE.ID);

  COMMIT;
END Renew_Kls_Dov_Line;

/
