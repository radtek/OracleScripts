--
-- V_KTU_UNP_2  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KTU_UNP_2
(YY, MM, KOD_PLAT, NAME_PLAT, KOD_PROD, 
 NAME_PROD, TIP_ERROR, NOM_ZD_KTU, NARIAD_KTU, DOVEREN_KTU, 
 VES_KTU, NOM_ZD_UNP, NARIAD_UNP, DOVEREN_UNP, VES_UNP, 
 DATE_END, MAX_DATE_NAR, CHECK_DATE)
AS 
SELECT 
  UNP.YY,
  UNP.MM,
  UNP.kod_plat,
  UNP.name_plat, 
  UNP.kod_prod, 
  UNP.name_prod,
  TipError(ktu.name_prod,unp.name_prod,ktu.nom_zd,unp.nom_zd,ktu.nariad,unp.nariad,ktu.doveren,unp.doveren,ktu.ves,unp.ves,ktu.date_end,unp.date_end) AS TIP_ERROR, 
  KTU.nom_zd AS NOM_ZD_KTU, 
  KTU.NARIAD AS NARIAD_KTU, 
  KTU.DOVEREN AS DOVEREN_KTU, 
  KTU.VES AS VES_KTU, 
  UNP.nom_zd AS NOM_ZD_UNP, 
  UNP.NARIAD AS NARIAD_UNP, 
  UNP.DOVEREN AS DOVEREN_UNP, 
  UNP.VES AS VES_UNP, 
  KTU.date_end, 
  UNP.date_end AS MAX_DATE_NAR, 
  '' AS CHECK_DATE
FROM V_NARIAD_KTU KTU, V_NARIAD_UNP UNP 
WHERE
  KTU.DOVEREN (+) = UNP.DOVEREN AND 
  KTU.NARIAD (+) = UNP.NARIAD AND 
  KTU.kod_plat (+) = UNP.kod_plat AND 
  KTU.nom_zd (+) = UNP.nom_zd AND
  KTU.YY (+) = UNP.YY AND
  KTU.MM (+) = UNP.MM 
ORDER BY UNP.YY, UNP.MM, UNP.kod_plat, UNP.kod_prod, UNP.nom_zd, UNP.doveren, UNP.nariad;


