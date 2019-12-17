/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_IG_EXP_LINKS  (Table) 
--
CREATE TABLE MASTER.EUL_IG_EXP_LINKS
(
  IEL_ID        NUMBER(10)                      NOT NULL,
  IEL_TYPE      VARCHAR2(10 BYTE),
  HIL_EXP_ID    NUMBER(10),
  HIL_HN_ID     NUMBER(10),
  KIL_EXP_ID    NUMBER(10),
  KIL_KEY_ID    NUMBER(10),
  KIL_SEQUENCE  NUMBER(22),
  NOTM          NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


