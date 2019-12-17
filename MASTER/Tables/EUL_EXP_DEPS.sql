/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_EXP_DEPS  (Table) 
--
CREATE TABLE MASTER.EUL_EXP_DEPS
(
  ED_ID       NUMBER(10)                        NOT NULL,
  ED_TYPE     VARCHAR2(10 BYTE),
  PD_P_ID     NUMBER(10),
  PED_EXP_ID  NUMBER(10),
  PFD_FUN_ID  NUMBER(10),
  PSD_SQ_ID   NUMBER(10),
  CD_EXP_ID   NUMBER(10),
  CFD_FUN_ID  NUMBER(10),
  CPD_EXP_ID  NUMBER(10),
  CID_EXP_ID  NUMBER(10),
  NOTM        NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


