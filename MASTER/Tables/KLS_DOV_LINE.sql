--
-- KLS_DOV_LINE  (Table) 
--
CREATE TABLE MASTER.KLS_DOV_LINE
(
  ID           NUMBER(10)                       NOT NULL,
  VES          NUMBER(14,3),
  PROD_ID_NPR  VARCHAR2(5 BYTE),
  DOVER_ID     NUMBER(10),
  IS_LOADED    NUMBER(1)                        DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


