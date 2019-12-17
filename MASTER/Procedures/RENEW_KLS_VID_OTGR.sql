--
-- RENEW_KLS_VID_OTGR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VID_OTGR (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE kls_vid_otgr
    set (load_name,load_type_id) =
	    (SELECT load_name,load_type FROM load_buffer.vid_load
		  WHERE load_buffer.vid_load.load_abbr=kls_vid_otgr.load_abbr)
  where exists (SELECT * FROM load_buffer.vid_load
                 where load_buffer.vid_load.load_abbr=kls_vid_otgr.load_abbr);

  INSERT INTO kls_vid_otgr (load_abbr,load_name,load_type_id)
    (SELECT load_abbr,load_name,load_type FROM load_buffer.vid_load
      WHERE not exists (SELECT * FROM kls_vid_otgr where kls_vid_otgr.load_abbr=load_buffer.vid_load.load_abbr));

  COMMIT;

END RENEW_KLS_VID_OTGR;

/

