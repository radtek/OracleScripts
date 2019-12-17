--
-- FOR_PARUS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.for_parus
AS
   PROCEDURE renew_dog_parus
   IS
   BEGIN
      DELETE FROM kls_dog_parus p
            WHERE p.dog_id IS NULL;

      INSERT INTO kls_dog_parus
         (SELECT DISTINCT    TRIM (c.sdoc_pref)
                          || TRIM (c.sdoc_numb) AS base_numb,
                          for_parus.get_dog_id (   TRIM (c.sdoc_pref)
                                                || TRIM (c.sdoc_numb)
                                               ) AS dog_id,
                          1 AS is_auto_link, NULL AS name_plat,
                          1 AS is_actual
                     FROM parus.v_contracts@oracle.world c
                    WHERE TRIM (c.sdoc_pref) LIKE 'СНП-0%' and c.nstatus=1
/*               AND For_Parus.get_dog_id (   TRIM (c.sdoc_pref)
                                         || TRIM (c.sdoc_numb)
                                        ) IS NOT NULL*/
          MINUS
          SELECT DISTINCT p.base_numb, p.dog_id, 1 AS is_auto_link,
                          NULL AS name_plat, 1 AS is_actual
                     FROM kls_dog_parus p);
   END;

   PROCEDURE renew_bills_parus (
      date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
      date_end   DATE := SYSDATE,
      param1     VARCHAR2 := '',
      param2     VARCHAR2 := '',
      param3     VARCHAR2 := ''
   )
   IS
      v_cnt   NUMBER;
   BEGIN
      IF date_beg IS NULL
      THEN
         RETURN;
      END IF;

      IF date_end IS NULL
      THEN
         RETURN;
      END IF;

      SELECT COUNT (*)
        INTO v_cnt
        FROM load_buffer.parus_dicaccfo;

      IF v_cnt = 0
      THEN
         RETURN;
      END IF;

      -- Обновление связей договоров
      UPDATE /*+ RULE */kls_dog_parus
         SET (base_numb, dog_id) =
                (SELECT DISTINCT a.base_numb, d.ID
                            FROM v_dicaccfo_sf a, kls_dog d
                           WHERE a.base_numb = kls_dog_parus.base_numb
                             AND a.num_dog = d.short_number(+))
       WHERE (is_auto_link = 1 OR dog_id IS NULL)
         AND EXISTS (SELECT NULL
                       FROM v_dicaccfo_sf a
                      WHERE a.base_numb = kls_dog_parus.base_numb);

      -- Обновление счетов
      UPDATE /*+ RULE */bills_parus
         SET (pref_sf, nom_sf, npo_sf, date_vyp_sf, date_kvit, date_buxg,
              prim, kol_dn, nom_zd, base_numb, num_dog, dog_id, usl_number,
              sender, num_kvit, conf_numb, sved_num, summa_dok, summa_prod,
              summa_prod_nds, summa_akciz, summa_gsm, summa_tarif,
              summa_tarif_nds, summa_vozn, summa_vozn_nds, summa_strah) =
                (SELECT a.pref_sf, a.npo_sf,
                           LTRIM (RTRIM (a.pref_sf))
                        || '/'
                        || LTRIM (RTRIM (a.npo_sf)),
                        a.acc_date, a.conf_date, a.acc_date,
                        SUBSTR (a.prim, 1, 240), a.kol_dn, a.nom_zd,
                        a.base_numb, a.num_dog, d.ID, 1, a.sender, a.num_kvit,
                        a.conf_numb,
                        DECODE (SIGN (a.sved_num - 9999999999),
                                1, 0,
                                a.sved_num
                               ),
                        a.sum_total, 0, 0, 0, 0, 0, 0, 0, 0, 0
                   FROM v_dicaccfo_sf a, kls_dog d
                  WHERE a.nom_dok = bills_parus.nom_dok AND a.num_dog = d.short_number(+))
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (SELECT a.nom_dok
                       FROM v_dicaccfo_sf a
                      WHERE a.nom_dok = bills_parus.nom_dok);

      COMMIT;

      -- Добавление связей договоров
      INSERT INTO kls_dog_parus
                  (base_numb, dog_id)
         SELECT DISTINCT a.base_numb, d.ID
                    FROM v_dicaccfo_sf a, kls_dog d
                   WHERE NOT EXISTS (SELECT NULL
                                       FROM kls_dog_parus c
                                      WHERE a.base_numb = c.base_numb)
                     AND a.num_dog = d.short_number(+);

      COMMIT;

      -- Добавление счетов
      INSERT INTO bills_parus
                  (nom_dok, pref_sf, nom_sf, npo_sf, date_vyp_sf, date_kvit,
                   date_buxg, prim, kol_dn, nom_zd, base_numb, num_dog,
                   dog_id, usl_number, sender, num_kvit, conf_numb, sved_num,
                   summa_dok, summa_prod, summa_prod_nds, summa_akciz,
                   summa_gsm, summa_tarif, summa_tarif_nds, summa_vozn,
                   summa_vozn_nds, summa_strah)
         SELECT a.nom_dok, a.pref_sf, a.npo_sf,
                LTRIM (RTRIM (a.pref_sf)) || '/' || LTRIM (RTRIM (a.npo_sf)),
                a.acc_date, a.conf_date, a.acc_date, SUBSTR (a.prim, 1, 240),
                a.kol_dn, a.nom_zd, a.base_numb, a.num_dog, d.ID, 1, a.sender,
                a.num_kvit, a.conf_numb,
                DECODE (SIGN (a.sved_num - 9999999999), 1, 0, a.sved_num),
                a.sum_total, 0, 0, 0, 0, 0, 0, 0, 0, 0
           FROM v_dicaccfo_sf a, kls_dog d
          WHERE NOT EXISTS (SELECT nom_dok
                              FROM bills_parus c
                             WHERE a.nom_dok = c.nom_dok) AND a.num_dog = d.short_number(+);

      COMMIT;
      -- Обновление позиций счетов
      renew_bill_pos_parus (date_beg, date_end, param1);

      -- Обновление продукта
      UPDATE /*+ RULE */bills_parus
         SET (prod_id_npr) =
                (SELECT MIN (a.prod_id_npr)
                   FROM bill_pos_parus a
                  WHERE a.nom_dok = bills_parus.nom_dok
                    AND a.bill_pos_parus_id = 1)
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.nom_dok
                  FROM bill_pos_parus a
                 WHERE a.nom_dok = bills_parus.nom_dok
                   AND a.bill_pos_parus_id = 1);

      -- Обновление сумм за продукт
      UPDATE /*+ RULE */bills_parus
         SET (summa_prod, summa_prod_nds, summa_akciz, summa_gsm) =
                (SELECT SUM (a.summa), SUM (a.summa_nds20),
                        SUM (a.summa_akciz), SUM (a.summa_gsm25)
                   FROM bill_pos_parus a
                  WHERE a.nom_dok = bills_parus.nom_dok
                    AND a.bill_pos_parus_id = 1)
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.nom_dok
                  FROM bill_pos_parus a
                 WHERE a.nom_dok = bills_parus.nom_dok
                   AND a.bill_pos_parus_id = 1);

      -- Обновление сумм-тариф
      UPDATE /*+ RULE */bills_parus
         SET (summa_tarif, summa_tarif_nds) =
                (SELECT SUM (a.summa), SUM (a.summa_nds20)
                   FROM bill_pos_parus a
                  WHERE a.nom_dok = bills_parus.nom_dok
                    AND a.bill_pos_parus_id = 10)
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.nom_dok
                  FROM bill_pos_parus a
                 WHERE a.nom_dok = bills_parus.nom_dok
                   AND a.bill_pos_parus_id = 10);

      -- Обновление сумм-вознаграждение
      UPDATE /*+ RULE */bills_parus
         SET (summa_vozn, summa_vozn_nds) =
                (SELECT SUM (a.summa), SUM (a.summa_nds20)
                   FROM bill_pos_parus a
                  WHERE a.nom_dok = bills_parus.nom_dok
                    AND (a.bill_pos_parus_id = 11 OR a.bill_pos_parus_id = 12
                        ))
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.nom_dok
                  FROM bill_pos_parus a
                 WHERE a.nom_dok = bills_parus.nom_dok
                   AND (a.bill_pos_parus_id = 11 OR a.bill_pos_parus_id = 12
                       ));

      -- Обновление сумм-страховка
      UPDATE /*+ RULE */bills_parus
         SET (summa_strah) =
                (SELECT SUM (a.summa)
                   FROM bill_pos_parus a
                  WHERE a.nom_dok = bills_parus.nom_dok
                    AND a.bill_pos_parus_id = 20)
       WHERE bills_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.nom_dok
                  FROM bill_pos_parus a
                 WHERE a.nom_dok = bills_parus.nom_dok
                   AND a.bill_pos_parus_id = 20);

      COMMIT;

      -- Удаление счетов
      DELETE FROM bills_parus
            WHERE NOT EXISTS (SELECT nom_dok
                                FROM v_dicaccfo_sf a
                               WHERE a.nom_dok = bills_parus.nom_dok)
              AND bills_parus.date_vyp_sf BETWEEN date_beg AND date_end;

      COMMIT;
   END;

   PROCEDURE renew_bill_pos_parus (
      date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
      date_end   DATE := SYSDATE,
      param1     VARCHAR2 := '',
      param2     VARCHAR2 := '',
      param3     VARCHAR2 := ''
   )
   IS
      v_cnt   NUMBER;
   BEGIN
      IF date_beg IS NULL
      THEN
         RETURN;
      END IF;

      IF date_end IS NULL
      THEN
         RETURN;
      END IF;

      SELECT COUNT (*)
        INTO v_cnt
        FROM load_buffer.parus_diclacfo;

      IF v_cnt = 0
      THEN
         RETURN;
      END IF;

      -- Обновляем позиции счетов
      UPDATE bill_pos_parus
         SET (bill_pos_parus_id, prod_id_npr, date_otgr, ves, date_vyp_sf,
              cena_bn, cena, summa_bn, summa_akciz, summa_nds20, summa_gsm25,
              summa, food_rn, food_prn, food_code, food_type, food_name,
              mes_unit, mes_unit_name, pref_sf, nom_sf) =
                (SELECT a.bill_pos_parus_id, a.prod, a.conf_date, a.ves,
                        a.acc_date, a.cena_bn, a.cena, a.sum_bn, a.akciz,
                        a.sum_nds, a.gsm, a.sum_total, a.food_rn, a.food_prn,
                        a.food_code, a.food_type, a.food_name, a.mes_unit,
                        a.mes_unit_name, a.acc_pref_sf, a.acc_nom_sf
                   FROM v_diclacfo_pos a
                  WHERE a.nom_dok = bill_pos_parus.nom_dok
                    AND a.rn = bill_pos_parus.parus_rn)
       WHERE bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND EXISTS (
                SELECT a.rn
                  FROM v_diclacfo_pos a
                 WHERE a.nom_dok = bill_pos_parus.nom_dok
                   AND a.rn = bill_pos_parus.parus_rn);

      COMMIT;

      -- Добавляем позиции счетов
      INSERT INTO bill_pos_parus
                  (nom_dok, parus_rn, bill_pos_parus_id, date_otgr, ves,
                   date_vyp_sf, cena_bn, cena, summa_bn, summa_akciz,
                   summa_nds20, summa_gsm25, summa, prod_id_npr, food_rn,
                   food_prn, food_code, food_type, food_name, mes_unit,
                   mes_unit_name, pref_sf, nom_sf)
         SELECT a.nom_dok, a.rn, a.bill_pos_parus_id, a.conf_date, a.ves,
                a.acc_date, a.cena_bn, a.cena, a.sum_bn, a.akciz, a.sum_nds,
                a.gsm, a.sum_total, a.prod, a.food_rn, a.food_prn,
                a.food_code, a.food_type, a.food_name, a.mes_unit,
                a.mes_unit_name, a.acc_pref_sf, a.acc_nom_sf
           FROM v_diclacfo_pos a
          WHERE NOT EXISTS (SELECT c.nom_dok
                              FROM bill_pos_parus c
                             WHERE a.nom_dok = c.nom_dok AND a.rn = c.parus_rn);

      COMMIT;

      -- Обновляем позиции счетов (недостающий продукт для услуг 11)
      UPDATE bill_pos_parus
         SET (prod_id_npr, date_otgr, ves, date_vyp_sf, cena_bn, cena,
              summa_bn, summa_akciz, summa_nds20, summa_gsm25, summa, food_rn,
              food_prn, food_code, food_type, food_name, mes_unit,
              mes_unit_name, pref_sf, nom_sf) =
                (SELECT '10003', a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                        0, a.food_rn, a.food_prn, a.food_code, a.food_type,
                        a.food_name, a.mes_unit, a.mes_unit_name,
                        a.acc_pref_sf, a.acc_nom_sf
                   FROM v_diclacfo_pos a
                  WHERE a.nom_dok = bill_pos_parus.nom_dok
                    AND a.bill_pos_parus_id = 11
                    AND NOT EXISTS (
                           SELECT nom_dok
                             FROM v_diclacfo_pos b
                            WHERE b.nom_dok = bill_pos_parus.nom_dok
                              AND b.bill_pos_parus_id = 1))
       WHERE bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND bill_pos_parus.bill_pos_parus_id = 1
         AND EXISTS (
                SELECT a.nom_dok
                  FROM v_diclacfo_pos a
                 WHERE a.nom_dok = bill_pos_parus.nom_dok
                   AND a.bill_pos_parus_id = 11
                   AND NOT EXISTS (
                          SELECT nom_dok
                            FROM v_diclacfo_pos b
                           WHERE b.nom_dok = bill_pos_parus.nom_dok
                             AND b.bill_pos_parus_id = 1));

      COMMIT;

      -- Добавляем позиции счетов (недостающий продукт для услуг 11)
      INSERT INTO bill_pos_parus
                  (nom_dok, parus_rn, bill_pos_parus_id, date_otgr, ves,
                   date_vyp_sf, cena_bn, cena, summa_bn, summa_akciz,
                   summa_nds20, summa_gsm25, summa, prod_id_npr, food_rn,
                   food_prn, food_code, food_type, food_name, mes_unit,
                   mes_unit_name, pref_sf, nom_sf)
         SELECT a.nom_dok, 0, 1, a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                0, '10003', a.food_rn, a.food_prn, a.food_code, a.food_type,
                a.food_name, a.mes_unit, a.mes_unit_name, a.acc_pref_sf,
                a.acc_nom_sf
           FROM v_diclacfo_pos a
          WHERE a.bill_pos_parus_id = 11
            AND NOT EXISTS (
                       SELECT c.nom_dok
                         FROM bill_pos_parus c
                        WHERE c.nom_dok = a.nom_dok
                              AND c.bill_pos_parus_id = 1);

      COMMIT;

      -- Обновляем позиции счетов (недостающий продукт для услуг 12)
      UPDATE bill_pos_parus
         SET (prod_id_npr, date_otgr, ves, date_vyp_sf, cena_bn, cena,
              summa_bn, summa_akciz, summa_nds20, summa_gsm25, summa, food_rn,
              food_prn, food_code, food_type, food_name, mes_unit,
              mes_unit_name, pref_sf, nom_sf) =
                (SELECT '10003', a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                        0, a.food_rn, a.food_prn, a.food_code, a.food_type,
                        a.food_name, a.mes_unit, a.mes_unit_name,
                        a.acc_pref_sf, a.acc_nom_sf
                   FROM v_diclacfo_pos a
                  WHERE a.nom_dok = bill_pos_parus.nom_dok
                    AND a.bill_pos_parus_id = 12
                    AND NOT EXISTS (
                           SELECT nom_dok
                             FROM v_diclacfo_pos b
                            WHERE b.nom_dok = bill_pos_parus.nom_dok
                              AND b.bill_pos_parus_id = 1))
       WHERE bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND bill_pos_parus.bill_pos_parus_id = 1
         AND EXISTS (
                SELECT a.nom_dok
                  FROM v_diclacfo_pos a
                 WHERE a.nom_dok = bill_pos_parus.nom_dok
                   AND a.bill_pos_parus_id = 12
                   AND NOT EXISTS (
                          SELECT nom_dok
                            FROM v_diclacfo_pos b
                           WHERE b.nom_dok = bill_pos_parus.nom_dok
                             AND b.bill_pos_parus_id = 1));

      COMMIT;

      -- Добавляем позиции счетов (недостающий продукт для услуг 12)
      INSERT INTO bill_pos_parus
                  (nom_dok, parus_rn, bill_pos_parus_id, date_otgr, ves,
                   date_vyp_sf, cena_bn, cena, summa_bn, summa_akciz,
                   summa_nds20, summa_gsm25, summa, prod_id_npr, food_rn,
                   food_prn, food_code, food_type, food_name, mes_unit,
                   mes_unit_name, pref_sf, nom_sf)
         SELECT a.nom_dok, 0, 1, a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                0, '10003', a.food_rn, a.food_prn, a.food_code, a.food_type,
                a.food_name, a.mes_unit, a.mes_unit_name, a.acc_pref_sf,
                a.acc_nom_sf
           FROM v_diclacfo_pos a
          WHERE a.bill_pos_parus_id = 12
            AND NOT EXISTS (
                       SELECT c.nom_dok
                         FROM bill_pos_parus c
                        WHERE c.nom_dok = a.nom_dok
                              AND c.bill_pos_parus_id = 1);

      COMMIT;

      -- Обновляем позиции счетов (недостающий продукт для тарифа)
      UPDATE bill_pos_parus
         SET (prod_id_npr, date_otgr, ves, date_vyp_sf, cena_bn, cena,
              summa_bn, summa_akciz, summa_nds20, summa_gsm25, summa, food_rn,
              food_prn, food_code, food_type, food_name, mes_unit,
              mes_unit_name, pref_sf, nom_sf) =
                (SELECT '10006', a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                        0, a.food_rn, a.food_prn, a.food_code, a.food_type,
                        a.food_name, a.mes_unit, a.mes_unit_name,
                        a.acc_pref_sf, a.acc_nom_sf
                   FROM v_diclacfo_pos a
                  WHERE a.nom_dok = bill_pos_parus.nom_dok
                    AND a.bill_pos_parus_id = 10
                    AND NOT EXISTS (
                           SELECT nom_dok
                             FROM v_diclacfo_pos b
                            WHERE b.nom_dok = bill_pos_parus.nom_dok
                              AND b.bill_pos_parus_id = 1))
       WHERE bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND bill_pos_parus.bill_pos_parus_id = 1
         AND EXISTS (
                SELECT a.nom_dok
                  FROM v_diclacfo_pos a
                 WHERE a.nom_dok = bill_pos_parus.nom_dok
                   AND a.bill_pos_parus_id = 10
                   AND NOT EXISTS (
                          SELECT nom_dok
                            FROM v_diclacfo_pos b
                           WHERE b.nom_dok = bill_pos_parus.nom_dok
                             AND b.bill_pos_parus_id = 1));

      COMMIT;

      -- Добавляем позиции счетов (недостающий продукт для тарифа)
      INSERT INTO bill_pos_parus
                  (nom_dok, parus_rn, bill_pos_parus_id, date_otgr, ves,
                   date_vyp_sf, cena_bn, cena, summa_bn, summa_akciz,
                   summa_nds20, summa_gsm25, summa, prod_id_npr, food_rn,
                   food_prn, food_code, food_type, food_name, mes_unit,
                   mes_unit_name, pref_sf, nom_sf)
         SELECT a.nom_dok, 0, 1, a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                0, '10006', a.food_rn, a.food_prn, a.food_code, a.food_type,
                a.food_name, a.mes_unit, a.mes_unit_name, a.acc_pref_sf,
                a.acc_nom_sf
           FROM v_diclacfo_pos a
          WHERE a.bill_pos_parus_id = 10
            AND NOT EXISTS (
                       SELECT c.nom_dok
                         FROM bill_pos_parus c
                        WHERE c.nom_dok = a.nom_dok
                              AND c.bill_pos_parus_id = 1);

      COMMIT;

      -- Обновляем позиции счетов (недостающий продукт для страховки)
      UPDATE bill_pos_parus
         SET (prod_id_npr, date_otgr, ves, date_vyp_sf, cena_bn, cena,
              summa_bn, summa_akciz, summa_nds20, summa_gsm25, summa, food_rn,
              food_prn, food_code, food_type, food_name, mes_unit,
              mes_unit_name, pref_sf, nom_sf) =
                (SELECT '10001', a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                        0, a.food_rn, a.food_prn, a.food_code, a.food_type,
                        a.food_name, a.mes_unit, a.mes_unit_name,
                        a.acc_pref_sf, a.acc_nom_sf
                   FROM v_diclacfo_pos a
                  WHERE a.nom_dok = bill_pos_parus.nom_dok
                    AND a.bill_pos_parus_id = 20
                    AND NOT EXISTS (
                           SELECT nom_dok
                             FROM v_diclacfo_pos b
                            WHERE b.nom_dok = bill_pos_parus.nom_dok
                              AND b.bill_pos_parus_id = 1))
       WHERE bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end
         AND bill_pos_parus.bill_pos_parus_id = 1
         AND EXISTS (
                SELECT a.nom_dok
                  FROM v_diclacfo_pos a
                 WHERE a.nom_dok = bill_pos_parus.nom_dok
                   AND a.bill_pos_parus_id = 20
                   AND NOT EXISTS (
                          SELECT nom_dok
                            FROM v_diclacfo_pos b
                           WHERE b.nom_dok = bill_pos_parus.nom_dok
                             AND b.bill_pos_parus_id = 1));

      COMMIT;

      -- Добавляем позиции счетов (недостающий продукт для услуг)
      INSERT INTO bill_pos_parus
                  (nom_dok, parus_rn, bill_pos_parus_id, date_otgr, ves,
                   date_vyp_sf, cena_bn, cena, summa_bn, summa_akciz,
                   summa_nds20, summa_gsm25, summa, prod_id_npr, food_rn,
                   food_prn, food_code, food_type, food_name, mes_unit,
                   mes_unit_name, pref_sf, nom_sf)
         SELECT a.nom_dok, 0, 1, a.conf_date, 0, a.acc_date, 0, 0, 0, 0, 0, 0,
                0, '10001', a.food_rn, a.food_prn, a.food_code, a.food_type,
                a.food_name, a.mes_unit, a.mes_unit_name, a.acc_pref_sf,
                a.acc_nom_sf
           FROM v_diclacfo_pos a
          WHERE a.bill_pos_parus_id = 20
            AND NOT EXISTS (
                       SELECT c.nom_dok
                         FROM bill_pos_parus c
                        WHERE c.nom_dok = a.nom_dok
                              AND c.bill_pos_parus_id = 1);

      COMMIT;

      -- Удаление позиций счетов
      DELETE FROM bill_pos_parus
            WHERE NOT EXISTS (SELECT prn
                                FROM v_diclacfo_pos a
                               WHERE a.nom_dok = bill_pos_parus.nom_dok)
              AND bill_pos_parus.date_vyp_sf BETWEEN date_beg AND date_end;

      COMMIT;
   END;

   PROCEDURE update_snapshots_reqv
   IS
   BEGIN
      UPDATE load_buffer.parus_dicaccfo a
         SET (a.num_kvit, a.sved_num, a.num_dog) =
                (SELECT get_num_kvit (a.prim), get_num_sved (a.conf_numb),
                        get_num_dog (a.base_numb)
                   FROM DUAL);

      COMMIT;

      INSERT INTO kls_prod_nomenklator
                  (modif, name_pr, name_group, parus_rn, parus_prn)
         SELECT food_code, food_name, food_name, food_rn, food_prn
           FROM (SELECT DISTINCT food_code AS food_code, food_name,
                                 NVL (food_rn, 0) AS food_rn,
                                 NVL (food_prn, 0) AS food_prn
                            FROM load_buffer.v_diclacfo) b
          WHERE NOT EXISTS (
                     SELECT *
                       FROM kls_prod_nomenklator a
                      WHERE a.parus_rn = b.food_rn
                            AND a.parus_prn = b.food_prn);

      UPDATE kls_prod_nomenklator
         SET prod = '10010'
       WHERE (prod IS NULL OR prod = '     ')
         AND (NLS_UPPER (modif) = 'Ж/Д ТАРИФ' OR NLS_UPPER (modif) =
                                                                    'ЖДУСЛУГА'
             );

      UPDATE kls_prod_nomenklator
         SET prod = '10092'
       WHERE (prod IS NULL OR prod = '     ')
         AND (   NLS_UPPER (modif) = 'ЗА ТРАНСПОРТИРОВКУ'
              OR NLS_UPPER (modif) = 'УСЛ. ПО ПРЕД.ЦИСТЕРН'
             );

      UPDATE kls_prod_nomenklator
         SET prod = '10020'
       WHERE (prod IS NULL OR prod = '     ')
         AND NLS_UPPER (modif) = 'СТРАХОВКА_ГР';

      UPDATE kls_prod_nomenklator
         SET prod = '10011'
       WHERE (prod IS NULL OR prod = '     ')
         AND NLS_UPPER (modif) = 'ВОЗНАГРАЖДЕНИЕ';

      COMMIT;
   END update_snapshots_reqv;

   FUNCTION str2num (ins VARCHAR2, l NUMBER)
      RETURN NUMBER
   IS
      v_tmp   NUMBER;
      s       VARCHAR (240);
   BEGIN
      s := SUBSTR (ins, l, 240);
      s :=
         TRANSLATE
            (s,
             'QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁйцукенгшщзхъфывапролджэячсмитьбюё`~!@#$%^&*()_+-=|\:";<>?/.,[]{}№''',
             '                                                                                                                                                           '
            );
      s := LTRIM (RTRIM (s));
      v_tmp := INSTR (s, ' ');

      IF v_tmp > 0
      THEN
         RETURN TO_NUMBER (SUBSTR (s, 1, v_tmp - 1));
      ELSE
         RETURN TO_NUMBER (s);
      END IF;
   EXCEPTION
     WHEN OTHERS THEN
	  RETURN 0;  	  
   END str2num;

   FUNCTION get_num_kvit (prim VARCHAR2)
      RETURN NUMBER
   IS
-- Определение номера квитанции из комментария исходящего счета из ПАРУСА
      CURSOR tmp_cur
      IS
         SELECT   LENGTH (RTRIM (LTRIM (pref_name))) AS len1, pref_name
             FROM ktu_2_npo_pref_kvit
         ORDER BY len1 DESC;

      v_num_kvit     NUMBER;
      v_comment      VARCHAR2 (240);
      v_pref_name0   VARCHAR2 (240);
      v_pref_name1   VARCHAR2 (240);
      v_len0         NUMBER;
      v_len1         NUMBER;
   BEGIN
      v_num_kvit := 0;
      v_comment := UPPER (RTRIM (LTRIM (prim)));

      WHILE INSTR (v_comment, '  ') > 0
      LOOP
         v_comment := REPLACE (v_comment, '  ', ' ');
      END LOOP;

      -- Перебор префиксов
      FOR lcur IN tmp_cur
      LOOP
         v_pref_name0 := UPPER (RTRIM (LTRIM (lcur.pref_name)));
         v_len0 := LENGTH (v_pref_name0);

         IF SUBSTR (v_comment, 1, v_len0 + 1) = (v_pref_name0 || '.')
         THEN
            v_num_kvit := str2num (v_comment, v_len0 + 2);
            EXIT;
         END IF;

         IF SUBSTR (v_comment, 1, v_len0) = (v_pref_name0)
         THEN
            v_num_kvit := str2num (v_comment, v_len0 + 1);
            EXIT;
         END IF;

         v_pref_name1 := RTRIM (LTRIM (REPLACE (v_pref_name0, ' ', '.')));
         v_len1 := LENGTH (v_pref_name1);

         IF SUBSTR (v_comment, 1, v_len1 + 1) = (v_pref_name1 || '.')
         THEN
            v_num_kvit := str2num (v_comment, v_len1 + 2);
            EXIT;
         END IF;

         IF SUBSTR (v_comment, 1, v_len1) = (v_pref_name1)
         THEN
            v_num_kvit := str2num (v_comment, v_len1 + 1);
            EXIT;
         END IF;

         v_pref_name1 := RTRIM (LTRIM (REPLACE (v_pref_name0, ' ', '')));
         v_len1 := LENGTH (v_pref_name1);

         IF SUBSTR (v_comment, 1, v_len1 + 1) = (v_pref_name1 || '.')
         THEN
            v_num_kvit := str2num (v_comment, v_len1 + 2);
            EXIT;
         END IF;

         IF SUBSTR (v_comment, 1, v_len1) = (v_pref_name1)
         THEN
            v_num_kvit := str2num (v_comment, v_len1 + 1);
            EXIT;
         END IF;
      END LOOP;

      RETURN v_num_kvit;
   END;

   FUNCTION get_num_sved (prim VARCHAR2)
      RETURN NUMBER
   IS
-- Определение номера сведения из исходящего счета из ПАРУСА
      CURSOR tmp_cur
      IS
         SELECT   LENGTH (RTRIM (LTRIM (pref_name))) AS len1, pref_name
             FROM ktu_2_npo_pref_sved
         ORDER BY len1 DESC;

      v_np           NUMBER;
      v_comment      VARCHAR2 (240);
      v_pref_name0   VARCHAR2 (240);
      v_len0         NUMBER;
   BEGIN
      v_np := 0;
      v_comment := UPPER (RTRIM (LTRIM (prim)));

      -- Перебор префиксов
      FOR lcur IN tmp_cur
      LOOP
         v_pref_name0 := UPPER (RTRIM (LTRIM (lcur.pref_name)));
         v_len0 := LENGTH (v_pref_name0);

         IF SUBSTR (v_comment, 1, v_len0) = (v_pref_name0)
         THEN
            v_np := str2num (v_comment, v_len0 + 1);
            EXIT;
         END IF;
      END LOOP;

      RETURN v_np;
   END;

   FUNCTION get_num_dog (base_numb VARCHAR2)
      RETURN VARCHAR2
   IS
      v_tmp       VARCHAR2 (240);
      i1          NUMBER;
      i2          NUMBER;
      i3          NUMBER;
      v_ss        VARCHAR2 (240);
      v_luk_dog   VARCHAR2 (240);
      v_cnt       NUMBER;
      isfound     BOOLEAN;
   BEGIN
      v_tmp := UPPER (LTRIM (RTRIM (base_numb)));
      i1 := INSTR (v_tmp, '(', 1, 1);

      IF i1 > 0
      THEN
         v_tmp := LTRIM (RTRIM (SUBSTR (v_tmp, 1, i1 - 1)));
      END IF;

      IF v_tmp = 'СНП-020031209'
      THEN
         v_tmp := 'СНП-020021209';
      END IF;

      v_tmp := REPLACE (v_tmp, 'СНП ', 'СНП-');
      v_tmp := REPLACE (v_tmp, 'CНП ', 'СНП-');
      v_tmp := REPLACE (v_tmp, 'КМС', '');
      i1 := INSTR (v_tmp, '-', 1, 1);
      i2 := INSTR (v_tmp, '/', 1, 1);
      i3 := INSTR (v_tmp, '/', 1, 2);

      IF i3 > 0
      THEN
         v_ss := SUBSTR (v_tmp, i2 + 1, i3 - i2 - 1);

         IF v_ss = '80'
         THEN
            v_ss := '080';
         END IF;

         v_luk_dog := SUBSTR (v_tmp, i1 + 1, i2 - i1 - 1) || '/' || v_ss;
      ELSE
         v_luk_dog := SUBSTR (v_tmp, i1 + 1, 240);
      END IF;

      isfound := FALSE;

      SELECT COUNT (*)
        INTO v_cnt
        FROM kls_dog
       WHERE kls_dog.short_number = v_luk_dog;

      isfound := (v_cnt > 0);

      IF NOT isfound
      THEN
         IF SUBSTR (v_luk_dog, 7, 1) <> '/'
         THEN
            v_ss :=
                   SUBSTR (v_luk_dog, 1, 6) || '/'
                   || SUBSTR (v_luk_dog, 7, 3);

            SELECT COUNT (*)
              INTO v_cnt
              FROM kls_dog
             WHERE kls_dog.short_number = v_ss;

            isfound := (v_cnt > 0);

            IF NOT isfound
            THEN
               IF SUBSTR (v_luk_dog, 1, 5) = '02021'
               THEN
                  v_luk_dog := '020021' || SUBSTR (v_luk_dog, 6, 240);
                  v_ss :=
                        SUBSTR (v_luk_dog, 1, 6)
                     || '/'
                     || SUBSTR (v_luk_dog, 7, 4);

                  SELECT COUNT (*)
                    INTO v_cnt
                    FROM kls_dog
                   WHERE kls_dog.short_number = v_ss;

                  isfound := (v_cnt > 0);

                  IF NOT isfound
                  THEN
                     v_luk_dog := ' ';
                  ELSE
                     v_luk_dog := v_ss;
                  END IF;
               END IF;
            ELSE
               v_luk_dog := v_ss;
            END IF;
         END IF;
      END IF;

      IF isfound
      THEN
         RETURN v_luk_dog;
      ELSE
         RETURN NULL;
      END IF;
   END;

   FUNCTION get_dog_id (base_numb VARCHAR2)
      RETURN NUMBER
   IS
      v_luk_dog   VARCHAR2 (240);
      v_id        NUMBER;
   BEGIN
      v_luk_dog := get_num_dog (base_numb);

      IF v_luk_dog IS NOT NULL
      THEN
         SELECT ID
           INTO v_id
           FROM kls_dog
          WHERE kls_dog.short_number = v_luk_dog;

         RETURN v_id;
      ELSE
         RETURN NULL;
      END IF;
   END;
END;
/

