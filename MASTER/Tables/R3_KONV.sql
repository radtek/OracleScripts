/* This object may not be sorted properly in the script due to cirular references. */
--
-- R3_KONV  (Table) 
--
CREATE TABLE MASTER.R3_KONV
(
  KSCHL        VARCHAR2(10 BYTE)                NOT NULL,
  T685T_VTEXT  VARCHAR2(100 BYTE),
  MATCH_ASNUM  VARCHAR2(10 BYTE),
  FOX_ID       NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.R3_KONV.KSCHL IS 'Условие разнарядки';

COMMENT ON COLUMN MASTER.R3_KONV.T685T_VTEXT IS 'Наименование';

COMMENT ON COLUMN MASTER.R3_KONV.MATCH_ASNUM IS 'Услуга ММ_МО';



