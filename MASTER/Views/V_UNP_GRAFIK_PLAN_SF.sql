--
-- V_UNP_GRAFIK_PLAN_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_GRAFIK_PLAN_SF
(DOG_ID, DATE_PRED, KOL_DN, SUMMA_PRED)
AS 
SELECT
  -- Плнируемая отгрузка по дням в РУБ
  b.DOG_ID,
  KLS_DATES.VALUE as date_pred,
  MAX(kol_dn) as KOL_DN,
  SUM(ROUND(b.summa_pred/b.kol_ost,2)) as summa_pred
FROM
(
SELECT
  aaaaa.DOG_ID,
  aaaaa.begin_date,
  aaaaa.end_date,
  kol_dn,kol_ost,
  aaaaa.end_date+1 as from_date, -- Дата начала плановой отгрузки
  (CASE
     WHEN KOL_OST>=KOL_DN THEN aaaaa.end_date+KOL_OST-KOL_DN
	 ELSE aaaaa.end_date
   END) as to_date,	 -- Дата окончания плановой отгрузки
  (CASE
     WHEN KOL_OST>=KOL_DN AND KOL_OST>0 THEN ROUND(summa_pred / KOL_OST,2)
	 ELSE 0
   END) AS summa_pred -- Планируемая отгрузка за сутки
FROM
(
SELECT
  aaaa.begin_date,
  aaaa.end_date,
  aaaa.DOG_ID,
  SUM(aaaa.summa_pred) AS summa_pred, -- Осталось отгрузить в текущем месяце (РУБ)
  MAX(GET_KOL_DN(aaaa.DOG_ID,aaaa.begin_date,aaaa.end_date,aaaa.PROD_ID_NPR)) as KOL_DN, -- Кол-во дней отсрочки
  LAST_DAY(aaaa.end_date) - aaaa.end_date as KOL_OST -- Кол-во дней осталось до конца месяца
FROM
(
SELECT /*+ ORDERED INDEX(b BILLS_DATE_KVIT) USE_NL(b,bp,kls_dog) */
  -- Факт предъявления с минусом (РУБ)
  r.begin_date,
  r.end_date,
  bp.PROD_ID_NPR,
  b.dog_id,
  sum(-bp.summa) AS summa_pred -- Фактически отгружено (РУБ)
FROM V_TEMP_UNP_GARFIK_PARAMS r, bills b, bill_pos bp, kls_prod
WHERE b.DATE_KVIT BETWEEN r.BEGIN_DATE AND r.END_DATE
  AND b.nom_dok=bp.nom_dok
  AND bp.PROD_ID_NPR=KLS_PROD.ID_NPR
  AND kls_prod.ID_GROUP_NPR>=DECODE(r.GRP_ID_NPR,'*','00000',r.GRP_ID_NPR)
  AND kls_prod.ID_GROUP_NPR<=DECODE(r.GRP_ID_NPR,'10100','99999','*','99999',r.GRP_ID_NPR)
  AND bp.IS_LUK+0=1
GROUP BY
  r.begin_date,
  r.end_date,
  bp.PROD_ID_NPR,
  b.dog_id
UNION ALL
SELECT
  -- План отгрузки с плюсом (РУБ)
  aaa.begin_date,
  aaa.end_date,
  aaa.PROD_ID_NPR,
  aaa.DOG_ID,
  ROUND((CASE
     WHEN aaa.CENA_BN=0 THEN NVL(aaa.PLAN_CENA,0)
	 ELSE aaa.CENA_BN
   END) * aaa.NDS * aaa.PLAN_VES,2) as summa_pred -- Запалнировано к отгрузке в текущем месяце (РУБ)
FROM
(
SELECT
  aa.begin_date,
  aa.end_date,
  aa.PROD_ID_NPR,
  aa.DOG_ID,
  aa.PLAN_VES,
  aa.PLAN_CENA as PLAN_CENA,
  GET_CENA_BN(aa.DOG_ID,aa.end_date,aa.prod_id_npr) as CENA_BN,
  (100+FOR_BILLS.GetNDSValue(aa.end_date))/100 as NDS
FROM
(
SELECT
  -- План отгрузки с плюсом (ТН)
  r.begin_date,
  r.end_date,
  a.PROD_ID_NPR,
  a.DOG_ID,
  MAX(a.PLAN_CENA) as PLAN_CENA,
  SUM(a.PLAN_VES) as PLAN_VES-- Запланировано к отгрузке в текущем месяце (ТН)
FROM plan_periods b,plan_post a,V_TEMP_UNP_GARFIK_PARAMS r, kls_prod
where b.PLAN_ID in (2,3) and
  b.DATE_PLAN=TRUNC(r.end_date,'MONTH') and
  a.PLAN_PER_ID=b.ID
  AND a.PROD_ID_NPR=KLS_PROD.ID_NPR
  AND kls_prod.ID_GROUP_NPR>=DECODE(r.GRP_ID_NPR,'*','00000',r.GRP_ID_NPR)
  AND kls_prod.ID_GROUP_NPR<=DECODE(r.GRP_ID_NPR,'10100','99999','*','99999',r.GRP_ID_NPR)
GROUP BY
  r.begin_date,
  r.end_date,
  a.PROD_ID_NPR,
  a.DOG_ID
) aa
) aaa
) aaaa
GROUP BY
  aaaa.begin_date,
  aaaa.end_date,
  aaaa.DOG_ID
HAVING sum(summa_pred)<>0
) aaaaa
) b, kls_dates,kls_dog,V_TEMP_UNP_GARFIK_PARAMS r
WHERE KLS_DATES.VALUE>=b.from_date
  AND KLS_DATES.VALUE<=b.to_date
  AND b.dog_id=kls_dog.id
  AND kls_dog.predpr_id=DECODE(r.PLAT_ID,0,kls_dog.predpr_id,r.PLAT_ID)
  AND kls_dog.dog_number like r.DOG_NUMBER
  AND KLS_DOG.AGENT_ID+0 in (8,4175) AND KLS_DOG.PREDPR_ID+0<>8 AND KLS_DOG.PREDPR_ID+0<>4175 -- только договора УНП
GROUP BY
  b.DOG_ID,
  KLS_DATES.VALUE;


