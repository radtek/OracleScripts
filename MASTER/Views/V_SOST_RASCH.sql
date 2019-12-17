--
-- V_SOST_RASCH  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SOST_RASCH
(DOG_NUMBER, DOG_ID, DATE_BUXG, DATE_TO_PLAT, VES, 
 SUMMA_DOK, SUMMA_OPL)
AS 
SELECT 
  kls_dog.dog_number, 
  bills.DOG_ID, 
  bills.DATE_BUXG, 
  bills.DATE_KVIT+bills.KOL_DN AS date_to_plat, 
  sum(kv.ves) AS ves, 
  sum(summa_dok) as summa_dok, 
  0 AS summa_opl 
  FROM bills,kls_dog, 
    (SELECT kvit.bill_id,SUM(ves) AS ves 
	 FROM kvit,kls_dog,month 
	 WHERE 
	   kvit.NOM_ZD=month.nom_zd AND 
	   month.dog_id=kls_dog.id AND 
	   kls_dog.LUKDOG_ID=793 
	  GROUP BY bill_id 
	) kv 
  WHERE bills.dog_id=kls_dog.ID and kls_dog.LUKDOG_ID=793 and bills.nom_dok=kv.bill_id 
  GROUP BY 
    kls_dog.dog_number, 
    bills.DOG_ID, 
    bills.DATE_BUXG, 
    bills.DATE_KVIT+bills.KOL_DN 
UNION ALL 
SELECT 
  kls_dog.dog_number, 
  kls_dog.id, 
  opl.DATA_por, 
  opl.DATA_por, 
  0 AS ves, 
  0 As summa_dok, 
  sum(opl.summa) AS summa_opl 
  FROM kls_dog,opl 
  WHERE opl.nom_dog=kls_dog.short_number and kls_dog.LUKDOG_ID=793 
  GROUP BY 
    kls_dog.dog_number, 
    kls_dog.id, 
    opl.DATA_por, 
    opl.DATA_por;


