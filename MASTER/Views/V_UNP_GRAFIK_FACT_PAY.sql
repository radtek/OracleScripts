--
-- V_UNP_GRAFIK_FACT_PAY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_GRAFIK_FACT_PAY
(DOG_ID, DATE_PLAT, SUMMA_PLAT)
AS 
SELECT   /*+ ORDERED */
         aa.dog_id, aa.date_plat, SUM (aa.summa_plat) AS summa_plat
    FROM (SELECT /*+ ORDERED USE_NL (c, a, b, bp, kls_dog) USE_HASH (kls_prod)*/
                                                        -- Разнесенные платежи
                 c.dog_id, c.date_post AS date_plat,
                                                   -- Фактическая дата платежа
                 a.summa AS summa_plat            -- Фактическая сумма платежа
            FROM v_temp_unp_garfik_params r,
                 payments c,
                 payments_on_bills a,
                 bill_pos bp,
                 bills b,
                 kls_dog,
                 kls_prod
           WHERE c.date_post BETWEEN r.begin_date AND LAST_DAY (r.end_date)
             AND c.ID = a.payments_id
             AND a.nom_dok = bp.nom_dok
             AND a.bill_pos_id = bp.bill_pos_id
             AND bp.nom_dok = b.nom_dok
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
             AND bp.is_luk = 1
          --
          UNION ALL
          --
          SELECT   /*+ ORDERED USE_NL (r_MASTER_REPORTS, b, a, kls_dog) INDEX (b PK_PAYMENTS) USE_HASH (b) USE_HASH (r_MASTER_REPORTS) USE_HASH (kls_dog)*/
-- Не разнесенные платежи
                   b.dog_id, b.date_post AS date_plat,         -- Дата платежа
                   SUM (a.summa) AS summa_plat                -- Сумма платежа
              FROM v_temp_unp_garfik_params r,
                   payments b,
                   (SELECT payments.ID, payments.summa
                      FROM payments
                    UNION ALL
                    SELECT payments_on_bills.payments_id,
                           -payments_on_bills.summa
                      FROM payments_on_bills) a,
                   kls_dog
             WHERE b.date_post BETWEEN r.begin_date AND LAST_DAY (r.end_date)
               AND r.grp_id_npr =
                               '*'
                                  -- Показывать, когда отбор по всем продуктам
               AND a.ID = b.ID
               AND b.dog_id = kls_dog.ID
               AND kls_dog.predpr_id =
                           DECODE (r.plat_id,
                                   0, kls_dog.predpr_id,
                                   r.plat_id
                                  )
               AND kls_dog.dog_number LIKE r.dog_number
          GROUP BY b.dog_id, b.date_post
            HAVING SUM (a.summa) > 0) aa
GROUP BY aa.dog_id, aa.date_plat;


