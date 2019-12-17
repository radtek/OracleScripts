--
-- V_GOSPROG1  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GOSPROG1
(N_DOG, PROGRAM, KOD_10, PLAN_DOG, SPLAN_DOG, 
 PLAN_MON, SPLAN_MON, KOD_MOSK, VES_MON, SUM_MON, 
 VES_YEAR, SVES_YEAR, OPL, DOLG, PROS, 
 PREV, KOD_NPR)
AS 
SELECT /*+ RULE*/
  uni_all.n_dog,
  uni_all.prg,
  uni_all.kod_10,   
  sum(nvl(uni_all.PLAN_DOG,0)) as plan_dog,
  ROUND(sum(nvl(uni_all.SPLAN_DOG,0)),2) as splan_dog,
  sum(nvl(uni_all.plan_mon,0)) as plan_mon,
  ROUND(sum(nvl(uni_all.splan_mon,0)),2) as splan_mon,
  uni_all.kod_mosk,
  sum(nvl(uni_all.ves_month,0)) as ves_mon,
  ROUND(sum(nvl(uni_all.sum_month,0)),2) as sum_mon,
  sum(nvl(uni_all.ves_year,0)) as ves_year,
  ROUND(sum(nvl(uni_all.sves_year,0)),2) as sves_year,
  sum(0) AS opl,
  sum(0) AS dolg,
  sum(0) AS pros,
  sum(0) AS prev,
  uni_all.npr as kod_npr
FROM
(SELECT 
  out_pl.n_dog,
  out_pl.prg,
  out_pl.kod_10,
  dg.vsego as PLAN_DOG,
  (dg.vsego/1000*prices.cena_otp) as SPLAN_DOG,
  mn.plan_mon,
  mn.splan_mon,
  out_pl.kod_mosk,
  kv.ves_month,
  kv.sum_month,
  out_pl.ves_year,
  out_pl.sves_year,
  out_pl.npr
FROM
  /*выбираем отгрузки за текущий месяц*/
  (SELECT kls_dog.SHORT_NUMBER as n_dog,
      month.GOSPROG_ID as prg,
    month.PROD_ID_NPR as npr,
    kls_region.KOD_MOSCOW as kod_mosk,
      Sum(kvit.VES*1000) as ves_month,
      Sum(kvit.VES*kvit.CENA_OTP) as Sum_month
  FROM   kvit,month,kls_dog,kls_predpr poluch,kls_region,v_master_reports r
  WHERE kvit.NOM_ZD=month.NOM_ZD
     AND month.DOG_ID=kls_dog.ID(+) 
     AND month.POLUCH_ID=poluch.ID(+)
     AND poluch.REGION_ID=kls_region.ID(+) 
     AND month.gosprog_id in (1,2,3,4,5) 
  AND TRIM(NLS_UPPER(r.REPORT_FILE))='PB30.XLS'
  AND month.DATE_PLAN=TRUNC(r.END_DATE,'MONTH')
     AND kvit.date_kvit<=r.END_DATE
     AND month.NAZN_OTG_ID<>10
   GROUP BY kls_dog.SHORT_NUMBER,month.PROD_ID_NPR,kls_region.KOD_MOSCOW,month.GOSPROG_ID) KV,
  /*выбираем заявки на текущий месяц */
  (SELECT kls_dog.SHORT_NUMBER as n_dog,
      month.GOSPROG_ID as prg,
      month.PROD_ID_NPR as npr,
      kls_region.KOD_MOSCOW as kod_mosk,
      Sum(month.TONN_DECLARED*1000) as plan_mon,
      Sum(month.TONN_DECLARED*month.CENA_OTP) as splan_mon
  FROM month,kls_dog,kls_predpr poluch,kls_region,v_master_reports r
  WHERE month.DOG_ID=kls_dog.ID(+) 
     AND month.POLUCH_ID=poluch.ID(+)
     AND poluch.REGION_ID=kls_region.ID(+)
     AND month.gosprog_id in (1,2,3,4,5) 
  AND TRIM(NLS_UPPER(r.REPORT_FILE))='PB30.XLS'
  AND month.DATE_PLAN=TRUNC(r.END_DATE,'MONTH')
     AND month.NAZN_OTG_ID<>10 
   GROUP BY kls_dog.SHORT_NUMBER,month.PROD_ID_NPR,kls_region.KOD_MOSCOW,month.GOSPROG_ID) MN,
   /* Отгрузки с начала года по 1 число отчетного м-ца кроме отгрузок на ответхранение. Они добавяться потом.*/
  (SELECT kls_dog.SHORT_NUMBER as n_dog,
      month.GOSPROG_ID as prg,
      v_out_plat_dbf.kod_nfp as npr,
      kls_prod.kod_10,
    v_out_plat_dbf.KATEG_PR,
      kls_region.KOD_MOSCOW as kod_mosk,
      Sum(case 
	  	   when to_char(v_out_plat_dbf.data_kvit,'mm')=to_char(r.END_DATE,'mm') then 0 
		   else v_out_plat_dbf.VES*1000 
	  end) as ves_year,
	  Sum(case 
	  	   when to_char(v_out_plat_dbf.data_kvit,'mm')=to_char(r.END_DATE,'mm') then 0 
		   else v_out_plat_dbf.summa_dok 
	  end) as sves_year
  FROM v_out_plat_dbf,month,kls_dog,kls_predpr poluch,kls_region,kls_prod,v_master_reports r
  WHERE v_out_plat_dbf.NOM_ZD=month.NOM_ZD(+)
     AND month.DOG_ID=kls_dog.ID(+) 
     AND month.POLUCH_ID=poluch.ID(+)
     AND poluch.REGION_ID=kls_region.ID(+)
     AND month.prod_id_npr=kls_prod.id_npr 
     AND month.gosprog_id in (1,2,3,4,5) 
  AND TRIM(NLS_UPPER(r.REPORT_FILE))='PB30.XLS'
     AND v_out_plat_dbf.data_kvit between TRUNC(r.END_DATE,'YEAR') AND r.END_DATE
     AND month.NAZN_OTG_ID<>10
  AND month.NAZN_OTG_ID<>8
   GROUP BY kls_dog.SHORT_NUMBER,kls_prod.kod_10,v_out_plat_dbf.KATEG_PR,v_out_plat_dbf.kod_nfp,kls_region.KOD_MOSCOW,month.GOSPROG_ID
   ) out_pl,
   /*Выбираем данные по заказам*/
   (SELECT kls_dog.SHORT_NUMBER as n_dog,
    zakaz.PROD_ID_NPR as npr,
    SUM(NVL(zakaz.VES,0)*1000) as vsego
 FROM kls_dog,zakaz,v_master_reports r
 WHERE zakaz.DOG_ID=kls_dog.ID
   AND zakaz.IS_AGENT=1
   AND zakaz.PERIOD_ID=1
   AND TRIM(NLS_UPPER(r.REPORT_FILE))='PB30.XLS'
      AND zakaz.DATE_PLAN between TRUNC(r.END_DATE,'YEAR') AND r.END_DATE
 GROUP BY KLS_DOG.SHORT_NUMBER,zakaz.PROD_ID_NPR) dg,
 npr_prices prices
 /*Объединяем таблицы в сводную */
WHERE out_pl.n_dog=mn.n_dog(+)
      AND out_pl.prg=mn.prg(+)
      AND out_pl.npr=mn.npr(+)
      AND out_pl.kod_mosk=mn.kod_mosk(+)
      AND out_pl.n_dog=kv.n_dog(+)
      AND out_pl.prg=kv.prg(+)
      AND out_pl.npr=kv.npr(+)
      AND out_pl.kod_mosk=kv.kod_mosk(+)
      AND out_pl.n_dog=dg.n_dog(+)
      AND out_pl.npr=dg.npr(+)
      AND out_pl.npr=prices.PROD_ID_NPR(+)
      AND prices.BEGIN_DATE=(select max(begin_date) from npr_prices where prod_id_npr=prices.prod_id_npr and cat_cen_id=out_pl.kateg_pr)
   AND prices.cat_cen_id=out_pl.kateg_pr
UNION ALL
/* присоединим данные по отгрузке за год на ответхранение по госпрограммам(month.NAZN_OTG_ID=8)*/
SELECT kls_dog.SHORT_NUMBER as n_dog,
    month.GOSPROG_ID as prg,
    kls_prod.KOD_10,
    0 as PLAN_DOG,
    0 as SPLAN_DOG,
    0 as plan_mon,
    0 as splan_mon,    
    kls_region.KOD_MOSCOW as kod_mosk,
    0 as ves_month,
      0 as sum_month,
    kvit.VES*1000 as ves_year,
    kvit.VES*kvit.CENA_OTP as sves_year,
    kls_prod.ID_NPR as npr
FROM   kvit,month,kls_dog,kls_predpr poluch,kls_region,kls_prod,v_master_reports r
WHERE kvit.NOM_ZD=month.NOM_ZD(+)
   AND month.DOG_ID=kls_dog.ID(+) 
   AND month.POLUCH_ID=poluch.ID(+)
   AND poluch.REGION_ID=kls_region.ID(+)
   AND month.PROD_ID_NPR=kls_prod.ID_NPR(+) 
   AND month.gosprog_id in (1,2,3,4,5) 
   AND TRIM(NLS_UPPER(r.REPORT_FILE))='PB30.XLS'
      AND kvit.date_kvit between TRUNC(r.END_DATE,'YEAR') AND TRUNC(r.END_DATE,'MONTH')-1
   AND month.NAZN_OTG_ID=8
) uni_all   
GROUP BY uni_all.n_dog,uni_all.kod_10,uni_all.npr,uni_all.kod_mosk,uni_all.prg;


