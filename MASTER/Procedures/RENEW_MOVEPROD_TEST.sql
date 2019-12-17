--
-- RENEW_MOVEPROD_TEST  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_moveprod_test (
   date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
   date_end   DATE := SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
BEGIN
-- Удаляем
   DELETE FROM SFDBF.moveprod_test
   WHERE month=date_beg;

   COMMIT;

INSERT INTO SFDBF.moveprod_test (month) values (TO_DATE(TO_CHAR(date_end,'DD.MM.YYYY')));
   
   
--- Добавляем производство
   INSERT INTO SFDBF.moveprod_test
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

END renew_moveprod_test;

/

