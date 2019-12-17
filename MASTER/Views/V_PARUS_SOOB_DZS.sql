--
-- V_PARUS_SOOB_DZS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_SOOB_DZS
(AGENT, INN, DOG, DAY_OTSR, KOD_REAL, 
 KOD_KONTR, DEB_ZAD, DEB_PRO, DEB_ZADE, DEB_PROE, 
 DAY_ZAD, COMMEN, RNA, DATE_F, DATE_T, 
 KRED, KREDE, DAY_PR)
AS 
SELECT AGENT, inn, dog, day_otsr, kod_real, kod_kontr, deb_zad * 1000,
       deb_pro * 1000, deb_zade * 1000, deb_proe * 1000, day_zad, commen, rna,
       date_f, date_t, -NVL(kred,0) * 1000,-NVL(krede,0) * 1000,NVL(day_pr,0)
  FROM parus.tr_debt_zadolg_nlg1@oracle.world
 WHERE AUTHID = 'PARUS' AND ident = 0;


