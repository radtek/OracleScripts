--
-- RENEW_KLS_KODIF  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_KODIF (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
 RETURN;
 UPDATE kls_kodif
    set (NAME,FIELD_TYPE,FIELD_LEN,FIELD_DEC,FIELD_SVED) =
	    (SELECT NAME_R,FIELD_TYPE,FIELD_LEN,FIELD_DEC,FIELD_SVED FROM load_buffer.NKODIFIK
		  WHERE load_buffer.nkodifik.id=kls_kodif.id)
  where exists (SELECT * FROM load_buffer.nkodifik
                 where load_buffer.nkodifik.id=kls_kodif.id);

  INSERT INTO kls_kodif (ID,NAME,FIELD_TYPE,FIELD_LEN,FIELD_DEC,FIELD_SVED)
    (SELECT ID,NAME_R,FIELD_TYPE,FIELD_LEN,FIELD_DEC,FIELD_SVED FROM load_buffer.NKODIFIK
      WHERE not exists (SELECT kls_kodif.id FROM kls_kodif where kls_kodif.id=load_buffer.nkodifik.id));

  COMMIT;

END RENEW_KLS_KODIF;

/

