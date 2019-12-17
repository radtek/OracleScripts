-- ÂÑÅÃÎ Ñ×ÅÒÎÂ Ñ ÐÀÑÕÎÆÄÅÍÈßÌÈ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(BILLS.summa_dok),SUM(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ+v_kvit_all.sum_prod_nds+v_kvit_all.sum_akciz+v_kvit_all.tarif+v_kvit_all.tarif_nds+v_kvit_all.SUM_VOZN11+v_kvit_all.SUM_VOZN11_NDS+v_kvit_all.SUM_VOZN12+v_kvit_all.SUM_VOZN12_NDS+v_kvit_all.SUM_STRAH+v_kvit_all.TARIF_GUARD+v_kvit_all.TARIF_GUARD_NDS)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.04.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(BILLS.summa_dok)<>SUM(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ+v_kvit_all.sum_prod_nds+v_kvit_all.sum_akciz+v_kvit_all.tarif+v_kvit_all.tarif_nds+v_kvit_all.SUM_VOZN11+v_kvit_all.SUM_VOZN11_NDS+v_kvit_all.SUM_VOZN12+v_kvit_all.SUM_VOZN12_NDS+v_kvit_all.SUM_STRAH+v_kvit_all.TARIF_GUARD+v_kvit_all.TARIF_GUARD_NDS)

-- ÇÀ ÏÐÎÄÓÊÒ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.SUMMA_PROD_BN),SUM(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.02.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.SUMMA_PROD_BN)<>SUM(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ)

-- ÑÒÐÀÕÎÂÊÀ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.STRAH),SUM(v_kvit_all.SUM_STRAH)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.02.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
--AND BILLS.IS_AGENT=2
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.STRAH)<>SUM(v_kvit_all.SUM_STRAH) 

-- ÒÀÐÈÔ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.TARIF_BN),SUM(v_kvit_all.tarif)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.02.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.TARIF_BN)<>SUM(v_kvit_all.TARIF) 

-- ÎÕÐÀÍÀ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.TARIF_GUARD_BN),SUM(v_kvit_all.tarif_guard)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.10.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.TARIF_GUARD_BN)<>SUM(v_kvit_all.TARIF_GUARD) 

-- ÐÓÁËÈ çà ÒÎÍÍÛ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.VOZN11_BN),SUM(v_kvit_all.SUM_VOZN11)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.04.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
--AND BILLS.IS_AGENT=1
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.VOZN11_BN)<>SUM(v_kvit_all.SUM_VOZN11)

-- ÇÀ ÀÐÅÍÄÓ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(v_bill_pos_flat_orig.VOZN12_BN),SUM(v_kvit_all.SUM_VOZN12)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID
AND BILLS.date_kvit>=TO_DATE('01.04.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(v_bill_pos_flat_orig.VOZN12_BN)<>SUM(v_kvit_all.SUM_VOZN12)



-- ÂÑÅÃÎ Ñ×ÅÒÎÂ Ñ ÐÀÑÕÎÆÄÅÍÈßÌÈ
SELECT BILLS.NOM_DOK,BILLS.nom_sf,BILLS.date_vyp_sf,MAX(BILLS.summa_dok),SUM(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ+v_kvit_all.sum_prod_nds+v_kvit_all.sum_akciz+v_kvit_all.tarif+v_kvit_all.tarif_nds+v_kvit_all.SUM_VOZN11+v_kvit_all.SUM_VOZN11_NDS+v_kvit_all.SUM_VOZN12+v_kvit_all.SUM_VOZN12_NDS+v_kvit_all.SUM_STRAH+v_kvit_all.TARIF_GUARD+v_kvit_all.TARIF_GUARD_NDS),MAX(v_bill_pos_flat_orig.ves),SUM(v_kvit_all.ves_brutto)
FROM v_kvit_all,BILLS,v_bill_pos_flat_orig
WHERE BILLS.nom_dok=v_kvit_all.BILL_ID(+)
AND BILLS.date_kvit>=TO_DATE('01.04.2003','dd.mm.yyyy')
AND BILLS.nom_dok=v_bill_pos_flat_orig.nom_dok
GROUP BY BILLS.nom_dok,BILLS.nom_sf,BILLS.date_vyp_sf
HAVING MAX(BILLS.summa_dok)<>SUM(NVL(v_kvit_all.SUM_PROD+v_kvit_all.SUM_AKCIZ+v_kvit_all.sum_prod_nds+v_kvit_all.sum_akciz+v_kvit_all.tarif+v_kvit_all.tarif_nds+v_kvit_all.SUM_VOZN11+v_kvit_all.SUM_VOZN11_NDS+v_kvit_all.SUM_VOZN12+v_kvit_all.SUM_VOZN12_NDS+v_kvit_all.SUM_STRAH+v_kvit_all.TARIF_GUARD+v_kvit_all.TARIF_GUARD_NDS,0))
