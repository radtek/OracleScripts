--
-- RENEW_KLS_PROD  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Prod (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  --- Справчоник нефтепродуктов для нарядов
  UPDATE KLS_PROD_NAR
    SET (order_npr,abbr_npr,name_npr)
	  = (SELECT NVL(nar_order,0), nar_short, NVL(nar_group,'НЕ ИСПОЛЬЗУЕТСЯ В НАРЯДАХ')
  	     FROM load_buffer.kindprod WHERE nar_order=KLS_PROD_NAR.ID
         GROUP BY nar_order, nar_order, nar_short, nar_group)
     WHERE EXISTS (SELECT nar_order FROM load_buffer.kindprod WHERE nar_order=KLS_PROD_NAR.ID
                   GROUP BY nar_order, nar_order, nar_short, nar_group);

  INSERT INTO KLS_PROD_NAR (ID,order_npr,abbr_npr,name_npr)
	(SELECT  NVL(nar_order,0), NVL(nar_order,0), nar_short, NVL(nar_group,'НЕ ИСПОЛЬЗУЕТСЯ В НАРЯДАХ') FROM load_buffer.kindprod A
      WHERE NOT EXISTS (SELECT C.ID FROM KLS_PROD_NAR C WHERE C.ID=A.nar_order)
	  GROUP BY nar_order, nar_order, nar_short, nar_group);

  UPDATE KLS_PROD_NAR
    SET (order_npr,abbr_npr,name_npr)
	  = (SELECT DISTINCT 0,'','НЕ ИСПОЛЬЗУЕТСЯ В НАРЯДАХ' FROM load_buffer.kindprod)
  WHERE ID=0;

  INSERT INTO KLS_PROD_NAR (ID,order_npr,abbr_npr,name_npr)
	(SELECT DISTINCT 0,0,'','НЕ ИСПОЛЬЗУЕТСЯ В НАРЯДАХ' FROM load_buffer.kindprod
      WHERE NOT EXISTS (SELECT * FROM KLS_PROD_NAR E WHERE E.ID=0));


  COMMIT;

  --- Справчоник плановых нефтепродуктов
  UPDATE KLS_PROD_PLAN
    SET (name_npr,abbr_npr,order_npr,flg_allowed)
	  = (SELECT MAX(pf_group), '', MAX(pg_gr_ordn), 1
  	     FROM load_buffer.kindprod WHERE pf_kod_gr IS NOT NULL AND TO_NUMBER(pf_kod_gr)+100000=KLS_PROD_PLAN.ID)
   WHERE EXISTS (SELECT kind_npr FROM load_buffer.kindprod WHERE pf_kod_gr IS NOT NULL AND TO_NUMBER(pf_kod_gr)+100000=KLS_PROD_PLAN.ID);

  INSERT INTO KLS_PROD_PLAN (ID,name_npr,abbr_npr,order_npr,flg_allowed)
	(SELECT DISTINCT TO_NUMBER(pf_kod_gr)+100000,pf_group, '', pg_gr_ordn,1 FROM load_buffer.kindprod A
      WHERE pf_kod_gr IS NOT NULL AND NOT EXISTS (SELECT C.ID FROM KLS_PROD_PLAN C WHERE C.ID=TO_NUMBER(A.pf_kod_gr)+100000));
  COMMIT;

  UPDATE KLS_PROD_PLAN
    SET (name_npr,abbr_npr,order_npr,parent_id,flg_allowed)
	  = (SELECT B.naim_pr, B.abbr, B.pf_ordnung,DECODE(B.pf_kod_gr,NULL,NULL,TO_NUMBER(B.pf_kod_gr)+100000),1
  	     FROM load_buffer.kindprod B WHERE TO_NUMBER(B.kind_npr)=KLS_PROD_PLAN.ID)
   WHERE EXISTS (SELECT kind_npr FROM load_buffer.kindprod WHERE TO_NUMBER(kind_npr)=KLS_PROD_PLAN.ID);

  INSERT INTO KLS_PROD_PLAN (ID,name_npr,abbr_npr,order_npr,parent_id,flg_allowed)
	(SELECT TO_NUMBER(B.kind_npr),B.naim_pr, B.abbr, B.pf_ordnung, DECODE(B.pf_kod_gr,NULL,NULL,TO_NUMBER(B.pf_kod_gr)+100000),1
	   FROM load_buffer.kindprod B WHERE NOT EXISTS (SELECT C.ID FROM KLS_PROD_PLAN C WHERE C.ID=TO_NUMBER(B.kind_npr)));

  COMMIT;

  --- Базовый справочник нефтепродуктов
  UPDATE KLS_PROD
    SET (id_kind_npr,id_group_npr,id_group_npr_gd,name_npr,abbr_npr,long_name_npr,gost_npr,gd_name_npr,
	  gd_kod_npr,kod_10,kod_okdp,normotgr,ed_iz,flg_allowed,dor_nalog,akciz,fasovka,
	  vol_fas,kod_fas_msk,ID,prod_nar_id,prod_plan_id,PROD_GU12_ID, MOS_GRP_ID,SF_NAME, NAME_GOST,ksss_prod_id)
	  = (SELECT A.kind_npr,A.kod_gr,A.GD_KODGR,A.naim_pr,A.abbr,A.NAME ||A.name1,A.gost,A.name_gd || A.name_gd1 || A.name_gd2 || A.name_gd3,
	       A.kod_gd,A.kod_10,A.k_okdp,A.normotgr,A.ed_iz,IIF(a.dostup,1,0),A.dor_nalog,Iif(A.akciz,1,0),Iif(A.fasovka,1,0),
           A.vol_fas,A.kod_fas,A.ID,NVL(B.nar_order,0),TO_NUMBER(A.KIND_NPR),A.KOD_GU12,A.KOD_10_GRP,A.SF_NAME,A.NAME_GOST,a.kod_ksss
  	     FROM load_buffer.prod A,load_buffer.kindprod B WHERE A.kod=KLS_PROD.id_npr AND A.kind_npr=B.kind_npr(+))
    WHERE EXISTS (SELECT A.kod FROM load_buffer.prod A WHERE A.kod=KLS_PROD.id_npr);

  INSERT INTO KLS_PROD (id_npr,id_kind_npr,id_group_npr,id_group_npr_gd,name_npr,abbr_npr,long_name_npr,gost_npr,gd_name_npr,
                        gd_kod_npr,kod_10,kod_okdp,normotgr,ed_iz,flg_allowed,dor_nalog,akciz,fasovka,
                        vol_fas,kod_fas_msk,ID,prod_nar_id,prod_plan_id,PROD_GU12_ID, MOS_GRP_ID,SF_NAME,NAME_GOST,ksss_prod_id)
	(SELECT  A.kod,A.kind_npr,A.kod_gr,A.GD_KODGR,A.naim_pr,A.abbr,A.NAME || A.name1,A.gost,A.name_gd || A.name_gd1 || A.name_gd2 || A.name_gd3,A.kod_gd,
	         A.kod_10,A.k_okdp,A.normotgr,A.ed_iz,IIF(a.dostup,1,0),A.dor_nalog,Iif(A.akciz,1,0),Iif(A.fasovka,1,0),
			 A.vol_fas,A.kod_fas,A.ID,NVL(B.nar_order,0),TO_NUMBER(A.KIND_NPR),A.KOD_GU12,A.KOD_10_GRP,A.SF_NAME,A.NAME_GOST ,a.kod_ksss
  	   FROM load_buffer.prod A,load_buffer.kindprod B
      WHERE A.kind_npr=B.kind_npr(+) AND NOT EXISTS (SELECT C.id_npr FROM KLS_PROD C WHERE C.id_npr=A.kod));

  INSERT INTO KLS_PROD (id_npr,id_group_npr,id_group_npr_gd,name_npr,abbr_npr,long_name_npr,flg_allowed,ID,prod_nar_id)
	(SELECT DISTINCT '00000','     ','     ','ВСЕ ПРОДУКТЫ','ВСЕ','ВСЕ ПРОДУКТЫ',1,0,0 FROM load_buffer.prod
      WHERE NOT EXISTS (SELECT * FROM KLS_PROD E WHERE E.id_npr='00000'));

/*  UPDATE KLS_PROD SET id_group_npr='10101' WHERE id_npr='10300';
  UPDATE KLS_PROD SET id_group_npr='10101' WHERE id_npr='10400';
  UPDATE KLS_PROD SET id_group_npr='10101' WHERE id_npr='10500';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='11500';
  UPDATE KLS_PROD SET id_group_npr='10101' WHERE id_npr='11900';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='13000';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='21000';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='21100';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='21200';
  UPDATE KLS_PROD SET id_group_npr='10102' WHERE id_npr='23000';*/

  UPDATE KLS_PROD SET id_group_npr='00000' WHERE id_group_npr=id_npr;

  UPDATE KLS_PROD SET id_group_npr_gd='00000' WHERE id_group_npr_gd=id_npr;

  UPDATE KLS_PROD SET ID_KIND_NPR='90099',ID_GROUP_NPR='90099',PROD_PLAN_ID='90099' WHERE ID_NPR='90000';
  COMMIT; 
END Renew_Kls_Prod;
/

