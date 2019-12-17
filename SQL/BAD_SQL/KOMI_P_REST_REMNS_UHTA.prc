CREATE OR REPLACE PROCEDURE       KOMI_P_REST_REMNS_UHTA (TO_PERIOD_BEGIN IN DATE)
AS
   nCount   INTEGER;
   nbalunit   NUMBER (17) := 1348886;-- ����
BEGIN
/* ���� ������� ����������� �� 01.01.2002 �� ����������� ������� */
   IF TO_PERIOD_BEGIN = TO_DATE ('01.01.2002', 'DD.MM.YYYY')
   THEN
/*������� �� ������*/
      FOR rec IN (SELECT *
                    FROM parus.ACCREMNS_UHTA a
                   WHERE a.remn_date = TO_PERIOD_BEGIN
                     AND a.balunit = nbalunit)
      LOOP
         SELECT COUNT (*)
           INTO nCount
           FROM parus.accremns a
          WHERE a.rn = rec.rn;

         IF nCount > 0
         THEN
            UPDATE parus.accremns a
               SET a.acnt_debit_sum = rec.acnt_debit_sum,
                   a.acnt_debit_base_sum = rec.acnt_debit_base_sum,
                   a.acnt_credit_sum = rec.acnt_credit_sum,
                   a.acnt_credit_base_sum = rec.acnt_credit_base_sum,
                   a.ctrl_debit_sum = rec.ctrl_debit_sum,
                   a.ctrl_debit_base_sum = rec.ctrl_debit_base_sum,
                   a.ctrl_credit_sum = rec.ctrl_credit_sum,
                   a.ctrl_credit_base_sum = rec.ctrl_credit_base_sum
             WHERE a.rn = rec.rn;
         ELSE
            INSERT INTO parus.accremns a
               SELECT *
                 FROM parus.ACCREMNS_UHTA
                WHERE rn = rec.rn;
         END IF;
      END LOOP;

/* ������� �� ��������� */
      FOR rec IN (SELECT *
                    FROM parus.ANLREMNS_UHTA a
                   WHERE a.remn_date = TO_PERIOD_BEGIN
                     AND a.balunit = nbalunit)
      LOOP
         SELECT COUNT (*)
           INTO nCount
           FROM parus.anlremns a
          WHERE a.rn = rec.rn;

         IF nCount > 0
         THEN
            UPDATE parus.anlremns a
               SET a.acnt_remn_sum = rec.acnt_remn_sum,
                   a.acnt_remn_base_sum = rec.acnt_remn_base_sum,
                   a.ctrl_remn_sum = rec.ctrl_remn_sum,
                   a.ctrl_remn_base_sum = rec.ctrl_remn_base_sum,
                   a.acnt_debit_sum = rec.acnt_debit_sum,
                   a.acnt_debit_base_sum = rec.acnt_debit_base_sum,
                   a.ctrl_debit_sum = rec.ctrl_debit_sum,
                   a.ctrl_debit_base_sum = rec.ctrl_debit_base_sum,
                   a.acnt_credit_sum = rec.acnt_credit_sum,
                   a.acnt_credit_base_sum = rec.acnt_credit_base_sum,
                   a.ctrl_credit_sum = rec.ctrl_credit_sum,
                   a.ctrl_credit_base_sum = rec.ctrl_credit_base_sum
             WHERE a.rn = rec.rn;
         ELSE
            INSERT INTO parus.anlremns
               SELECT *
                 FROM parus.ANLREMNS_UHTA
                WHERE rn = rec.rn;
         END IF;
      END LOOP;

/* ��������� ��������� ���������/���������� */
      FOR rec IN (SELECT *
                    FROM parus.DCREMNS_UHTA a
                   WHERE a.open_date = TO_PERIOD_BEGIN
                     AND a.balunit = nbalunit)
      LOOP
         SELECT COUNT (*)
           INTO nCount
           FROM parus.DCACNTS a
          WHERE a.rn = rec.rn;

         IF nCount = 0
         THEN
            INSERT INTO parus.DCACNTS
               SELECT *
                 FROM parus.DCREMNS_UHTA
                WHERE rn = rec.rn;
         END IF;
      END LOOP;

/* ������������ �� ���������/���������� */
      FOR rec IN (SELECT *
                    FROM parus.DCSPECS_UHTA a
                   WHERE a.open_date = TO_PERIOD_BEGIN
                     AND a.balunit = nbalunit)
      LOOP
         SELECT COUNT (*)
           INTO nCount
           FROM parus.dcspecs a
          WHERE a.rn = rec.rn;

         IF nCount > 0
         THEN
            UPDATE parus.dcspecs a
               SET a.acnt_pay_sum = rec.acnt_remn_sum,
                   a.ctrl_pay_sum = rec.acnt_remn_base_sum,
                   a.acnt_remn_sum = rec.acnt_remn_sum,
                   a.acnt_remn_base_sum = rec.acnt_remn_base_sum,
                   a.ctrl_remn_sum = rec.ctrl_remn_sum,
                   a.ctrl_remn_base_sum = rec.ctrl_remn_base_sum,
                   a.acnt_debit_sum = rec.acnt_debit_sum,
                   a.acnt_debit_base_sum = rec.acnt_debit_base_sum,
                   a.ctrl_debit_sum = rec.ctrl_debit_sum,
                   a.ctrl_debit_base_sum = rec.ctrl_debit_base_sum,
                   a.acnt_credit_sum = rec.acnt_credit_sum,
                   a.acnt_credit_base_sum = rec.acnt_credit_base_sum,
                   a.ctrl_credit_sum = rec.ctrl_credit_sum,
                   a.ctrl_credit_base_sum = rec.ctrl_credit_base_sum
             WHERE a.rn = rec.rn;
         ELSE
            INSERT INTO parus.dcspecs a
               SELECT *
                 FROM parus.DCSPECS_UHTA
                WHERE rn = rec.rn;
         END IF;
      END LOOP;

/* ������� �� ��� */
      FOR rec IN (SELECT *
                    FROM parus.VALREMNS_UHTA a
                   WHERE a.remn_date = TO_PERIOD_BEGIN
                     AND a.balunit = nbalunit)
      LOOP
         SELECT COUNT (*)
           INTO nCount
           FROM parus.valremns a
          WHERE a.rn = rec.rn;

         IF nCount > 0
         THEN
            UPDATE parus.valremns a
               SET a.acnt_remn_quant = rec.acnt_remn_quant,
                   a.acnt_alt_quant = rec.acnt_alt_quant,
                   a.acnt_remn_sum = rec.acnt_remn_sum,
                   a.acnt_remn_base_sum = rec.acnt_remn_base_sum,
                   a.ctrl_remn_quant = rec.ctrl_remn_quant,
                   a.ctrl_alt_quant = rec.ctrl_alt_quant,
                   a.ctrl_remn_sum = rec.ctrl_remn_sum,
                   a.ctrl_remn_base_sum = rec.ctrl_remn_base_sum
             WHERE a.rn = rec.rn;
         ELSE
            INSERT INTO parus.valremns a
               SELECT *
                 FROM parus.VALREMNS_UHTA
                WHERE rn = rec.rn;
         END IF;
      END LOOP;

      COMMIT;
   END IF;
END;
/

