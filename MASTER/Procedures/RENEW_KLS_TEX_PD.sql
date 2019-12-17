--
-- RENEW_KLS_TEX_PD  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_TEX_PD (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

 UPDATE kls_tex_pd
    set (grotp_id,grotp_okpo,plattarif_id,tex_pd_name,bank,rs,grotp_short_name,plattar_short_name) =
	    (SELECT kod_grotpr,okpo_grotp,kod_predpr,name,bank,rs,name_grotp,name_plat FROM load_buffer.tex_pd
		  WHERE tex_pd.kod_tex_pd=kls_tex_pd.id AND tex_pd.kod_grotpr=kls_tex_pd.grotp_id)
  where exists (SELECT kod_tex_pd FROM load_buffer.tex_pd where tex_pd.kod_tex_pd=kls_tex_pd.id AND tex_pd.kod_grotpr=kls_tex_pd.grotp_id);

  INSERT INTO kls_tex_pd (id,grotp_id,grotp_okpo,plattarif_id,tex_pd_name,bank,rs,grotp_short_name,plattar_short_name)
    (SELECT kod_tex_pd,kod_grotpr,okpo_grotp,kod_predpr,name,bank,rs,name_grotp,name_plat FROM load_buffer.tex_pd
      WHERE not exists (SELECT id FROM kls_tex_pd where tex_pd.kod_tex_pd=kls_tex_pd.id AND tex_pd.kod_grotpr=kls_tex_pd.grotp_id));

  COMMIT;

END RENEW_KLS_TEX_PD;

/

