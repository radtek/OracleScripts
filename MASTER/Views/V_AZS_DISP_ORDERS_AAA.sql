--
-- V_AZS_DISP_ORDERS_AAA  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AZS_DISP_ORDERS_AAA
(STORE_RN, NOMEN_RN, SUM_VOL, SUM_MAS, OPER_DAY)
AS 
select store_rn, nomen_rn, sum(volume) as sum_vol, sum(massa) as sum_mas, oper_day 
from 
(
parus.TB_SNP_STORE_OPER_PSV@oracle.world
) 
where USER_ID=NLS_UPPER(SYS_CONTEXT('USERENV','OS_USER')) 
and source_id = 86 
group by store_rn, nomen_rn, oper_day;


