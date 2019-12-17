--
-- RENEW_MONTH  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Month (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  v_dat DATE;
BEGIN

  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='MONTH';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

  UPDATE MASTER.MONTH M_M
    SET (prod_id_npr,tex_pd_id,poluch_id,vetka_id,gosprog_id,nazn_otg_id,tonn_declared,tonn_loaded,
		 cist_declared,cist_loaded,FLG_ALLOW_8_AXES,flg_upper_sliv,flg_dop_cist,flg_forma_2,flg_obogr,
		 load_abbr,date_plan,prim,cena,cena_otp,sum_zd,gr4,k_tar,
		 dog_id,usl_number,stan_id,stanotp_id,npr_sobstv_id,input_date,update_date,tarif1tonn,potreb_id,
		 npodog_id,grotp_id,date_cen,GP_NAPR_ID, TONN_R, CIST_R, TRANSPORT, IS_EXP, SUPPLIER_ID, CENA_OTP_NPO,kol_dn_npo,
		 TONN_RAZNAR,CIST_RAZNAR,ZAKAZ_ID,ZAKAZ_HIST_ID,EXPED_ID,GU12_A_ID,POKUP_DOG_ID,POKUP_USL_NUMBER,
		 STAN_PER_ID,INCOTERM_ID,VZISK_ID/*,ZAKAZ_KOD_ISU*/
		 )
	 = (
SELECT L_M.kod_npr,L_M.kod_tex_pd,L_M.kod_poluch,L_M.kvet,L_M.program,
	           L_M.kod_otgr,NVL(L_M.tonn,0),NVL(L_M.otgr,0),
			   ROUND(NVL(L_M.tonn,0)/L_M.NORMOTGR),
			   NVL(L_M.otgr_cist,0),L_M.osn_8,
			   L_M.sliv_v,Iif(L_M.dop_cist,1,0),DECODE(L_M.forma_2,0,DECODE(L_M.vzisk_id,1,3,2,4,0),L_M.forma_2),
			   L_M.obogr,L_M.otgrr,
			   L_M.date_plan,L_M.prim,L_M.cena,L_M.cena_otp,L_M.sum_zd,L_M.gr4,
			   L_M.k_tar,D.ID, L_M.k_usl, L_M.STAN_ID, s_o.ID, S_S.PREDPR_ID, L_M.vvoddat, 
			   L_M.kordat,L_M.tarif1tonn,L_M.kod_potreb, d2.ID, L_M.kod_grotp, L_M.DATE_CEN,
			   L_M.gp_napr, L_M.tonn_r, L_M.k_cistr, L_M.transp, DECODE(L_M.prizn_mps,3,1,0),S_P.PREDPR_ID, L_M.SCENA_OTP, L_M.SKOL_DN,
			   NVL(L_M.TONN_R,0),NVL(L_M.k_cistr,0), ZAKAZ_ID, l_m.ZAKAZ_HIST, L_M.EXPED_ID, NVL(etran.ID,etran_exp.ID),
			   POKUP_DOG.ID,L_M.K_USL_POK,S_P.STAN_ID,i.ID,l_m.VZISK_ID/*,l_m.kod_isu - обновляется из ZAKAZ */
          FROM 
		    (SELECT MONTH.*, P.PROD_GU12_ID, DECODE(NVL(P.NORMOTGR,0),0,55,P.NORMOTGR) as NORMOTGR,KLS_TEX_PD.PLATTARIF_ID,S.ID AS STAN_ID,
			    E.PREDPR_ID as EXPED_ID
			      FROM load_buffer.MONTH,KLS_PROD P,KLS_TEX_PD,KLS_STAN S,
 		          	(SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=3) E
				  WHERE MONTH.kod_npr=P.ID_NPR
		            AND MONTH.KOD_TEX_PD=KLS_TEX_PD.ID(+)
 	                AND MONTH.KOD_GROTPR=KLS_TEX_PD.GROTP_ID(+)
					AND MONTH.KST = S.STAN_KOD  
               	    AND MONTH.exped = E.KOD_MOSCOW(+)
				  ) L_M, 
			(SELECT * FROM STAN_ROLE WHERE KLS_ROLE_ID=2) S_P, KLS_INCOTERM i, 				   	  
		    KLS_DOG D, KLS_DOG D2, KLS_STAN S_O, KLS_DOG POKUP_DOG, 
		    (SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=1) S_S, 
			(SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=1) S_P, 
			(SELECT trim(a.nom_z) as nom_z, TO_CHAR(a.prod_id) as PROD_GU12_ID, 
			     TRUNC(a.from_date,'MONTH') as date_plan, MAX(a.id) as id,
				 b.STAN_ID,a.PLATTAR_ID 
			   FROM gu12_a a, gu12_b b 
			  where a.id=b.id_a AND trim(a.nom_z) is not null AND a.PLATTAR_ID is not null
			  GROUP BY trim(a.nom_z), TO_CHAR(a.prod_id), 
			     TRUNC(a.from_date,'MONTH'),
				 b.STAN_ID,a.PLATTAR_ID) etran,
			(SELECT trim(a.nom_z) as nom_z, TO_CHAR(a.prod_id) as PROD_GU12_ID, 
			     TRUNC(a.from_date,'MONTH') as date_plan, MAX(a.id) as id,
				 b.STAN_ID,DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID) as EXPED_ID 
			   FROM gu12_a a, gu12_b b 
			  where a.id=b.id_a AND trim(a.nom_z) is not null AND a.EXPED_ID is not null
			  GROUP BY trim(a.nom_z), TO_CHAR(a.prod_id), 
			     TRUNC(a.from_date,'MONTH'),
				 b.STAN_ID,DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID)) etran_exp
		 WHERE L_M.nom_zd=M_M.nom_zd 
		   AND L_M.N_DOG2 = D2.SHORT_NUMBER(+) 
		   AND L_M.N_DOG = D.SHORT_NUMBER 
		   AND L_M.N_DOG_POK = POKUP_DOG.SHORT_NUMBER(+) 
		   AND L_M.KST_O = S_O.STAN_KOD
		   AND L_M.KOD_SOBS = S_S.FOX_KOD(+)
		   AND L_M.KOD_POST = S_P.FOX_KOD(+)
		   AND L_M.date_plan=etran.date_plan(+)
		   AND L_M.PROD_GU12_ID=etran.PROD_GU12_ID(+)
		   AND L_M.nom_etran=etran.nom_z(+)
		   AND L_M.STAN_ID=etran.STAN_ID(+)
		   AND L_M.PLATTARIF_ID=etran.PLATTAR_ID(+)
		   AND L_M.date_plan=etran_exp.date_plan(+)
		   AND L_M.PROD_GU12_ID=etran_exp.PROD_GU12_ID(+)
		   AND L_M.nom_etran=etran_exp.nom_z(+)
		   AND L_M.STAN_ID=etran_exp.STAN_ID(+)
		   AND L_M.EXPED_ID=etran_exp.EXPED_ID(+)
		   AND L_M.STAN_PER=S_P.STAN_KOD(+) 
		   AND L_M.INCOTERM=i.TAG(+)				 
		   )
    WHERE EXISTS (SELECT NULL
          FROM load_buffer.MONTH L_M
		 WHERE L_M.nom_zd=M_M.nom_zd)
      AND M_M.update_date BETWEEN date_beg AND date_end
	  AND m_m.DATE_PLAN>v_dat;	 
      --and (m_m.NOM_ZD='1212-36611' or m_M.NOM_ZD='1201-46582');


  INSERT INTO MASTER.MONTH
        (nom_zd,prod_id_npr,tex_pd_id,poluch_id,vetka_id,gosprog_id,nazn_otg_id,tonn_declared,tonn_loaded,
		 cist_declared,cist_loaded,FLG_ALLOW_8_AXES,flg_upper_sliv,flg_dop_cist,flg_forma_2,flg_obogr,
		 load_abbr,date_plan,prim,cena,cena_otp,sum_zd,gr4,k_tar,
		 dog_id,usl_number,stan_id,stanotp_id,npr_sobstv_id,input_date,update_date,tarif1tonn,potreb_id,
		 npodog_id,grotp_id,date_cen,GP_NAPR_ID, TONN_R, CIST_R, TRANSPORT, IS_EXP, SUPPLIER_ID, CENA_OTP_NPO, KOL_DN_NPO,
		 TONN_RAZNAR,CIST_RAZNAR,ZAKAZ_ID,ZAKAZ_HIST_ID,EXPED_ID,GU12_A_ID,POKUP_DOG_ID,POKUP_USL_NUMBER,
		 STAN_PER_ID,INCOTERM_ID,VZISK_ID,ZAKAZ_KOD_ISU)
	 (SELECT L_M.nom_zd, L_M.kod_npr,L_M.kod_tex_pd,L_M.kod_poluch,L_M.kvet,L_M.program,
	           L_M.kod_otgr,NVL(L_M.tonn,0),NVL(L_M.otgr,0),
			   ROUND(NVL(L_M.tonn,0)/L_M.NORMOTGR),
			   NVL(L_M.otgr_cist,0),L_M.osn_8,
			   L_M.sliv_v,Iif(L_M.dop_cist,1,0),DECODE(L_M.forma_2,0,DECODE(L_M.vzisk_id,1,3,2,4,0),L_M.forma_2),L_M.obogr,L_M.otgrr,
			   L_M.date_plan,L_M.prim,L_M.cena,L_M.cena_otp,L_M.sum_zd,L_M.gr4,
			   L_M.k_tar,D.ID, L_M.k_usl, L_M.STAN_ID, s_o.ID, S_S.PREDPR_ID, L_M.vvoddat, 
			   L_M.kordat,L_M.tarif1tonn,L_M.kod_potreb, d2.ID, L_M.kod_grotp, L_M.DATE_CEN,
			   L_M.gp_napr, L_M.tonn_r, L_M.k_cistr, L_M.transp, DECODE(L_M.prizn_mps,3,1,0),S_P.PREDPR_ID,L_M.SCENA_OTP,L_M.SKOL_DN,
			   NVL(L_M.TONN_R,0),NVL(L_M.k_cistr,0), ZAKAZ_ID, l_m.ZAKAZ_HIST, L_M.EXPED_ID, NVL(etran.ID,etran_exp.ID),
			   POKUP_DOG.ID,L_M.K_USL_POK,S_P.STAN_ID,i.ID,l_m.VZISK_ID,l_m.kod_isu
          FROM 
		    (SELECT MONTH.*, P.PROD_GU12_ID, DECODE(NVL(P.NORMOTGR,0),0,55,P.NORMOTGR) as NORMOTGR,KLS_TEX_PD.PLATTARIF_ID,S.ID AS STAN_ID,
			    E.PREDPR_ID as EXPED_ID
			      FROM load_buffer.MONTH,KLS_PROD P,KLS_TEX_PD,KLS_STAN S,
 		          	(SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=3) E				   
				  WHERE MONTH.kod_npr=P.ID_NPR
		            AND MONTH.KOD_TEX_PD=KLS_TEX_PD.ID(+)
 	                AND MONTH.KOD_GROTPR=KLS_TEX_PD.GROTP_ID(+)
					AND MONTH.KST = S.STAN_KOD  
               	    AND MONTH.exped = E.KOD_MOSCOW(+)
				  ) L_M, 
			(SELECT * FROM STAN_ROLE WHERE KLS_ROLE_ID=2) S_P, KLS_INCOTERM i, 				   	  
			KLS_DOG D, KLS_DOG D2, KLS_STAN S_O, KLS_DOG POKUP_DOG, 
		    (SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=1) S_S, 
			(SELECT * FROM PREDPR_ROLE WHERE KLS_ROLE_ID=1) S_P, 
			(SELECT trim(a.nom_z) as nom_z, TO_CHAR(a.prod_id) as PROD_GU12_ID, 
			     TRUNC(a.from_date,'MONTH') as date_plan, MAX(a.id) as id,
				 b.STAN_ID,a.PLATTAR_ID 
			   FROM gu12_a a, gu12_b b 
			  where a.id=b.id_a AND trim(a.nom_z) is not null AND a.PLATTAR_ID is not null
			  GROUP BY trim(a.nom_z), TO_CHAR(a.prod_id), 
			     TRUNC(a.from_date,'MONTH'),
				 b.STAN_ID,a.PLATTAR_ID) etran,
			(SELECT trim(a.nom_z) as nom_z, TO_CHAR(a.prod_id) as PROD_GU12_ID, 
			     TRUNC(a.from_date,'MONTH') as date_plan, MAX(a.id) as id,
				 b.STAN_ID,DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID) as EXPED_ID 
			   FROM gu12_a a, gu12_b b 
			  where a.id=b.id_a AND trim(a.nom_z) is not null AND a.EXPED_ID is not null
			  GROUP BY trim(a.nom_z), TO_CHAR(a.prod_id), 
			     TRUNC(a.from_date,'MONTH'),
				 b.STAN_ID,DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID)) etran_exp
		 WHERE L_M.N_DOG2 = D2.SHORT_NUMBER(+) 
		   AND L_M.N_DOG = D.SHORT_NUMBER 
		   AND L_M.N_DOG_POK = POKUP_DOG.SHORT_NUMBER(+) 
		   AND L_M.KST_O = S_O.STAN_KOD 
		   AND L_M.KOD_SOBS = S_S.FOX_KOD(+)
		   AND L_M.KOD_POST = S_P.FOX_KOD(+)
		   AND L_M.date_plan=etran.date_plan(+)
		   AND L_M.PROD_GU12_ID=etran.PROD_GU12_ID(+)
		   AND L_M.nom_etran=etran.nom_z(+)
		   AND L_M.STAN_ID=etran.STAN_ID(+)
		   AND L_M.PLATTARIF_ID=etran.PLATTAR_ID(+)
		   AND L_M.date_plan=etran_exp.date_plan(+)
		   AND L_M.PROD_GU12_ID=etran_exp.PROD_GU12_ID(+)
		   AND L_M.nom_etran=etran_exp.nom_z(+)
		   AND L_M.STAN_ID=etran_exp.STAN_ID(+)
		   AND L_M.EXPED_ID=etran_exp.EXPED_ID(+)				 
		   AND L_M.STAN_PER=S_P.STAN_KOD(+) 
		   AND L_M.INCOTERM=i.TAG(+)				 
		   AND NOT EXISTS (SELECT M_M.nom_zd FROM MASTER.MONTH M_M WHERE M_M.nom_zd=L_M.nom_zd));

  UPDATE MASTER.MONTH
    SET PLANSTRU_ID
	 = (SELECT DISTINCT g_r.ID
          FROM load_buffer.MONTH_FOR_RENEW M, LOAD_BUFFER.GR_REAL G_R
		 WHERE MASTER.MONTH.nom_zd=m.nom_zd AND
			   M.KOD_POS=G_R.KOD_POS AND
			   M.KOD_SGR=G_R.KOD_SGR AND
			   M.KOD_SPG=G_R.KOD_SPG AND
			   M.KOD_RZD=G_R.KOD_RZD AND
               M.KOD_PRZ=G_R.KOD_PRZ AND
			   M.KOD_GRP=G_R.KOD_GRP AND
			   M.KOD_PGR=G_R.KOD_PGR)
    WHERE EXISTS (SELECT M.nom_zd
	                FROM load_buffer.MONTH_FOR_RENEW M, LOAD_BUFFER.GR_REAL G_R
              	   WHERE MASTER.MONTH.nom_zd=M.nom_zd AND
		   			   M.KOD_POS=G_R.KOD_POS AND
  					   M.KOD_SGR=G_R.KOD_SGR AND
			   		   M.KOD_SPG=G_R.KOD_SPG AND
			   		   M.KOD_RZD=G_R.KOD_RZD AND
               		   M.KOD_PRZ=G_R.KOD_PRZ AND
			   		   M.KOD_GRP=G_R.KOD_GRP AND
			   		   M.KOD_PGR=G_R.KOD_PGR)
      AND update_date BETWEEN date_beg AND date_end
	  AND DATE_PLAN>v_dat;
      --and (NOM_ZD='1212-36611' or NOM_ZD='1201-46582');

  DELETE FROM MASTER.MONTH M_M WHERE NOT EXISTS (SELECT L_M.NOM_ZD FROM load_buffer.month_FOR_RENEW L_M WHERE L_M.NOM_ZD = M_M.NOM_ZD) 
    AND M_M.update_date BETWEEN date_beg AND date_end
	  AND m_m.DATE_PLAN>v_dat	 ;

  FOR_ZAKAZ.FillFact(0,date_beg,date_end);
  	
  COMMIT;

END Renew_Month; 
/

