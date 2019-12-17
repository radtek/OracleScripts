--
-- V_KOLYA_FOR_AUDIT_GP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KOLYA_FOR_AUDIT_GP
(GOSPROG_NAME, LONG_NAME_NPR, NOM_ZD, DATE_PLAN, TONN_DECLARED, 
 TONN_LOADED)
AS 
select
  kls_gosprog.GOSPROG_NAME,
  kls_prod.LONG_NAME_NPR,
  month.nom_zd,
  month.DATE_PLAN,
  month.TONN_DECLARED,
  (select sum(kvit.ves) from kvit where kvit.nom_zd=month.nom_zd) AS tonn_loaded
  from month,kls_gosprog,kls_prod
  where 
	month.GOSPROG_ID=kls_gosprog.ID and
	month.PROD_ID_NPR=kls_prod.ID_NPR and
	month.GOSPROG_ID<>0
	and month.DATE_PLAN between
	  TO_DATE('01.01.2003','dd.mm.yyyy') and
	  TO_DATE('30.06.2004','dd.mm.yyyy');


