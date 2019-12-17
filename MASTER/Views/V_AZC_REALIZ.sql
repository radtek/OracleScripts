--
-- V_AZC_REALIZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AZC_REALIZ
(ID_SOBSTV, ID_ORG, ID_NPR, DATE_OP, SUMMA_VOL, 
 SUMMA_VES)
AS 
SELECT   /*+ FIRST_ROWS*/
            a.sobstv_id AS id_sobstv, a.org_stru_id AS id_org,
            a.prod_id_npr AS id_npr, a.date_oper AS date_op,
            SUM (a.volume) AS summa_vol, SUM (a.ves) AS summa_ves
       FROM azc_operation a, azc_type_operation b
      WHERE a.type_oper_id = b.ID AND b.kind_oper = 2
   GROUP BY a.date_oper, a.sobstv_id, a.org_stru_id, a.prod_id_npr
   ORDER BY a.date_oper, a.sobstv_id, a.org_stru_id, a.prod_id_npr;


