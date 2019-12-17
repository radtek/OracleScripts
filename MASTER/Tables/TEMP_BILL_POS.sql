--
-- TEMP_BILL_POS  (Table) 
--
CREATE TABLE MASTER.TEMP_BILL_POS
(
  TERMINAL_NAME  VARCHAR2(30 BYTE),
  OSUSER_NAME    VARCHAR2(30 BYTE),
  NOM_DOK        NUMBER(7),
  BILL_POS_ID    NUMBER(7),
  VES            NUMBER(15,6)                   DEFAULT 0,
  CENA_BN        NUMBER(16,6)                   DEFAULT 0,
  CENA           NUMBER(16,6)                   DEFAULT 0,
  SUMMA_BN       NUMBER(20,6)                   DEFAULT 0,
  SUMMA_AKCIZ    NUMBER(20,6)                   DEFAULT 0,
  SUMMA_NDS20    NUMBER(20,6)                   DEFAULT 0,
  SUMMA          NUMBER(20,6)                   DEFAULT 0,
  PROD_ID_NPR    VARCHAR2(5 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;


