--
-- BILL_POS_TMP  (Table) 
--
CREATE TABLE MASTER.BILL_POS_TMP
(
  NOM_DOK            NUMBER(10),
  BILL_POS_ID        NUMBER(7),
  VES                NUMBER(15,6)               DEFAULT 0,
  CENA_BN            NUMBER(16,6)               DEFAULT 0,
  CENA               NUMBER(16,6)               DEFAULT 0,
  SUMMA_BN           NUMBER(20,6)               DEFAULT 0,
  SUMMA_AKCIZ        NUMBER(20,6)               DEFAULT 0,
  SUMMA_NDS20        NUMBER(20,6)               DEFAULT 0,
  SUMMA_GSM25        NUMBER(20,6)               DEFAULT 0,
  SUMMA              NUMBER(20,6)               DEFAULT 0,
  CENA_POKUP         NUMBER(16,6)               DEFAULT 0,
  SUMMA_BN_POKUP     NUMBER(20,6)               DEFAULT 0,
  SUMMA_NDS20_POKUP  NUMBER(20,6)               DEFAULT 0,
  SUMMA_GSM25_POKUP  NUMBER(20,6)               DEFAULT 0,
  DATE_REALIZ        DATE,
  ID_OLD             NUMBER(7),
  PROD_ID_NPR        VARCHAR2(5 BYTE),
  OWNERSHIP_ID       NUMBER(3),
  ANALIT_ID          NUMBER(3),
  IS_AGENT           NUMBER(1),
  IS_LUK             NUMBER(1),
  NACENKA            NUMBER(10,2)               DEFAULT 0,
  NUM_AKT            NUMBER(10),
  PROTO_NUM          VARCHAR2(15 BYTE),
  PROTO_DATE         DATE,
  NO_AKCIZ           NUMBER(1)                  DEFAULT 0,
  SUPPLIER_ID        NUMBER(10),
  NOM_SF_POKUP       VARCHAR2(10 BYTE),
  NOM_DOK_POKUP      NUMBER(10),
  IS_POKUP           NUMBER(10)                 DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


