CREATE OR REPLACE PROCEDURE komi_p_makepay_econ (
   nrn_dk      IN   NUMBER,
   ncompany    IN   NUMBER,
   spref       IN   VARCHAR2,
   scatalog    IN   VARCHAR2,
   sfinoper    IN   VARCHAR2,
   sagent      IN   VARCHAR2,
   sacc_cr     IN   VARCHAR2,
   dpay_date   IN   DATE,
   scomments   IN   VARCHAR2)
IS
   ncrn        NUMBER (17);
   npayrn      NUMBER (17);
   spay_numb   VARCHAR2 (10);
   spayer      VARCHAR2 (20);
   nagent      NUMBER (17);
   ncount      NUMBER;
   nacc_cr     NUMBER (17);
   nsum_pay    NUMBER (17, 2) := 0;
   /*Добавлено НС 12.07.2002*/
   sCODE_JP  JURPERSONS.CODE%TYPE;  -- мнемокод ЮЛ
   nRN_JP    JURPERSONS.RN%TYPE;  -- RN ЮЛ
   /*Добавлено НС 12.07.2002*/

   CURSOR c_dk_specs (nrn NUMERIC, nacc_cr NUMERIC)
   IS
      SELECT tr.sheet_line_debit, tr.main_turn, op.rn AS econ_rn, sp.rn AS specs_rn,
             op.operation_date, sp.account_debit, sp.account_credit,
             -1 * sp.acnt_sum AS acnt_sum, -1 * sp.acnt_base_sum AS acnt_base_sum
        FROM odcturns tr, odcturnsspecs trsp, econoprs op, oprspecs sp
       WHERE tr.prn = op.rn
         AND tr.rn = trsp.prn
         AND trsp.spec = sp.rn
         AND trsp.TYPE IN (1, 3)
         AND tr.sheet_line_debit = nrn
         AND sp.account_credit <> nacc_cr
      UNION ALL
      (SELECT tr.sheet_line_credit, tr.main_turn, op.rn AS econ_rn, sp.rn AS specs_rn,
              op.operation_date, sp.account_debit, sp.account_credit,
              sp.acnt_sum AS acnt_sum, sp.acnt_base_sum AS acnt_base_sum
         FROM odcturns tr, odcturnsspecs trsp, econoprs op, oprspecs sp
        WHERE tr.prn = op.rn
          AND tr.rn = trsp.prn
          AND trsp.spec = sp.rn
          AND trsp.TYPE IN (2, 3)
          AND tr.sheet_line_credit = nrn);
begin

  /*Добавлено НС 12.07.2002*/
  /* Ищем основное ЮЛ */
  FIND_JURPERSONS_MAIN( 1,nCOMPANY,sCODE_JP,nRN_JP);
  /*Добавлено НС 12.07.2002*/
--   p_exception (0, 'RN ' || TO_CHAR (nrn_dk));
/*Номер каталога*/
   find_acatalog_name (0, ncompany, NULL, 'PayNotes', scatalog, ncrn);

   IF ncrn IS NULL
   THEN
      p_exception (0, 'Не найден каталог - ' || scatalog);
   END IF;

   find_account_by_number (ncompany, sacc_cr, nacc_cr);

   IF nacc_cr IS NULL
   THEN
      p_exception (0, 'Не найден счет по кредиту - ' || sacc_cr);
   END IF;

   if sagent is not null
   then

   FIND_AGNLIST_BY_MNEMO( 0, nCOMPANY, sAGENT, nAGENT );

   IF nagent IS NULL
   THEN
      p_exception (0, 'Не найден контрагент - ' || sagent);
   END IF;
   end if;
   
   FOR rec_dk IN (SELECT *
                    FROM dcspecs
                   WHERE prn = nrn_dk
                     and (agent = nagent or nagent is null)
                     AND acnt_debit_sum + acnt_credit_sum <> 0)
   LOOP
/*Ищем наименование контрагента*/
      SELECT g.agnabbr
        INTO spayer
        FROM agnlist g, dcspecs n
       WHERE n.agent = g.rn
         AND n.rn = rec_dk.rn;
      nsum_pay := 0;

/*Вычисляем сумму платежа*/
      FOR rec_dk_specs IN c_dk_specs (rec_dk.rn, nacc_cr)
      LOOP
/*Операции имеющие ссылки на документы имеющие ссылки на журнал платежей*/
/*Существует вероятность того что есть ссылка на платеж через документ*/
         SELECT COUNT (*)
           INTO ncount
           FROM v_doclinks_inout_out d, v_doclinks_inout_in e
          WHERE rec_dk_specs.econ_rn = d.nout_document
            AND d.sout_unitcode = 'EconomicOperations'
            AND d.ndocument = e.nin_document
            AND d.sunitcode = e.sin_unitcode
            AND e.sunitcode = 'PayNotes';

         IF ncount = 0
         THEN
/*Смотрим есть ли у данной записи в спецификации ссылка на платеж*/
            SELECT COUNT (*)
              INTO ncount
              FROM v_doclinks_inout_out e
             WHERE rec_dk_specs.specs_rn = e.nout_document
               AND e.sunitcode = 'PayNotes';

            IF ncount = 0
            THEN
               nsum_pay := nsum_pay + rec_dk_specs.acnt_sum;
            END IF;
         END IF;
      END LOOP;

/*Добавляем запись в журнал платежей*/
      IF nsum_pay <> 0
      THEN
/*Следующий номер в платежах*/
         p_paynotes_getnextnumb (ncompany, spref, spay_numb);
         p_paynotes_insert (ncompany=> ncompany,
            ncrn                  => ncrn,
            sJUR_PERS             => sCODE_JP,
            spay_prefix           => spref,
            spay_number           => spay_numb,
            spayer                => spayer,
            dpay_date             => dpay_date,
            nserv_pay             => 0.,
            sfaceacc              => NULL,
            sgraphpoint           => NULL,
            sfinoper              => sfinoper,
            spaytool              => NULL,
            svdoc_type            => NULL,
            svdoc_numb            => NULL,
            dvdoc_date            => NULL,
            sfdoc_type            => NULL,
            sfdoc_numb            => NULL,
            dfdoc_date            => NULL,
            scurrency             => 'Руб.',
            ncurr_rate            => 1.,
            ncurr_rate_base       => 1.,
            ncurr_rate_acc        => 1.,
            ncurr_rate_pay_acc    => 1.,
            ncurr_rate_trd        => 1.,
            ncurr_rate_base_trd   => 1.,
            npay_sum              => nsum_pay,
            npay_sum_acc          => 0.,
            npay_sum_trd          => 0.,
            nfinspec              => NULL,
            nintrdebt             => NULL,
            nsignplan             => 0.,
            staxgroup             => NULL,
            spay_plan_prefix      => NULL,
            spay_plan_number      => NULL,
            nsignactive           => 0.,
            spay_type             => NULL,
            stdoc_type            => NULL,
            stdoc_numb            => NULL,
            dtdoc_date            => NULL,
            ntax_sum              => 0.,
            ntax_percent          => 0.,
            scomments             => scomments,
            nrn                   => npayrn);

/*Привязываем к журналу платежей хоз.операции*/
         FOR rec_dk_specs IN c_dk_specs (rec_dk.rn, nacc_cr)
         LOOP
/*Операции имеющие ссылки на документы имеющие ссылки на журнал платежей*/
/*Существует вероятность того что есть ссылка на платеж через документ*/
            SELECT COUNT (*)
              INTO ncount
              FROM v_doclinks_inout_out d, v_doclinks_inout_in e
             WHERE rec_dk_specs.econ_rn = d.nout_document
               AND d.sout_unitcode = 'EconomicOperations'
               AND d.ndocument = e.nin_document
               AND d.sunitcode = e.sin_unitcode
               AND e.sunitcode = 'PayNotes';

            IF ncount = 0
            THEN
/*Смотрим есть ли у данной записи в спецификации ссылка на платеж*/
               SELECT COUNT (*)
                 INTO ncount
                 FROM v_doclinks_inout_out e
                WHERE rec_dk_specs.specs_rn = e.nout_document
                  AND e.sunitcode = 'PayNotes';

               IF ncount = 0
               THEN
                  /*Устанавливаем связи по спецификации*/
                  p_linksall_link_direct (ncompany,
                     'PayNotes',
                     npayrn,
                     NULL,
                     rec_dk_specs.operation_date,
                     0,
                     'EconomicOperationsSpecs',
                     rec_dk_specs.specs_rn,
                     NULL,
                     rec_dk_specs.operation_date,
                     0,
                     0);
                  /*Устанавливаем связи по заголовку*/
                  p_linksall_link_direct (ncompany,
                     'PayNotes',
                     npayrn,
                     NULL,
                     rec_dk_specs.operation_date,
                     0,
                     'EconomicOperations',
                     rec_dk_specs.econ_rn,
                     NULL,
                     rec_dk_specs.operation_date,
                     0,
                     0);
               END IF;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
/* scomment := 'Успешно выполнено' ;*/
END komi_p_makepay_econ;
/

