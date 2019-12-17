CREATE OR REPLACE PROCEDURE PR_MAKE_VAL_REMNS (
   nCOMPANY         IN   NUMBER,-- привязать к организации
   sACC             IN   VARCHAR2,-- счет с остатками
   sPBE_OLD         IN   VARCHAR2,-- ПБЕ
   sPBE_NEW         IN   VARCHAR2,-- ПБЕ
   dDATE            IN   DATE,-- дата начала периода
   sMOL             IN   VARCHAR2,-- МОЛ
   sCURRENCY        IN   VARCHAR2,-- валюта
   sOPER_PREF       IN   VARCHAR2,-- префикс хозоперации
   sCAT             IN   VARCHAR2,-- каталог хозоперации
   sOPER_CONTENTS   IN   VARCHAR2-- содержание хозоперации
                                 )
AS
   nCURR         NUMBER (17);
   nACC          NUMBER (17);
   sACCOUNT      VARCHAR2 (10);
   nCRN          NUMBER (17);
   nPBE_OLD      NUMBER (17);
   nPBE_NEW      NUMBER (17);
   dOPER_DATE    DATE;
   sOPER_NUMB    VARCHAR2 (10);
   nRN           NUMBER (17);
   NIDENT        NUMBER (17);
   nacnt_equal   NUMBER (17, 5);
   nctrl_equal   NUMBER (17, 5);
   DELIMITER     VARCHAR2 (10)  := ';';
   BLANK         VARCHAR2 (10)  := '()';
   /*Добавлено НС 12.07.2002*/
   sCODE_JP  JURPERSONS.CODE%TYPE;  -- мнемокод ЮЛ
   nRN_JP    JURPERSONS.RN%TYPE;  -- RN ЮЛ
   /*Добавлено НС 12.07.2002*/
begin

/*Добавлено НС 12.07.2002*/
/* Ищем основное ЮЛ */
   FIND_JURPERSONS_MAIN( 1,nCOMPANY,sCODE_JP,nRN_JP);
/*Добавлено НС 12.07.2002*/
   FIND_ACATALOG_NAME (0, nCOMPANY, NULL, 'EconomicOperations', sCAT, nCRN);
   FIND_CURRENCY_BY_ISO (nCOMPANY, sCURRENCY, NCURR);

   IF sPBE_NEW IS NOT NULL
   THEN
      FIND_BALUNIT_BY_MNEMO (nCOMPANY, sPBE_NEW, nPBE_NEW);
   ELSE
      nPBE_NEW := NULL;
   END IF;

   BEGIN
      SELECT PERIOD_END
        INTO dOPER_DATE
        FROM APERIODS
       WHERE PERIOD_BEGIN = dDATE
         AND COMPANY = nCOMPANY;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Период не найден');
   END;

   P_VALTURNS_GETIDENT (NIDENT);
   P_VALTURNS_CREATE (ncompany,
      nident,
      blank,
      delimiter,
      dDATE,
      dOPER_DATE,
      sACC,
      sPBE_OLD,
      sCODE_JP,
      sCURRENCY,
      NULL,
      sMOL,
      NULL,
      NULL,
      NULL,
      0,
      NULL,
      NULL,
      NULL,
      0,
      nRN);

   FOR rec IN (SELECT *
                 FROM VALTURNS a
                WHERE a.IDENT = NIDENT)
   LOOP
      IF rec.acnt_res_sum+rec.acnt_res_base_sum+rec.ctrl_res_sum+rec.ctrl_res_base_sum <> 0 OR 
         rec.acnt_res_quant+rec.ctrl_res_quant <> 0
      THEN
         P_ECONOPRS_GETNEXTNUMB (nCOMPANY, sOPER_PREF, sOPER_NUMB);
         P_ECONOPRS_BASE_INSERT (nCOMPANY,
            nCRN,
            nRN_JP,
            sOPER_PREF,
            sOPER_NUMB,
            sOPER_CONTENTS,
            dOPER_DATE,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            rec.AGENT,
            rec.AGENT,
            nRN);

         IF rec.acnt_res_aquant <> 0
         THEN
            nacnt_equal := rec.acnt_res_quant / rec.acnt_res_aquant;
         ELSE
            nacnt_equal := 0;
         END IF;

         IF rec.ctrl_res_aquant <> 0
         THEN
            nctrl_equal := rec.ctrl_res_quant / rec.ctrl_res_aquant;
         ELSE
            nctrl_equal := 0;
         END IF;

         IF rec.acnt_res_sum < 0
         THEN
            parus.p_oprspecs_base_insert (ncompany=> nCOMPANY,
               nprn              => nRN,
               nbalu_debit       => rec.balunit,
               nacc_debit        => rec.account,
               nanl1_debit       => NULL,
               nanl2_debit       => NULL,
               nanl3_debit       => NULL,
               nanl4_debit       => NULL,
               nanl5_debit       => NULL,
               nbalu_credit      => nPBE_NEW,
               nacc_credit       => rec.account,
               nanl1_credit      => NULL,
               nanl2_credit      => NULL,
               nanl3_credit      => NULL,
               nanl4_credit      => NULL,
               nanl5_credit      => NULL,
               ncurrency         => rec.currency,
               nnomen_code       => rec.nomenclature,
               snomen_partno     => rec.nomen_partno,
               dnomen_indate     => rec.nomen_indate,
               nacnt_sum         => -1 * rec.acnt_res_sum,
               nacnt_base_sum    => -1 * rec.acnt_res_base_sum,
               nacnt_quant       => rec.acnt_res_quant,
               nacnt_alt_quant   => rec.acnt_res_aquant,
               nacnt_equal       => nacnt_equal,
               nctrl_sum         => -1 * rec.ctrl_res_sum,
               nctrl_base_sum    => -1 * rec.ctrl_res_base_sum,
               nctrl_quant       => rec.ctrl_res_quant,
               nctrl_alt_quant   => rec.ctrl_res_aquant,
               nctrl_equal       => nctrl_equal,
               sa1_sign          => NULL,
               sa2_sign          => NULL,
               sa3_sign          => NULL,
               sa4_sign          => NULL,
               sa5_sign          => NULL,
               sa6_sign          => NULL,
               sa7_sign          => NULL,
               sa8_sign          => NULL,
               sa9_sign          => NULL,
               sa10_sign         => NULL,
               ninc_to_dc        => NULL,
               nrn               => nrn);
         ELSE
            parus.p_oprspecs_base_insert (ncompany=> nCOMPANY,
               nprn              => nRN,
               nbalu_debit       => nPBE_NEW,
               nacc_debit        => rec.account,
               nanl1_debit       => NULL,
               nanl2_debit       => NULL,
               nanl3_debit       => NULL,
               nanl4_debit       => NULL,
               nanl5_debit       => NULL,
               nbalu_credit      => rec.balunit,
               nacc_credit       => rec.account,
               nanl1_credit      => NULL,
               nanl2_credit      => NULL,
               nanl3_credit      => NULL,
               nanl4_credit      => NULL,
               nanl5_credit      => NULL,
               ncurrency         => rec.currency,
               nnomen_code       => rec.nomenclature,
               snomen_partno     => rec.nomen_partno,
               dnomen_indate     => rec.nomen_indate,
               nacnt_sum         => rec.acnt_res_sum,
               nacnt_base_sum    => rec.acnt_res_base_sum,
               nacnt_quant       => rec.acnt_res_quant,
               nacnt_alt_quant   => rec.acnt_res_aquant,
               nacnt_equal       => nacnt_equal,
               nctrl_sum         => rec.ctrl_res_sum,
               nctrl_base_sum    => rec.ctrl_res_base_sum,
               nctrl_quant       => rec.ctrl_res_quant,
               nctrl_alt_quant   => rec.ctrl_res_aquant,
               nctrl_equal       => nctrl_equal,
               sa1_sign          => NULL,
               sa2_sign          => NULL,
               sa3_sign          => NULL,
               sa4_sign          => NULL,
               sa5_sign          => NULL,
               sa6_sign          => NULL,
               sa7_sign          => NULL,
               sa8_sign          => NULL,
               sa9_sign          => NULL,
               sa10_sign         => NULL,
               ninc_to_dc        => NULL,
               nrn               => nrn);
         END IF;
      END IF;
   END LOOP;
END;
/

