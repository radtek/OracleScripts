--
-- RENEW_KLS_LOAD_TYPE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Load_Type (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE KLS_LOAD_TYPE
    SET (type_otgr_name,LOAD_MOS_ID) =
	    (SELECT NAME,kod_m FROM load_buffer.vid_otgr WHERE load_buffer.vid_otgr.ID=KLS_LOAD_TYPE.ID)
  WHERE EXISTS (SELECT NULL FROM load_buffer.vid_otgr WHERE load_buffer.vid_otgr.ID=KLS_LOAD_TYPE.ID);

  INSERT INTO KLS_LOAD_TYPE (ID,type_otgr_name,LOAD_MOS_ID)
    (SELECT ID,NAME,kod_m FROM load_buffer.vid_otgr
      WHERE NOT EXISTS (SELECT NULL FROM KLS_LOAD_TYPE WHERE KLS_LOAD_TYPE.ID=load_buffer.vid_otgr.ID));

  COMMIT;

END Renew_Kls_Load_Type;

/

