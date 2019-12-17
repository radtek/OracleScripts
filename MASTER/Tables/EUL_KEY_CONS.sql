--
-- EUL_KEY_CONS  (Table) 
--
CREATE TABLE MASTER.EUL_KEY_CONS
(
  KEY_ID            NUMBER(10)                  NOT NULL,
  KEY_TYPE          VARCHAR2(10 BYTE),
  KEY_NAME          VARCHAR2(100 BYTE),
  KEY_DESCRIPTION   VARCHAR2(240 BYTE),
  KEY_EXT_KEY       VARCHAR2(64 BYTE),
  KEY_OBJ_ID        NUMBER(10),
  FK_KEY_ID_REMOTE  NUMBER(10),
  FK_OBJ_ID_REMOTE  NUMBER(10),
  FK_ONE_TO_ONE     NUMBER(1),
  FK_OUTER_DETAIL   NUMBER(1),
  FK_OUTER_MASTER   NUMBER(1),
  FK_SUMMARY_COUNT  NUMBER(22),
  FK_MANDATORY      NUMBER(1),
  NOTM              NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


