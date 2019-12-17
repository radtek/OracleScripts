CREATE OR REPLACE PROCEDURE KOMI_P_INVOICES_MAKE_TR_RPT (
   nCOMPANY      IN   NUMBER,  -- Организация
   sCRN          IN   VARCHAR2,-- Каталог товарного отчета
   sRPT_PREFIX   IN   VARCHAR2,-- Префикс товарного отчета
   sRPT_NUMBER   IN   VARCHAR2,-- Номер товарного отчета
   dRPT_DATE     IN   DATE,    -- Дата товарного отчета
   sSTORE        IN   VARCHAR2,-- Склад
   sSTOREOPER    IN   VARCHAR2,-- Складская операция.
   dB_DATE       IN   DATE,    -- Начало периода
   dE_DATE       IN   DATE)    -- Конец периода
AS
   nSTORE              NUMBER (17);
   nSTOREOPER          NUMBER (17);-- регистрационный номер складской операции
   bCREATED            BOOLEAN                    := FALSE;
   nFIND               NUMBER (17)                := 0;
   nMOL                NUMBER (17);
   nSTORE_OPER         NUMBER (17);
   nPAY_TYPE           NUMBER (17);
   nDISP_TYPE          NUMBER (17);
   nCURRENCY           NUMBER (17);
   nCURR_RATE          NUMBER (17);
   nCURR_RATE_BASE     NUMBER (17);
   nINT_STORE          NUMBER (17);
   nOPER_DIRECTION     NUMBER (17);
   nAGENT              NUMBER (17);
   nVALID_DOCTYPE      NUMBER (17);
   sVALID_DOCNUMB      FACEACC.VALID_DOCNUMB%TYPE;
   dVALID_DOCDATE      DATE;
   nTRRN               NUMBER (17);
   nSPTRRN             NUMBER (17);
   nPBE                NUMBER (17);
   nSMOL               NUMBER (17);
   nMU_MAIN            NUMBER (17);
   nMU_ADD             NUMBER (17);
   nM_REAL             NUMBER (17);
   nQ_REAL             NUMBER (17, 3);
   nQSJ_REAL           NUMBER (17, 3);
   BASE_CURR           NUMBER (17);
   nCRN               NUMBER (17);
   nEQUAL              NUMBER (17, 5);
   nQUANT              NUMBER (17, 3);
   nSUM                NUMBER (17, 2);
   nOVERHEADSSUM       NUMBER (17, 2);
   nOVERHEADSBASESUM   NUMBER (17, 2);
   nFACEACC            NUMBER (17);
   nIDENT              NUMBER (17);
   bFOUND              BOOLEAN                    := FALSE;

   PROCEDURE CreateMaster
   IS
   /*Добавлено НС 12.07.2002*/
   sCODE_JP  JURPERSONS.CODE%TYPE;  -- мнемокод ЮЛ
   nRN_JP    JURPERSONS.RN%TYPE;  -- RN ЮЛ
   /*Добавлено НС 12.07.2002*/
   begin

      /*Добавлено НС 12.07.2002*/
      /* Ищем основное ЮЛ */
      FIND_JURPERSONS_MAIN( 1,nCOMPANY,sCODE_JP,nRN_JP);
      /*Добавлено НС 12.07.2002*/
      IF NOT bCREATED
      THEN
/* создание заголовка товарного отчета */
         P_SALESRPTMAIN_BASE_INSERT (NCRN,
            NCOMPANY,
            SRPT_PREFIX,
            SRPT_NUMBER,
            DRPT_DATE,
            nRN_JP,
            DB_DATE,
            DE_DATE,
            NSTORE,
            NMOL,
            NTRRN);
/* установка выходного документа */
         PKG_INHIER.SET_OUT_DOC (nIDENT, 0, NTRRN, nCRN);
         bCREATED := TRUE;
      END IF;
   END;
BEGIN
/* проверка наличия каталога */
   BEGIN
      SELECT RN
        INTO nCRN
        FROM ACATALOG
       WHERE NAME like sCRN
         AND COMPANY = nCOMPANY
         AND DOCNAME = 'TradeReports';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Каталог товарного отчета не опеределен.');
   END;

/* предварительная проверка прав доступа */
   PKG_ENV.ACCESS (nCOMPANY, NULL, nCRN, 'TradeReports', 'INVC2TR_CREATE');
/* вызов конструктора PKG_INHIER */
   nIDENT := PKG_INHIER.CONSTRUCTOR (nCOMPANY, gen_ident);
/* подготовка к привязке документа */
   PKG_INHIER.PREP_LINK (nIDENT);
   PKG_INHIER.SET_OUT_UNIT (nIDENT, 0, 'TradeReports', NULL, 'INVC2TR_CREATE', 'SALESREPORTMAIN');
   PKG_INHIER.SET_OUT_UNIT (nIDENT, 1, 'TradeReportsSp');

/* поиск складской операции */
   IF strtrim (sSTOREOPER) IS NOT NULL
   THEN
      FIND_DICSTOPR_CODE (0, nCOMPANY, sSTOREOPER, nSTOREOPER);
   ELSE
      nSTOREOPER := NULL;
   END IF;

/* поиск склада */
   FIND_DICSTORE_NUMB (0, nCOMPANY, sSTORE, nSTORE);
/* поиск МОЛ для склада */
   SELECT ST.AZS_AGENT, ST.AZS_PBE
     INTO nMOL, nPBE
     FROM AZSAZSLISTMT ST
    WHERE RN = nSTORE
      AND COMPANY = nCOMPANY;
/* определение базовой валюты */
   FIND_CURRENCY_BASE (NCOMPANY, BASE_CURR);

/* поиск записи прихода для указанного склада, которые попадают в указанный интервал дат */
   FOR REC IN (SELECT/*+ ORDERED */
                   OIR.RN RN, OIR.DATE_TIME, OIR.STORE_OPER, OIR.CONF_DOC_TYPE, OIR.INCOME_ACT_NUM,
                   OIR.INCOME_ACT_DATE, OIR.INVOICE_NUM, OIR.INVOICE_DATE, OIR.NOMEN_NUMBER, OIR.AGENT,
                   OIR.FACE_ACC, OIR.FACT_DENSITY, OIR.FACT_VOLUME, OIR.FACT_MASS, OIR.QUANT, OIR.MEAS_UNIT,
                   OIR.SUMM, OIR.TAX_GROUP, OIR.TRANS_TYPE, OIR.TRANS_NUMBER, OIR.STATUS STATUS, OIR.PARTY,
                   ID.CODE
                 FROM OILINREG OIR, INCOMDOC ID
                WHERE OIR.COMPANY = NCOMPANY
                  AND OIR.AZS_NUMBER = NSTORE
                  AND OIR.PARTY = ID.RN
                  AND (   nSTOREOPER IS NULL
                       OR OIR.STORE_OPER = nSTOREOPER)
                  AND TRUNC (OIR.DATE_TIME) BETWEEN DB_DATE AND DE_DATE)
   LOOP
/* проверка - отработана ли данная запись прихода */
      P_LINKSALL_FIND_UNITCODE_LINK (1, NCOMPANY, 'OilIncomeRegistry', REC.RN, 'TradeReports', NFIND);
      nOVERHEADSSUM := 0;

      IF nFIND = 0
      THEN
/* создание заголовка товарного отчета */
         CreateMaster;
/* формирование спецификаций */
/* поиск связей с журналом накладных расходов */
         PKG_INHIER.SET_IN_UNIT (nIDENT, 0, 'RealizationOverheads');

         FOR OVH IN (SELECT/*+ RULE */
                         O.DOCUMENT ORN, FC.AGENT FC_AGENT, FC.FACEACC FC_FACEACC, OH.*
                       FROM DOCINPT I, DOCLINKS L, DOCOUTPT O, OVERHEADS OH, FINECHARGES FC
                      WHERE I.DOCUMENT = REC.RN
                        AND I.UNITCODE = 'OilIncomeRegistry'
                        AND L.IN_DOC = I.RN
                        AND L.OUT_DOC = O.RN
                        AND O.UNITCODE = 'RealizationOverheads'
                        AND O.DOCUMENT = OH.RN
                        AND FC.RN =
                             (SELECT/*+ ORDERED */
                                  OO.DOCUMENT RN
                                FROM DOCINPT II, DOCLINKS LL, DOCOUTPT OO
                               WHERE II.DOCUMENT = OH.RN
                                 AND II.UNITCODE = 'RealizationOverheads'
                                 AND LL.IN_DOC = II.RN
                                 AND LL.OUT_DOC = OO.RN
                                 AND OO.UNITCODE = 'FineCharges')
                        AND OH.SIGNGOODSREP = 1)
         LOOP
/* установка входного документа */
            PKG_INHIER.SET_IN_DOC (nIDENT, 0, OVH.ORN);

            IF OVH.FC_AGENT <> REC.AGENT
            THEN
               P_SALESRPTDET_BASE_INSERT (NTRRN,
                  OVH.WORK_DATE,
                  OVH.STOPER,
                  OVH.DOC_TYPE,
                  OVH.DOC_NUMB,
                  OVH.DOC_DATE,
                  NULL,
                  NULL,
                  NULL,
                  NPBE,
                  OVH.FC_AGENT,
                  OVH.FC_FACEACC,
                  REC.NOMEN_NUMBER,
                  NULL/* nNOMMODIF */,
                  NULL/* nNOMNMODIFPACK */,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  0,
                  0,
                  0,
                  NULL,
                  REC.CODE,
                  NULL,
                  OVH.CURRENCY,
                  1,
                  1,
                  OVH.SUMM,
                  OVH.SUMM,
                  REC.TAX_GROUP,
                  REC.TRANS_TYPE,
                  REC.TRANS_NUMBER,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NSPTRRN);
/* установка выходного документа */
               PKG_INHIER.SET_OUT_DOC (nIDENT, 1, NSPTRRN);
/* привязка входного документа к буферному или выходному */
               PKG_INHIER.LINK_IN (nIDENT);
               bFOUND := TRUE;
            ELSE
               nOVERHEADSSUM := nOVERHEADSSUM + OVH.SUMM;
            END IF;
         END LOOP;

         PKG_INHIER.SET_IN_UNIT (nIDENT, 0, 'OilIncomeRegistry');
/* установка входного документа */
         PKG_INHIER.SET_IN_DOC (nIDENT, 0, REC.RN);

         IF REC.STATUS = 2
         THEN
            P_SALESRPTDET_BASE_INSERT (NTRRN,
               REC.DATE_TIME,
               REC.STORE_OPER,
               REC.CONF_DOC_TYPE,
               REC.INVOICE_NUM,
               REC.INVOICE_DATE,
               NULL,
               NULL,
               NULL,
               NPBE,
               REC.AGENT,
               REC.FACE_ACC,
               REC.NOMEN_NUMBER,
               NULL/* nNOMMODIF */,
               NULL/* nNOMNMODIFPACK */,
               NULL,
               NULL,
               NULL,
               REC.FACT_DENSITY,
               REC.FACT_VOLUME,
               REC.FACT_MASS,
               REC.QUANT,
               REC.MEAS_UNIT,
               REC.CODE,
               NULL,
               BASE_CURR,
               1,
               1,
               REC.SUMM + nOVERHEADSSUM,
               REC.SUMM + nOVERHEADSSUM,
               REC.TAX_GROUP,
               REC.TRANS_TYPE,
               REC.TRANS_NUMBER,
               NULL,
               NULL,
               NULL,
               NULL,
               NSPTRRN);
         ELSE
            P_SALESRPTDET_BASE_INSERT (NTRRN,
               REC.DATE_TIME,
               REC.STORE_OPER,
               REC.CONF_DOC_TYPE,
               REC.INVOICE_NUM,
               REC.INVOICE_DATE,
               NULL,
               NULL,
               NULL,
               NPBE,
               REC.AGENT,
               REC.FACE_ACC,
               REC.NOMEN_NUMBER,
               NULL/* nNOMMODIF */,
               NULL/* nNOMNMODIFPACK */,
               NULL,
               NULL,
               NULL,
               REC.FACT_DENSITY,
               REC.FACT_VOLUME,
               REC.FACT_MASS,
               REC.QUANT,
               REC.MEAS_UNIT,
               REC.CODE,
               NULL,
               BASE_CURR,
               1,
               1,
               nOVERHEADSSUM,
               nOVERHEADSSUM,
               REC.TAX_GROUP,
               REC.TRANS_TYPE,
               REC.TRANS_NUMBER,
               NULL,
               NULL,
               NULL,
               NULL,
               NSPTRRN);
         END IF;

/* установка выходного документа */
         PKG_INHIER.SET_OUT_DOC (nIDENT, 1, NSPTRRN);
/* привязка входного документа к буферному или выходному */
         PKG_INHIER.LINK_IN (nIDENT);
         bFOUND := TRUE;
      END IF;
   END LOOP;

   PKG_INHIER.SET_IN_UNIT (nIDENT, 0, 'Invoices');
   PKG_INHIER.SET_IN_UNIT (nIDENT, 1, 'InvoiceSpecs');

/* цикл по накладным, которые попадают в указанный интервал дат и содержат фактические спецификации */
   FOR INVS IN (SELECT/*+ ORDERED */
                    INV.RN IRN, INV.INVOICE_TYPE IIT, INV.INVOICE_NUMB IIN, INV.INVOICE_DATE IID,
                    INV.STORE_OPER STORE_OPER
                  FROM INVOICES INV
                 WHERE INV.COMPANY = nCOMPANY
                   AND INV.INVOICE_DATE >= dB_DATE
                   AND INV.INVOICE_DATE <= dE_DATE
                   AND INV.SEND_STORE = nSTORE
                   AND (   nSTOREOPER IS NULL
                        OR INV.STORE_OPER = nSTOREOPER)
                   AND EXISTS (SELECT *
                                 FROM INVCSPEC IIS
                                WHERE IIS.PRN = INV.RN
                                  AND IIS.SPEC_TYPE = 1))
   LOOP
/* установка входного документа */
      PKG_INHIER.SET_IN_DOC (nIDENT, 0, INVS.IRN);
/* проверка - отработана ли данная накладная */
      P_LINKSALL_FIND_UNITCODE_LINK (1, nCOMPANY, 'Invoices', INVS.IRN, 'TradeReports', nFIND);

/* cчитывание складской операции, вида оплаты, вида отгрузки, валюты, курса валюты и склада из заголовка накладной */
      IF (nFIND = 0)
      THEN
/* создание заголовка товарного отчета */
         CreateMaster;
         SELECT/*+ ORDERED */ I.STORE_OPER, I.PAY_TYPE, I.DISP_TYPE, I.CURRENCY, I.CURR_RATE,
                              I.CURR_RATE_BASE,
                              I.INT_STORE
           INTO nSTORE_OPER, nPAY_TYPE, nDISP_TYPE, nCURRENCY, nCURR_RATE, nCURR_RATE_BASE,
                nINT_STORE
           FROM INVOICES I
          WHERE I.RN = INVS.IRN;
/* считывание направления складской операции */
         SELECT SO.SECTION
           INTO nOPER_DIRECTION
           FROM AZSGSMWAYSTYPES SO
          WHERE SO.RN = nSTORE_OPER;

/* считывание контрагента, документа основания и МОЛ */
         IF (nOPER_DIRECTION = 0)
         THEN
/* если расход, то определяем контрагента и документ основание */
            SELECT/*+ ORDERED */
                FA.AGENT, FA.VALID_DOCTYPE, FA.VALID_DOCNUMB, FA.VALID_DOCDATE, FA.RN
              INTO nAGENT, nVALID_DOCTYPE, sVALID_DOCNUMB, dVALID_DOCDATE, nFACEACC
              FROM FACEACC FA, INVOICES IV
             WHERE FA.RN = IV.FACE_ACCOUNT
               AND IV.RN = INVS.IRN;
         ELSE
/* если внутреннее перемещение, то определяем склад и ПБЕ */
            SELECT/*+ ORDERED */
                S.AZS_PBE, S.AZS_AGENT
              INTO nPBE, nSMOL
              FROM AZSAZSLISTMT S, INVOICES IV
             WHERE S.RN = nINT_STORE
               AND IV.RN = INVS.IRN;
         END IF;

/* создание спецификаций товарного отчета */
         FOR SPEC IN (SELECT/*+ ORDERED */
                          SPC.RN RN, SPC.OPER_DATE O_D, SPC.NOMEN NMN, SPC.EQUAL EQV, SPC.TAX_GROUP TGR,
                          SPC.UMEAS_PRICE UMP, SPC.QUANT SQ, SPC.AQUANT SAQ, SPC.SPEC_SUM SS,
                          SPC.SPEC_SUM_BASE SSB
                        FROM INVCSPEC SPC
                       WHERE SPC.PRN = INVS.IRN
                         AND SPC.SPEC_TYPE = 1)
         LOOP
/* установка входного документа */
            PKG_INHIER.SET_IN_DOC (nIDENT, 1, SPEC.RN);

/* определяем единицы измерения для номенклатуры */
            BEGIN
               SELECT UMEAS_MAIN, UMEAS_ALT
                 INTO nMU_MAIN, nMU_ADD
                 FROM DICNOMNS
                WHERE RN = SPEC.NMN;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  P_EXCEPTION (0, 'Номенклатура не определена.');
            END;

/* определяем количество реализации и Единицу измерения реализации */
            IF (SPEC.UMP = nMU_MAIN)
            THEN
               nM_REAL := nMU_MAIN;
               nQ_REAL := SPEC.SQ;
            ELSIF (    (nMU_ADD IS NOT NULL)
                   AND (SPEC.UMP = nMU_ADD))
            THEN
               nM_REAL := nMU_ADD;
               nQ_REAL := SPEC.SAQ;
            ELSE
               P_EXCEPTION (0, 'Несоответствие единицы измерения цены единицам измерения номенклатуры.');
            END IF;

/* формирование спецификаций */
/* поиск связей с журналом складских операций */
            FOR R IN (SELECT/*+ RULE */
                          O.DOCUMENT nSTOREOPERJOURNAL_RN, SOJ.*, ID.CODE PARTY
                        FROM DOCINPT I,
                             DOCLINKS L,
                             DOCOUTPT O,
                             STOREOPERJOURN SOJ,
                             GOODSSUPPLY GS,
                             GOODSPARTIES GP,
                             INCOMDOC ID
                       WHERE I.DOCUMENT = SPEC.RN
                         AND I.UNITCODE = 'InvoiceSpecs'
                         AND L.IN_DOC = I.RN
                         AND L.OUT_DOC = O.RN
                         AND O.DOCUMENT = SOJ.RN
                         AND O.UNITCODE = 'StoreOpersJournal'
                         AND SOJ.STOPER = nSTORE_OPER
                         AND SOJ.GOODSSUPPLY = GS.RN
                         AND GS.PRN = GP.RN
                         AND GP.INDOC = ID.RN)
            LOOP
/* определяем количество реализации и Единицу измерения реализации */
               IF (    (nMU_ADD IS NOT NULL)
                   AND (SPEC.UMP = nMU_ADD))
               THEN
                  nQSJ_REAL := NVL (R.QUANTALT, 0);
               ELSE
                  nQSJ_REAL := R.QUANT;
               END IF;

               IF (nOPER_DIRECTION = 0)
               THEN
/* если расход */
                  P_SALESRPTDET_BASE_INSERT (nTRRN,
                     SPEC.O_D,
                     nSTORE_OPER,
                     INVS.IIT,
                     LTRIM (INVS.IIN),
                     INVS.IID,
                     nVALID_DOCTYPE,
                     sVALID_DOCNUMB,
                     dVALID_DOCDATE,
                     NULL,
                     nAGENT,
                     nFACEACC,
                     SPEC.NMN,
                     NULL/* nNOMMODIF */,
                     NULL/* nNOMNMODIFPACK */,
                     nPAY_TYPE,
                     nDISP_TYPE,
                     NULL,
                     SPEC.EQV,
                     R.QUANT,
                     R.QUANTALT,
                     nQSJ_REAL,
                     nM_REAL,
                     R.PARTY,
                     NULL,
                     nCURRENCY,
                     nCURR_RATE,
                     nCURR_RATE_BASE,
                     SPEC.SS / nQ_REAL * nQSJ_REAL,
                     SPEC.SSB / nQ_REAL * nQSJ_REAL,
                     SPEC.TGR,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     nSPTRRN);
               ELSE
/* если внутреннее перемещение */
                  P_SALESRPTDET_BASE_INSERT (nTRRN,
                     SPEC.O_D,
                     nSTORE_OPER,
                     INVS.IIT,
                     LTRIM (INVS.IIN),
                     INVS.IID,
                     NULL,
                     NULL,
                     NULL,
                     nPBE,
                     nSMOL,
                     NULL,
                     SPEC.NMN,
                     NULL/* nNOMMODIF */,
                     NULL/* nNOMNMODIFPACK */,
                     nPAY_TYPE,
                     nDISP_TYPE,
                     NULL,
                     SPEC.EQV,
                     R.QUANT,
                     R.QUANTALT,
                     nQSJ_REAL,
                     nM_REAL,
                     R.PARTY,
                     NULL,
                     nCURRENCY,
                     nCURR_RATE,
                     nCURR_RATE_BASE,
                     SPEC.SS / nQ_REAL * nQSJ_REAL,
                     SPEC.SSB / nQ_REAL * nQSJ_REAL,
                     SPEC.TGR,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     nSPTRRN);
               END IF;

/* установка выходного документа */
               PKG_INHIER.SET_OUT_DOC (nIDENT, 1, nSPTRRN);
/* привязка входного документа к буферному или выходному */
               PKG_INHIER.LINK_IN (nIDENT);
               bFOUND := TRUE;
            END LOOP;
         END LOOP;
      END IF;
   END LOOP;

/* сканирование актов недостачи, которые попадают в заданный интервал и имеют спецификации
в которых принятое количество отличается от фактического */
   PKG_INHIER.SET_IN_UNIT (nIDENT, 0, 'LossActs');

   FOR LAS IN (SELECT/*+ ORDERED */
                   LA.RN LRN, LA.DOC_TYPE LDT, LA.DOC_NUMB LDN, LA.DOC_DATE LDD, LA.INVOICE LI
                 FROM LOSSACTS LA, INVOICES INV
                WHERE LA.COMPANY = nCOMPANY
                  AND LA.DOC_DATE >= dB_DATE
                  AND LA.DOC_DATE <= dE_DATE
                  AND LA.INVOICE = INV.RN
                  AND INV.SEND_STORE = nSTORE
                  AND (   nSTOREOPER IS NULL
                        OR INV.STORE_OPER = nSTOREOPER)
                  AND EXISTS (SELECT *
                                FROM INVCSPEC LIVCS
                               WHERE LIVCS.PRN = LA.INVOICE
                                 AND LIVCS.REAL_QUANT != LIVCS.QUANT))
   LOOP
/* установка входного документа */
      PKG_INHIER.SET_IN_DOC (nIDENT, 0, LAS.LRN);
/* проверка - отработан ли акт недостачи */
      P_LINKSALL_FIND_UNITCODE_LINK (1, nCOMPANY, 'LossActs', LAS.LRN, 'TradeReports', nFIND);

      IF (nFIND = 0)
      THEN
/* создание заголовка товарного отчета */
         CreateMaster;
         SELECT/*+ ORDERED */ I.STORE_OPER, I.PAY_TYPE, I.DISP_TYPE, I.CURRENCY, I.CURR_RATE,
                              I.CURR_RATE_BASE,
                              I.INT_STORE
           INTO nSTORE_OPER, nPAY_TYPE, nDISP_TYPE, nCURRENCY, nCURR_RATE, nCURR_RATE_BASE,
                nINT_STORE
           FROM INVOICES I
          WHERE I.RN = LAS.LI;
/* cчитывание направления складской операции */
         SELECT SO.SECTION
           INTO nOPER_DIRECTION
           FROM AZSGSMWAYSTYPES SO
          WHERE SO.RN = nSTORE_OPER;

/* cчитывание контрагента, документа основания и МОЛ */
         IF (nOPER_DIRECTION = 0)
         THEN
/* если расход, то определяем контрагента и документ основание */
            SELECT/*+ ORDERED */
                FA.AGENT, FA.VALID_DOCTYPE, FA.VALID_DOCNUMB, FA.VALID_DOCDATE
              INTO nAGENT, nVALID_DOCTYPE, sVALID_DOCNUMB, dVALID_DOCDATE
              FROM FACEACC FA, INVOICES IV
             WHERE FA.RN = IV.FACE_ACCOUNT
               AND IV.RN = LAS.LI;
         ELSE
/* если внутреннее перемещение, то определяем склад и ПБЕ */
            SELECT/*+ ORDERED */
                S.AZS_PBE, S.AZS_AGENT
              INTO nPBE, nSMOL
              FROM AZSAZSLISTMT S, INVOICES IV
             WHERE S.RN = nINT_STORE
               AND IV.RN = LAS.LI;
         END IF;

         FOR SPEC1 IN (SELECT/*+ ORDERED */
                           SPC.RN RN, SPC.OPER_DATE O_D, SPC.NOMEN NMN, SPC.EQUAL EQV, SPC.TAX_GROUP TGR,
                           SPC.UMEAS_PRICE UMP, SPC.QUANT SQ, SPC.AQUANT SAQ, SPC.SPEC_SUM SS,
                           SPC.SPEC_SUM_BASE SSB, SPC.REAL_QUANT SRQ, SPC.REAL_SUM SRS,
                           SPC.REAL_SUM_BASE SRSB
                         FROM INVCSPEC SPC
                        WHERE SPC.PRN = LAS.LI
                          AND SPC.SPEC_TYPE = 1)
         LOOP
/* установка входного документа */
            PKG_INHIER.SET_IN_DOC (nIDENT, 1, SPEC1.RN);

/* определяем единицы измерения для номенклатуры */
            BEGIN
               SELECT UMEAS_MAIN, UMEAS_ALT
                 INTO nMU_MAIN, nMU_ADD
                 FROM DICNOMNS
                WHERE RN = SPEC1.NMN;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  P_EXCEPTION (0, 'Номенклатура не определена.');
            END;

/* определяем количество реализации и Единицу измерения реализации */
            IF (SPEC1.UMP = nMU_MAIN)
            THEN
               nM_REAL := nMU_MAIN;
               nQ_REAL := SPEC1.SRQ - SPEC1.SQ;
            ELSE
               IF (    (nMU_ADD IS NOT NULL)
                   AND (SPEC1.UMP = nMU_ADD))
               THEN
                  nM_REAL := nMU_ADD;
                  nQ_REAL := (SPEC1.SRQ - SPEC1.SQ) * SPEC1.EQV;
               ELSE
                  P_EXCEPTION (0, 'Несоответствие единицы измерения цены единицам измерения номенклатуры.');
               END IF;
            END IF;

/* формирование спецификаций */
            IF (nOPER_DIRECTION = 0)
            THEN
/* если расход */
               P_SALESRPTDET_BASE_INSERT (nTRRN,
                  SPEC1.O_D,
                  nSTORE_OPER,
                  LAS.LDT,
                  LAS.LDN,
                  LAS.LDD,
                  nVALID_DOCTYPE,
                  sVALID_DOCNUMB,
                  dVALID_DOCDATE,
                  NULL,
                  nAGENT,
                  NULL,
                  SPEC1.NMN,
                  NULL/* nNOMMODIF */,
                  NULL/* nNOMNMODIFPACK */,
                  nPAY_TYPE,
                  nDISP_TYPE,
                  NULL,
                  SPEC1.EQV,
                  SPEC1.SRQ - SPEC1.SQ,
                  (SPEC1.SRQ - SPEC1.SQ) * SPEC1.EQV,
                  nQ_REAL,
                  nM_REAL,
                  NULL,
                  NULL,
                  nCURRENCY,
                  nCURR_RATE,
                  nCURR_RATE_BASE,
                  SPEC1.SRS - SPEC1.SS,
                  SPEC1.SRSB - SPEC1.SSB,
                  SPEC1.TGR,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  nSPTRRN);
            ELSE
/* если внутреннее перемещение */
               P_SALESRPTDET_BASE_INSERT (nTRRN,
                  SPEC1.O_D,
                  nSTORE_OPER,
                  LAS.LDT,
                  LTRIM (LAS.LDN),
                  LAS.LDD,
                  NULL,
                  NULL,
                  NULL,
                  nPBE,
                  nSMOL,
                  NULL,
                  SPEC1.NMN,
                  NULL/* nNOMMODIF */,
                  NULL/* nNOMNMODIFPACK */,
                  nPAY_TYPE,
                  nDISP_TYPE,
                  NULL,
                  SPEC1.EQV,
                  SPEC1.SRQ - SPEC1.SQ,
                  (SPEC1.SRQ - SPEC1.SQ) * SPEC1.EQV,
                  nQ_REAL,
                  nM_REAL,
                  NULL,
                  NULL,
                  nCURRENCY,
                  nCURR_RATE,
                  nCURR_RATE_BASE,
                  SPEC1.SRS - SPEC1.SS,
                  SPEC1.SRSB - SPEC1.SSB,
                  SPEC1.TGR,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  nSPTRRN);
            END IF;

/* установка выходного документа */
            PKG_INHIER.SET_OUT_DOC (nIDENT, 1, nSPTRRN);
/* привязка входного документа к буферному или выходному */
            PKG_INHIER.LINK_IN (nIDENT);
            bFOUND := TRUE;
         END LOOP;
      END IF;
   END LOOP;

/* cканирование актов списывания/оприходывания излишков , которые попадают в заданный интервал */
   PKG_INHIER.SET_IN_UNIT (nIDENT, 0, 'OilInventoryActs');
   PKG_INHIER.SET_IN_UNIT (nIDENT, 1, 'OilInventoryActsSpecs');

   FOR C IN (SELECT/*+ RULE */
                 H.RN HEADER, H.DOC_TYPE, H.DOC_PREF, H.DOC_NUMB, H.DOC_DATE, SP.RN SPEC, SP.PRN, SP.NOMEN,
                 SP.STORE_OPER, SP.QUANT_MAIN, SP.QUANT_ALT, SP.UMEAS_PRICE, SP.PRICE, SP.TAX_GROUP
               FROM OILINVACT H, OILINVACTSP SP, AZSBOOKREMNSMAIN BR
              WHERE H.COMPANY = nCOMPANY
                AND H.BREMN = BR.RN
                AND BR.AZS_NUMBER = nSTORE
                AND H.DOC_DATE BETWEEN DB_DATE AND DE_DATE)
   LOOP
/* установка входного документа */
      PKG_INHIER.SET_IN_DOC (nIDENT, 0, C.HEADER);
      PKG_INHIER.SET_IN_DOC (nIDENT, 1, C.SPEC);
/* проверка - отработана ли данная запись прихода */
      P_LINKSALL_FIND_UNITCODE_LINK (1, NCOMPANY, 'OilInventoryActsSpecs', C.SPEC, 'TradeReportsSp', NFIND);

      IF NFIND = 0
      THEN
/* создание заголовка товарного отчета */
         CreateMaster;

/* определяем группу ТМЦ */
         BEGIN
            SELECT UMEAS_MAIN, UMEAS_ALT
              INTO nMU_MAIN, nMU_ADD
              FROM DICNOMNS
             WHERE RN = C.NOMEN;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               P_EXCEPTION (0, 'Номенклатура не определена.');
         END;

         IF C.QUANT_MAIN != 0
         THEN
            nEQUAL := C.QUANT_ALT / C.QUANT_MAIN;
         ELSE
            nEQUAL := 0;
         END IF;

/* определяем количество реализации и Единицу измерения реализации */
         IF (C.UMEAS_PRICE = nMU_MAIN)
         THEN
            nQUANT := C.QUANT_MAIN;
         ELSIF (    (nMU_ADD IS NOT NULL)
                AND (C.UMEAS_PRICE = nMU_ADD))
         THEN
            nQUANT := C.QUANT_ALT;
         ELSE
            P_EXCEPTION (0, 'Несоответствие единицы измерения цены единицам измерения номенклатуры.');
         END IF;

         nSUM := C.PRICE * nQUANT;
/* формирование спецификаций */
         P_SALESRPTDET_BASE_INSERT (NTRRN,
            C.DOC_DATE,
            C.STORE_OPER,
            C.DOC_TYPE,
            LTRIM (C.DOC_PREF) || LTRIM (C.DOC_NUMB),
            C.DOC_DATE,
            NULL,
            NULL,
            NULL,
            NPBE,
            NMOL,
            NULL,
            C.NOMEN,
            NULL/* nNOMMODIF */,
            NULL/* nNOMNMODIFPACK */,
            NULL,
            NULL,
            NULL,
            nEQUAL,
            C.QUANT_MAIN,
            C.QUANT_ALT,
            nQUANT,
            C.UMEAS_PRICE,
            NULL,
            NULL,
            BASE_CURR,
            1,
            1,
            nSUM,
            nSUM,
            C.TAX_GROUP,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NSPTRRN);
/* установка выходного документа */
         PKG_INHIER.SET_OUT_DOC (nIDENT, 1, nSPTRRN);
/* привязка входного документа к буферному или выходному */
         PKG_INHIER.LINK_IN (nIDENT);
         bFOUND := TRUE;
      END IF;
   END LOOP;

/* если данных для отчета не найдено и отчет, соответственно, не создан */
   IF NOT bFOUND
   THEN
      P_EXCEPTION (0, 'Данные для формирования товарного отчета не найдены.');
   END IF;

/* проверка прав доступа и привязка входных и выходных документов */
   PKG_INHIER.LINK_PROLOGUE (nIDENT);
   PKG_INHIER.LINK_DOCS (nIDENT);
   PKG_INHIER.INHR_PROPS (nIDENT);
   PKG_INHIER.LINK_EPILOGUE (nIDENT);
   PKG_INHIER.DESTRUCTOR (nIDENT);
END;
/

