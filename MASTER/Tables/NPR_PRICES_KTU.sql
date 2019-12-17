--
-- NPR_PRICES_KTU  (Table) 
--
CREATE TABLE MASTER.NPR_PRICES_KTU
(
  ID                   NUMBER(6)                NOT NULL,
  CAT_CEN_ID           NUMBER(3),
  PROD_ID_NPR          VARCHAR2(5 BYTE),
  CENA                 NUMBER(9,2),
  NDS20                NUMBER(9,2),
  NGSM25               NUMBER(9,2),
  AKCIZ                NUMBER(9,2),
  CENA_OTP             NUMBER(9,2),
  BEGIN_DATE           DATE,
  END_DATE             DATE,
  INPUT_DATE           DATE,
  OWNERSHIP_ID         NUMBER(3),
  SUPPLIER_ID          NUMBER(6),
  PROTOKOL_DATE        DATE,
  PROTOKOL_NUM         VARCHAR2(15 BYTE),
  IS_ORIGINAL          NUMBER(1)                DEFAULT 0,
  PROTOKOL_BEGIN_DATE  DATE,
  NDS20_NPO            NUMBER(9,2),
  CENA_NPO             NUMBER(9,2),
  CENA_OTP_NPO         NUMBER(9,2)
)
TABLESPACE USERS2
NOCOMPRESS ;


