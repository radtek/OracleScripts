--
-- TEMP_BILL_KVIT_POSSIBLE  (Table) 
--
CREATE TABLE MASTER.TEMP_BILL_KVIT_POSSIBLE
(
  KVIT_ID          NUMBER,
  NUM_KVIT         INTEGER,
  TERMINAL_NAME    VARCHAR2(30 BYTE),
  OSUSER_NAME      VARCHAR2(30 BYTE),
  NUM_CIST         VARCHAR2(10 BYTE),
  VES              NUMBER(10,3)                 DEFAULT 0,
  TARIF            NUMBER(12,2)                 DEFAULT 0,
  TARIF19          NUMBER(12,2)                 DEFAULT 0,
  SVED_NUM         NUMBER(6)                    DEFAULT 0,
  SUM_PROD         NUMBER(15,2)                 DEFAULT 0,
  SUM_AKCIZ        NUMBER(15,2)                 DEFAULT 0,
  SUM_PROD_NDS     NUMBER(15,2)                 DEFAULT 0,
  TARIF_NDS        NUMBER(15,2)                 DEFAULT 0,
  SUM_VOZN11       NUMBER(15,2)                 DEFAULT 0,
  SUM_VOZN11_NDS   NUMBER(15,2)                 DEFAULT 0,
  SUM_VOZN12       NUMBER(15,2)                 DEFAULT 0,
  SUM_VOZN12_NDS   NUMBER(15,2)                 DEFAULT 0,
  SUM_STRAH        NUMBER(15,2)                 DEFAULT 0,
  CENA             NUMBER(10,2),
  CENA_OTP         NUMBER(10,2),
  DATE_CENA        DATE,
  DATE_KVIT        DATE,
  PROTO_NUM        VARCHAR2(15 BYTE),
  PROTO_DATE       DATE,
  CENA_VOZN        NUMBER(10,2),
  TARIF_GUARD      NUMBER(12,2),
  TARIF_GUARD_NDS  NUMBER(12,2),
  NACENKA          NUMBER(10,2),
  NUM_AKT          NUMBER(10),
  BILL_POS_ID      NUMBER(10),
  NO_AKCIZ         NUMBER(1),
  NPR_PRICES_ID    NUMBER,
  CAT_CEN_ID       NUMBER
)
TABLESPACE USERS2
NOCOMPRESS ;


