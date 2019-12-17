/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_DOMAINS  (Table) 
--
CREATE TABLE MASTER.EUL_DOMAINS
(
  DOM_ID              NUMBER(10)                NOT NULL,
  DOM_NAME            VARCHAR2(100 BYTE),
  DOM_DESCRIPTION     VARCHAR2(240 BYTE),
  DOM_DATA_TYPE       NUMBER(2),
  DOM_LOGICAL_ITEM    NUMBER(1),
  DOM_SYS_GENERATED   NUMBER(1),
  DOM_CARDINALITY     NUMBER(22),
  DOM_LAST_EXEC_TIME  NUMBER(22),
  DOM_IT_ID_LOV       NUMBER(10),
  DOM_IT_ID_RANK      NUMBER(10),
  NOTM                NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


