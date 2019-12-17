--
-- V_DAYLY_FACT_OTGR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DAYLY_FACT_OTGR
(PROD_ID_NPR, OTGR, REQ, NPR_SOBSTV_ID, DATE_OTGR)
AS 
SELECT kvit.prod_id_NPR, 
sum(kvit.VES) as otgr, 
sum(month.TONN_DECLARED) as req,
MONTH.NPR_SOBSTV_id, 
kvit.date_otgr
FROM kvit , month 
WHERE month.nazn_OTG_id<>8 and month.nazn_OTG_id<>10 and (kvit.NOM_ZD) = (MONTH.NOM_ZD)  and month.date_plan>sysdate-60
group by kvit.prod_id_NPR,MONTH.NPR_SOBSTV_id, kvit.date_otgr
order by kvit.date_otgr, kvit.prod_id_NPR;


