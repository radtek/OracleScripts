--
-- V_PLAN_FACT_CONF_PROD  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PLAN_FACT_CONF_PROD
(ID_NPR, GROUP_ORDER, GROUP_NAME, GROUP_VISIBLE, PROD_ORDER, 
 PROD_NAME)
AS 
select /*+ ORDERED */
  kls_prod.id_npr,
  grp.GROUP_ORDER,
  grp.GROUP_NAME,
  grp.GROUP_VISIBLE,
  NVL(mrk.GROUP_ORDER,kls_prod.ID_NPR) as PROD_ORDER,
  NVL(mrk.GROUP_NAME,kls_prod.NAME_NPR) as PROD_NAME
from kls_prod,
  (SELECT pg.*,pgd.PROD_ID_NPR from kls_prod_groups pg, kls_prod_groups_desc pgd
    WHERE pg.prod_type_grp_id=1
     and pg.ID=pgd.PROD_GROUPS_ID) grp,
  (SELECT pg.*,pgd.PROD_ID_NPR from kls_prod_groups pg, kls_prod_groups_desc pgd
    WHERE pg.prod_type_grp_id=3
     and pg.ID=pgd.PROD_GROUPS_ID
 	 AND pg.GROUP_VISIBLE=1) mrk
where kls_prod.id_npr=grp.PROD_ID_NPR(+)
  and kls_prod.id_npr=mrk.PROD_ID_NPR(+);


