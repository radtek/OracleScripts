--
-- V_VANEEV_TOKILL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_VANEEV_TOKILL
(NAME_1, NAME_NPR, DATE_OPER, VES, SUMMA, 
 OST)
AS 
SELECT
  NAME_1,
  NAME_NPR,
  DATE_OPER,
  SUM(DECODE(name_oper,'–≈¿À»«¿÷»ﬂ',ves,0)) AS ves,
  SUM(DECODE(name_oper,'–≈¿À»«¿÷»ﬂ',summa,0)) AS summa,
  SUM(DECODE(name_oper,'Œ—“¿“Œ ',ves,0)) AS ost   
 FROM
(
SELECT   azc_operation.*, azc_operation.ID AS id_,
         azc_type_operation.NAME AS name_oper, azc_type_operation.kind_oper,
         org_structure.NAME AS name_1, azc_place_send.NAME AS name_2,
         kls_prod.name_npr, kls_prod.azc_pr_grp_id, kls_predpr.short_name,
         org_relations.org_stru_2_id, kls_cat_cen.for_azc,
         azc_prod_group.note_
    FROM azc_operation,
         azc_type_operation,
         org_structure,
         kls_cat_cen,
         azc_prod_group,
         azc_place_send,
         kls_prod,
         kls_predpr,
         org_relations
   WHERE azc_type_operation.ID = azc_operation.type_oper_id
     AND azc_operation.org_stru_id = org_structure.ID
     AND azc_operation.discount = kls_cat_cen.ID
     AND azc_operation.place_send_id = azc_place_send.ID
     AND kls_prod.azc_pr_grp_id = azc_prod_group.ID
     AND azc_operation.prod_id_npr = kls_prod.id_npr
     AND azc_operation.sobstv_id = kls_predpr.ID
     AND org_structure.ID = org_relations.org_stru_1_id
     AND (azc_type_operation.kind_oper in (0,3,2,5)
         )
     AND azc_operation.date_oper <= TO_DATE ('30.06.2004', 'dd-mm-yyyy')
     AND azc_operation.date_oper >= TO_DATE ('01.01.2004', 'dd-mm-yyyy')
     AND EXISTS (
            SELECT NULL
              FROM org_relations a
             WHERE a.org_stru_1_id = azc_operation.org_stru_id
               AND a.org_stru_2_id = 32)
--ORDER BY azc_operation.org_stru_id DESC
)
GROUP BY   
  NAME_1,
  NAME_NPR,
  DATE_OPER
  ORDER BY
    NAME_1,
  NAME_NPR,
  DATE_OPER;


