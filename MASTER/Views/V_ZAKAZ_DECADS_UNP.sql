--
-- V_ZAKAZ_DECADS_UNP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ZAKAZ_DECADS_UNP
(DATE_, PREDPR_ID, PREDPR_NAME, PROD_ID_NPR, NAME_NPR, 
 GROUP_NAME, VES, DECADE_)
AS 
Select 
-- Ãğàôèê îòãğóçêè ïî äàííûì ÓÍÏ
date_,
predpr_id,
predpr_name,
prod_id_npr, 
name_npr,
group_name,
sum(ves) as ves, 
decade_
from 
(
SELECT   gu12_br.date_r AS date_,
         4175 as predpr_id, 
         'ÎÎÎ "ËÓÊÎÉË-ÓÍÏ"' AS predpr_name,
         gu12_br.id_npr as prod_id_npr,
         kls_prod.name_npr,
         kls_prod_groups.group_name, 
         SUM (gu12_br.ves) AS ves,
         DECODE
              (TRUNC (    (  EXTRACT (DAY FROM gu12_br.date_r
                                     )
                           - 1
                          )
                        / 10
                      + 1
                     ),
               4, 3,
               TRUNC (    (  EXTRACT (DAY FROM gu12_br.date_r
                                     )
                           - 1
                          )
                        / 10
                      + 1
                     )
              ) AS decade_
    FROM v_master_reports r,
         kls_prod,
         (SELECT *
            FROM kls_prod_groups_desc a
           WHERE a.prod_type_grp_id = 1) gr_prod,
         kls_prod_groups,
         gu12_b,
         gu12_br
   WHERE NLS_UPPER(r.report_file)='ZAKAZ_DECADS.XLS'
     and gu12_b.plat_id=2641
     AND gu12_b.ID = gu12_br.id_b
     AND gu12_br.id_npr = kls_prod.id_npr
     AND gu12_br.id_npr = gr_prod.prod_id_npr
     AND gr_prod.prod_groups_id = kls_prod_groups.ID
     AND gu12_br.date_r >= r.begin_date
     AND gu12_br.date_r <= r.end_date
     and exists
     (select null from
         zakaz, 
         zakaz_hist,
         MONTH
        where zakaz.ID = zakaz_hist.zakaz_id
          AND zakaz_hist.STATUS_ZAKAZ_ID=20
          AND zakaz_hist.nom_zd = MONTH.nom_zd
          AND MONTH.stan_id = gu12_b.stan_id
          AND MONTH.gu12_a_id = gu12_b.id_a
    )
GROUP BY gu12_br.date_r,
         gu12_br.ID_NPR,
         kls_prod_groups.group_name,
         kls_prod.name_npr
--ORDER BY gu12_br.date_r, 
--         kls_prod_groups.group_name,
--         kls_prod.name_npr
union all
SELECT  zakaz.begin_date AS date_,
        kls_predpr.id as predpr_id, 
        kls_predpr.predpr_name AS predpr_name,
        zakaz.prod_id_npr,
        kls_prod.name_npr,
        kls_prod_groups.group_name, 
        SUM (zakaz.ves) AS ves,
         DECODE
              (TRUNC (    (  EXTRACT (DAY FROM zakaz.begin_date)
                           - 1
                          )
                        / 10
                      + 1
                     ),
               4, 3,
               TRUNC (    (  EXTRACT (DAY FROM zakaz.begin_date
                                     )
                           - 1
                          )
                        / 10
                      + 1
                     )
              ) AS decade_
    FROM v_master_reports r,
         zakaz,
         kls_dog,
         kls_prod,
         kls_predpr,
         (SELECT *
            FROM kls_prod_groups_desc a
           WHERE a.prod_type_grp_id = 1) gr_prod,
         kls_prod_groups
   WHERE NLS_UPPER(r.report_file)='ZAKAZ_DECADS.XLS'
     and zakaz.lukdog_id = kls_dog.ID
     AND zakaz.is_agent = 2
     AND zakaz.is_accept = 1
     AND kls_dog.agent_id = kls_predpr.ID
     and not exists
     (select null from 
         zakaz_hist,
         MONTH,
         gu12_b,
         gu12_br
        where zakaz.ID = zakaz_hist.zakaz_id
          AND zakaz_hist.STATUS_ZAKAZ_ID=20
          AND zakaz_hist.nom_zd = MONTH.nom_zd
          AND MONTH.stan_id = gu12_b.stan_id
          AND MONTH.gu12_a_id = gu12_b.id_a
          AND gu12_b.ID = gu12_br.id_b
      )
     AND zakaz.prod_id_npr = kls_prod.id_npr
     AND zakaz.prod_id_npr = gr_prod.prod_id_npr
     AND gr_prod.prod_groups_id = kls_prod_groups.ID
     AND zakaz.date_plan >=r.begin_date
     AND zakaz.date_plan <=r.end_date
GROUP BY kls_predpr.predpr_name,
         kls_predpr.id, 
         zakaz.begin_date,
         kls_prod_groups.group_name,
         kls_prod.name_npr,
         zakaz.prod_id_npr
)
GROUP BY predpr_name,
         predpr_id,
         decade_,
         date_,
         group_name,
         name_npr,
         prod_id_npr
ORDER BY predpr_name,
         date_,
         group_name,
         name_npr;


