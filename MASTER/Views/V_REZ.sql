--
-- V_REZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REZ
(SDEP_READY, SNAME, REZ_NUM, NAME_NPR, STATUS, 
 DEAD_VOL_M3, MAX_VOL_M3, TRK_COUNT)
AS 
select a.sdep_ready, a.sname, d.rez_num, f.name_npr,
	   decode(d.status, 0, 'рабочий', 1, 'на консервации', 2, 'на ремонте') status,
	   d.dead_vol_m3, d.max_vol_m3, d.trk_count
from VANEEV.V_DICSTORE_PSV@oracle.world a, PARUS_STORE_ORG_STRU_LINK b, org_structure c,
	 arc_rez d, (SELECT /*+ ALL_ROWS */  DISTINCT A.SDEP_READY, C.FILIAL_ID    
	 		 			FROM V_PARUS_DICSTORE A, PARUS_STORE_ORG_STRU_LINK B, V_ORG_STRUCTURE C
						WHERE sDEP_READY IS NOT NULL
						  AND A.nRN=B.STORE_RN
						    AND B.ORG_STRU_ID=C.ID
						ORDER BY sDEP_READY
	 ) e, kls_prod f
where
b.org_stru_id = c.id
and f.id_npr = d.prod_id_npr
and b.store_rn = a.nrn
and d.org_stru_id = c.id
and b.is_main = 1
and e.sdep_ready = a.sdep_ready
and  e.filial_id = (select max(filial_id) from v_master_reports)
order by 2, 3;


