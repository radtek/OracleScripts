--
-- V_DAYLYFACT_HRAN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DAYLYFACT_HRAN
(DATE_OTGR, PROD_ID_NPR, OTGR, NPR_SOBSTV_ID)
AS 
SELECT kvit.date_otgr,kvit.prod_id_NPR, 
iif_num(month.nazn_OTG_id,'=',8,kvit.VES,-kvit.VES) as otgr, 
MONTH.NPR_SOBSTV_id 
FROM kvit , month 
WHERE (month.nazn_OTG_id=8 or month.nazn_OTG_id=9) and (kvit.NOM_ZD) = (MONTH.NOM_ZD) and month.date_plan>sysdate-60
order by kvit.date_otgr, kvit.prod_id_NPR;


