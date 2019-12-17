--
-- GET_FIN_BY_DATE_DOG_SUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Fin_By_Date_Dog_Sum (
   Dog_id#         NUMBER,
   Date_graphik#   DATE,
   Planstru_id#    NUMBER DEFAULT NULL)
   RETURN NUMBER
AS
   Otgr#        NUMBER;
   Otgr1#       NUMBER;
   OPL#         NUMBER;
   Opl1#        NUMBER;
   Pros1#       NUMBER;
   Pros2#       NUMBER;

   CURSOR Temp
   IS
      SELECT   BILLS.Date_plat, BILLS.Nom_dok,
               NVL (SUM (BILL_POS.Summa), 0) AS Summa_dok,
               NVL (SUM (DECODE (SIGN (BILL_POS.Bill_pos_id - 10),
                                 -1, NVL (BILL_POS.Summa, 0),0)),0) AS Summa_prod
          FROM BILL_POS, BILLS
         WHERE BILLS.Nom_dok = BILL_POS.Nom_dok AND BILLS.Dog_id = Dog_id#
      GROUP BY bills.date_plat, BILLS.Nom_dok
        HAVING bills.date_plat <= Date_graphik#
      ORDER BY 1 DESC, 2 DESC;

   Dest         Temp%ROWTYPE;
   V_is_agent   NUMBER;
BEGIN
   /* PSV 30.06.2002 - по Поставке оплаты только на сумму продукта */
   BEGIN
      SELECT KLS_DOG.Is_agent
        INTO V_is_agent
        FROM KLS_DOG
       WHERE KLS_DOG.ID = Dog_id#;
   EXCEPTION
      WHEN OTHERS
      THEN
         V_is_agent := -1;
   END;

   IF Planstru_id# IS NOT NULL
   THEN
      SELECT NVL (SUM (REAL_OPL.D_41 + REAL_OPL.D_191 + REAL_OPL.Sum_akciz),0)
        INTO OPL#
        FROM REAL_OPL, BILLS, MONTH
       WHERE REAL_OPL.Nom_dok = BILLS.Nom_dok
         AND BILLS.Nom_zd = MONTH.Nom_zd
         AND MONTH.Planstru_id = Planstru_id#
         AND BILLS.Dog_id = Dog_id#
         AND REAL_OPL.Data_post < TRUNC (Date_graphik#, 'Mon');

      IF Planstru_id# <> 95
      THEN
         SELECT NVL (SUM (OPL.Summa), 0)
           INTO Opl1#
           FROM OPL
          WHERE Dog_id = Dog_id# AND Data_por < TRUNC (Date_graphik#, 'Mon');

         OPL# := Opl1# - OPL#;
      END IF;
   ELSE
      SELECT NVL (SUM (OPL.Summa), 0)
        INTO OPL#
        FROM OPL
       WHERE Dog_id = Dog_id# AND Data_por < TRUNC (Date_graphik#, 'Mon');
   END IF;

   IF V_is_agent = 2
   THEN
      IF Planstru_id# IS NOT NULL
      THEN
         SELECT NVL (SUM (BILLS.Prod_sum), 0)
           INTO Otgr#
           FROM BILLS, MONTH
          WHERE BILLS.Nom_zd = MONTH.Nom_zd
            AND MONTH.Planstru_id = Planstru_id#
            AND BILLS.Dog_id = Dog_id#
            AND BILLS.Date_plat <= Date_graphik# ;

         IF Planstru_id# <> 95
         THEN
            SELECT NVL (SUM (BILLS.Prod_sum), 0)
              INTO Otgr1#
              FROM BILLS
             WHERE Dog_id = Dog_id# AND Date_plat <= Date_graphik#;
            Otgr# := Otgr1# - Otgr#;
         END IF;
      ELSE
         SELECT NVL (SUM (BILLS.Prod_sum), 0)
           INTO Otgr#
           FROM BILLS
          WHERE Dog_id = Dog_id# AND Date_plat <= Date_graphik#;
      END IF;
   ELSE
      SELECT NVL (SUM (BILLS.Summa_dok), 0)
        INTO Otgr#
        FROM BILLS
       WHERE Dog_id = Dog_id# AND Date_plat <= Date_graphik#;
   END IF;

   Pros1# := Otgr# - OPL#;
   Pros2# := 0;

   OPEN Temp;

   LOOP
      IF Pros1# <= 0
      THEN
         EXIT;
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
END Get_Fin_By_Date_Dog_Sum;

/

