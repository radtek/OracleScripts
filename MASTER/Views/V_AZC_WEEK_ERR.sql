--
-- V_AZC_WEEK_ERR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AZC_WEEK_ERR
(TEXT)
AS 
select "TEXT" from parus.v_snp_error_check_osv@oracle.world;


