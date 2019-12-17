
select /*+ rule */
  kvit.PERECH_TEXPD_NUM,
  kvit.PERECH_TEXPD_DATE,
--  kls_dog.predpr_id,
  sum(kvit.TARIF) as tarif,
  sum(kvit.tarif_guard) as ohrana
from kvit,month,kls_dog
where date_kvit>=to_date('01.09.2006','dd.mm.yyyy') and date_kvit<=to_date('31.10.2006','dd.mm.yyyy')
--where perech_texpd_date>=to_date('01.09.2006','dd.mm.yyyy') and perech_texpd_date<=to_date('31.10.2006','dd.mm.yyyy')
and kvit.nom_zd=month.nom_zd and month.dog_id=kls_dog.id
and exists (
select null from  
(
SELECT
  MAX(NOM_SCH) as NOM_SCH,
  DATE_SCH,
  NOM_PERECH,
  DAT_PERECH
FROM REESTR_RAIL_RGD_SF
WHERE r21=95
  AND DAT_PERECH>=TO_DATE('01.03.2006','dd.mm.yyyy')
GROUP BY DATE_SCH,NOM_PERECH,DAT_PERECH  
) a
where a.nom_perech=kvit.PERECH_TEXPD_NUM
and a.dat_perech=kvit.PERECH_TEXPD_DATE
and a.date_sch between :begin_date and :end_date
)
group by   
  kvit.PERECH_TEXPD_NUM,
  kvit.PERECH_TEXPD_DATE
  --kls_dog.predpr_id
