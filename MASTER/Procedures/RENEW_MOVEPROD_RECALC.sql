--
-- RENEW_MOVEPROD_RECALC  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_moveprod_recalc (
   date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
   date_end   DATE := SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
   np      VARCHAR2 (5);
   q_all   NUMBER;
   per     DATE;
   s_tmp   NUMBER;
   q_n     NUMBER;
   q_o     NUMBER;
BEGIN
   FOR rec1 IN (SELECT   prod_id_npr, q_all, period, oper, MONTH
                    FROM moveprod_ost
                   WHERE MONTH = date_beg
                ORDER BY prod_id_npr, period)
   LOOP
      np := rec1.prod_id_npr;
      q_all := rec1.q_all;
      per := rec1.period;
      s_tmp := 0;

      IF rec1.oper = 1
      THEN
         FOR rec2 IN (SELECT   /*+ FIRST_ROWS */
                               MONTH, oper, kind, prod_id_npr, quan, period,
                               buyinvc, idinvoice, idclient, selldate,
                               suboper, num_kvit, num_cist, is_re, ID,
                               moveprod_id, date_oforml
                          FROM moveprod
                         WHERE prod_id_npr = np AND oper = 9 AND is_re = 0 AND month = date_beg
                      ORDER BY date_oforml,
                               num_kvit,
                               ID,
                               SIGN (quan * -1),
                               idinvoice)
         LOOP
            IF s_tmp < q_all
            THEN
               s_tmp := s_tmp + rec2.quan;

               IF s_tmp > q_all
               THEN
                  BEGIN
                     q_n := s_tmp - q_all;
                     q_o := rec2.quan - q_n;

                     UPDATE moveprod
                        SET is_re = 1,
                            period = per,
                            quan = q_o
                      WHERE moveprod_id = rec2.moveprod_id;

                     INSERT INTO moveprod
                                 (MONTH, oper, kind,
                                  prod_id_npr, quan, period,
                                  buyinvc, idinvoice,
                                  idclient, selldate, suboper,
                                  num_kvit, num_cist, is_re, ID,
                                  date_oforml
                                 )
                          VALUES (rec2.MONTH, rec2.oper, rec2.kind,
                                  rec2.prod_id_npr, q_n, rec2.period,
                                  rec2.buyinvc, rec2.idinvoice,
                                  rec2.idclient, rec2.selldate, rec2.suboper,
                                  rec2.num_kvit, rec2.num_cist, 0, rec2.ID,
                                  rec2.date_oforml
                                 );
                  END;
               ELSE
                  UPDATE moveprod
                     SET is_re = 1,
                         period = per
                   WHERE moveprod_id = rec2.moveprod_id;
               END IF;
            END IF;
         END LOOP;
      ELSE
         FOR rec3 IN (SELECT   /*+ FIRST_ROWS */
                               MONTH, oper, kind, prod_id_npr, quan, period,
                               buyinvc, idinvoice, idclient, selldate,
                               suboper, num_kvit, num_cist, is_re, ID,
                               moveprod_id, date_oforml
                          FROM moveprod
                         WHERE prod_id_npr = np
                           AND (oper = 3 OR oper = 2)
                           AND is_re = 0
						   AND month = date_beg
                      ORDER BY date_oforml,
                               num_kvit,
                               ID,
                               SIGN (quan * -1),
                               idinvoice)
         LOOP
            IF s_tmp < q_all
            THEN
               s_tmp := s_tmp + rec3.quan;

               IF s_tmp > q_all
               THEN
                  BEGIN
                     q_n := s_tmp - q_all;
                     q_o := rec3.quan - q_n;

                     UPDATE moveprod
                        SET is_re = 1,
                            period = per,
                            quan = q_o
                      WHERE moveprod_id = rec3.moveprod_id;

                     INSERT INTO moveprod
                                 (MONTH, oper, kind,
                                  prod_id_npr, quan, period,
                                  buyinvc, idinvoice,
                                  idclient, selldate, suboper,
                                  num_kvit, num_cist, is_re, ID,
                                  date_oforml
                                 )
                          VALUES (rec3.MONTH, rec3.oper, rec3.kind,
                                  rec3.prod_id_npr, q_n, rec3.period,
                                  rec3.buyinvc, rec3.idinvoice,
                                  rec3.idclient, rec3.selldate, rec3.suboper,
                                  rec3.num_kvit, rec3.num_cist, 0, rec3.ID,
                                  rec3.date_oforml
                                 );
                  END;
               ELSE
                  UPDATE moveprod
                     SET is_re = 1,
                         period = per
                   WHERE moveprod_id = rec3.moveprod_id;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END LOOP;

   COMMIT;
END renew_moveprod_recalc;

/

