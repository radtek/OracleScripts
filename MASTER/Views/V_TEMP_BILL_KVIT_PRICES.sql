--
-- V_TEMP_BILL_KVIT_PRICES  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TEMP_BILL_KVIT_PRICES
(ABBR_NPR, ID_NPR, CENA, CENA_OTP, BEGIN_DATE, 
 END_DATE, ID, SELECTED)
AS 
SELECT 
  kls_prod.abbr_npr,
  a.id_npr,
  npr_prices.CENA,
  npr_prices.CENA_OTP,
  npr_prices.BEGIN_DATE,
  npr_prices.END_DATE,
  npr_prices.ID,
  DECODE(b.id_npr,NULL,0,1) AS Selected
FROM npr_prices,kls_prod,(SELECT DISTINCT id_npr,date_kvit FROM V_TEMP_BILL_KVIT) a,
  (SELECT DISTINCT npr_prices_id,id_npr FROM V_TEMP_BILL_KVIT) b WHERE
  npr_prices.CAT_CEN_ID=100 and
  npr_prices.PROD_ID_NPR=a.id_npr and
  npr_prices.PROD_ID_NPR=kls_prod.id_npr and
  npr_prices.id=b.npr_prices_id(+) and
  npr_prices.prod_id_npr=b.id_npr(+) and
  (npr_prices.END_DATE is null or npr_prices.END_DATE>=a.date_kvit)
ORDER BY begin_date DESC;


