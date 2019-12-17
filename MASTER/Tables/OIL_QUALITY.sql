--
-- OIL_QUALITY  (Table) 
--
CREATE TABLE MASTER.OIL_QUALITY
(
  OIL_QUALITY_ID  NUMBER,
  PROD_ID_NPR     VARCHAR2(5 BYTE),
  PERIOD          DATE,
  PL20C           NUMBER                        DEFAULT 0,
  PL15C           NUMBER                        DEFAULT 0,
  VOL_WATER       NUMBER                        DEFAULT 0,
  VOL_MEX         NUMBER                        DEFAULT 0,
  VOL_SERA        NUMBER                        DEFAULT 0,
  VOL_HLOR        NUMBER                        DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


