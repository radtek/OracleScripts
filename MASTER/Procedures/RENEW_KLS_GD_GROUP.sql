--
-- RENEW_KLS_GD_GROUP  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_gd_group (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  --- Справочник ж/д групп грузов
  UPDATE KLS_GD_GROUP
    SET (ABBR, NAME)
	  = (SELECT DECODE(kod,-1,'',TO_CHAR(kod,'00')), naim
  	     FROM load_buffer.gruzgu12 WHERE kod=KLS_GD_GROUP.ID)
     WHERE EXISTS (SELECT NULL FROM load_buffer.gruzgu12 WHERE kod=KLS_GD_GROUP.ID);

  INSERT INTO KLS_GD_GROUP (ID,ABBR,NAME)
	(SELECT  kod,DECODE(kod,-1,'',TO_CHAR(kod,'00')), naim FROM load_buffer.gruzgu12 A
      WHERE NOT EXISTS (SELECT NULL FROM KLS_GD_GROUP C WHERE C.ID=A.kod));

  COMMIT;
END Renew_Kls_gd_group;

/

