--
-- V_GU12_CARD_DATE_STAN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GU12_CARD_DATE_STAN
(DATE_O, STAN_ID, SOBVAG, KOL_PLAN, VES_PLAN, 
 KOL_FAKT, VES_FAKT)
AS 
SELECT
DATE_O
,STAN_ID
,SOBVAG
,SUM(A.KOL_PLAN) AS KOL_PLAN
,SUM(A.VES_PLAN) AS VES_PLAN
,SUM(A.KOL_FAKT) AS KOL_FAKT
,SUM(A.VES_FAKT) AS VES_FAKT
FROM V_GU12_CARD_N A
GROUP BY DATE_O,STAN_ID,SOBVAG
ORDER BY DATE_O,STAN_ID,SOBVAG;


