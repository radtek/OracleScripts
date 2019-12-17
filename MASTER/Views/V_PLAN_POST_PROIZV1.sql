--
-- V_PLAN_POST_PROIZV1  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PLAN_POST_PROIZV1
(PROD_ID_NPR, NAME_NPR, NAME, NAME1, PLAN_VES, 
 DATE_PLAN)
AS 
SELECT v.prod_id_npr, kp.name_npr, v.NAME,v.name1, v.plan_ves, pp.date_plan
  FROM (SELECT plan_id, plan_per_id, prod_id_npr,
               kls_planstru.ID AS planstru_id, kls_planstru.level_pos,
               kls_planstru.NAME,name1, kod_sgr1, kod_spg1, kod_rzd1, kod_prz1,
               kod_grp1, kod_pgr1, kls_planstru.parent_id, dog_id, payform_id,
               plan_ves, plan_sum
          FROM kls_planstru,
               (SELECT   plan_post.plan_id, plan_post.plan_per_id,
                         plan_post.prod_id_npr, plan_post.planstru_id,kls_planstru.name as name1,
                         kls_planstru.kod_sgr AS kod_sgr1, 0 AS kod_spg1,
                         0 AS kod_rzd1, 0 AS kod_prz1, 0 AS kod_grp1,
                         0 AS kod_pgr1, plan_post.dog_id,
                         plan_post.payform_id,
                         SUM (plan_post.plan_ves) AS plan_ves,
                         SUM (plan_post.plan_sum) AS plan_sum
                    FROM kls_planstru, plan_post
                   WHERE (kls_planstru.ID = plan_post.planstru_id)
                     AND (kls_planstru.view_level = 1)
                     AND plan_post.plan_id = 2
                GROUP BY plan_post.plan_id,
                         plan_post.plan_per_id,
                         plan_post.prod_id_npr,
                         plan_post.planstru_id,kls_planstru.name,
                         kls_planstru.kod_sgr,
                         0,
                         0,
                         0,
                         0,
                         0,
                         plan_post.dog_id,
                         plan_post.payform_id)
         WHERE kod_sgr = kod_sgr1
           AND kod_spg = kod_spg1
           AND kod_rzd = kod_rzd1
           AND kod_prz = kod_prz1
           AND kod_grp = kod_grp1
           AND kod_pgr = kod_pgr1
        UNION ALL
        SELECT plan_id, plan_per_id, prod_id_npr,
               kls_planstru.ID AS planstru_id, kls_planstru.level_pos,
               kls_planstru.NAME, name1,kod_sgr1, kod_spg1, kod_rzd1, kod_prz1,
               kod_grp1, kod_pgr1, kls_planstru.parent_id, dog_id, payform_id,
               plan_ves, plan_sum
          FROM kls_planstru,
               (SELECT   plan_post.plan_id, plan_post.plan_per_id,
                         plan_post.prod_id_npr, plan_post.planstru_id,kls_planstru.name as name1,
                         kls_planstru.kod_sgr AS kod_sgr1,
                         kls_planstru.kod_spg AS kod_spg1, 0 AS kod_rzd1,
                         0 AS kod_prz1, 0 AS kod_grp1, 0 AS kod_pgr1,
                         plan_post.dog_id, plan_post.payform_id,
                         SUM (plan_post.plan_ves) AS plan_ves,
                         SUM (plan_post.plan_sum) AS plan_sum
                    FROM kls_planstru, plan_post
                   WHERE (kls_planstru.ID = plan_post.planstru_id)
                     AND (kls_planstru.view_level = 2)
                     AND plan_post.plan_id = 2
                GROUP BY plan_post.plan_id,
                         plan_post.plan_per_id,
                         plan_post.prod_id_npr,
                         plan_post.planstru_id,kls_planstru.name,
                         kls_planstru.kod_sgr,
                         kls_planstru.kod_spg,
                         0,
                         0,
                         0,
                         0,
                         plan_post.dog_id,
                         plan_post.payform_id)
         WHERE kod_sgr = kod_sgr1
           AND kod_spg = kod_spg1
           AND kod_rzd = kod_rzd1
           AND kod_prz = kod_prz1
           AND kod_grp = kod_grp1
           AND kod_pgr = kod_pgr1
        UNION ALL
        SELECT plan_id, plan_per_id, prod_id_npr,
               kls_planstru.ID AS planstru_id, kls_planstru.level_pos,
               kls_planstru.NAME,name1, kod_sgr1, kod_spg1, kod_rzd1, kod_prz1,
               kod_grp1, kod_pgr1, kls_planstru.parent_id, dog_id, payform_id,
               plan_ves, plan_sum
          FROM kls_planstru,
               (SELECT   plan_post.plan_id, plan_post.plan_per_id,
                         plan_post.prod_id_npr, plan_post.planstru_id,kls_planstru.name as name1,
                         kls_planstru.kod_sgr AS kod_sgr1,
                         kls_planstru.kod_spg AS kod_spg1,
                         kls_planstru.kod_rzd AS kod_rzd1, 0 AS kod_prz1,
                         0 AS kod_grp1, 0 AS kod_pgr1, plan_post.dog_id,
                         plan_post.payform_id,
                         SUM (plan_post.plan_ves) AS plan_ves,
                         SUM (plan_post.plan_sum) AS plan_sum
                    FROM kls_planstru, plan_post
                   WHERE (kls_planstru.ID = plan_post.planstru_id)
                     AND (kls_planstru.view_level = 3)
                     AND plan_post.plan_id = 2
                GROUP BY plan_post.plan_id,
                         plan_post.plan_per_id,
                         plan_post.prod_id_npr,
                         plan_post.planstru_id,kls_planstru.name,
                         kls_planstru.kod_sgr,
                         kls_planstru.kod_spg,
                         kls_planstru.kod_rzd,
                         0,
                         0,
                         0,
                         plan_post.dog_id,
                         plan_post.payform_id)
         WHERE kod_sgr = kod_sgr1
           AND kod_spg = kod_spg1
           AND kod_rzd = kod_rzd1
           AND kod_prz = kod_prz1
           AND kod_grp = kod_grp1
           AND kod_pgr = kod_pgr1) v,
       plan_periods pp,
       kls_prod kp
 WHERE v.plan_per_id = pp.ID AND kp.id_npr = v.prod_id_npr;


