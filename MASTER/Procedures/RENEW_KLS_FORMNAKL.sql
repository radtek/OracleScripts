--
-- RENEW_KLS_FORMNAKL  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_FORMNAKL (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE kls_formnakl
    set (form_name, flg_dostup, flg_group) =
	(SELECT A.name,IIF(A.dostup,1,0),IIF(A.grp,1,0) FROM load_buffer.forma A WHERE A.kod=kls_formnakl.id)
    where exists (SELECT * FROM load_buffer.forma B WHERE B.kod=kls_formnakl.id);

  INSERT INTO kls_formnakl (id, form_name, flg_dostup, flg_group)
   (SELECT C.kod, C.name, IIF(C.dostup,1,0),IIF(C.grp,1,0) FROM load_buffer.forma C
    WHERE not exists (SELECT * FROM kls_formnakl D where D.ID=C.KOD));

  INSERT INTO kls_formnakl (id, form_name, flg_dostup, flg_group)
   (SELECT DISTINCT 0, 'Не Ж/Д отгрузка', 0, 0 FROM load_buffer.forma
    WHERE not exists (SELECT * FROM kls_formnakl D where D.ID=0));

  COMMIT;

END RENEW_KLS_FORMNAKL;

/

