--
-- V_XX101_PPKN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_XX101_PPKN
(NUMKVIT, DATEKVIT, PASSPORTNUM)
AS 
select distinct KVITNUM as numkvit, kvitdate as datekvit, passportnum
from XX101_ZKERP_DATA
where (transportkind = '03' or transportkind = '06')
and passportnum is not null
--and kvitdate is not null
and kvitdate between SYSDATE-4 and SYSDATE
--order by kvitdate  desc
;


