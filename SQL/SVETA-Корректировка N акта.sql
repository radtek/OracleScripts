SELECT 'UPDATE sf_sfak_prod SET dopoln2='''||dopoln2||''' WHERE kod_tu=6 AND kod_prod='||TO_CHAR(kod_prod)||';'
FROM sveta.SF_SFAK_PROD WHERE kod_prod IN (
SELECT nom_dok/*,old_nom_sf,nom_sf,old_nom_dok,date_vyp_sf,summa_dok*/ FROM BILLS WHERE (old_nom_dok IS NOT NULL AND old_nom_dok<>0)
AND date_vyp_sf>=TO_DATE('01.06.2003','dd.mm.yyyy') AND nom_sf<>old_nom_sf
--ORDER BY old_nom_dok,nom_sf
) 