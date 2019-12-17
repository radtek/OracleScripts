--
-- PLAN_REFINERY  (Table) 
--
CREATE TABLE MASTER.PLAN_REFINERY
(
  KOD        NUMBER(10),
  DATA       DATE,
  PROD       VARCHAR2(5 BYTE),
  PERER      NUMBER(6),
  SOBSTV     NUMBER(6)                          DEFAULT 0,
  OSTAT      NUMBER(10,3)                       DEFAULT 0,
  OSTATTOV   NUMBER(10,3)                       DEFAULT 0,
  HRAN       NUMBER(10,3)                       DEFAULT 0,
  PLANUTMSK  NUMBER(10,3)                       DEFAULT 0,
  OSTUTMSK   NUMBER(10,3)                       DEFAULT 0,
  HRANUTMSK  NUMBER(10,3)                       DEFAULT 0,
  DAVUTMSK   NUMBER(10,3)                       DEFAULT 0,
  PLAN       NUMBER(10,3)                       DEFAULT 0,
  DEC1       NUMBER(10,3)                       DEFAULT 0,
  DEC2       NUMBER(10,3)                       DEFAULT 0,
  DEC3       NUMBER(10,3)                       DEFAULT 0,
  UNPD1      NUMBER(10,3)                       DEFAULT 0,
  UNPD2      NUMBER(10,3)                       DEFAULT 0,
  UNPD3      NUMBER(10,3)                       DEFAULT 0,
  OPERPLAN   NUMBER(10,3)                       DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


