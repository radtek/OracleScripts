--
-- V_OTGR_ARX  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_OTGR_ARX
(NPODOG_ID, DOG_NUMBER, DATE_KVIT, D_PAY, TARIF, 
 VOZNAGR, SUM_PROD, STRAH, VES)
AS 
SELECT   /*+ RULE */
            M.Npodog_id, D.dog_number, K.Date_kvit,
            K.Date_kvit + M.Kol_dn_npo AS D_pay,
            SUM(ROUND((ROUND(DECODE(K.Flg_operdata,1, NVL (M.Tarif1tonn, 0)* K.Ves_brutto,K.Tarif),2)+ K.Tarif_guard)* (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100,2)) AS Tarif,-- Ж/д тариф
            SUM(ROUND(ROUND(DECODE (K.Vagowner_id,3, USL_DOG.Usl_sum * K.Ves_brutto,DECODE (K.Flg_vag_klient,1, USL_DOG.Usl_sum* K.Ves_brutto,DECODE(K.Tarif,0, USL_DOG.Usl_sum* K.Ves_brutto,K.Tarif19 - K.Tarif))),2)* (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100,2)) AS Voznagr,-- Вознаграждение
            SUM(ROUND(K.Ves * M.Cena_otp_npo * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100, 2)) AS Sum_prod,
            SUM(ROUND((ROUND (K.Ves * M.Cena_otp_npo * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100, 2))* USL_DOG.Proc_insure/ 100,2)) AS Strah,
			SUM(k.ves) AS ves
       FROM KVIT K, MONTH M, KLS_PLANSTRU Ps, KLS_DOG D, USL_DOG
      WHERE K.Nom_zd = M.Nom_zd
        AND M.Planstru_id = Ps.ID
        AND M.Npodog_id = D.ID
        AND (M.Dog_id = USL_DOG.Dog_id AND M.Usl_number = USL_DOG.Usl_number
            )
        AND Ps.Region_id = 21
        AND K.Date_kvit >= TO_DATE ('01.09.2003', 'dd.mm.yyyy')
   GROUP BY M.Npodog_id,
            D.dog_number,
            K.Date_kvit,
            K.Date_kvit + M.Kol_dn_npo
   ORDER BY M.Npodog_id, K.Date_kvit;


