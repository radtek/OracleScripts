--
-- RENEW_MOVEPROD_OST  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_moveprod_ost (
   date_beg DATE:= TRUNC (SYSDATE, 'MONTH'),
   date_end DATE:= SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
   s_tmp    NUMBER;
   s_tmp1   NUMBER;
   s_tmp2   NUMBER;
BEGIN
--Удаляем
   DELETE FROM moveprod_ost
         WHERE MONTH = date_end;

   COMMIT;

-- Проход по остаткам и списание остатков
   FOR rec1 IN (SELECT   /*+ FIRST_ROWS */
                         prod_id_npr, q_all, period, oper
                    FROM moveprod_ost
                   WHERE MONTH = date_beg
                ORDER BY prod_id_npr, period)
   LOOP
      s_tmp := 0;

      IF rec1.oper = 0
      THEN                                                  -- Просто остатки
         SELECT /*+ FIRST_ROWS */
                SUM (m.quan)
           INTO s_tmp
           FROM moveprod m
          WHERE m.oper IN (3, 4, 2)
            AND m.period = rec1.period
            AND m.prod_id_npr = rec1.prod_id_npr
			AND m.month=date_beg;
      ELSE                                               --Остатки на хранении
         SELECT /*+ FIRST_ROWS */
                SUM (m.quan)
           INTO s_tmp
           FROM moveprod m
          WHERE m.oper = 9
            AND m.period = rec1.period
            AND m.prod_id_npr = rec1.prod_id_npr
			AND m.month=date_beg;
      END IF;

      INSERT INTO MASTER.moveprod_ost
                  (prod_id_npr, q_all,
                   period, oper, MONTH
                  )
           VALUES (rec1.prod_id_npr, rec1.q_all - NVL (s_tmp, 0),
                   rec1.period, rec1.oper, date_end
                  );
   END LOOP;

   COMMIT;

-- Проход по отгрузке и формирование новых остатков
   FOR rec3 IN (SELECT   /*+ FIRST_ROWS */
                         prod_id_npr, SUM (quan) AS q_all, period,
                         DECODE (suboper, 10, 1, 0) AS oper, MONTH
                    FROM moveprod
                   WHERE ((oper = 1) OR (oper = 2)) AND month=date_beg
                GROUP BY prod_id_npr,
                         period,
                         DECODE (suboper, 10, 1, 0),
                         MONTH)
   LOOP
      s_tmp := 0;
      s_tmp1 := 0;
      s_tmp2 := 0;

      IF rec3.oper = 0
      THEN                                                  -- Просто остатки
         SELECT /*+ FIRST_ROWS */
                SUM (m.quan)
           INTO s_tmp
           FROM moveprod m
          WHERE m.oper IN (3, 9)
            AND m.period = rec3.period
            AND m.prod_id_npr = rec3.prod_id_npr
			AND m.month=date_beg;

         --Остатки на хранении
         SELECT /*+ FIRST_ROWS */
                SUM (m.quan)
           INTO s_tmp2
           FROM moveprod m
          WHERE m.oper = 2
            AND m.period = rec3.period
            AND m.prod_id_npr = rec3.prod_id_npr
			AND m.month=date_beg;
      END IF;

      SELECT /*+ FIRST_ROWS */
             SUM (m.q_all)
        INTO s_tmp1
        FROM moveprod_ost m
       WHERE m.oper = rec3.oper
         AND m.period = rec3.period
         AND m.prod_id_npr = rec3.prod_id_npr
         AND m.MONTH = date_end;

      IF NVL (s_tmp1, 0) <> 0
      THEN
         UPDATE moveprod_ost m
            SET m.q_all = rec3.q_all + s_tmp1
          WHERE m.oper = rec3.oper
            AND m.period = rec3.period
            AND m.prod_id_npr = rec3.prod_id_npr
            AND m.MONTH = date_end;
      ELSE
         INSERT INTO MASTER.moveprod_ost
                     (prod_id_npr,
                      q_all,
                      period, oper, MONTH
                     )
              VALUES (rec3.prod_id_npr,
                      rec3.q_all - NVL (s_tmp, 0) - NVL (s_tmp2, 0),
                      rec3.period, rec3.oper, date_end
                     );
      END IF;
   END LOOP;

   COMMIT;

-- убираем записи с пустым количеством
   DELETE FROM moveprod_ost
         WHERE q_all = 0;

   COMMIT;
END renew_moveprod_ost;

/

