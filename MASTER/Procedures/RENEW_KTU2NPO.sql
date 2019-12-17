--
-- RENEW_KTU2NPO  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KTU2NPO (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
  IsFull NUMBER(1);
BEGIN

  UPDATE ktu_2_npo_sf
    set (NOM_SF,NPO_SF) =
	(SELECT a.NOM_SF,a.NPO_SF FROM load_buffer.ktu_2_npo A WHERE A.nom_dok=ktu_2_npo_sf.nom_dok)
    where exists (SELECT nom_dok FROM load_buffer.ktu_2_npo B WHERE B.nom_dok=ktu_2_npo_sf.nom_dok);
  COMMIT;

  INSERT INTO ktu_2_npo_sf
    (NOM_DOK,NOM_SF,NPO_SF)
	(SELECT a.nom_dok,a.NOM_SF,a.NPO_SF FROM load_buffer.ktu_2_npo A
  WHERE not exists (SELECT nom_dok FROM ktu_2_npo_sf C WHERE A.nom_dok=C.nom_dok));
  COMMIT;

  DELETE FROM ktu_2_npo_sf WHERE not exists
    (SELECT nom_dok FROM load_buffer.ktu_2_npo a WHERE a.nom_dok=ktu_2_npo_sf.nom_dok);

  COMMIT;

END RENEW_KTU2NPO;

/

