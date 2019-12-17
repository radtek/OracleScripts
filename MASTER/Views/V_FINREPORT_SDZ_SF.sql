--
-- V_FINREPORT_SDZ_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_SDZ_SF
(IS_HOLDING, KOD_PLAT, DOG_ID, DATE_BUXG, KOL_DN, 
 DATE_TO_OPL, SUMMA_DOK, SUMMA_DOK1, SUMMA, SUMMA_PROD, 
 SUMMA_AGEN, NOM_DOK)
AS 
SELECT
  DECODE(KLS_PREDPR.HOLDING_ID,41,0,DECODE(KLS_PREDPR.HOLDING_ID,42,0,1)),
  KLS_DOG.PREDPR_ID,
  v_bills.DOG_ID,
  v_bills.DATE_KVIT,
  v_bills.KOL_DN, 
  v_bills.DATE_KVIT+v_bills.KOL_DN, 
  NVL(b_p.summa_agen,0)+NVL(b_p.summa_prod,0) AS summa_dok,
  v_bills.summa_dok AS summa_dok1,
  NVL(b_p.summa,0),
  NVL(b_p.summa_prod,0),
  NVL(b_p.summa_agen,0),
  v_bills.nom_dok
FROM v_bills, KLS_PREDPR, KLS_DOG,    
  (SELECT 
     bill_pos.NOM_DOK, 
	 SUM(bill_pos.SUMMA) AS summa, 
	 SUM(DECODE(SIGN(bill_pos.BILL_POS_ID-10),1,DECODE(bill_pos.BILL_POS_ID,20,bill_pos.SUMMA,0),bill_pos.SUMMA)) AS summa_prod, 
	 SUM(DECODE(bill_pos.BILL_POS_ID,11,bill_pos.SUMMA,12,bill_pos.SUMMA,0)) AS summa_agen 
    FROM bill_pos GROUP BY bill_pos.NOM_DOK) b_p 
WHERE v_bills.DOG_ID=KLS_DOG.ID(+) AND KLS_DOG.PREDPR_ID=KLS_PREDPR.ID AND v_bills.NOM_DOK = b_p.NOM_DOK(+);


