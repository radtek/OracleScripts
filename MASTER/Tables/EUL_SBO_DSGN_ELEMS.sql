/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SBO_DSGN_ELEMS  (Table) 
--
CREATE TABLE MASTER.EUL_SBO_DSGN_ELEMS
(
  SDE_ID           NUMBER(10)                   NOT NULL,
  SDE_TYPE         VARCHAR2(10 BYTE),
  SDE_SUMO_ID      NUMBER(10),
  SDE_FORMULA_MOD  NUMBER(1),
  SAIL_EXP_ID      NUMBER(10),
  SMIL_EXP_ID      NUMBER(10),
  SMIL_FUN_ID      NUMBER(10),
  NOTM             NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


