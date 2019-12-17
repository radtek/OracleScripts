--
-- XX101_ZVZAV_TO_MONTH  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.XX101_ZVZAV_TO_MONTH
(FILENAME, PARSEDATETIME, PROPAGATESTATUS, FILEROWNUM, ACTIONCODE, 
 PLAT_ID, POLUCH_ID, POTREB_ID, PROD_ID_NPR, PROD_GU12_ID, 
 DOG_ID, USL_NUMBER, USL_OPL_ID, VES, KOL, 
 DATE_PLAN, IS_EXP, TRANSPORT, PRIM, LOAD_ABBR, 
 STAN_ID, VETKA_NAME, CAT_CEN_ID, DATE_CENA, CENA, 
 CENA_OTP, NAZN_OTG_ID, SUM_ZD, DOC302_ID, BEGIN_DATE, 
 UPDATE_DATE, UPDATE_TIME, GR4, TEX_PD_ID, PLATTARIF_ID, 
 PLANSTRU_ID, STANOTP_ID, NOM_ETRAN, EXPED_ID, LINK_ID, 
 LINK_HIST_ID, INPUT_NUM, INPUT_DATE, DOC301_ID, RODVAG_ID, 
 GR_GRUZ_ID, MEASUREUNIT)
AS 
SELECT
  filename,PARSEDATETIME,PROPAGATESTATUS,filerownum,z.ACTIONCODE,
  plat.ID AS plat_id,
  poluch.ID AS poluch_id,
  NVL(potreb.ID,poluch.ID) AS potreb_id,
  prod.ID_NPR AS prod_id_npr,
  prod.PROD_GU12_ID,
  d.id AS dog_id,
  u_d.USL_NUMBER,
  d.USL_OPL_ID,
  z.ORDERWEIGHT AS ves,
  FLOOR(z.ORDERWEIGHT/DECODE(NVL(prod.NORMOTGR,0),0,55,prod.NORMOTGR)) AS kol,
  TRUNC(ADD_MONTHS(z.begindate,0),'month') AS date_plan,
  DECODE(z.DELIVERYDIRECTION,1,1,0) AS is_exp,
  '' AS transport,
  z.REMARKTEXT AS prim,
  (CASE
     WHEN z.shipmentkindcode='01' THEN '—¿Ã'
     WHEN z.shipmentkindcode='03' AND z.VAGONSOWNERSHIPCODE='0001' THEN 'Ãœ—'
     WHEN z.shipmentkindcode='03' AND z.VAGONSOWNERSHIPCODE='0003' THEN ' À»'
     WHEN z.shipmentkindcode='03' AND z.VAGONSOWNERSHIPCODE='0004' THEN 'À“–'
     ELSE 'œŒ—'
   END) AS load_abbr,
  (CASE
     WHEN z.shipmentkindcode='01' THEN 2595
     ELSE s.ID
   END) AS stan_id,
  SUBSTR(NLS_UPPER(z.UNLOADINGSTATIONNAME),1,50) AS vetka_name,
  u_d.cat_cen_id ,
  ADD_MONTHS(z.begindate,0) AS date_cena,
  Ora_Val(z.price) AS cena,
  ora_val(z.price)*1.18 AS cena_otp,
  DECODE(z.DELIVERYDIRECTION,1,5,1) AS nazn_otg_id,
  NVL(Ora_Val(z.price),0)*NVL(z.PLANWEIGHT,0) AS sum_zd,
  z.ORDERNUM AS doc302_id,
  ADD_MONTHS(z.begindate,0) AS begin_date,
  ADD_MONTHS(z.begindate,0) AS update_date,
  '00:00:00' AS update_time,
  z.senderspecialmark AS gr4,
  --nvl(tpd.kod_tex_pd,0) as kod_tex_pd,
  7247252 AS tex_pd_id,
  (SELECT NVL(plattarif_id,0) FROM KLS_TEX_PD WHERE KLS_TEX_PD.ID=7247252 AND KLS_TEX_PD.GROTP_ID=4175) AS plattarif_id,
  ps.ID AS PLANSTRU_ID,
  s_o.ID AS stanotp_id,
  z.NUMOFETRANSYSTEM AS NOM_ETRAN,
  ex.predpr_id AS exped_id,
  (SELECT DISTINCT zakaz_id FROM ZAKAZ_HIST WHERE id=TO_NUMBER(z.NPOORDERID)) AS LINK_ID,
  z.NPOORDERID AS LINK_HIST_id,
  z.SUPPLYORDERNUM AS INPUT_NUM,
  ADD_MONTHS(z.SUPPLYORDERDATE,0) AS INPUT_DATE,
  z.SHIPMENTREQUESTID AS doc301_id,
  pgu12.gd_vagtype_id AS rodvag_id,
  pgu12.gd_group_id AS gr_gruz_id,z.measureunit
FROM
  XX101_ZVZAV_DATA z, KLS_STAN s_o,
  KLS_STAN s,
  (SELECT isu_kod_dog, dog_id, MAX(usl_number) AS usl_number, MAX(cat_cen_id) AS cat_cen_id FROM USL_DOG GROUP BY isu_kod_dog, dog_id) u_d,
  KLS_DOG d, KLS_PREDPR plat,
  XX101_ACTIVE_KLS_PREDPR poluch, XX101_ACTIVE_KLS_PREDPR potreb,
  (select * from KLS_PROD where id_npr<='90000')  prod, KLS_PROD_GU12 pgu12,
  --(select p.id, t.id as kod_tex_pd, p.KSSS_PREDPR_ID from kls_tex_pd t, kls_predpr p where t.plattarif_id=p.id and t.grotp_id=4175 and t.id<>0) tpd
  KLS_PLANSTRU ps,
  (SELECT predpr_id,kod_isu FROM PREDPR_ROLE WHERE kls_role_id=3) ex
WHERE z.SOURCESTATIONCODE=s_o.ksss_stan_id (+)
  AND z.DESTINATIONSTATIONCODE=s.ksss_stan_id (+)
  AND REPLACE(DECODE(z.CONTRACT,'A200707804  000','”Õœ',z.contract),' ','')=u_d.isu_kod_dog (+)
  AND u_d.dog_id=d.id (+)
  AND d.predpr_id=plat.id (+)
  AND z.PRODUCTRECIPIENTKSSSCODE=poluch.KSSS_PREDPR_ID(+)
  AND z.CONSUMERKSSSCODE=potreb.KSSS_PREDPR_ID(+)
  AND z.PRODUCTKSSSCODE=prod.KSSS_prod_id(+)
  AND prod.PROD_GU12_ID=pgu12.ID(+)
  --and z.TARIFFPAYERKSSSCODE=tpd.ksss_predpr_id(+)
  AND z.PLANNINGGROUPSHIERARCHY=ps.ISU_KOD(+)
  AND z.FORWARDERKSSSCODE=ex.KOD_ISU(+)
  --and z.ordernum in (3020085711);
;


