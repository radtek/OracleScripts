/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SUB_QUERIES  (Table) 
--
CREATE TABLE MASTER.EUL_SUB_QUERIES
(
  SQ_ID      NUMBER(10)                         NOT NULL,
  SQ_NAME    VARCHAR2(100 BYTE),
  SQ_OBJ_ID  NUMBER(10),
  SQ_IT_ID   NUMBER(10),
  SQ_FIL_ID  NUMBER(10),
  NOTM       NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


