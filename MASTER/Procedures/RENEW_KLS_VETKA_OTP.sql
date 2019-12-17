--
-- RENEW_KLS_VETKA_OTP  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Vetka_Otp (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_VETKA_OTP
    SET (MESTO_ID,LOAD_TYPE_ID,VETKA_NAME,SHORT_NAME,ORDNUNG,DOSTUP)
	  = (SELECT A.mesto,A.tip_otgr,A.track_name,A.naim_pr,A.sortby,Iif(A.dostup,1,0)
  	     FROM load_buffer.tracks A WHERE A.kod=KLS_VETKA_OTP.id)
    WHERE EXISTS (SELECT A.kod FROM load_buffer.tracks A WHERE A.kod=KLS_VETKA_OTP.id);

  INSERT INTO KLS_VETKA_OTP (ID,MESTO_ID,LOAD_TYPE_ID,VETKA_NAME,SHORT_NAME,ORDNUNG,DOSTUP)
	(SELECT  A.kod,A.mesto,A.tip_otgr,A.track_name,A.naim_pr,A.sortby,Iif(A.dostup,1,0) FROM load_buffer.tracks A
      WHERE NOT EXISTS (SELECT C.id FROM KLS_VETKA_OTP C WHERE C.id=A.kod));

  COMMIT;

END Renew_Kls_Vetka_Otp;

/

