--
-- RENEW_KLS_VAGONTYPE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_VAGONTYPE (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE kls_vagontype
    set (vagontype_name,ed_izm) =
	(SELECT name,ed_izm FROM load_buffer.vag_type WHERE kod=id)
     where EXISTS (SELECT kod FROM load_buffer.vag_type  WHERE kod=id);


  INSERT INTO kls_vagontype (id,vagontype_name,ed_izm)
	(SELECT kod,name,ed_izm FROM load_buffer.vag_type
    WHERE not exists (SELECT id FROM kls_vagontype WHERE id=kod));

  COMMIT;
END RENEW_KLS_VAGONTYPE;

/

