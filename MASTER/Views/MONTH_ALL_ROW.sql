--
-- MONTH_ALL_ROW  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.MONTH_ALL_ROW
(ID, MONTH_ALL_ID, SORTBY, CLIENT_NUMBER, CLIENT_DATE, 
 INPUT_NUMBER, INPUT_DATE, REQUEST, KOL, SPEED_VES, 
 SPEED_KOL, KLS_PREDPR_ID, KLS_DOG_ID, DATE_DOG, KLS_PROD_ID, 
 STAN_ID, PRICH, PAYFORM_ID, LOAD_ABBR, VETKA_ID, 
 GR4, POLUCH_ID, POTREB_ID, USL_OPL_ID, ORGSTRU_ID, 
 PRICE, POLUCH_NAME, POTREB_NAME, PRICE_POK, PRICE_REAL, 
 KLS_PLANSTRUID, STORE_NAME, NOM_ZD, STATUS_ZAKAZ_ID, GU12_A_ID, 
 STAN_OLD_ID, BEGIN_DATE)
AS 
select 
  zakaz_hist.ID, 
  ZAKAZ_ID as MONTH_ALL_ID, 
  SORTBY, 
  zakaz_hist.CLIENT_NUMBER, 
  zakaz_hist.CLIENT_DATE, 
  zakaz_hist.INPUT_NUMBER, 
  zakaz_hist.INPUT_DATE, 
  zakaz_hist.VES as REQUEST, 
  zakaz_hist.KOL, 
  zakaz_hist.SPEED_VES, 
  zakaz_hist.SPEED_KOL, 
  zakaz.PLAT_ID as KLS_PREDPR_ID, 
  zakaz.DOG_ID as KLS_DOG_ID, 
  NULL as DATE_DOG, 
  TO_NUMBER(zakaz_hist.PROD_ID_NPR) as KLS_PROD_ID, 
  zakaz_hist.STAN_ID, 
  zakaz.PRIM as PRICH, 
  zakaz.PAYFORM_ID, 
  zakaz.LOAD_ABBR, 
  zakaz.VETKA_ID, 
  zakaz.GR4, 
  zakaz_hist.POLUCH_ID, 
  zakaz.POTREB_ID, 
  zakaz.USL_OPL_ID, 
  zakaz.FILIAL_ID as ORGSTRU_ID, 
  zakaz_hist.PRICE, 
  zakaz.POTREB_NAME as POLUCH_NAME, 
  zakaz.POTREB_NAME, 
  0 as PRICE_POK, 
  0 as PRICE_REAL, 
  zakaz.PLANSTRU_ID as KLS_PLANSTRUID, 
  zakaz.NEFTEBASA as STORE_NAME, 
  NOM_ZD, 
  STATUS_ZAKAZ_ID, 
  GU12_A_ID, 
  OLD_STAN_ID as STAN_OLD_ID , 
  zakaz_hist.BEGIN_DATE 
from zakaz_hist,zakaz 
where zakaz_hist.zakaz_id=zakaz.id;


