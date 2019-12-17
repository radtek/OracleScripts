--
-- DAYLY_FACT  (Table) 
--
CREATE TABLE MASTER.DAYLY_FACT
(
  KOD           NUMBER(10)                      NOT NULL,
  KOD_PLAN      NUMBER(10),
  KOD_DEC       NUMBER(5),
  PERER         NUMBER(6),
  DATA          DATE,
  PROD          VARCHAR2(5 BYTE),
  OSTAT_TEK     NUMBER(10,3)                    DEFAULT 0,
  HRAN_TEK      NUMBER(10,3)                    DEFAULT 0,
  PLAN_DAY      NUMBER(10,3)                    DEFAULT 0,
  PLAN_NAR      NUMBER(10,3)                    DEFAULT 0,
  GRAF_NAR      NUMBER(10,3)                    DEFAULT 0,
  FAKT_NAR      NUMBER(10,3)                    DEFAULT 0,
  POLEZOSTATKI  NUMBER(10,3)                    DEFAULT 0,
  OTGR_NAR      NUMBER(10,3)                    DEFAULT 0,
  REFORM        NUMBER(10,3)                    DEFAULT 0,
  VSEGOZA       NUMBER(10,3)                    DEFAULT 0,
  POKUP         NUMBER(10,3)                    DEFAULT 0,
  SOBSTV        NUMBER(6),
  PEREPASP      NUMBER(10,3)                    DEFAULT 0,
  PROIZV        NUMBER(10,3)                    DEFAULT 0,
  KOMP          NUMBER(10,3)                    DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


