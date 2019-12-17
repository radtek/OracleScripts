--
-- RENEW_KLS_CAT_CEN  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_CAT_CEN (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE kls_CAT_CEN
    set (cat_cen_name,fox_id) = (SELECT MAX(naim),MAX(id) FROM load_buffer.CAT_CEN WHERE cat_cen=kls_CAT_CEN.id)
    where exists (SELECT cat_cen FROM load_buffer.CAT_CEN WHERE cat_cen=kls_CAT_CEN.id);


  INSERT INTO kls_CAT_CEN (id,cat_cen_name,fox_id) (SELECT cat_cen,MAX(naim),max(id) FROM load_buffer.CAT_CEN
    WHERE cat_cen not in (SELECT id FROM kls_CAT_CEN) GROUP BY cat_cen);
  COMMIT;
END RENEW_KLS_CAT_CEN;

/

