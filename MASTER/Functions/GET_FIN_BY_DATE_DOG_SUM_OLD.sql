--
-- GET_FIN_BY_DATE_DOG_SUM_OLD  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Fin_By_Date_Dog_Sum_old (
   Dog_id#         NUMBER
                         ,
   Date_graphik#   DATE
                       ,
   Planstru_id#    NUMBER DEFAULT NULL

)
   RETURN NUMBER
AS
   Otgr#        NUMBER;
   Otgr1#       NUMBER;
   Opl#         NUMBER;
   Opl1#        NUMBER;
   Pros1#       NUMBER;
   Pros2#       NUMBER;

   CURSOR Temp
   IS
      SELECT   Date_kvit + Kol_dn AS Date_plat, Bills.Nom_dok,
               NVL (SUM (Bill_pos.Summa), 0) AS Summa_dok,
               NVL (SUM (DECODE (SIGN (Bill_pos.Bill_pos_id - 10),
                                 -1, NVL (Bill_pos.Summa, 0),
                                 0
                                )
                        ),
                    0
                   ) AS Summa_prod
          FROM Bill_pos, Bills
         WHERE Bills.Nom_dok = Bill_pos.Nom_dok AND Bills.Dog_id = Dog_id#
      GROUP BY Date_kvit + Kol_dn, Bills.Nom_dok
        HAVING Date_kvit + Kol_dn <= Date_graphik#
      ORDER BY 1 DESC, 2 DESC;

   Dest         Temp%ROWTYPE;
   V_is_agent   NUMBER;
BEGIN
   /* PSV 30.06.2002 - по поставке оплаты только на сумму продукта */
   BEGIN
      SELECT Kls_dog.Is_agent
        INTO V_is_agent
        FROM Kls_dog
       WHERE Kls_dog.ID = Dog_id#;
   EXCEPTION
      WHEN OTHERS
      THEN
         V_is_agent := -1;
   END;

   IF Planstru_id# IS NOT NULL
   THEN
      SELECT NVL (SUM (Real_opl.D_41 + Real_opl.D_191 + Real_opl.Sum_akciz),
                  0)
        INTO Opl#
        FROM Real_opl, Bills, MONTH
       WHERE Real_opl.Nom_dok = Bills.Nom_dok
         AND Bills.Nom_zd = MONTH.Nom_zd
         AND MONTH.Planstru_id = Planstru_id#
         AND Bills.Dog_id = Dog_id#
         AND Real_opl.Data_post < TRUNC (Date_graphik#, 'Mon');

      IF Planstru_id# <> 95
      THEN
         SELECT NVL (SUM (Opl.Summa), 0)
           INTO Opl1#
           FROM Opl
          WHERE Dog_id = Dog_id# AND Data_por < TRUNC (Date_graphik#, 'Mon');

         Opl# := Opl1# - Opl#;
      END IF;
   ELSE
      SELECT NVL (SUM (Opl.Summa), 0)
        INTO Opl#
        FROM Opl
       WHERE Dog_id = Dog_id# AND Data_por < TRUNC (Date_graphik#, 'Mon');
   END IF;

   IF V_is_agent = 2
   THEN
      IF Planstru_id# IS NOT NULL
      THEN
         SELECT NVL (SUM (Bills.Prod_sum), 0)
           INTO Otgr#
           FROM Bills, MONTH
          WHERE Bills.Nom_zd = MONTH.Nom_zd
            AND MONTH.Planstru_id = Planstru_id#
            AND Bills.Dog_id = Dog_id#
            AND Bills.Date_kvit + Bills.Kol_dn <= Date_graphik#
/*ADVICE(117): Complex expression not fully parenthesized [404] */
                                                               ;

         IF Planstru_id# <> 95
         THEN
            SELECT NVL (SUM (Bills.Prod_sum), 0)
              INTO Otgr1#
              FROM Bills
             WHERE Dog_id = Dog_id# AND Date_kvit + Kol_dn <= Date_graphik#
/*ADVICE(126): Complex expression not fully parenthesized [404] */
                                                                           ;

            Otgr# := Otgr1# - Otgr#;
         END IF;
      ELSE
         SELECT NVL (SUM (Bills.Prod_sum), 0)
           INTO Otgr#
           FROM Bills
          WHERE Dog_id = Dog_id# AND Date_kvit + Kol_dn <= Date_graphik#
/*ADVICE(136): Complex expression not fully parenthesized [404] */
                                                                        ;
      END IF;
   ELSE
      SELECT NVL (SUM (Bills.Summa_dok), 0)
        INTO Otgr#
        FROM Bills
       WHERE Dog_id = Dog_id# AND Date_kvit + Kol_dn <= Date_graphik#
/*ADVICE(144): Complex expression not fully parenthesized [404] */
                                                                     ;
   END IF;

   Pros1# := Otgr# - Opl#;
   Pros2# := 0;

   OPEN Temp;

   LOOP
      IF Pros1# <= 0
      THEN
         EXIT;
/*ADVICE(157): IF THEN EXIT should be replaced by EXIT WHEN [401] */

      END IF;

      FETCH Temp
       INTO Dest;

      EXIT WHEN Temp%NOTFOUND;

      IF V_is_agent = 2
      THEN
         IF Dest.Summa_prod <= Pros1#
         THEN
            Pros2# := Pros2# + Dest.Summa_prod;
            Pros1# := Pros1# - Dest.Summa_prod;
         ELSE
            Pros2# := Pros2# + Pros1#;
            Pros1# := 0;
         END IF;
      ELSE
         IF Dest.Summa_dok <= Pros1#
         THEN
            Pros2# := Pros2# + Dest.Summa_prod;
            Pros1# := Pros1# - Dest.Summa_dok;
         ELSE
            Pros2# := Pros2# + Dest.Summa_prod * (Pros1# / Dest.Summa_dok);
            Pros1# := 0;
         END IF;
      END IF;
   END LOOP;
/*ADVICE(187): Presence of more than one exit point from a loop [503] */


   RETURN Pros2#;
END Get_Fin_By_Date_Dog_Sum_old;

/

