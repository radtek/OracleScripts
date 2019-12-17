--
-- UNP_DISPETCHER  (Materialized View) 
--
CREATE MATERIALIZED VIEW MASTER.UNP_DISPETCHER 
TABLESPACE USERS2
NOCOMPRESS
BUILD IMMEDIATE
USING INDEX
            TABLESPACE USERSINDX
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
SELECT USERNAME, FAMILIYA, IMYA, OTCHESTVO FROM PASP.DISPETCHER@ORA.LUNP.RU

;


COMMENT ON MATERIALIZED VIEW MASTER.UNP_DISPETCHER IS 'snapshot table for snapshot MASTER.UNP_DISPETCHER';
