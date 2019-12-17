--
-- V_PARUS_SOOB_DZM  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_SOOB_DZM
(AGENT, INN, DOG, DAY_OTSR, KOD_REAL, 
 KOD_KONTR, DEB_ZAD, DEB_PRO, DAY_ZAD, COMMEN, 
 RNA, DATE_F, DATE_T, KRED, DAY_PR)
AS 
SELECT AGENT, inn, dog, day_otsr, kod_real, kod_kontr,
       deb_zad * 1000 AS deb_zad, deb_pro * 1000 AS deb_pro, day_zad, commen,
       rna, date_f, date_t, - kred*1000, day_pr
  FROM parus.tr_debt_zadolg_nlg@oracle.world
 WHERE AUTHID = 'PARUS' AND ident = 0;


