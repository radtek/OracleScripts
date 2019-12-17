--
-- V_PARUS_DEBITOR_OPL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_DEBITOR_OPL
(LUKDOG_ID, PLAT_ID, DOG_ID, DATE_OPL, SUMMA, 
 NOM_DOK)
AS 
SELECT
  v_opl_snp.LUKDOG_ID,
  v_opl_snp.PLAT_ID,
  v_opl_snp.dog_id,
  v_OPL_snp.DATE_OPL,
  v_OPL_snp.SUMMA,
  v_OPL_snp.NOM_DOK
FROM v_opl_snp
WHERE v_OPL_snp.is_snp=2
  AND v_OPL_snp.DATE_OPL>=TO_DATE('01.12.2002','dd.mm.yyyy');


