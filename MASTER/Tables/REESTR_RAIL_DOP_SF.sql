--
-- REESTR_RAIL_DOP_SF  (Table) 
--
CREATE TABLE MASTER.REESTR_RAIL_DOP_SF
(
  V_DOK                  VARCHAR2(1 BYTE),
  V_PLAY                 VARCHAR2(2 BYTE),
  MES_DOK                VARCHAR2(2 BYTE),
  GOD_DOK                VARCHAR2(4 BYTE),
  SUMMA                  NUMBER(22,2),
  NOM_DOK                VARCHAR2(10 BYTE),
  NOM_PERECH             VARCHAR2(10 BYTE),
  DAT_PERECH             DATE,
  NOM_SF_GD              VARCHAR2(10 BYTE),
  DAT_SF                 DATE,
  NUM_CIST               NUMBER,
  REM                    VARCHAR2(20 BYTE),
  SOBST                  NUMBER,
  KST                    NUMBER,
  REESTR_RAIL_DOP_SF_ID  NUMBER
)
TABLESPACE USERS2
NOCOMPRESS ;


