--
-- RENEW_KLS_VID_USL  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VID_USL (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_VID_USL
    set usl_name = (SELECT A.naim FROM load_buffer.vid_usl A WHERE A.kod=kls_vid_usl.id)
    where exists (SELECT B.kod FROM load_buffer.vid_usl B where B.kod=kls_vid_usl.id);

  INSERT INTO kls_VID_USL (ID,USL_NAME) (SELECT C.kod, C.naim FROM load_buffer.vid_usl C
    WHERE not exists (SELECT D.id FROM kls_VID_USL D where D.id=C.kod));
  COMMIT;

END RENEW_KLS_VID_USL;

/

