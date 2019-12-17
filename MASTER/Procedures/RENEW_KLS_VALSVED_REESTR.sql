--
-- RENEW_KLS_VALSVED_REESTR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VALSVED_REESTR (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE /*+ RULE */ KLS_VALSVED
    set (QUAL,DATEUPLOAD) =
	    (SELECT A.QUAL,A.DATEUPLOAD FROM load_buffer.VALSVED_REESTR A
		  WHERE A.SVED_ID=KLS_VALSVED.SVED_ID AND
		        A.KODIF_ID=KLS_VALSVED.KODIF_ID)
  where exists (SELECT * FROM load_buffer.VALSVED_REESTR B
                 where B.SVED_ID=KLS_VALSVED.SVED_ID AND
				       B.KODIF_ID=KLS_VALSVED.KODIF_ID)
		AND SVED_FLG_OPERDATA=1 AND FROM_DBF=1;

  INSERT INTO KLS_VALSVED (SVED_ID,SVED_FLG_OPERDATA,FROM_DBF,KODIF_ID,QUAL,DATEUPLOAD)
    (SELECT C.SVED_ID,1,1,C.KODIF_ID,C.QUAL,C.DATEUPLOAD FROM load_buffer.VALSVED_REESTR C
      WHERE not exists (SELECT D.SVED_ID FROM KLS_VALSVED D
                 WHERE C.SVED_ID=D.SVED_ID AND
				       1=D.SVED_FLG_OPERDATA AND
				       C.KODIF_ID=D.KODIF_ID));

  DELETE /*+ RULE */ FROM KLS_VALSVED A WHERE A.SVED_FLG_OPERDATA=1 AND A.FROM_DBF=1 AND
    (NOT EXISTS (SELECT E.SVED_ID from load_buffer.VALSVED_REESTR E
	            WHERE E.SVED_ID = A.SVED_ID AND
				      1=A.SVED_FLG_OPERDATA AND
					  E.KODIF_ID=A.KODIF_ID) OR
    EXISTS (SELECT F.SVED_ID from KLS_VALSVED F
            WHERE F.SVED_FLG_OPERDATA=0 AND F.SVED_ID=A.SVED_ID));
  COMMIT;
END RENEW_KLS_VALSVED_REESTR;

/

