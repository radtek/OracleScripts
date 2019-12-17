--
-- RENEW_MOVEPROD_SFDBF  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_moveprod_sfdbf (
   date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
   date_end   DATE := SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
BEGIN
-- Удаляем
   DELETE FROM sfdbf.moveprod
         WHERE MONTH = date_beg;

   COMMIT;

   INSERT INTO sfdbf.moveprod
               (MONTH, idinvoice, quan, period, kvit_id, buyinvc)
      (SELECT MONTH, idinvoice, quan, period, ID, buyinvc
         FROM MASTER.moveprod
        WHERE oper <> 1 and month=date_beg);

   COMMIT;
END renew_moveprod_sfdbf;

/

