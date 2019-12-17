--
-- V_REESTR_AKCIZ_BY_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REESTR_AKCIZ_BY_SF
(BEGIN_DATE, END_DATE, OWNER_NAME, OWNER_INN, OWNER_KPP, 
 OWNER_EX_SVID, PLAT_NAME, PLAT_INN, PLAT_KPP, PLAT_EX_SVID, 
 PROD_NAME, PROD_KOD, PROD_ORD, NOM_SF, DATE_VYP_SF, 
 VES)
AS 
SELECT /*+ ORDERED INDEX(kvit) USE_NL(r,kvit,bills) */
  r.BEGIN_DATE,
  r.END_DATE,
  owner.SF_NAME as OWNER_NAME,
  owner.INN as OWNER_INN,
  owner.KPP as OWNER_KPP,
  'серия ' || owner_akciz.EX_SVID_PREF || ' N ' || owner_akciz.EX_SVID_NUMB as OWNER_EX_SVID,
  plat.SF_NAME as PLAT_NAME,
  plat.INN as PLAT_INN,
  Plat.KPP as PLAT_KPP,
  'серия ' || plat_akciz.EX_SVID_PREF || ' N ' || plat_akciz.EX_SVID_NUMB as PLAT_EX_SVID,
  prod_akciz.GROUP_NAME as prod_name,
  prod_akciz.GROUP_ABBR as prod_kod,
  prod_akciz.GROUP_ORDER as prod_ord,
  bills.NOM_SF,
  bills.DATE_VYP_SF,
  SUM(kvit.VES_BRUTTO) as VES
FROM (select * from v_master_reports WHERE NLS_UPPER(REPORT_FILE)='REESTR_AKCIZ_BY_SF.XLS') r, 
  kvit, 
  bills,
  kls_predpr owner, -- Продавец 
  (
  SELECT a.PLAT_ID,MAX(EX_SVID_PREF) as EX_SVID_PREF,MAX(EX_SVID_NUMB) as EX_SVID_NUMB
     FROM kls_predpr_akciz a, (select * from v_master_reports WHERE NLS_UPPER(REPORT_FILE)='REESTR_AKCIZ_BY_SF.XLS') r
    WHERE a.DATE_BEG<=r.END_DATE
      AND a.DATE_END>=r.BEGIN_DATE
   AND a.EX_SVID=1
   GROUP BY a.PLAT_ID   
  ) owner_akciz, -- Акцизное свидетельство продавца 
  kls_dog, -- Договор 
  kls_predpr plat, -- Покупатель
  (
  SELECT a.PLAT_ID,MAX(EX_SVID_PREF) as EX_SVID_PREF,MAX(EX_SVID_NUMB) as EX_SVID_NUMB
     FROM kls_predpr_akciz a, (select * from v_master_reports WHERE NLS_UPPER(REPORT_FILE)='REESTR_AKCIZ_BY_SF.XLS') r
    WHERE a.DATE_BEG<=r.END_DATE
      AND a.DATE_END>=r.BEGIN_DATE
   AND a.EX_SVID=1
   GROUP BY a.PLAT_ID   
  ) plat_akciz, -- Акцизное свидетельство ппокупателя 
  (select ds.PROD_ID_NPR, gr.ID, gr.GROUP_ABBR, gr.GROUP_ORDER, gr.GROUP_NAME 
     from kls_prod_groups_desc ds, kls_prod_groups gr 
    where ds.PROD_GROUPS_ID=gr.ID and gr.prod_type_grp_id=6) prod_akciz -- Подакцизные н/пр
WHERE kvit.DATE_KVIT BETWEEN r.BEGIN_DATE AND r.END_DATE
  AND bills.NOM_DOK=kvit.BILL_ID
  AND bills.owner_id=owner.ID
  AND bills.dog_id=kls_dog.ID
  AND kls_dog.PREDPR_ID=plat.ID
  AND kvit.PROD_ID_NPR=prod_akciz.PROD_ID_NPR
  AND owner.ID=owner_akciz.PLAT_ID(+)
  AND plat.ID=plat_akciz.PLAT_ID(+)
  AND plat.ID=r.PLAT_ID
GROUP BY
  r.BEGIN_DATE,
  r.END_DATE,
  owner.SF_NAME,
  owner.INN,
  owner.KPP,
  'серия ' || owner_akciz.EX_SVID_PREF || ' N ' || owner_akciz.EX_SVID_NUMB,
  plat.SF_NAME,
  plat.INN,
  Plat.KPP,
  'серия ' || plat_akciz.EX_SVID_PREF || ' N ' || plat_akciz.EX_SVID_NUMB,
  prod_akciz.GROUP_NAME,
  prod_akciz.GROUP_ABBR,
  prod_akciz.GROUP_ORDER,
  bills.NOM_SF,
  bills.DATE_VYP_SF
ORDER BY 
  prod_akciz.GROUP_ORDER,
  bills.DATE_VYP_SF,
  bills.NOM_SF;


