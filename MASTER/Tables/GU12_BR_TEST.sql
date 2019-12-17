--
-- GU12_BR_TEST  (Table) 
--
CREATE TABLE MASTER.GU12_BR_TEST
(
  ID       NUMBER,
  ID_B     NUMBER,
  DATE_R   DATE,
  KOL_VAG  NUMBER(8)                            DEFAULT 0,
  VES      NUMBER(8)                            DEFAULT 0,
  ID_NPR   VARCHAR2(5 BYTE),
  METKA    NUMBER(1)
)
TABLESPACE USERS2
NOCOMPRESS ;


