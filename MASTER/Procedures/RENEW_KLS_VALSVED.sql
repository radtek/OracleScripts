--
-- RENEW_KLS_VALSVED  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VALSVED (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE /*+ RULE*/ KLS_VALSVED
    set (QUAL,DATEUPLOAD) =
	    (SELECT A.QUAL,a.DATEUPLOAD FROM load_buffer.VALSVED A
		  WHERE A.SVED_ID=KLS_VALSVED.SVED_ID AND
		        A.KODIF_ID=KLS_VALSVED.KODIF_ID)
  where SVED_FLG_OPERDATA=0 AND FROM_DBF=1 AND
        exists (SELECT * FROM load_buffer.VALSVED B
                 where B.SVED_ID=KLS_VALSVED.SVED_ID AND
				       B.KODIF_ID=KLS_VALSVED.KODIF_ID);

  INSERT INTO KLS_VALSVED (SVED_ID,SVED_FLG_OPERDATA,FROM_DBF,KODIF_ID,QUAL,DATEUPLOAD)
    (SELECT C.SVED_ID,0,1,C.KODIF_ID,C.QUAL,C.DATEUPLOAD FROM load_buffer.VALSVED C
      WHERE not exists (SELECT D.SVED_ID FROM KLS_VALSVED D
                         WHERE C.SVED_ID=D.SVED_ID AND
		          		       C.KODIF_ID=D.KODIF_ID AND
					           0=D.SVED_FLG_OPERDATA));

  DELETE /*+ RULE */ FROM KLS_VALSVED A WHERE A.SVED_FLG_OPERDATA=0 AND A.FROM_DBF=1 AND
     NOT EXISTS (SELECT * from load_buffer.VALSVED E WHERE E.SVED_ID = A.SVED_ID AND E.KODIF_ID=A.KODIF_ID) AND
     A.DATEUPLOAD BETWEEN date_beg AND date_end;

  RENEW_KLS_VALSVED_REESTR(DATE_BEG,DATE_END,param1,param2,param3);

  COMMIT;
  
END RENEW_KLS_VALSVED;

/

