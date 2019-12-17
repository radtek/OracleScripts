CREATE OR REPLACE PROCEDURE       snp_p_make_val_remns(
   ncompany         IN   NUMBER,-- привязать к организации
   sacc_old         IN   VARCHAR2,-- счет с остатками
   sacc_new         IN   VARCHAR2,-- Новый счет
   spbe_old         IN   VARCHAR2,-- ПБЕ
   spbe_new         IN   VARCHAR2,-- ПБЕ
   ddate            IN   DATE,-- дата начала периода
   smol             IN   VARCHAR2,-- МОЛ
   sparty           IN   VARCHAR2,-- Партия
   scurrency        IN   VARCHAR2,-- валюта
   soper_pref       IN   VARCHAR2,-- префикс хозоперации
   scat             IN   VARCHAR2,-- каталог хозоперации
   soper_contents   IN   VARCHAR2-- содержание хозоперации
)
AS
   ncurr         NUMBER(17);
   nacc          NUMBER(17);
   saccount      VARCHAR2(10);
   ncrn          NUMBER(17);
   npbe_old      NUMBER(17);
   npbe_new      NUMBER(17);
   nacc_new      NUMBER(17);
   doper_date    DATE;
   soper_numb    VARCHAR2(10);
   nrn           NUMBER(17);
   ntmp          NUMBER(17);
   nident        NUMBER(17);
   nacnt_equal   NUMBER(17, 5);
   nctrl_equal   NUMBER(17, 5);
   delimiter     VARCHAR2(10)         := ';';
   blank         VARCHAR2(10)         := '()';
   old_agent     NUMBER(17):=0;
   /*Добавлено НС 12.07.2002*/
   scode_jp      jurpersons.code%TYPE;-- мнемокод ЮЛ
   nrn_jp        jurpersons.rn%TYPE;-- RN ЮЛ
/*Добавлено НС 12.07.2002*/
BEGIN
/*Добавлено НС 12.07.2002*/
/* Ищем основное ЮЛ */
   find_jurpersons_main(1, ncompany, scode_jp, nrn_jp);
/*Добавлено НС 12.07.2002*/
   find_acatalog_name(0, ncompany, NULL, 'EconomicOperations', scat, ncrn);
   find_currency_by_iso(ncompany, scurrency, ncurr);

   IF spbe_new IS NOT NULL
   THEN
      find_balunit_by_mnemo(ncompany, spbe_new, npbe_new);
   ELSE
      npbe_new    := NULL;
   END IF;

   IF sacc_new IS NOT NULL
   THEN
      find_account_by_number(ncompany, sacc_new, nacc_new);
   ELSE
      nacc_new    := NULL;
   END IF;

   BEGIN
      SELECT period_end
        INTO doper_date
        FROM aperiods
       WHERE period_begin = ddate
         AND company = ncompany;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_exception(0, 'Период не найден');
   END;

   p_valturns_getident(nident);
   p_valturns_create(ncompany,
      nident,
      blank,
      delimiter,
      ddate,
      ddate,
--      doper_date,
      sacc_old,
      spbe_old,
      scode_jp,
      scurrency,
      NULL,
      smol,
      NULL,
      NULL,
      NULL,
      0,
      NULL,
      NULL,
      NULL,
      0,
      ntmp
   );
   FOR rec IN(SELECT *
                FROM valturns a
               WHERE a.ident = nident
               ORDER by a.agent)
   LOOP
      IF    rec.acnt_res_sum + rec.acnt_res_base_sum + rec.ctrl_res_sum + rec.ctrl_res_base_sum <> 0
         OR rec.acnt_res_quant + rec.ctrl_res_quant <> 0
      THEN
         IF nrn IS NULL or rec.agent <> old_agent 
         THEN
            p_econoprs_getnextnumb(ncompany, soper_pref, soper_numb);
            p_econoprs_base_insert(ncompany,
               ncrn,
               nrn_jp,
               soper_pref,
               soper_numb,
               soper_contents,
--               doper_date,
               ddate,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               rec.agent,
               rec.agent,
               nrn
            );
            old_agent:=rec.agent;
         END IF;

         IF rec.acnt_res_aquant <> 0
         THEN
            nacnt_equal    := rec.acnt_res_quant / rec.acnt_res_aquant;
         ELSE
            nacnt_equal    := 0;
         END IF;

         IF rec.ctrl_res_aquant <> 0
         THEN
            nctrl_equal    := rec.ctrl_res_quant / rec.ctrl_res_aquant;
         ELSE
            nctrl_equal    := 0;
         END IF;

         IF rec.acnt_res_sum < 0
         THEN
            parus.p_oprspecs_base_insert(ncompany=> ncompany,
               nprn              => nrn,
               nbalu_debit       => rec.balunit,
               nacc_debit        => rec.account,
               nanl1_debit       => NULL,
               nanl2_debit       => NULL,
               nanl3_debit       => NULL,
               nanl4_debit       => NULL,
               nanl5_debit       => NULL,
               nbalu_credit      => npbe_new,
               nacc_credit       => nacc_new,
               nanl1_credit      => NULL,
               nanl2_credit      => NULL,
               nanl3_credit      => NULL,
               nanl4_credit      => NULL,
               nanl5_credit      => NULL,
               ncurrency         => rec.currency,
               nnomen_code       => rec.nomenclature,
               snomen_partno     => nvl(sparty,rec.nomen_partno),
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
               nrn               => ntmp
            );
         ELSE
            parus.p_oprspecs_base_insert(ncompany=> ncompany,
               nprn              => nrn,
               nbalu_debit       => npbe_new,
               nacc_debit        => nacc_new,
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
               snomen_partno     => nvl(sparty,rec.nomen_partno),
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
               nrn               => ntmp
            );
         END IF;
      END IF;
   END LOOP;

   p_valturns_pack_by_ident(nident);
END;
/

