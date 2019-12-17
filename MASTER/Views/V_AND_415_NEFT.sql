--
-- V_AND_415_NEFT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AND_415_NEFT
(DAT, POSTAV, PROIZ, ID_PROD_NPR, NAME_NPR, 
 KSSS_PROD_ID, POST, A8, A10, A13)
AS 
select last_day(r.datares) as dat, r.postav, r.proiz, t.id_prod_npr, p.name_npr, p.ksss_prod_id,
 sum(r.post) as post, 5 as a8, 157143 as a10, 1149 as a13
from oil_resurs r, oil_trace t, kls_prod p
where r.mpor = t.kod
and t.id_prod_npr = p.id_npr
--and r.datares >= '01.01.2015' and r.datares <= '31.01.2015'
group by last_day(r.datares), t.id_prod_npr, r.postav, r.proiz, t.id_prod_npr, p.name_npr, p.ksss_prod_id;


