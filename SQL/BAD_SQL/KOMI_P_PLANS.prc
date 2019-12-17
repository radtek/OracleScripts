CREATE OR REPLACE PROCEDURE       komi_p_plans (date_from DATE, Date_to DATE)
AS
   nom     NUMBER;
   Plans   komi_kPlans%ROWTYPE;
   d       DATE;

   CURSOR main
   IS
      SELECT v_stages.DBegin_date, v_contracts.sagent, v_fCacOperPlans.sNomen,
             v_stages.sPay_Type, v_fCacOperPlans.nQuant
        FROM v_contracts, v_stages, v_faceAccTrade, v_fCacOperPlans
       WHERE (v_contracts.nrn = v_stages.nprn)
         AND (v_stages.sFaceAcc = v_faceAccTrade.sNumb)
         AND (v_faceAccTrade.nrn = v_fCacOperPlans.nprn)
         AND (v_stages.DBegin_date >= date_from)
         AND (v_stages.DBegin_date <= date_to)
--          and(v_stages.DEnd_date<=Date_to)
                                              ;

   PROCEDURE ins
   AS
      n   NUMBER;
   BEGIN
      n := 4;
      plans.kv := '4 �������';

      IF d < TO_DATE ('01.04.2001', 'dd.mm.yyyy')
      THEN
         plans.kv := '1 �������';
         n := 1;
      END IF;

      IF     (n = 4)
         AND (d < TO_DATE ('01.07.2001', 'dd.mm.yyyy'))
      THEN
         plans.kv := '2 �������';
         n := 2;
      END IF;

      IF     (n = 4)
         AND (d < TO_DATE ('01.10.2001', 'dd.mm.yyyy'))
      THEN
         plans.kv := '3 �������';
         n := 3;
      END IF;

      INSERT INTO komi_kPlans
           VALUES (USER, Plans.kv, Plans.kon, Plans.nom, Plans.op, Plans.kol);
   END;

--select sum(kol),max(kv),max(kon),max(nom),max(op) from kplans group by kv,kon,nom,op

   PROCEDURE InsBl
   AS
   BEGIN
      INSERT INTO komi_kPlans
           VALUES (USER, '1 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '1 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '1 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '2 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '2 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '2 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '3 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '3 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '3 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '4 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '4 �������', '���', NULL, NULL, NULL);

      INSERT INTO komi_kPlans
           VALUES (USER, '4 �������', '���', NULL, NULL, NULL);
   END;
BEGIN
   nom := 0;

   DELETE komi_kPlans
    WHERE ident = USER;

   InsBl;
   OPEN main;

   LOOP
      FETCH main INTO d, plans.kon, plans.nom, plans.op, plans.kol;
      EXIT WHEN main%NOTFOUND;
      ins;
--    P_EXCEPTION ( 0,'ok' );
   END LOOP;

   CLOSE main;
END;
/

