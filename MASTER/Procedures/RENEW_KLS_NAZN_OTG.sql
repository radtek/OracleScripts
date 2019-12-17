--
-- RENEW_KLS_NAZN_OTG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_NAZN_OTG (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE kls_nazn_otg
    set nazn_otg_name = (SELECT naz_otgr FROM load_buffer.nazn_otg A WHERE A.kod_otgr=kls_nazn_otg.id)
    where exists (SELECT kod_otgr FROM load_buffer.nazn_otg B WHERE B.KOD_OTGR=kls_nazn_otg.id);

  INSERT INTO kls_nazn_otg (id,nazn_otg_name)
  (SELECT C.kod_otgr,C.naz_otgr FROM load_buffer.nazn_otg C
    WHERE not exists (SELECT * FROM kls_nazn_otg D WHERE D.id=C.kod_otgr));

  COMMIT;

END RENEW_KLS_NAZN_OTG;

/

