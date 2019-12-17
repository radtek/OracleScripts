--
-- RENEW_KLS_KALIBR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_KALIBR (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE kls_kalibr
    SET (VAGON_MAX_VES,VAGON_AXES) =
	(SELECT A.GRU,A.KOO FROM load_buffer.cist_typ A WHERE A.tip=kls_kalibr.id)
     where EXISTS (SELECT * FROM load_buffer.cist_typ B WHERE B.tip=kls_kalibr.id);

  INSERT INTO kls_kalibr (id,VAGON_MAX_VES,VAGON_AXES)
	(SELECT C.tip,C.GRU,C.KOO FROM load_buffer.cist_typ C
    WHERE not exists (SELECT * FROM kls_kalibr WHERE kls_kalibr.id=C.TIP));

  INSERT INTO kls_kalibr (id)
	(SELECT DISTINCT '0' FROM load_buffer.cist_typ
    WHERE not exists (SELECT * FROM kls_kalibr WHERE kls_kalibr.id='0'));

  COMMIT;
END RENEW_KLS_KALIBR;

/

