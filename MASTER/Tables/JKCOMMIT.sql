--
-- JKCOMMIT  (Table) 
--
CREATE TABLE MASTER.JKCOMMIT
(
  JKC_SES_ID   NUMBER(10)                       NOT NULL,
  MESTO_ID     NUMBER(2)                        NOT NULL,
  NOM_ZD       VARCHAR2(12 BYTE)                NOT NULL,
  SVED_NUM     NUMBER(6)                        NOT NULL,
  SVED_DATE    DATE,
  DATE_EDIT    DATE,
  DATE_OFORML  DATE,
  SVED_CNT     NUMBER(4),
  SVED_VES     NUMBER(15,6),
  SVED_ID      VARCHAR2(9 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;


