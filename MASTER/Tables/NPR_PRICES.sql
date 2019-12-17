--
-- NPR_PRICES  (Table) 
--
CREATE TABLE MASTER.NPR_PRICES
(
  ID                   NUMBER(6)                NOT NULL,
  CAT_CEN_ID           NUMBER(3),
  PROD_ID_NPR          VARCHAR2(5 BYTE),
  CENA                 NUMBER(15,6)             DEFAULT 0,
  NDS20                NUMBER(15,6)             DEFAULT 0,
  NGSM25               NUMBER(15,6)             DEFAULT 0,
  AKCIZ                NUMBER(15,6)             DEFAULT 0,
  CENA_OTP             NUMBER(15,6)             DEFAULT 0,
  BEGIN_DATE           DATE,
  END_DATE             DATE,
  INPUT_DATE           DATE,
  OWNERSHIP_ID         NUMBER(3),
  SUPPLIER_ID          NUMBER(6),
  PROTOKOL_DATE        DATE,
  PROTOKOL_NUM         VARCHAR2(15 BYTE),
  IS_ORIGINAL          NUMBER(1)                DEFAULT 0,
  PROTOKOL_BEGIN_DATE  DATE,
  NDS20_NPO            NUMBER(15,6)             DEFAULT 0,
  CENA_NPO             NUMBER(15,6)             DEFAULT 0,
  CENA_OTP_NPO         NUMBER(15,6)             DEFAULT 0,
  NO_AKCIZ             NUMBER(1)                DEFAULT 0,
  CENA_BN              NUMBER(15,6)
)
TABLESPACE USERS2
NOCOMPRESS ;


