--
-- RENEW_KLS_GD_PRINVAG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Gd_Prinvag (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  --- Справочник принадлежности вагонов (для ГУ-12)
  UPDATE KLS_GD_PRINVAG
    SET (ABBR)
	  = (SELECT kod
  	     FROM load_buffer.pringu12 WHERE ASCII(kod)=KLS_GD_PRINVAG.ID)
     WHERE EXISTS (SELECT NULL FROM load_buffer.pringu12 WHERE ASCII(kod)=KLS_GD_PRINVAG.ID);

  INSERT INTO KLS_GD_PRINVAG (ID,ABBR,NAME)
	(SELECT ASCII(kod),kod,naim
	   FROM load_buffer.pringu12 A
      WHERE NOT EXISTS (SELECT NULL FROM KLS_GD_PRINVAG C WHERE C.ID=ASCII(A.kod)));

  COMMIT;
END Renew_Kls_Gd_Prinvag;

/

