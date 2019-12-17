--
-- AZC_STATIC_REP  (Table) 
--
CREATE TABLE MASTER.AZC_STATIC_REP
(
  ID              NUMBER                        NOT NULL,
  STYPE           VARCHAR2(15 BYTE)             NOT NULL,
  OBJ             VARCHAR2(30 BYTE)             NOT NULL,
  SNOMEN          VARCHAR2(70 BYTE)             NOT NULL,
  QUANT           NUMBER,
  USER_ID         VARCHAR2(70 BYTE)             NOT NULL,
  GROUP_NAME_AZS  VARCHAR2(40 BYTE),
  KOD_OKDP        VARCHAR2(20 BYTE),
  DATE_FROM       DATE,
  DATE_TO         DATE
)
TABLESPACE USERS
NOCOMPRESS ;


