--
-- RENEW_KLS_VAGOWNER  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Vagowner (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE KLS_VAGOWNER
    SET (vagowner_name,short_name,predpr_id,VAGOWN_MOS_ID,VAGOWN_TYP_ID,SOBSTV_ID,DISPLAY_NAME,OWNER_ID,SORTBY,LOAD_TYPE_ID) =
	(SELECT NAME,name_k,kod_predpr,kod_m,tip_sobs,sobstv,view_name,vlad,sortby,tip_otgr 
	   FROM load_buffer.TYPES WHERE nom=ID)
    WHERE EXISTS (SELECT nom FROM load_buffer.TYPES B WHERE B.nom=KLS_VAGOWNER.ID);

  INSERT INTO KLS_VAGOWNER (ID,vagowner_name,short_name,predpr_id,VAGOWN_MOS_ID,VAGOWN_TYP_ID,SOBSTV_ID,DISPLAY_NAME,owner_id,SORTBY,LOAD_TYPE_ID)
	(SELECT nom,NAME,name_k,kod_predpr,kod_m,tip_sobs,sobstv,view_name,vlad,sortby,tip_otgr 
	   FROM load_buffer.TYPES
    WHERE NOT EXISTS (SELECT ID FROM KLS_VAGOWNER WHERE ID=nom));

  COMMIT;

END Renew_Kls_Vagowner;

/

