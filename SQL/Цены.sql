SELECT a.cat_cen_id,KLS_PROD.name_npr,a.begin_date,a.end_date,a.cena,a.nds20,a.ngsm25,a.akciz,a.cena_otp,a.protokol_num,a.protokol_date 
FROM NPR_PRICES_KTU a, KLS_PROD WHERE a.prod_id_npr=KLS_PROD.id_npr
AND a.cat_cen_id=119
ORDER BY 1,2,3