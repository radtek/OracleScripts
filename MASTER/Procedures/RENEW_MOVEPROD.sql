--
-- RENEW_MOVEPROD  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_moveprod (
   date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
   date_end   DATE := SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
BEGIN
-- Удаляем
   DELETE FROM moveprod
   WHERE month=date_beg;

   COMMIT;

--- Добавляем производство
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re)
      (SELECT /*+ FIRST_ROWS */
              date_beg, 1, 1, dayly_fact.prod, dayly_fact.proizv, date_beg,
              '', '', '', '', 1, '', '', dayly_fact.kod, 0
         FROM dayly_fact
        WHERE dayly_fact.DATA = TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY'))
          AND dayly_fact.sobstv = 8
          AND dayly_fact.proizv > 0.0001);

   COMMIT;

--- Добавляем отгрузку по счетам(включая экспорт)
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re, date_oforml)
      (SELECT /*+ rule */ /* FIRST_ROWS INDEX (b BILLS_PK) */
              date_beg, 3, 2, kv.prod_id_npr, kv.ves, date_beg, '', b.nom_dok,
              d.predpr_id, b.date_kvit, DECODE (m.nazn_otg_id, 5, 4, 1),
              kv.num_kvit, kv.num_cist, kv.ID, 0, kv.date_oforml
         FROM bills b,
              (SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_oforml
                 FROM kvit
                WHERE prod_id_npr <> '90000'
               UNION ALL
               SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_oforml
                 FROM dop_kvit
                WHERE prod_id_npr <> '90000') kv,
              MONTH m,
              kls_dog d
        WHERE b.nom_dok = kv.bill_id
          AND kv.nom_zd = m.nom_zd
          AND b.dog_id = d.ID
          AND m.nazn_otg_id <> 9
          AND m.nazn_otg_id <> 10
          AND m.nazn_otg_id <> 8
          AND ABS (kv.ves) > 0.0001
          AND b.date_vyp_sf BETWEEN date_beg AND TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));

   COMMIT;

--- Добавляем отгрузку экспорт
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re, date_oforml)
      (SELECT date_beg, 3, 3, kv.prod_id_npr, kv.ves, date_beg, '', '',
              d.predpr_id, kv.date_kvit, 4, kv.num_kvit, kv.num_cist, kv.ID,
              0, kv.date_oforml
         FROM (SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_kvit, date_oforml
                 FROM kvit
                WHERE prod_id_npr <> '90000') kv,
              MONTH m,
              kls_dog d
        WHERE kv.nom_zd = m.nom_zd
          AND m.dog_id = d.ID
          AND m.nazn_otg_id = 5
          AND ABS (kv.ves) > 0.0001
          AND (kv.bill_id IS NULL OR kv.bill_id = 0)
          AND kv.date_kvit BETWEEN date_beg AND TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));

   COMMIT;

--- Добавляем отгрузку на собственные нужды
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re, date_oforml)
      (SELECT date_beg, 3, 4, kv.prod_id_npr, kv.ves, date_beg, '', '',
              d.predpr_id, kv.date_kvit, 5, kv.num_kvit, kv.num_cist, kv.ID,
              0, kv.date_oforml
         FROM (SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_kvit, date_oforml
                 FROM kvit
                WHERE prod_id_npr <> '90000') kv,
              MONTH m,
              kls_dog d
        WHERE kv.nom_zd = m.nom_zd
          AND m.dog_id = d.ID
          AND m.nazn_otg_id <> 5
          AND m.nazn_otg_id <> 8
          AND m.poluch_id = 8
          AND ABS (kv.ves) > 0.0001
          AND (kv.bill_id IS NULL OR kv.bill_id = 0)
          AND kv.date_kvit BETWEEN date_beg AND TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));

   COMMIT;

--- Добавляем отгрузку на хранение
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re, date_oforml)
      (SELECT date_beg, 2, 5, kv.prod_id_npr, kv.ves, date_beg, '', '',
              d.predpr_id, kv.date_kvit, 10, kv.num_kvit, kv.num_cist, kv.ID,
              0, kv.date_oforml
         FROM (SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_kvit, date_oforml
                 FROM kvit
                WHERE prod_id_npr <> '90000') kv,
              MONTH m,
              kls_dog d
        WHERE kv.nom_zd = m.nom_zd
          AND m.dog_id = d.ID
          AND m.nazn_otg_id = 8
          AND ABS (kv.ves) > 0.0001
          AND (kv.bill_id IS NULL OR kv.bill_id = 0)
          AND kv.date_kvit BETWEEN date_beg AND TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));

   COMMIT;

--- Добавляем отгрузку с хранения
   INSERT INTO MASTER.moveprod
               (MONTH, oper, kind, prod_id_npr, quan, period, buyinvc,
                idinvoice, idclient, selldate, suboper, num_kvit, num_cist,
                ID, is_re, date_oforml)
      (SELECT /*+ FIRST_ROWS INDEX (b BILLS_PK) */
              date_beg, 9, 6, kv.prod_id_npr, kv.ves, date_beg, '', b.nom_dok,
              d.predpr_id, b.date_kvit, 9, kv.num_kvit, kv.num_cist, kv.ID, 0,
              kv.date_oforml
         FROM bills b,
              (SELECT /*+ PARALLEL (kvit 2) */
                      nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_oforml
                 FROM kvit
                WHERE prod_id_npr <> '90000'
               UNION ALL
               SELECT nom_zd, prod_id_npr, ves, num_kvit, num_cist, bill_id,
                      ID, date_oforml
                 FROM dop_kvit
                WHERE prod_id_npr <> '90000') kv,
              MONTH m,
              kls_dog d
        WHERE b.nom_dok = kv.bill_id
          AND kv.nom_zd = m.nom_zd
          AND b.dog_id = d.ID
          AND m.nazn_otg_id = 9
          AND ABS (kv.ves) > 0.0001
          AND b.date_vyp_sf BETWEEN date_beg AND TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));

   COMMIT;
END renew_moveprod; 
/

