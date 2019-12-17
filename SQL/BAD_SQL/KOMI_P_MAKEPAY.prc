CREATE OR REPLACE PROCEDURE komi_p_makepay (
   nrn        IN   NUMBER,
   ncompany   IN   NUMBER,
   spref      IN   VARCHAR2,
   scatalog   IN   VARCHAR2,
   sfinoper   IN   VARCHAR2,
   sacc_db    IN   VARCHAR2,
   spbe_db    IN   VARCHAR2,
   sacc_cr    IN   VARCHAR2,
   spbe_cr    IN   VARCHAR2,
   nagn_to    IN   NUMBER DEFAULT 0)
/* scomment OUT  VARCHAR2 */
IS
   ncrn        NUMBER (17);
   npayrn      NUMBER (17);
   spay_numb   VARCHAR2 (10);
   spayer      VARCHAR2 (20);
   ncount      NUMBER;
   nacc_db     NUMBER (17);
   nacc_cr     NUMBER (17);
   DELIMITER   VARCHAR2 (10) := ';';
   BLANK       VARCHAR2 (10) := '()';
   /*Добавлено НС 12.07.2002*/
   sCODE_JP  JURPERSONS.CODE%TYPE;  -- мнемокод ЮЛ
   nRN_JP    JURPERSONS.RN%TYPE;  -- RN ЮЛ
   /*Добавлено НС 12.07.2002*/
begin

  /*Добавлено НС 12.07.2002*/
  /* Ищем основное ЮЛ */
  FIND_JURPERSONS_MAIN( 1,nCOMPANY,sCODE_JP,nRN_JP);
  /*Добавлено НС 12.07.2002*/

/*Номер каталога*/
   find_acatalog_name (0, ncompany, NULL, 'PayNotes', scatalog, ncrn);
   find_account_by_number (ncompany, sacc_db, nacc_db);

   IF nacc_db IS NULL
   THEN
      p_exception (0, 'Не найден счет по дебету - ' || sacc_db);
   END IF;

   find_account_by_number (ncompany, sacc_cr, nacc_cr);

   IF nacc_cr IS NULL
   THEN
      p_exception (0, 'Не найден счет по кредиту - ' || sacc_cr);
   END IF;

   IF ncrn IS NULL
   THEN
      p_exception (0, 'Не найден каталог - ' || scatalog);
   END IF;

   FOR c_econ IN (SELECT *
                    FROM econoprs m
                   WHERE m.rn = nrn)
   LOOP
/* Пройдемся по спецификации хоз.операции */
      FOR c_specs IN (SELECT n.*
                        FROM oprspecs n, dicbunts un_d, dicbunts un_c
                       WHERE n.prn = nrn
                         AND n.balunit_debit = un_d.rn (+)
                         AND n.balunit_credit = un_c.rn (+)
                         AND n.account_debit = nacc_db
                         AND (
                                   RTRIM (spbe_db) IS NULL
                                OR     strin (BLANK, spbe_db, DELIMITER) = 1
                                   AND n.balunit_debit IS NULL
                                OR UN_D.BUNIT_MNEMO LIKE spbe_db
                                OR     INSTR (spbe_db, DELIMITER) <> 0
                                   AND strinlike (UN_D.BUNIT_MNEMO, spbe_db, DELIMITER, BLANK) = 1)
                         AND n.account_credit = nacc_cr
                         AND (
                                   RTRIM (spbe_cr) IS NULL
                                OR     strin (BLANK, spbe_cr, DELIMITER) = 1
                                   AND n.balunit_credit IS NULL
                                OR UN_C.BUNIT_MNEMO LIKE spbe_cr
                                OR     INSTR (spbe_cr, DELIMITER) <> 0
                                   AND strinlike (UN_C.BUNIT_MNEMO, spbe_cr, DELIMITER, BLANK) = 1))
      LOOP
/*Ищем наименование контрагента*/
         IF nagn_to = 0
         THEN
            SELECT g.agnabbr
              INTO spayer
              FROM econoprs m, agnlist g
             WHERE m.rn = nrn
               AND g.rn = m.agent_from;
         ELSE
            SELECT g.agnabbr
              INTO spayer
              FROM econoprs m, agnlist g
             WHERE m.rn = nrn
               AND g.rn = m.agent_to;
         END IF;

/*Операции имеющие ссылки на документы имеющие ссылки на журнал платежей*/
/*Существует вероятность того что есть ссылка на платеж через документ*/
         SELECT COUNT (*)
           INTO ncount
           FROM v_doclinks_inout_out d, v_doclinks_inout_in e
          WHERE nrn = d.nout_document
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
             WHERE c_specs.rn = e.nout_document
               AND e.sunitcode = 'PayNotes';

            IF ncount = 0
            THEN
/*Следующий номер в платежах*/
               p_paynotes_getnextnumb (ncompany, spref, spay_numb);
/*Добавляем запись в журнал платежей*/
               p_paynotes_insert (ncompany=> ncompany,
                  ncrn                  => ncrn,
                  sJUR_PERS             => sCODE_JP,
                  spay_prefix           => spref,
                  spay_number           => spay_numb,
                  spayer                => spayer,
                  dpay_date             => c_specs.operation_date,
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
                  npay_sum              => c_specs.acnt_sum,
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
                  scomments             => c_econ.operation_contents,
                  nrn                   => npayrn);
               /*Устанавливаем связи по спецификации*/
               p_linksall_link_direct (ncompany,
                  'PayNotes',
                  npayrn,
                  NULL,
                  c_econ.operation_date,
                  0,
                  'EconomicOperationsSpecs',
                  c_specs.rn,
                  NULL,
                  c_specs.operation_date,
                  0,
                  0);
               /*Устанавливаем связи по заголовку*/
               p_linksall_link_direct (ncompany,
                  'PayNotes',
                  npayrn,
                  NULL,
                  c_econ.operation_date,
                  0,
                  'EconomicOperations',
                  nrn,
                  NULL,
                  c_econ.operation_date,
                  0,
                  0);
            END IF;
         END IF;
      END LOOP;
   END LOOP;
/* scomment := 'Успешно выполнено' ;*/
END komi_p_makepay;
/

