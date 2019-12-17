CREATE OR REPLACE PROCEDURE komi_p_make_econoprs (
   nCOMPANY         IN   NUMBER,
   sIN_ACC          IN   VARCHAR2,
   sIN_PBE          IN   VARCHAR2,
   sOUT_ACC         IN   VARCHAR2,
   sOUT_PBE         IN   VARCHAR2,
   dDATE            IN   DATE,
   sOPER_PREF       IN   VARCHAR2,
   sCAT             IN   VARCHAR2,
   sOPER_CONTENTS   IN   VARCHAR2)
AS
   nCURR          NUMBER (17);
   nIN_ACC        NUMBER (17);
   nOUT_ACC       NUMBER (17);
   nCRN           NUMBER (17);
   nIN_PBE        NUMBER (17);
   nOUT_PBE       NUMBER (17);
   dOPER_DATE     DATE;
   nSUM           NUMBER (17, 2);
   sOPER_NUMB     VARCHAR2 (10);
   nACCREMNS_RN   NUMBER (17);
   nRN            NUMBER (17);
   nSPECRN        NUMBER (17);
   /*Добавлено НС 12.07.2002*/
   sCODE_JP  JURPERSONS.CODE%TYPE;  -- мнемокод ЮЛ
   nRN_JP    JURPERSONS.RN%TYPE;  -- RN ЮЛ
   /*Добавлено НС 12.07.2002*/
begin

/*Добавлено НС 12.07.2002*/
/* Ищем основное ЮЛ */
   FIND_JURPERSONS_MAIN( 1,nCOMPANY,sCODE_JP,nRN_JP);
/*Добавлено НС 12.07.2002*/
   FIND_ACCOUNT_BY_NUMBER (nCOMPANY, sIN_ACC, nIN_ACC);

   IF nIN_ACC IS NULL
   THEN
      P_EXCEPTION (0, 'Не найден исходящий счет ' || sIN_ACC);
   END IF;

   FIND_ACCOUNT_BY_NUMBER (nCOMPANY, sOUT_ACC, nOUT_ACC);

   IF nOUT_ACC IS NULL
   THEN
      P_EXCEPTION (0, 'Не найден входящий счет ' || sOUT_ACC);
   END IF;

   FIND_ACATALOG_NAME (0, nCOMPANY, NULL, 'EconomicOperations', sCAT, nCRN);

   IF nCRN IS NULL
   THEN
      P_EXCEPTION (0, 'Не найден каталог хоз.операций ' || sCAT);
   END IF;

   IF sIN_PBE IS NOT NULL
   THEN
      FIND_BALUNIT_BY_MNEMO (nCOMPANY, sIN_PBE, nIN_PBE);
   ELSE
      P_EXCEPTION (0, 'Не найден исходящий ПБЕ ' || sIN_PBE);
   END IF;

   IF sOUT_PBE IS NOT NULL
   THEN
      FIND_BALUNIT_BY_MNEMO (nCOMPANY, sOUT_PBE, nOUT_PBE);
   ELSE
      P_EXCEPTION (0, 'Не найден входящий ПБЕ ' || sOUT_PBE);
   END IF;

   BEGIN
      SELECT a.rn
        INTO nACCREMNS_RN
        FROM V_ACCREMNS a
       WHERE (a.COMPANY = nCOMPANY)
         AND a.account_rn = nIN_ACC
         AND a.balunit_rn = nIN_PBE
         AND a.remn_date = ddate;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Не найдены остатки для переноса');
   END;

   FOR C IN (SELECT b.analytic1, b.analytic2, b.analytic3, b.analytic4, b.analytic5,
                    b.acnt_debit_sum, b.acnt_debit_base_sum, b.acnt_credit_sum,
                    b.acnt_credit_base_sum, b.currency
               FROM ANLREMNS b
              WHERE b.PRN = nACCREMNS_RN)
   LOOP
      P_ECONOPRS_GETNEXTNUMB (nCOMPANY, sOPER_PREF, sOPER_NUMB);
      P_ECONOPRS_BASE_INSERT (nCOMPANY,
         nCRN,
         nRN_JP,
         sOPER_PREF,
         sOPER_NUMB,
         sOPER_CONTENTS,
         dDATE,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         nRN);

      IF c.acnt_debit_sum <> 0
      THEN
         P_OPRSPECS_BASE_INSERT (nCOMPANY,
            nRN,
            nOUT_PBE,
            nOUT_ACC,
            c.analytic1,
            c.analytic2,
            c.analytic3,
            c.analytic4,
            c.analytic5,
            nIN_PBE,
            nIN_ACC,
            c.analytic1,
            c.analytic2,
            c.analytic3,
            c.analytic4,
            c.analytic5,
            c.currency,
            NULL,
            NULL,
            NULL,
            c.acnt_debit_sum,
            c.acnt_debit_base_sum,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            1,
            nSPECRN);
      END IF;

      IF c.acnt_credit_sum <> 0
      THEN
         P_OPRSPECS_BASE_INSERT (nCOMPANY,
            nRN,
            nIN_PBE,
            nIN_ACC,
            c.analytic1,
            c.analytic2,
            c.analytic3,
            c.analytic4,
            c.analytic5,
            nOUT_PBE,
            nOUT_ACC,
            c.analytic1,
            c.analytic2,
            c.analytic3,
            c.analytic4,
            c.analytic5,
            c.currency,
            NULL,
            NULL,
            NULL,
            c.acnt_credit_sum,
            c.acnt_credit_base_sum,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            1,
            nSPECRN);
      END IF;
   END LOOP;
END komi_p_make_econoprs;
/

