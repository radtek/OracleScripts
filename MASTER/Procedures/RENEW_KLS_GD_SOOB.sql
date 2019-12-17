--
-- RENEW_KLS_GD_SOOB  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Gd_soob (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  --- Справочник ж/д сообщений (для ГУ-12)
  UPDATE KLS_GD_SOOB
    SET (NAME)
	  = (SELECT naim
  	     FROM load_buffer.soobgu12 WHERE kod=KLS_GD_SOOB.ID)
     WHERE EXISTS (SELECT NULL FROM load_buffer.soobgu12 WHERE kod=KLS_GD_SOOB.ID);

  INSERT INTO KLS_GD_SOOB (ID,NAME)
	(SELECT kod,naim
	   FROM load_buffer.soobgu12 A
      WHERE NOT EXISTS (SELECT NULL FROM KLS_GD_SOOB C WHERE C.ID=A.kod));

  COMMIT;
END Renew_Kls_Gd_Soob;

/

