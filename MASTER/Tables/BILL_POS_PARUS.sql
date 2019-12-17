--
-- BILL_POS_PARUS  (Table) 
--
CREATE TABLE MASTER.BILL_POS_PARUS
(
  NOM_DOK            NUMBER(18)                 NOT NULL,
  PARUS_RN           NUMBER(18)                 NOT NULL,
  BILL_POS_PARUS_ID  NUMBER(10)                 DEFAULT 0                     NOT NULL,
  PREF_SF            VARCHAR2(20 BYTE),
  NOM_SF             VARCHAR2(10 BYTE),
  DATE_VYP_SF        DATE,
  DATE_OTGR          DATE,
  PROD_ID_NPR        VARCHAR2(5 BYTE),
  VES                NUMBER(18,6)               DEFAULT 0,
  CENA_BN            NUMBER(18,6)               DEFAULT 0,
  CENA               NUMBER(18,6)               DEFAULT 0,
  SUMMA_BN           NUMBER(22,6)               DEFAULT 0,
  SUMMA_AKCIZ        NUMBER(22,6)               DEFAULT 0,
  SUMMA_NDS20        NUMBER(22,6)               DEFAULT 0,
  SUMMA_GSM25        NUMBER(22,6)               DEFAULT 0,
  SUMMA              NUMBER(22,6)               DEFAULT 0,
  FOOD_RN            NUMBER(18),
  FOOD_PRN           NUMBER(18),
  FOOD_CODE          VARCHAR2(20 BYTE),
  FOOD_TYPE          NUMBER(10),
  FOOD_NAME          VARCHAR2(240 BYTE),
  MES_UNIT           NUMBER(18),
  MES_UNIT_NAME      VARCHAR2(10 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;


