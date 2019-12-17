--
-- OIL_PLAN  (Table) 
--
CREATE TABLE MASTER.OIL_PLAN
(
  KOD          NUMBER                           NOT NULL,
  SOBSTVEN     NUMBER,
  POSTAV       NUMBER,
  PER          NUMBER,
  MESTOR       NUMBER,
  DATAPLAN     DATE,
  OSTATKI      NUMBER                           DEFAULT 0,
  OSTMRT       NUMBER                           DEFAULT 0,
  OSTMRTK      NUMBER                           DEFAULT 0,
  PLAN         NUMBER                           DEFAULT 0,
  PLANPERER    NUMBER                           DEFAULT 0,
  POBR         NUMBER                           DEFAULT 0,
  PEROBR       NUMBER                           DEFAULT 0,
  ID_PROD_NPR  VARCHAR2(5 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;


