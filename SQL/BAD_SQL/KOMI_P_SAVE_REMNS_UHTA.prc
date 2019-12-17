CREATE OR REPLACE PROCEDURE       KOMI_P_SAVE_REMNS_UHTA (TO_PERIOD_BEGIN IN DATE)
AS
   nCount     INTEGER;
   nbalunit   NUMBER (17) := 1348886;-- Ухта
BEGIN
/* Если остатки переносятся на 01.01.2002 то скопируем остатки по Ухте */
   IF TO_PERIOD_BEGIN = TO_DATE ('01.01.2002', 'DD.MM.YYYY')
   THEN
      DELETE
        FROM parus.ACCREMNS_UHTA;

      DELETE
        FROM parus.ANLREMNS_UHTA;

      DELETE
        FROM parus.DCREMNS_UHTA;

      DELETE
        FROM parus.DCSPECS_UHTA;

      DELETE
        FROM parus.VALREMNS_UHTA;

      INSERT INTO parus.ACCREMNS_UHTA
         SELECT *
           FROM parus.accremns a
          WHERE a.remn_date = TO_PERIOD_BEGIN
            AND a.balunit = nbalunit;

      INSERT INTO parus.ANLREMNS_UHTA
         SELECT *
           FROM parus.anlremns a
          WHERE a.remn_date = TO_PERIOD_BEGIN
            AND a.balunit = nbalunit;

      INSERT INTO parus.DCREMNS_UHTA
         SELECT *
           FROM parus.DCACNTS a
          WHERE a.open_date = TO_PERIOD_BEGIN
            AND a.balunit = nbalunit;

      INSERT INTO parus.DCSPECS_UHTA
         SELECT *
           FROM parus.dcspecs a
          WHERE a.open_date = TO_PERIOD_BEGIN
            AND a.balunit = nbalunit;

      INSERT INTO parus.VALREMNS_UHTA
         SELECT *
           FROM parus.valremns a
          WHERE a.remn_date = TO_PERIOD_BEGIN
            AND a.balunit = nbalunit;

      COMMIT;
   END IF;
END;
/

