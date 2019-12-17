--
-- V_ZAKAZ_DECADS_SNP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ZAKAZ_DECADS_SNP
(DATE_, DECADE_, PREDPR_ID, PREDPR_NAME, PROD_ID_NPR, 
 NAME_NPR, GROUP_NAME, VES, NOM_ZD)
AS 
SELECT   month.input_date AS date_,
         DECODE
              (TRUNC (    (  EXTRACT (DAY FROM month.input_date
                                     )
                           - 1
                          )
                        / 10
                      + 1
                     ),
               4, 3,
               TRUNC (    (  EXTRACT (DAY FROM month.input_date
                                     )
                           - 1
                          )
                        / 10
                      + 1
                     )
              ) AS decade_,
         4175 as predpr_id, 
         'ÎÎÎ "ËÓÊÎÉË-ÓÍÏ"' AS predpr_name,
         month.prod_id_npr as prod_id_npr,
         kls_prod.name_npr,
         kls_prod_groups.group_name, 
         month.tonn_declared AS ves,
         month.nom_zd
    FROM v_master_reports r,
         kls_prod,
         (SELECT *
            FROM kls_prod_groups_desc a
           WHERE a.prod_type_grp_id = 1) gr_prod,
         kls_prod_groups,
         month,
         kls_dog
   WHERE NLS_UPPER(r.report_file)='ZAKAZ_DECADS.XLS'
     and month.dog_id=kls_dog.id and kls_dog.predpr_id=2641
     AND month.prod_id_npr = kls_prod.id_npr
     AND month.prod_id_npr = gr_prod.prod_id_npr
     AND gr_prod.prod_groups_id = kls_prod_groups.ID
     AND month.date_plan >= r.begin_date
     AND month.date_plan <= r.end_date
     and exists
     (select null from
         zakaz, 
         zakaz_hist
        where zakaz.ID = zakaz_hist.zakaz_id
          AND zakaz_hist.STATUS_ZAKAZ_ID=20
          AND zakaz_hist.nom_zd = MONTH.nom_zd
          AND zakaz.is_agent = 2
          AND zakaz.is_accept = 1    
          )
--GROUP BY month.input_date,
--         month.prod_ID_NPR,
--         kls_prod_groups.group_name,
--         kls_prod.name_npr
union all

SELECT  
-- ïëàí îòãðóçêè ïî äàííûì ÑÍÏ
  zakaz.begin_date as date_,
  DECODE
              (TRUNC (    (  EXTRACT (DAY FROM zakaz.begin_date
                                     )
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
              ) AS decade_,
  kls_predpr.id as predpr_id,
  kls_predpr.PREDPR_NAME,
  zakaz.prod_id_npr,
  kls_prod.NAME_NPR,
  kls_prod_groups.GROUP_NAME,
  zakaz_hist.load_ves AS ves,
  zakaz.INPUT_NUMBER
FROM v_master_reports r,
     zakaz,
     zakaz_hist,
     kls_dog,
     kls_predpr,
     kls_prod,
     (SELECT *
     FROM kls_prod_groups_desc a
     WHERE a.prod_type_grp_id = 1) gr_prod,
     kls_prod_groups
WHERE NLS_UPPER(r.report_file)='ZAKAZ_DECADS.XLS'
     and zakaz.lukdog_id = kls_dog.ID
     AND zakaz.is_agent = 2
     AND zakaz.is_accept = 1
     and zakaz.PROD_ID_NPR = gr_prod.PROD_ID_NPR
     and gr_prod.PROD_GROUPS_ID =kls_prod_groups.ID
     and gr_prod.PROD_ID_NPR=kls_prod.ID_NPR
     AND kls_dog.agent_id = kls_predpr.ID
     AND zakaz.date_plan >=r.begin_date
     AND zakaz.date_plan <=r.end_date
     AND zakaz.ID = zakaz_hist.zakaz_id
     AND zakaz_hist.STATUS_ZAKAZ_ID=20
     and not exists
     (select null from MONTH
        where zakaz_hist.nom_zd = MONTH.nom_zd
      )
--GROUP BY zakaz.begin_date, 
--            kls_predpr.id,
--                kls_predpr.PREDPR_NAME,
--                    zakaz.prod_id_npr,
--                        kls_prod_groups.GROUP_NAME,
--                            kls_prod.NAME_NPR
;


