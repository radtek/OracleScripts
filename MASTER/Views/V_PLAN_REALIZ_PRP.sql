--
-- V_PLAN_REALIZ_PRP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PLAN_REALIZ_PRP
(AZS_ID, AZS_NAME, UCH_ID, UCH_NAME, NB_ID, 
 NBASA, POST_ID, POST, ID_NPR, NAME_NPR, 
 GROUP_KIND_NAME, DATE_PLAN, VES, ORG_KIND_ID, TIP_REAL_ID)
AS 
SELECT /*+ ORDERED FIRST_ROWS */
       org.ID AS azs_id, org.NAME AS azs_name, org.uch_id,
       org.uchastok AS uch_name, org.nb_id, org.nbasa, POST.ID AS post_id,
       POST.short_name AS POST, prod.id_npr, prod.name_npr,
       'ÀÇÑ' AS group_kind_name, rl.date_plan, rl.ves, rl.org_kind_id,
       rl.tip_real_id
  FROM kls_prod prod,
       plan_realiz rl,
       kls_predpr POST,
       (SELECT azs.ID, azs.NAME, uch.uchastok, uch.uch_id, nb.nbasa, nb.nb_id
          FROM org_links ol,
               org_structure azs,
               (SELECT olu.org_stru_1_id, nbu.NAME AS uchastok,
                       nbu.ID AS uch_id
                  FROM org_links olu, org_structure nbu
                 WHERE olu.org_stru_2_id = nbu.ID AND nbu.org_kind_id = 4) uch,
               (SELECT olu.org_stru_1_id, nb.NAME AS nbasa, nb.ID AS nb_id
                  FROM org_links olu, org_links oln, org_structure nb
                 WHERE olu.org_stru_2_id = oln.org_stru_1_id
                   AND oln.org_stru_2_id = nb.ID
                   AND nb.org_kind_id = 1
                   AND oln.is_root <> 1
                UNION ALL
                SELECT olu.org_stru_1_id, nb.NAME AS nbasa, nb.ID AS nb_id
                  FROM org_links olu, org_structure nb, org_structure az
                 WHERE olu.org_stru_2_id = nb.ID
                   AND olu.org_stru_1_id = az.ID
                   AND az.org_kind_id IN (5, 12)
                   AND nb.org_kind_id = 1
                   AND olu.is_root <> 1) nb
         WHERE ol.org_stru_1_id = azs.ID
           AND azs.org_kind_id IN (5, 12)
           AND ol.org_stru_1_id = uch.org_stru_1_id(+)
           AND ol.org_stru_1_id = nb.org_stru_1_id(+)) org
 WHERE rl.sklad_id = org.ID
   AND rl.prod_id_npr = prod.id_npr
   AND rl.supplier_id = POST.ID
UNION ALL
SELECT /*+ ORDERED */
       skl.ID AS azs_id, skl.NAME AS azs_name, 0 AS uch_id, '' AS uch_name,
       fil.ID AS nb_id, fil.NAME AS nbasa, POST.ID AS post_id,
       POST.short_name AS POST, prod.id_npr, prod.name_npr,
       ok.group_kind_name, rl.date_plan, rl.ves, rl.org_kind_id,
       rl.tip_real_id
  FROM kls_prod prod,
       plan_realiz rl,
       org_structure skl,
       kls_org_kind ok,
       org_structure fil,
       kls_predpr POST
 WHERE rl.org_stru_id = fil.ID
   AND rl.sklad_id = skl.ID
   AND rl.prod_id_npr = prod.id_npr
   AND rl.supplier_id = POST.ID
   AND skl.org_kind_id = ok.ID
   AND ok.group_kind_id = 1;


