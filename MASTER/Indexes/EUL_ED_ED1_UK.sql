/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_ED_ED1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_ED_ED1_UK ON MASTER.EUL_EXP_DEPS
(PSD_SQ_ID, PFD_FUN_ID, CD_EXP_ID, PED_EXP_ID, PD_P_ID, 
CFD_FUN_ID, CPD_EXP_ID, CID_EXP_ID)
TABLESPACE USERSINDX;


