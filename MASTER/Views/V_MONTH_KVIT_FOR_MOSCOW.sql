--
-- V_MONTH_KVIT_FOR_MOSCOW  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MONTH_KVIT_FOR_MOSCOW
(IS_EXP, DATE_KVIT, LONG_NAME_NPR, PROD_ID_NPR, KOD_10, 
 MATNR, REGION_NAME, TYPE_OTGR_NAME, STAN_KOD, STAN_NAME, 
 DOG_NUMBER, DOG_NUMBER2, STAN_PER, PLAT_NAME, POLU_NAME, 
 EXPED_ID, EXPED_NAME, VAGOWNER_NAME, TONN_DECLARED, VES, 
 NUM_CIST, NUM_KVIT, CENA_OTP, DOG_DATE, KVIT_ID, 
 NOM_ZD, DATE_PLAN, DATE_OTGR, PLANSTRU_ID, STAN_ID, 
 LOAD_TYPE_ID, DOG_ID, PRIM)
AS 
SELECT /*+ RULE */
  mon_kv.IS_EXP,
  mon_kv.DATE_KVIT,
  kls_prod.LONG_NAME_NPR,
  kls_prod.ID_NPR as PROD_ID_NPR,
  kls_prod.KOD_10,
  ksss_prod.MATNR,
  kls_region.REGION_NAME,
  kls_load_type.TYPE_OTGR_NAME,
  kls_stan.STAN_KOD,
  kls_stan.STAN_NAME,
  kls_dog.DOG_NUMBER,
  kls_dog2.DOG_NUMBER as DOG_NUMBER2,
  Trim(Trim(kls_shabexp.STAN1)||' '||Trim(kls_shabexp.STAN2)||' '||Trim(kls_shabexp.STAN3)||' '||Trim(kls_shabexp.STAN4)) as STAN_PER,
  plat.PREDPR_NAME as PLAT_NAME,
  polu.PREDPR_NAME as POLU_NAME,
  mon_kv.EXPED_ID,
  exped.PREDPR_NAME as EXPED_NAME,
  kls_vagowner.VAGOWNER_NAME,
  NVL(mon_kv.TONN_DECLARED,0) as TONN_DECLARED,
  NVL(mon_kv.ves,0) as VES,
  mon_kv.NUM_CIST,
  mon_kv.NUM_KVIT,
  NVL(mon_kv.CENA_OTP,0) as CENA_OTP,
  kls_dog.DOG_DATE,
  mon_kv.KVIT_ID,
  mon_kv.NOM_ZD,
  mon_kv.DATE_PLAN,
  mon_kv.DATE_OTGR,
  mon_kv.PLANSTRU_ID,
  mon_kv.STAN_ID,
  mon_kv.LOAD_TYPE_ID,
  mon_kv.DOG_ID,
  mon_kv.PRIM
FROM
(
SELECT /*+ RULE */
  M.NOM_ZD,
  M.IS_EXP,
  M.DOG_ID,
  M.NPODOG_ID,
  DECODE(KLS_PLANSTRU.NAME,PARENT_STRU.NAME,KLS_PLANSTRU.PARENT_ID,M.PLANSTRU_ID) as PLANSTRU_ID, /* Для корректной привязки к причинам */
  M.DATE_PLAN,
  M.LOAD_ABBR,
  M.LOAD_TYPE_ID,
  M.STAN_ID,
  M.POLUCH_ID,
  M.PRIM,
  M.TONN_DECLARED,
  DECODE(K.ID,NULL,M.DATE_PLAN,DECODE(K.FLG_OPERDATA,1,K.DATE_OTGR,K.DATE_KVIT)) as DATE_KVIT,
  DECODE(K.ID,NULL,M.PROD_ID_NPR,K.PROD_ID_NPR) as PROD_ID_NPR,
  DECODE(M.is_exp,1,
    DECODE(K.ID,NULL,M.SHABEXP_ID,K.SHABEXP_ID),
	NULL) as SHABEXP_ID,
  DECODE(K.ID,NULL,M.EXPED_ID,K.EXPED_ID) as EXPED_ID,
  DECODE(K.ID,NULL,M.CENA_OTP,K.CENA_OTP) as CENA_OTP,
  k.ID as KVIT_ID,
  DECODE(K.ID,NULL,M.DATE_PLAN,k.DATE_OTGR) as DATE_OTGR,
  K.VAGOWNER_ID,
  k.VES,
  k.NUM_CIST,
  k.NUM_KVIT
FROM
  (
  /* Заявки */
    select /*+ RULE */
	    month.nom_zd,
        month.IS_EXP,
        month.DATE_PLAN,
        month.PROD_ID_NPR,
        month.STAN_ID,
        month.LOAD_ABBR,
        kls_vid_otgr.LOAD_TYPE_ID,
        month.DOG_ID,
        month.NPODOG_ID,
		month.POLUCH_ID,
        shabexp.id as SHABEXP_ID,
        DECODE(mon_exped.EXPED_ID,NULL,month.EXPED_ID,mon_exped.EXPED_ID) as EXPED_ID,
        month.TONN_DECLARED,
        month.CENA_OTP,
        DECODE(month.PRIM,NULL,month.gr4,'',month.gr4,month.PRIM) as prim,
		month.PLANSTRU_ID
      from
        month, KLS_VID_OTGR,
	    (select DOG_ID,PROD_ID_NPR,STAN_ID,MAX(ID) as ID FROM kls_shabexp GROUP BY DOG_ID,PROD_ID_NPR,STAN_ID) shabexp,
   	    (SELECT nom_zd,MAX(exped_id) as exped_id FROM kvit GROUP BY nom_zd) mon_exped
      where month.date_plan>=to_date('01.06.2004','dd.mm.yyyy') and
	    month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR and
        month.DOG_ID=shabexp.DOG_ID(+) and
        month.PROD_ID_NPR=shabexp.PROD_ID_NPR(+) and
        month.STAN_ID=shabexp.STAN_ID(+) and
 	    month.NOM_ZD=mon_exped.nom_zd(+)
  ) M,
  (
  /* Отгрузка */
    select /*+ RULE */
      kvit.ID,
	  kvit.FLG_OPERDATA,
	  kvit.nom_zd,
	  kvit.DATE_KVIT,
	  kvit.DATE_OTGR,
	  kvit.PROD_ID_NPR,
	  kvit.SHABEXP_ID,
	  kvit.EXPED_ID,
	  DECODE(kvit.VAGOWNER_ID,0,NULL,kvit.VAGOWNER_ID) as VAGOWNER_ID,
      kvit.ves,
      kvit.NUM_CIST,
      DECODE(kvit.NUM_KVIT,99999,NULL,0,NULL,kvit.NUM_KVIT) as NUM_KVIT,
      kvit.CENA_OTP,
	  kls_vid_otgr.LOAD_TYPE_ID,
	  month.date_plan,
	  month.PLANSTRU_ID,
	  month.DOG_ID,
	  month.STAN_ID
    from
 	  kvit,month,KLS_VID_OTGR
	where
	  kvit.nom_zd=month.nom_zd and
      month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR
  	  and month.date_plan>=to_date('01.06.2004','dd.mm.yyyy')
  ) K,
  KLS_PLANSTRU, KLS_PLANSTRU PARENT_STRU
WHERE
  M.nom_zd=K.NOM_ZD(+) and
  M.PLANSTRU_ID=KLS_PLANSTRU.ID and
  KLS_PLANSTRU.PARENT_ID=PARENT_STRU.ID(+)
) mon_kv,
    kls_prod,
	ksss_prod,kls_stan,
	kls_region,
	kls_load_type,kls_dog,kls_dog kls_dog2,
	kls_predpr plat,kls_predpr polu,kls_predpr exped,
	kls_vagowner,kls_shabexp
WHERE
  mon_kv.PROD_ID_NPR=kls_prod.ID_NPR (+) and
  kls_prod.ID_NPR=ksss_prod.FOX_ID(+) and
  mon_kv.STAN_ID=kls_stan.ID and
  kls_stan.REGION_ID=kls_region.ID and
  mon_kv.LOAD_TYPE_ID=kls_load_type.ID and
  mon_kv.DOG_ID=kls_dog.ID and
  mon_kv.NPODOG_ID=kls_dog2.ID(+) and
  kls_dog.PREDPR_ID=plat.id and
  mon_kv.POLUCH_ID=polu.id and
  mon_kv.EXPED_ID=exped.id(+) and
  mon_kv.VAGOWNER_ID=kls_vagowner.ID(+) and
  mon_kv.shabexp_id=kls_shabexp.ID(+);


