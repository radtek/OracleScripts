--
-- OIL_RESURS  (Table) 
--
CREATE TABLE MASTER.OIL_RESURS
(
  KOD        NUMBER                             NOT NULL,
  KOD_PLAN   NUMBER,
  DATARES    DATE,
  MPOR       NUMBER,
  POSTAV     NUMBER,
  MESTOR     NUMBER,
  PROIZ      NUMBER,
  GRUP       NUMBER,
  PASPORT    NUMBER,
  OSTAT      NUMBER                             DEFAULT 0,
  POST       NUMBER                             DEFAULT 0,
  POSTPLAN   NUMBER                             DEFAULT 0,
  PERER      NUMBER                             DEFAULT 0,
  PERERPLAN  NUMBER                             DEFAULT 0,
  AKT        VARCHAR2(10 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;


