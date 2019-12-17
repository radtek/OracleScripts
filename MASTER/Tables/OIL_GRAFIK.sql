--
-- OIL_GRAFIK  (Table) 
--
CREATE TABLE MASTER.OIL_GRAFIK
(
  KOD          NUMBER,
  KOD_PLAN     NUMBER,
  DATAGRAF     DATE,
  POSTAV       NUMBER,
  PER          NUMBER,
  PROD         NUMBER,
  MESTOR       NUMBER,
  OSTATKI      NUMBER,
  GRAFIK       NUMBER,
  PLANPERER    NUMBER,
  ID_PROD_NPR  VARCHAR2(5 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

