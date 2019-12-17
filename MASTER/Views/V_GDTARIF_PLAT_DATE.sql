--
-- V_GDTARIF_PLAT_DATE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GDTARIF_PLAT_DATE
(TARIF, DATE_KVIT, TEX_PD_NAME, DOG_NUMBER, TARNDS, 
 MAIN_DOG, YEAR, MONTH)
AS 
SELECT k.tarif, k.date_kvit, kls.tex_pd_name, d.dog_number,k.tarif*(100+FOR_BILLS.GetNDSValue(k.date_kvit))/100 as tarnds,
       maindog.dog_number as main_dog,EXTRACT(YEAR FROM k.date_kvit) as year,EXTRACT(MONTH FROM k.date_kvit) as month
  FROM kls_dog d, kvit k, MONTH m, kls_tex_pd kls, kls_dog_main, kls_dog maindog
 WHERE (d.ID = m.dog_id)
        AND (m.nom_zd = k.nom_zd)
        AND (k.tex_pd_id = kls.ID)
		AND d.is_agent=kls_dog_main.is_agent
		and k.date_kvit between kls_dog_main.from_date and kls_dog_main.to_date
        AND (kls_dog_main.dog_id = maindog.ID)
        AND (k.grotp_id = kls.grotp_id)
        AND (k.tarif > 0)
		and k.date_kvit>='01-jan-2003'
order by k.date_kvit;


