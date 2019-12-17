--
-- V_UNP_GRAFIK_PLAN_PAY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_GRAFIK_PLAN_PAY
(DOG_ID, DATE_PLAT, SUMMA_PLAT)
AS 
SELECT   /*+ ORDERED */
         aa.dog_id, aa.date_plat, SUM (aa.summa_plat) AS summa_plat
    FROM (SELECT /*+ ORDERED INDEX (bp BILL_POS_NOM_DOK_2_I) USE_HASH (kls_prod)*/
                                                                      --Все СФ
                 b.dog_id, b.date_plat AS date_plat,
              -- Дата окончания отсрочки платежа (предполагаемая дата платежа)
                 bp.summa AS summa_plat             -- Ожидаемая сумма платежа
            FROM v_temp_unp_garfik_params r,
                 bills b,
                 bill_pos bp,
                 kls_dog,
                 kls_prod
           WHERE b.date_plat BETWEEN r.begin_date AND LAST_DAY (r.end_date)
             AND b.date_kvit >= TO_DATE ('01.01.2005', 'dd.mm.yyyy')
             AND bp.prod_id_npr = kls_prod.id_npr
             AND kls_prod.id_group_npr >=
                             DECODE (r.grp_id_npr,
                                     '*', '00000',
                                     r.grp_id_npr
                                    )
             AND kls_prod.id_group_npr <=
                    DECODE (r.grp_id_npr,
                            '10100', '99999',
                            '*', '99999',
                            r.grp_id_npr
                           )
             AND b.dog_id = kls_dog.ID
             AND kls_dog.predpr_id =
                           DECODE (r.plat_id,
                                   0, kls_dog.predpr_id,
                                   r.plat_id
                                  )
             AND kls_dog.dog_number LIKE r.dog_number
             AND b.nom_dok = bp.nom_dok
             AND bp.is_luk = 1
          --
          UNION ALL
          --
          SELECT /*+ ORDERED INDEX (p PAYMENTS_ON_BILLS_NOM_DOK_I) USE_HASH (kls_prod)*/
                                                          --Оплаты (с минусом)
                 b.dog_id, b.date_plat AS date_plat,
              -- Дата окончания отсрочки платежа (предполагаемая дата платежа)
                 -p.summa AS summa_plat                  -- Оплата (с минусом)
            FROM v_temp_unp_garfik_params r,
                 bills b,
                 bill_pos bp,
                 payments_on_bills p,
                 kls_dog,
                 kls_prod
           WHERE b.date_plat BETWEEN r.begin_date AND LAST_DAY (r.end_date)
             AND b.date_kvit >= TO_DATE ('01.01.2005', 'dd.mm.yyyy')
             AND bp.prod_id_npr = kls_prod.id_npr
             AND kls_prod.id_group_npr >=
                             DECODE (r.grp_id_npr,
                                     '*', '00000',
                                     r.grp_id_npr
                                    )
             AND kls_prod.id_group_npr <=
                    DECODE (r.grp_id_npr,
                            '10100', '99999',
                            '*', '99999',
                            r.grp_id_npr
                           )
             AND b.dog_id = kls_dog.ID
             AND kls_dog.predpr_id =
                           DECODE (r.plat_id,
                                   0, kls_dog.predpr_id,
                                   r.plat_id
                                  )
             AND kls_dog.dog_number LIKE r.dog_number
             AND b.nom_dok = bp.nom_dok
             AND bp.nom_dok = p.nom_dok
             AND bp.bill_pos_id = p.bill_pos_id
             AND bp.is_luk = 1
          --
          UNION ALL
          --
          SELECT /*+ ORDERED INDEX (a PAYMENTS_ON_BILLS_NOM_DOK_I)*/
                                                               --Оплаченные СФ
                 b.dog_id,
--    c.DATE_POST as date_plat, -- фактическая дата платежа
                          b.date_plat AS date_plat,
                                                -- Предполагаемая дата платежа
                 a.summa AS summa_plat            -- Фактическая сумма платежа
            FROM v_temp_unp_garfik_params r,
                 bills b,
                 bill_pos bp,
                 payments_on_bills a,
                 payments c,
                 kls_dog,
                 kls_prod
           WHERE b.nom_dok = bp.nom_dok
             AND bp.nom_dok = a.nom_dok
             AND bp.bill_pos_id = a.bill_pos_id
             AND a.payments_id = c.ID
             AND b.date_kvit >= TO_DATE ('01.01.2005', 'dd.mm.yyyy')
             AND b.date_plat BETWEEN r.begin_date AND LAST_DAY (r.end_date)
--    AND c.DATE_POST BETWEEN r.BEGIN_DATE AND r.END_DATE
             AND bp.prod_id_npr = kls_prod.id_npr
             AND kls_prod.id_group_npr >=
                             DECODE (r.grp_id_npr,
                                     '*', '00000',
                                     r.grp_id_npr
                                    )
             AND kls_prod.id_group_npr <=
                    DECODE (r.grp_id_npr,
                            '10100', '99999',
                            '*', '99999',
                            r.grp_id_npr
                           )
             AND b.dog_id = kls_dog.ID
             AND kls_dog.predpr_id =
                           DECODE (r.plat_id,
                                   0, kls_dog.predpr_id,
                                   r.plat_id
                                  )
             AND kls_dog.dog_number LIKE r.dog_number
             AND bp.is_luk = 1) aa
GROUP BY aa.dog_id, aa.date_plat;


