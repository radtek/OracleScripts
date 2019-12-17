CREATE OR REPLACE PROCEDURE komi_p_makepay_dk (
   nrn        IN   NUMBER,
   ncompany   IN   NUMBER,
   spref      IN   VARCHAR2,
   scatalog   IN   VARCHAR2,
   sfinoper   IN   VARCHAR2)
IS
   ncrn        NUMBER (17);
   npayrn      NUMBER (17);
   spay_numb   VARCHAR2 (10);
   spayer      VARCHAR2 (20);
   ncount      NUMBER;
   nacc        NUMBER (17);
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

   IF ncrn IS NULL
   THEN
      p_exception (0, 'Не найден каталог - ' || scatalog);
   END IF;

   FOR c_dcacnts IN (SELECT *
                       FROM dcacnts m
                      WHERE m.rn = nrn)
   LOOP
/* Пройдемся по спецификации ведомости дебиторов/кредиторов */
      FOR c_specs IN (SELECT *
                        FROM dcspecs n
                       WHERE n.prn = nrn)
      LOOP
/*Ищем наименование контрагента*/
         SELECT g.agnabbr
           INTO spayer
           FROM agnlist g
          WHERE g.rn = c_specs.agent;
/*Смотрим есть ли у данной записи в спецификации ссылка на платеж*/
         SELECT COUNT (*)
           INTO ncount
           FROM v_doclinks_inout_out e
          WHERE c_specs.rn = e.nout_document
            AND e.sunitcode = 'PayNotes';

         IF     ncount = 0
            AND c_specs.acnt_remn_sum < 0
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
               dpay_date             => c_specs.open_date,
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
               npay_sum              => ABS (c_specs.acnt_remn_sum),
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
               scomments             => 'Входящий остаток на - ' ||
                                           TO_CHAR (c_specs.open_date, 'DD.MM.YYYY'),
               nrn                   => npayrn);
/* Пока связи не устанавливаем */
            /*Устанавливаем связи по спецификации*/
/*            p_linksall_link_direct (ncompany,
               'PayNotes',
               npayrn,
               NULL,
               c_specs.open_date,
               0,
               'DebitorsCreditorsRemnLines',
               c_specs.rn,
               NULL,
               c_specs.open_date,
               0,
               0);*/
            /*Устанавливаем связи по заголовку*/
/*            p_linksall_link_direct (ncompany,
               'PayNotes',
               npayrn,
               NULL,
               c_dcacnts.open_date,
               0,
               'DebitorsCreditorsRemnants',
               nrn,
               NULL,
               c_dcacnts.open_date,
               0,
               0);*/
         END IF;
      END LOOP;
   END LOOP;
/* scomment := 'Успешно выполнено' ;*/
END komi_p_makepay_dk;
/

