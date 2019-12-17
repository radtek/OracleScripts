--
-- V_GU12_GRUZ_POL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GU12_GRUZ_POL
(ID, GD_KOD, FOX_KOD, PREDPR_NAME, SHORT_NAME, 
 OKPO)
AS 
select id,Trim(gd_kod),decode(id,2641,'03478446',3633,'3032',Trim(gd_kod)),predpr_name,short_name,okpo
from kls_predpr
where id<>1 and is_block=0 and gd_kod is not null
order by short_name;


