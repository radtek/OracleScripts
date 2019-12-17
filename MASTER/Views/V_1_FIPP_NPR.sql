--
-- V_1_FIPP_NPR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_1_FIPP_NPR
(DOG_NUMBER, DOG_ID, DATE_BUXG, DATE_TO_PLAT, VES, 
 SUMMA_DOK, SUMMA_OPL)
AS 
SELECT 
  kls_dog.dog_number, 
  bills.DOG_ID, 
  bills.DATE_BUXG, 
  bills.DATE_KVIT+bills.KOL_DN AS date_to_plat, 
  sum(kv.ves) AS ves, 
  sum(v_bill_pos.SUMMA) AS summa_dok, 
  0 AS summa_opl 
  FROM bills,v_bill_pos,kls_dog, 
    (SELECT kvit.bill_id,SUM(ves) AS ves 
	 FROM kvit,kls_dog,month 
	 WHERE 
	   kvit.NOM_ZD=month.nom_zd AND 
	   month.dog_id=kls_dog.id AND 
	   kls_dog.LUKDOG_ID=793 
	  GROUP BY bill_id 
	) kv 
  WHERE bills.dog_id=kls_dog.ID and v_bill_pos.nom_dok=bills.nom_dok and kls_dog.LUKDOG_ID=793 and bills.nom_dok=kv.bill_id 
  and v_bill_pos.PROD_ID_NPR>10300 
  GROUP BY 
    kls_dog.dog_number, 
    bills.DOG_ID, 
    bills.DATE_BUXG, 
    bills.DATE_KVIT+bills.KOL_DN 
UNION ALL 
SELECT 
  kls_dog.dog_number, 
  opl.DOG_ID, 
  opl.DATA_POR, 
  opl.DATA_POR, 
  0 AS ves, 
  0 As summa_dok, 
  sum(real_opl.d_41+real_opl.d_191+real_opl.sum_akciz) AS summa_opl 
  FROM opl,real_opl, kls_dog 
  WHERE kls_dog.LUKDOG_ID=793 and real_opl.UN_DOK=opl.nom_dok and real_opl.dog_realp=kls_dog.SHORT_NUMBER and real_opl.close_date is not null 
  GROUP BY 
    kls_dog.dog_number, 
    opl.DOG_ID, 
    opl.DATA_POR, 
    opl.DATA_POR;


