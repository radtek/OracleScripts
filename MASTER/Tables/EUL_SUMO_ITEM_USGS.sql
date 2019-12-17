/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SUMO_ITEM_USGS  (Table) 
--
CREATE TABLE MASTER.EUL_SUMO_ITEM_USGS
(
  SIU_ID             NUMBER(10)                 NOT NULL,
  SIU_TYPE           VARCHAR2(10 BYTE),
  SIU_SUMO_ID        NUMBER(10),
  SIU_EXP_ID         NUMBER(10),
  SIU_EXT_COLUMN     VARCHAR2(64 BYTE),
  SIU_ITEM_MODIFIED  NUMBER(1),
  SMIU_FUN_ID        NUMBER(10),
  SMIU_MEASURE_SET   NUMBER(22),
  NOTM               NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


