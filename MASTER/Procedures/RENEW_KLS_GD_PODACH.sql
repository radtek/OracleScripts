--
-- RENEW_KLS_GD_PODACH  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Gd_podach (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  --- Справочник подач (для ГУ-12)
  UPDATE KLS_GD_PODACH
    SET (NAME)
	  = (SELECT naim
  	     FROM load_buffer.podagu12 WHERE kod=KLS_GD_PODACH.ID)
     WHERE EXISTS (SELECT NULL FROM load_buffer.podagu12 WHERE kod=KLS_GD_PODACH.ID);

  INSERT INTO KLS_GD_PODACH (ID,NAME)
	(SELECT kod,naim
	   FROM load_buffer.podagu12 A
      WHERE NOT EXISTS (SELECT NULL FROM KLS_GD_PODACH C WHERE C.ID=A.kod));

  COMMIT;
END Renew_Kls_Gd_Podach;

/

