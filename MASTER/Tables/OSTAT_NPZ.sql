--
-- OSTAT_NPZ  (Table) 
--
CREATE TABLE MASTER.OSTAT_NPZ
(
  NPZ_DATE     DATE,
  SOBSTV_ID    NUMBER,
  OST          NUMBER,
  PASP         NUMBER,
  OTGR         NUMBER,
  HRAN         NUMBER,
  ID_PROD_NPR  VARCHAR2(5 BYTE),
  M_OST        NUMBER                           DEFAULT 0,
  REQUEST      NUMBER                           DEFAULT 0,
  KOMP         NUMBER(10,3)                     DEFAULT 0,
  REZERV       NUMBER(10,3)
)
TABLESPACE USERS2
NOCOMPRESS ;


