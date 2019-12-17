--
-- V_BUDJET_NPR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_BUDJET_NPR
(DOG_NUMBER, DOG_ID, DATE_BUXG, DATE_TO_PLAT, SUMMA_DOK, 
 SUMMA_OPL)
AS 
SELECT 
  kls_dog.dog_number, 
  bills.DOG_ID, 
  bills.DATE_BUXG, 
  bills.DATE_KVIT+bills.KOL_DN AS date_to_plat, 
  sum(v_bill_pos.SUMMA) AS summa_dok, 
  0 AS summa_opl 
  FROM bills,v_bill_pos,kls_dog, 
    (SELECT kvit.bill_id 
	 FROM kvit,kls_dog,month 
	 WHERE 
	   kvit.NOM_ZD=month.nom_zd AND 
	   month.dog_id=kls_dog.id AND 
	   (kls_dog.LUKDOG_ID=787 or kls_dog.ID=787)
	  GROUP BY bill_id 
	) kv 
  WHERE bills.dog_id=kls_dog.ID and v_bill_pos.nom_dok=bills.nom_dok and (kls_dog.LUKDOG_ID=787 or kls_dog.ID=787) and bills.nom_dok=kv.bill_id 
  and v_bill_pos.PROD_ID_NPR>10300 
  GROUP BY 
    kls_dog.dog_number, 
    bills.DOG_ID, 
    bills.DATE_BUXG, 
    bills.DATE_KVIT+bills.KOL_DN 
UNION ALL 
SELECT
  kls_dog.DOG_NUMBER,
  opl.DOG_ID,
  opl.DATA_POR AS date_buxg,
  opl.DATA_POR AS date_to_plat,
  0 as summa_dok,
  sum(opl.SUMMA) AS summa_opl
  FROM kls_dog,opl
  WHERE kls_dog.id=opl.dog_id AND kls_dog.ID=787 
  GROUP BY 
    kls_dog.dog_number, 
    opl.DOG_ID, 
    opl.DATA_POR, 
    opl.DATA_POR;


