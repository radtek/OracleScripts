--
-- RENEW_OSTAT_NPZ  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.renew_ostat_npz (
   date_beg   DATE := TRUNC (SYSDATE, 'MONTH'),
   date_end   DATE := SYSDATE,
   param1     VARCHAR2 := '',
   param2     VARCHAR2 := '',
   param3     VARCHAR2 := ''
)
IS
   date_inc   DATE;
   new_db     DATE;
   new_de     DATE;
BEGIN
--- Определяем дату
   BEGIN
      SELECT DISTINCT a.dat_
                 INTO date_inc
                 FROM load_buffer.rs a;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20999, 'Пустой LOAD_BUFFER.RS');
      WHEN TOO_MANY_ROWS
      THEN
         raise_application_error (-20999, 'В LOAD_BUFFER.RS больше 1 даты');
      WHEN OTHERS
      THEN
         raise_application_error (-20999, 'Ошибка в LOAD_BUFFER.RS');
   END;

   new_db := TRUNC (date_inc, 'MONTH');
   new_de := date_inc;

-- Удаляем
   DELETE FROM ostat_npz
         WHERE npz_date = date_inc;

--- Добавляем
   INSERT INTO MASTER.ostat_npz
               (npz_date, sobstv_id, id_prod_npr, ost, pasp, otgr, hran,komp)
      (SELECT a.dat_, DECODE (a.vlad, 76,3722,61, 4281, 88,4293, 42,4294, 35, 1, 17, 10, 1, 8, 0),
              p.kod, a.ost, a.pasp, a.otgr - a.otgr_nhr + a.prod + a.otgr_shr,
              a.otgr_nhr - a.otgr_shr,a.KOMP
         FROM load_buffer.rs a, v_prod_ok p
        WHERE p.kod_10 = a.kod_okp);

-- Обновляем мертвые остатки
   UPDATE MASTER.ostat_npz
      SET m_ost =
             NVL ((SELECT SUM (MASTER.iif_num (a.vol,
                                               '<',
                                               a.dead_vol,
                                               a.vol,
                                               a.dead_vol
                                              )
                              )
                     FROM MASTER.v_arc_rez a
                    WHERE a.prod_id_npr = ostat_npz.id_prod_npr
                      AND a.dateupload = date_inc + 1
                      AND a.ar_tov_id = 1),
                  0
                 )
    WHERE ostat_npz.npz_date = date_inc AND ostat_npz.sobstv_id = 8;

   COMMIT;

-- Обновляем заявлено
   UPDATE MASTER.ostat_npz
      SET request =
             NVL ((SELECT SUM (a.tonn_declared)
                     FROM MASTER.MONTH a
                    WHERE a.prod_id_npr = ostat_npz.id_prod_npr
                      AND a.input_date BETWEEN new_db AND new_de),
                  0
                 )
    WHERE ostat_npz.npz_date = date_inc AND ostat_npz.sobstv_id = 8;

   COMMIT;

-- обновляем суточное производство
   UPDATE MASTER.dayly_fact
      SET MASTER.dayly_fact.ostat_tek = NVL (
             (SELECT NVL (MASTER.ostat_npz.ost, 0)
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0),
          MASTER.dayly_fact.perepasp = nvl (
             (SELECT MASTER.ostat_npz.pasp
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0),
          MASTER.dayly_fact.otgr_nar = nvl (
             (SELECT MASTER.ostat_npz.otgr
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0),
          MASTER.dayly_fact.hran_tek = nvl (
             (SELECT MASTER.plan_refinery.hran + MASTER.ostat_npz.hran
                FROM MASTER.ostat_npz, MASTER.plan_refinery
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA
                 AND MASTER.plan_refinery.kod = MASTER.dayly_fact.kod_plan),0),
         MASTER.dayly_fact.polezostatki =nvl (
             (SELECT iif_num (MASTER.ostat_npz.ost,
                              '<',
                              MASTER.ostat_npz.m_ost,
                              0,
                              MASTER.ostat_npz.ost - MASTER.ostat_npz.m_ost
                             )
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0),
          MASTER.dayly_fact.vsegoza = nvl (
             (SELECT MASTER.ostat_npz.request
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0),
          MASTER.dayly_fact.komp =nvl (
             (SELECT MASTER.ostat_npz.komp
                FROM MASTER.ostat_npz
               WHERE MASTER.ostat_npz.id_prod_npr = MASTER.dayly_fact.prod
                 AND MASTER.ostat_npz.sobstv_id = MASTER.dayly_fact.sobstv
                 AND MASTER.ostat_npz.npz_date = MASTER.dayly_fact.DATA),0)
    WHERE MASTER.dayly_fact.DATA = new_de;

   COMMIT;
END renew_ostat_npz;

/

