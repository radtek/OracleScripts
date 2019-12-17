--
-- RENEW_KLS_VIDDOG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VIDDOG (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_viddog
    set (viddog_name,is_agent) = (SELECT A.name,A.is_agent FROM load_buffer.vid_dog A WHERE A.vid_dog=kls_viddog.id)
    where exists (SELECT B.vid_dog FROM load_buffer.vid_dog B WHERE B.vid_dog=kls_viddog.id);

  INSERT INTO kls_viddog (id,viddog_name,is_agent)
   (SELECT C.vid_dog,C.name,C.is_agent FROM load_buffer.vid_dog C
    WHERE not exists (SELECT D.id FROM kls_viddog D WHERE D.id=C.vid_dog));
  COMMIT;

END RENEW_KLS_VIDDOG;

/

