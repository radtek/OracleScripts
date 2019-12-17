--
-- V_UNP_BUDJET_NPR_NEW  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_BUDJET_NPR_NEW
(BEGIN_DATE, END_DATE, GROUP_ORDER, GROUP_NAME, PLAT_NAME, 
 BEGIN_DEB, BEGIN_DEB_PROSR, BEGIN_DEB_CUR, BEGIN_DEB_NEXT, BEGIN_KRED, 
 SUMMA_DOK_CUR, SUMMA_DOK_NEXT, SUMMA_PAYED, SUMMA_TOPAY, END_DEB, 
 END_DEB_PROSR, END_DEB_CUR, END_KRED)
AS 
SELECT /*+ RULE */
  a.begin_date,
  a.end_date,
  a.GROUP_ORDER,
  a.GROUP_NAME,
  a.PLAT_NAME,
  NVL(SUM(A.begin_deb),0) AS begin_deb, -- Задолженность в предыдущем периоде
  NVL(SUM(A.begin_deb_prosr),0) AS begin_deb_prosr, -- Просрочена задолженность в предыдущем периоде
  NVL(SUM(A.begin_deb_cur),0) AS begin_deb_cur, -- Задолженность прошлого периода к погашению в текущем
  NVL(SUM(A.begin_deb_next),0) AS begin_deb_next, -- Задолженность прошлого периода к погашению в текущем
  NVL(SUM(A.begin_kred),0) AS begin_kred, -- Кредиторка в предыдущем периоде
  NVL(SUM(A.summa_dok_cur),0) AS summa_dok_cur, -- Отгружено в текущем периоде, к погашению в текущем периоде
  NVL(SUM(A.summa_dok_next),0) AS summa_dok_next, -- Отгружено в текущем периоде, к погашению в следующем периоде
  NVL(SUM(A.summa_payed),0) AS summa_payed, -- Оплачено в текущем периоде
  NVL(SUM(A.summa_topay),0) AS summa_topay, -- Не разнесены оплаты в текущем периоде
  NVL(SUM(A.end_deb),0) AS end_deb, -- Задолженность на конец текущего периода (для ПРОВЕРКИ)
  NVL(SUM(A.end_deb_prosr),0) AS end_deb_prosr, -- Просрочена задолженность на конец текущего периода (для ПРОВЕРКИ)
  NVL(SUM(A.end_deb_cur),0) AS end_deb_cur, -- Текущая задолженность на конец текущего периода (для ПРОВЕРКИ)
  NVL(SUM(A.end_kred),0) AS end_kred -- Кредиторка на конец текущего периода (для ПРОВЕРКИ)
FROM
(
SELECT * FROM V_UNP_BUDJET_NPR_FACT
UNION ALL
SELECT * FROM V_UNP_BUDJET_NPR_PLAN
) a
GROUP BY
  a.begin_date,
  a.end_date,
  a.GROUP_ORDER,
  a.GROUP_NAME,
  a.PLAT_NAME;


