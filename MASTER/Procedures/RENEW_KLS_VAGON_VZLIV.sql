--
-- RENEW_KLS_VAGON_VZLIV  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VAGON_VZLIV (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE kls_vagon_vzliv
    set (VOLUME) =
	(SELECT obc FROM load_buffer.cist_vsl WHERE typec=kalibr_id and vzlvc=vzliv)
  where EXISTS 
	(SELECT null FROM load_buffer.cist_vsl WHERE typec=kalibr_id and vzlvc=vzliv);


  INSERT INTO kls_vagon_vzliv (kalibr_id,vzliv,VOLUME)
	(SELECT typec,vzlvc,obc FROM load_buffer.cist_vsl
      WHERE not exists 
	    (SELECT null FROM kls_vagon_vzliv WHERE typec=kalibr_id and vzlvc=vzliv));

  COMMIT;
END RENEW_KLS_VAGON_VZLIV;

/

