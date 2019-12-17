--
-- V_AGENT_REPORT_2006  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AGENT_REPORT_2006
(DATE_AGENT, DOG_NUMBER, DOG_DATE, PREDPR_NAME, VES, 
 SUM_TARIF_AREND_BN, SUM_TARIF_AREND_NDS, SUM_TARIF_AREND, SUM_TARIF_BN, SUM_TARIF_NDS, 
 SUM_TARIF, SUM_VOZN_10001_BN, SUM_VOZN_10001_NDS, SUM_VOZN_10001, SUM_VOZN_BN, 
 SUM_VOZN_NDS, SUM_VOZN, SUM_USL_AREND_BN, SUM_USL_AREND_NDS, SUM_USL_AREND, 
 SUM_USL_BN, SUM_USL_NDS, SUM_USL, SUM_VOZN_GD_BN, SUM_VOZN_GD_NDS, 
 SUM_VOZN_GD, SUM_STRAH, SUM_VOZN_10052_BN, SUM_VOZN_10052_NDS, SUM_VOZN_10052, 
 SUM_VOZN_10051_BN, SUM_VOZN_10051_NDS, SUM_VOZN_10051, SUM_VOZN_10050_BN, SUM_VOZN_10050_NDS, 
 SUM_VOZN_10050, SUM_VOZN_10060_BN, SUM_VOZN_10060_NDS, SUM_VOZN_10060, SUM_VOZN_10061_BN, 
 SUM_VOZN_10061_NDS, SUM_VOZN_10061, SUM_VOZN_10053_BN, SUM_VOZN_10053_NDS, SUM_VOZN_10053, 
 SUM_VOZN_10054_BN, SUM_VOZN_10054_NDS, SUM_VOZN_10054, SUM_VOZN_10007_BN, SUM_VOZN_10007_NDS, 
 SUM_VOZN_10007, SUM_VOZN_10056_BN, SUM_VOZN_10056_NDS, SUM_VOZN_10056, SUM_VOZN_10057_BN, 
 SUM_VOZN_10057_NDS, SUM_VOZN_10057)
AS 
SELECT
  date_agent,
  DOG_NUMBER,
  dog_date,
  PREDPR_NAME,
  SUM(VES) AS ves,
  -- Тариф по транспортировке в аренд.вагонах
  SUM(sum_tarif_arend_bn),
  SUM(sum_tarif_arend_nds),
  SUM(sum_tarif_arend),
  -- Тариф
  SUM(sum_tarif_bn),
  SUM(sum_tarif_nds),
  SUM(sum_tarif),
  -- Вознаграждение по ИВР
  SUM(sum_vozn_10001_bn),
  SUM(sum_vozn_10001_NDS),
  SUM(sum_vozn_10001),
  -- Вознаграждение
  SUM(sum_vozn_bn),
  SUM(sum_vozn_NDS),
  SUM(sum_vozn),
  -- Услуги по организации транспортировки в аренд вагонах
  SUM(sum_usl_arend_bn),
  SUM(sum_usl_arend_NDS),
  SUM(sum_usl_arend),
  -- Услуги по организации транспортировки в вагонах МПС
  SUM(sum_usl_bn),
  SUM(sum_usl_NDS),
  SUM(sum_usl),
  -- Услуги предоставлению вагонов
  SUM(sum_vozn_gd_bn),
  SUM(sum_vozn_gd_NDS),
  SUM(sum_vozn_gd),
  SUM(sum_strah),
  -- Договорный сбор за перевозку в вагонах перевозчика
  SUM(sum_vozn_10052_bn),
  SUM(sum_vozn_10052_NDS),
  SUM(sum_vozn_10052),
  -- Договорный сбор за перевозку в арендованных вагонах
  SUM(sum_vozn_10051_bn),
  SUM(sum_vozn_10051_NDS),
  SUM(sum_vozn_10051),
  -- Cбор за изменение заявки
  SUM(sum_vozn_10050_bn),
  SUM(sum_vozn_10050_NDS),
  SUM(sum_vozn_10050),
  -- Штраф за невыполнение заявки 0,1 МРОТ
  SUM(sum_vozn_10060_bn),
  'НДС не предусмотрен' as sum_vozn_10060_NDS,
  SUM(sum_vozn_10060),
  -- Штраф за невыполнение заявки 0,1 МРОТ/3*2
  SUM(sum_vozn_10061_bn),
  'НДС не предусмотрен' AS sum_vozn_10061_NDS,
  SUM(sum_vozn_10061),
  -- Cбор за изменение станции
  SUM(sum_vozn_10053_bn),
  SUM(sum_vozn_10053_NDS),
  SUM(sum_vozn_10053),
  -- Cбор за факс-обмен
  SUM(sum_vozn_10054_bn),
  SUM(sum_vozn_10054_NDS),
  SUM(sum_vozn_10054),
  -- Услуги по подаче телеграм
  SUM(sum_vozn_10007_bn),
  SUM(sum_vozn_10007_NDS),
  SUM(sum_vozn_10007),
  -- Отстой цистерн Покупателя на путях общего пользования составил 
  SUM(sum_vozn_10056_bn),
  SUM(sum_vozn_10056_NDS),
  SUM(sum_vozn_10056),
  -- Подготовка цистерн Покупателя под налив средствами Сосногорского вагонного депо составила 
  SUM(sum_vozn_10057_bn),
  SUM(sum_vozn_10057_NDS),
  SUM(sum_vozn_10057)
FROM
(
SELECT
  end_date AS date_agent,
  kls_dog.DOG_NUMBER,
  RusDate(kls_dog.dog_date) as dog_date,
  kls_predpr.PREDPR_NAME,
  SUM(v_bill_pos_flat.VES) AS ves,
  -- Тариф по транспортировке в аренд.вагонах
  0 AS sum_tarif_arend_bn,
  0 AS sum_tarif_arend_nds,
  0 AS sum_tarif_arend,
  -- Тариф
  0 AS sum_tarif_bn,
  0 AS sum_tarif_nds,
  0 AS sum_tarif,
  -- Вознаграждение по ИВР
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10001_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10001_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10001,
  -- Вознаграждение
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR>='10100' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR>='10100' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR>='10100' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn,
  -- Услуги по организации транспортировки в аренд вагонах
  0 AS sum_usl_arend_bn,
  0 AS sum_usl_arend_NDS,
  0 AS sum_usl_arend,
  -- Услуги по организации транспортировки в вагонах МПС
  0 AS sum_usl_bn,
  0 AS sum_usl_NDS,
  0 AS sum_usl,
  -- Услуги предоставлению вагонов
  0 AS sum_vozn_gd_bn,
  0 AS sum_vozn_gd_NDS,
  0 AS sum_vozn_gd,
  SUM(v_bill_pos_flat.STRAH) AS sum_strah,
  -- Договорный сбор за перевозку в вагонах перевозчика
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10052' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10052_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10052' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10052_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10052' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10052,
  -- Договорный сбор за перевозку в арендованных вагонах
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10051' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10051_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10051' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10051_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10051' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10051,
  -- Cбор за изменение заявки
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10050' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10050_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10050' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10050_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10050' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10050,
  -- Штраф за невыполнение заявки 0,1 МРОТ
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10060' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10060_bn,
  'НДС не предусмотрен' AS sum_vozn_10060_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10060' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10060,
  -- Штраф за невыполнение заявки 0,1 МРОТ/3*2
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10061' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10061_bn,
  'НДС не предусмотрен' AS sum_vozn_10061_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10061' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10061,
  -- Cбор за изменение станции
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10053' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10053_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10053' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10053_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10053' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10053,
  -- Cбор за факс-обмен
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10054' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10054_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10054' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10054_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10054' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10054,
  -- Услуги по подаче телеграм
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10007' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10007_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10007' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10007_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10007' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10007,
  -- Отстой цистерн Покупателя на путях общего пользования составил 
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10056' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10056_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10056' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10056_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10056' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10056,
  -- Подготовка цистерн Покупателя под налив средствами Сосногорского вагонного депо составила 
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10057' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
   ELSE 0
   END) AS sum_vozn_10057_bn,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10057' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
   ELSE 0
   END) AS sum_vozn_10057_NDS,
  SUM(CASE
      WHEN v_bills.PROD_ID_NPR='10057' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
   ELSE 0
   END) AS sum_vozn_10057
 FROM v_bills_fin_unp v_bills,v_bill_pos_flat_fin_unp v_bill_pos_flat,kls_dog,kls_predpr,usl_dog,V_MASTER_REPORTS,month,kls_vid_otgr
 WHERE
   v_bills.DOG_ID=kls_dog.id and
   v_bills.NOM_DOK=v_bill_pos_flat.NOM_DOK and
   kls_dog.PREDPR_ID=kls_predpr.ID and
--   v_bills.DATE_KVIT>=TO_DATE('01.01.2005','dd.mm.yyyy') and
--   v_bill_pos_flat.DATE_REALIZ>=TO_DATE('01.01.2005','dd.mm.yyyy') and
   kls_dog.dog_number LIKE V_MASTER_REPORTS.DOG_NUMBER and
   v_bills.DATE_VYP_SF between begin_date AND end_date and
   NLS_UPPER(V_MASTER_REPORTS.REPORT_FILE)='OTCH_AGENT_2006.XLS'
   AND (v_bills.PROD_ID_NPR IN ('10001','10007','10050','10051','10052','10053','10054','10060','10061','10056','10057') OR
        v_bills.PROD_ID_NPR>='10100')
   AND v_bills.DOG_ID=usl_dog.DOG_ID(+)
   AND v_bills.USL_NUMBER=usl_dog.USL_NUMBER(+)
   AND v_bills.IS_AGENT IN (2,4,5)
   AND v_bills.nom_zd=month.nom_zd(+)
   AND month.load_abbr=kls_vid_otgr.load_abbr(+)
   AND (kls_vid_otgr.LOAD_TYPE_ID in (1,4,6) or kls_vid_otgr.LOAD_TYPE_ID is null)
 GROUP BY
   end_date,
   kls_dog.DOG_NUMBER,
   kls_dog.dog_date,
   kls_predpr.PREDPR_NAME
--
UNION ALL
--
-- Тариф
SELECT
  end_date AS date_agent,
  kls_dog.DOG_NUMBER,
  RusDate(kls_dog.dog_date) as dog_date,
  kls_predpr.PREDPR_NAME,
  0 AS ves,
  -- Тариф по транспортировке в аренд.вагонах
  0 AS sum_tarif_arend_bn,
  0 AS sum_tarif_arend_nds,
  0 AS sum_tarif_arend,
  -- Тариф
  SUM(v_bill_pos_flat.TARIF_BN+v_bill_pos_flat.TARIF_GUARD_BN) AS sum_tarif_bn,
  SUM(v_bill_pos_flat.TARIF_NDS+v_bill_pos_flat.TARIF_GUARD_NDS) AS sum_tarif_nds,
  SUM(v_bill_pos_flat.TARIF+v_bill_pos_flat.TARIF_GUARD) AS sum_tarif,
  -- Вознаграждение по ИВР
  0 AS sum_vozn_10001_bn,
  0 AS sum_vozn_10001_NDS,
  0 AS sum_vozn_10001,
  -- Вознаграждение
  0 AS sum_vozn_bn,
  0 AS sum_vozn_NDS,
  0 AS sum_vozn,
  -- Услуги по организации транспортировки в аренд вагонах
  0 AS sum_usl_arend_bn,
  0 AS sum_usl_arend_NDS,
  0 AS sum_usl_arend,
  -- Услуги по организации транспортировки в вагонах МПС
  0 AS sum_usl_bn,
  0 AS sum_usl_NDS,
  0 AS sum_usl,
  -- Услуги предоставлению вагонов
  0 AS sum_vozn_gd_bn,
  0 AS sum_vozn_gd_NDS,
  0 AS sum_vozn_gd,
  0 AS sum_strah,
  -- Договорный сбор за перевозку в вагонах перевозчика
  0 AS sum_vozn_10052_bn,
  0 AS sum_vozn_10052_NDS,
  0 AS sum_vozn_10052,
  -- Договорный сбор за перевозку в арендованных вагонах
  0 AS sum_vozn_10051_bn,
  0 AS sum_vozn_10051_NDS,
  0 AS sum_vozn_10051,
  -- Cбор за изменение заявки
  0 AS sum_vozn_10050_bn,
  0 AS sum_vozn_10050_NDS,
  0 AS sum_vozn_10050,
  -- Штраф за невыполнение заявки 0,1 МРОТ
  0 AS sum_vozn_10060_bn,
  'НДС не предусмотрен' AS sum_vozn_10060_NDS,
  0 AS sum_vozn_10060,
  -- Штраф за невыполнение заявки 0,1 МРОТ/3*2
  0 AS sum_vozn_10061_bn,
  'НДС не предусмотрен' AS sum_vozn_10061_NDS,
  0 AS sum_vozn_10061,
  -- Cбор за изменение станции
  0 AS sum_vozn_10053_bn,
  0 AS sum_vozn_10053_NDS,
  0 AS sum_vozn_10053,
  -- Cбор за факс-обмен
  0 AS sum_vozn_10054_bn,
  0 AS sum_vozn_10054_NDS,
  0 AS sum_vozn_10054,
  -- Услуги по подаче телеграм
  0 AS sum_vozn_10007_bn,
  0 AS sum_vozn_10007_NDS,
  0 AS sum_vozn_10007,
  -- Отстой цистерн Покупателя на путях общего пользования составил 
  0 AS sum_vozn_10056_bn,
  0 AS sum_vozn_10056_NDS,
  0 AS sum_vozn_10056,
  -- Подготовка цистерн Покупателя под налив средствами Сосногорского вагонного депо составила 
  0 AS sum_vozn_10057_bn,
  0 AS sum_vozn_10057_NDS,
  0 AS sum_vozn_10057
 FROM v_bills_fin_unp v_bills,V_AGENT_REPORT_TARIF_2006 v_bill_pos_flat,kls_dog,kls_predpr,usl_dog,V_MASTER_REPORTS,month,kls_vid_otgr
 WHERE
   v_bills.DOG_ID=kls_dog.id and
   v_bills.NOM_DOK=v_bill_pos_flat.NOM_DOK and
   kls_dog.PREDPR_ID=kls_predpr.ID and
--   v_bills.DATE_KVIT>=TO_DATE('01.01.2005','dd.mm.yyyy') and
--   v_bill_pos_flat.DATE_REALIZ>=TO_DATE('01.01.2005','dd.mm.yyyy') and
   kls_dog.dog_number LIKE V_MASTER_REPORTS.DOG_NUMBER and
--   v_bills.DATE_VYP_SF between begin_date AND end_date and
   NLS_UPPER(V_MASTER_REPORTS.REPORT_FILE)='OTCH_AGENT_2006.XLS'
   AND v_bills.PROD_ID_NPR>='10100'
   AND v_bills.DOG_ID=usl_dog.DOG_ID(+)
   AND v_bills.USL_NUMBER=usl_dog.USL_NUMBER(+)
   AND v_bills.IS_AGENT IN (2,4,5)
   AND v_bills.nom_zd=month.nom_zd(+)
   AND month.load_abbr=kls_vid_otgr.load_abbr(+)
   AND (kls_vid_otgr.LOAD_TYPE_ID in (1,4,6) or kls_vid_otgr.LOAD_TYPE_ID is null)
 GROUP BY
   end_date,
   kls_dog.DOG_NUMBER,
   kls_dog.dog_date,
   kls_predpr.PREDPR_NAME
)
GROUP BY
  date_agent,
  DOG_NUMBER,
  dog_date,
  PREDPR_NAME;


