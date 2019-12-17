--
-- BILLS_PARUS  (Table) 
--
CREATE TABLE MASTER.BILLS_PARUS
(
  NOM_DOK          NUMBER(18)                   NOT NULL,
  PREF_SF          VARCHAR2(20 BYTE),
  NOM_SF           VARCHAR2(10 BYTE),
  NPO_SF           VARCHAR2(40 BYTE),
  PROD_ID_NPR      VARCHAR2(5 BYTE),
  DATE_VYP_SF      DATE,
  DATE_KVIT        DATE,
  DATE_BUXG        DATE,
  DATE_MOS         DATE,
  SUMMA_DOK        NUMBER(18,2)                 DEFAULT 0,
  SUMMA_PROD       NUMBER(18,2)                 DEFAULT 0,
  SUMMA_PROD_NDS   NUMBER(18,2)                 DEFAULT 0,
  SUMMA_AKCIZ      NUMBER(18,2)                 DEFAULT 0,
  SUMMA_GSM        NUMBER(18,2)                 DEFAULT 0,
  SUMMA_TARIF      NUMBER(18,2)                 DEFAULT 0,
  SUMMA_TARIF_NDS  NUMBER(18,2)                 DEFAULT 0,
  SUMMA_VOZN       NUMBER(18,2)                 DEFAULT 0,
  SUMMA_VOZN_NDS   NUMBER(18,2)                 DEFAULT 0,
  SUMMA_STRAH      NUMBER(18,2)                 DEFAULT 0,
  KOL_DN           NUMBER(5)                    DEFAULT 0,
  NOM_ZD           VARCHAR2(20 BYTE),
  BASE_NUMB        VARCHAR2(20 BYTE),
  NUM_DOG          VARCHAR2(20 BYTE),
  DOG_ID           NUMBER(10),
  USL_NUMBER       NUMBER(3)                    DEFAULT 1,
  SENDER           VARCHAR2(50 BYTE),
  PRIM             VARCHAR2(240 BYTE),
  NUM_KVIT         NUMBER(10),
  CONF_NUMB        VARCHAR2(20 BYTE),
  SVED_NUM         NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.BILLS_PARUS IS 'Счета-фактуры НПО, выставленные в ПАРУСЕ';



