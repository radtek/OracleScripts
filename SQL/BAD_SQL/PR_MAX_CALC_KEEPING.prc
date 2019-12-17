CREATE OR REPLACE procedure pr_max_calc_keeping (
          company      IN  number,
          ddate_to     IN   date,
          sagent       IN   varchar2,
          sstore       IN   varchar2,
          scatalog     IN   varchar2
    ) as
    IDENT NUMBER(17);
    DDATE_BEGIN DATE;
    vDATE_END   DATE;
    GROUP_IDENT number(17) default null;
    ITS_FLAG    NUMBER(1) DEFAULT 0;
    NRN         NUMBER;
begin
  IDENT := PARUS.gen_ident(); 
  DDATE_BEGIN := trunc(LAST_DAY(ADD_MONTHS(ddate_to,-1))+1); 
  vDATE_END   := TRUNC(ADD_MONTHS(ddate_to,-3));  --Отступаем на 3 месяца назад
  
  --Подчищаем временные таблицы
  DELETE FROM PARUS.STROPERJRN_D D WHERE D.AUTHID = USER;
  DELETE FROM PARUS.max_calc_keeping D WHERE D.sUSER = USER;
  COMMIT;
  --Формируем статки товарных запасов на 1 число месяца
  --получаем всех контрагентов у которых закончилось топливо к концу месяца
  P_STROPERJRN_D (
                 NCOMPANY     => COMPANY,
                 DDATE        => DDATE_BEGIN,
                 NGROUP_IDENT => GROUP_IDENT,
                 NIDENT       => IDENT,
                 SCGROUP_CODE => NULL,
                 SCNOMEN_CODE => NULL,
                 SCMODIF_CODE => NULL,
                 SCPACK       => NULL,
                 SCPARTY      => NULL,
                 SCNOM_CAT    => NULL,
                 SCSTORE_CAT  => NULL,
                 SCSTORE      => sstore);
  commit;
  --Сбрасываем остатки товарных запасов на 1 число месяца во временную таблицу
  FOR B IN (select A.RN, A.AGNABBR, D.NOMEN, SUM(D.QUANT) AS QUANT
              from stroperjrn_d d,
                   INCOMDOC T,
                   AGNLIST A
             where d.authid = user
               AND T.CODE = D.PARTY
               AND T.STOR_SIGN = 1
               AND D.QUANT > 0
               AND T.AGENT = A.RN
             GROUP BY A.RN, A.AGNABBR, D.NOMEN) LOOP
         INSERT INTO max_calc_keeping (/*nIDENT,*/ sUSER, nAGNRN, sAGNABBR, sNOMEN,
                                       ddate_begin ,ddate_end, quant_begin, quant_end,rn)
                               VALUES (/*IDENT,*/ user, B.RN, B.AGNABBR, B.NOMEN, 
                                       DDATE_BEGIN, ddate_to, B.QUANT, 0, gen_id());
  END LOOP;
  --Подчищаем временую таблицу товарных запасов
  DELETE FROM STROPERJRN_D D WHERE D.AUTHID = USER;
  COMMIT;
  --Формируем остатки товарных запасов на последнее число месяца
  --получаем контрагентов у которых осталось топливо на последнее число месяца
  P_STROPERJRN_D (
                 NCOMPANY     => COMPANY, 
                 DDATE        => DDATE_TO,
                 NGROUP_IDENT => GROUP_IDENT,
                 NIDENT       => IDENT,
                 SCGROUP_CODE => NULL,
                 SCNOMEN_CODE => NULL,
                 SCMODIF_CODE => NULL,
                 SCPACK       => NULL,
                 SCPARTY      => NULL,
                 SCNOM_CAT    => NULL,
                 SCSTORE_CAT  => NULL,
                 SCSTORE      => sstore);
    commit;
   --Сбрасываем остатки товарных запасов на на последнее число месяца во временную таблицу
   FOR B IN (select A.RN, A.AGNABBR, D.NOMEN, SUM(D.QUANT) AS QUANT
              from stroperjrn_d d,
                   INCOMDOC T,
                   AGNLIST A
             where d.authid = user
               AND T.CODE = D.PARTY
               AND T.STOR_SIGN = 1
               AND D.QUANT > 0
               AND T.AGENT = A.RN
             GROUP BY A.RN, A.AGNABBR, D.NOMEN) LOOP
          
          ITS_FLAG := 0;
             
          begin
             select t.rn 
               INTO NRN
               from max_calc_keeping t
              where t.nagnrn = b.rn
                and t.snomen = b.NOMEN
                and t.suser = user;
          exception
              when no_data_found then
                  ITS_FLAG := 1;
                  INSERT INTO max_calc_keeping (/*nIDENT,*/ sUSER, nAGNRN, sAGNABBR, sNOMEN, 
                                                ddate_begin, ddate_end, quant_begin, quant_end, rn)
                                        VALUES (/*IDENT,*/ user, B.RN, B.AGNABBR, B.NOMEN,
                                                DDATE_BEGIN, DDATE_TO, 0, B.QUANT, gen_id()); 
          end;
          IF ITS_FLAG = 0 THEN
                 UPDATE max_calc_keeping T SET T.QUANt_END = B.QUANT WHERE T.RN = NRN;
          END IF;
         
  END LOOP;
  COMMIT;
  
  FOR C IN (SELECT *
              FROM max_calc_keeping K
             WHERE K.DDATE_END = DDATE_TO) LOOP
   
     FOR D IN (SELECT J.*
                 FROM STOREOPERJOURN J,
                      GOODSSUPPLY GS,
                      GOODSPARTIES GP,
                      AZSAZSLISTMT S,
                      NOMMODIF M,
                      DICNOMNS N,
                      FACEACC F,
                      AGNLIST A
                WHERE J.GOODSSUPPLY = GS.RN
                  AND GS.STORE = S.RN
                  AND GS.PRN = GP.RN
                  AND GP.NOMMODIF = M.RN
                  AND M.PRN = N.RN
                  AND J.FACEACC = F.RN
                  AND F.AGENT = A.RN
                  AND J.OPERDATE BETWEEN C.DDATE_END AND vDATE_END
                  AND A.AGNABBR = C.SAGNABBR
                  AND N.NOMEN_CODE = C.SNOMEN
                ORDER BY J.OPERDATE DESC ) LOOP
       
       NULL;
       
       END LOOP; 
  
  END LOOP;  
  
end;
/

