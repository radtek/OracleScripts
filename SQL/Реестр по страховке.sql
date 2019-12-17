select
  PLAT_NAME,
  DOG_NUMBER,
  NOM_SF,
  DATE_VYP_SF,
  DATE_KVIT,
  PROD_NAME,
  VES,
  SUMMA_PROD,
  NACENKA,
  SUMMA_STRAH,
  NUM_STRAH
from V_LUKREP_SF_NEW A
where A.DATE_MOS>=:beg_date
  and A.DATE_MOS<=:end_date
  and A.SUMMA_STRAH<>0
  and A.IS_SF=1
order by dog_number,nom_sf  