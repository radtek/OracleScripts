--
-- V_GOSPROG6  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GOSPROG6
(KOD_OPER, NAME_OPER, KOD_VLAD, NAME_VLAD, KOD_POLU, 
 NAME_POLU, ZAYAV, MON, YEAR)
AS 
SELECT /*+ RULE*/
   plat.INN as kod_oper,
   SUBSTR(plat.predpr_name,1,30) as name_oper,
   sobst.INN as kod_vlad,
   SUBSTR(sobst.predpr_name,1,30) as name_vlad,
   SUBSTR(y.poluch,1,10) as kod_polu,
   SUBSTR(poluch.name,1,30) as name_polu,
   NVL(raz.tonn,0) as zayav,
   NVL(mon.bz_ves,0) as mon,
   NVL(y.kvit_ves,0) as year
FROM
(SELECT
    kls_dog.PREDPR_ID as plat,
    month.GP_NAPR_ID as poluch,
    month.NPR_SOBSTV_ID as sobst,
    SUM(ROUND(month.TONN_R*1000,0)) AS tonn
   FROM month,kls_dog,v_master_reports r 
   WHERE month.DOG_ID=kls_dog.ID
    AND month.GOSPROG_ID+0=6
 AND TRIM(NLS_UPPER(r.REPORT_FILE))='PA30.XLS'
 AND month.DATE_PLAN=TRUNC(r.END_DATE,'MONTH')
    AND SUBSTR(month.PROD_ID_NPR,1,3)='115'
    AND month.NAZN_OTG_ID<>10
 GROUP BY kls_dog.PREDPR_ID,month.GP_NAPR_ID,month.NPR_SOBSTV_ID) raz,
(SELECT
    kls_dog.PREDPR_ID as plat,
    month.GP_NAPR_ID as poluch,
    month.NPR_SOBSTV_ID as sobst,
    SUM(ROUND(kvit.VES*1000,0)) as bz_ves
   FROM month,kvit,kls_dog,v_master_reports r 
   WHERE month.NOM_ZD=kvit.NOM_ZD
       AND month.DOG_ID=kls_dog.ID
       AND month.GOSPROG_ID+0=6
 AND TRIM(NLS_UPPER(r.REPORT_FILE))='PA30.XLS'
 AND kvit.date_kvit BETWEEN TRUNC(r.END_DATE,'MONTH') AND r.END_DATE
    AND SUBSTR(month.PROD_ID_NPR,1,3)='115'
    AND month.NAZN_OTG_ID<>10
 GROUP BY kls_dog.PREDPR_ID,month.GP_NAPR_ID,month.NPR_SOBSTV_ID) mon,
(SELECT
    kls_dog.PREDPR_ID as plat,
    month.GP_NAPR_ID as poluch,
    month.NPR_SOBSTV_ID as sobst,
    SUM(ROUND(kvit.VES*1000,0)) as kvit_ves
   FROM month,kvit,kls_dog,v_master_reports r 
   WHERE month.NOM_ZD=kvit.NOM_ZD
       AND month.DOG_ID=kls_dog.ID
       AND month.GOSPROG_ID+0=6
 AND TRIM(NLS_UPPER(r.REPORT_FILE))='PA30.XLS'
 AND kvit.date_kvit between TRUNC(r.END_DATE,'YEAR') AND TRUNC(r.END_DATE,'MONTH')-1
    AND SUBSTR(month.PROD_ID_NPR,1,3)='115'
    AND month.NAZN_OTG_ID<>10
 GROUP BY kls_dog.PREDPR_ID,month.GP_NAPR_ID,month.NPR_SOBSTV_ID) y,
 kls_predpr plat,kls_gp_napr poluch,kls_predpr sobst
WHERE y.plat=mon.plat(+)
   AND y.poluch=mon.poluch(+)
   AND y.sobst=mon.sobst(+)
   AND y.plat=raz.plat(+)
   AND y.poluch=raz.poluch(+)
   AND y.sobst=raz.sobst(+)
   AND y.plat=plat.id(+)
   AND y.poluch=poluch.id(+)
   AND y.sobst=sobst.id(+);


