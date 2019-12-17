/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SUM_BITMAPS  (Table) 
--
CREATE TABLE MASTER.EUL_SUM_BITMAPS
(
  SB_ID        NUMBER(10)                       NOT NULL,
  SB_BITMAP    RAW(250),
  SB_SEQUENCE  NUMBER(22),
  SB_EXP_ID    NUMBER(10),
  SB_KEY_ID    NUMBER(10),
  SB_FUN_ID    NUMBER(10),
  NOTM         NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


