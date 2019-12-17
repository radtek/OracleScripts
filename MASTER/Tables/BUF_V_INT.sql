--
-- BUF_V_INT  (Table) 
--
CREATE TABLE MASTER.BUF_V_INT
(
  SYB_RNK      NUMBER(3),
  N_OB         NUMBER(8),
  N_FID        NUMBER(4),
  N_GR_TY      NUMBER(4),
  N_SH         NUMBER(10),
  DD_MM_YYYY   DATE,
  N_INTER_RAS  NUMBER(4),
  KOL_DB       NUMBER(7),
  KOL          NUMBER(7),
  VAL          NUMBER,
  STAT         VARCHAR2(1 BYTE),
  MIN_0        NUMBER(4),
  MIN_1        NUMBER(4),
  INTERV       NUMBER(2),
  AK_SUM       NUMBER,
  POK_START    NUMBER,
  RASH_POLN    NUMBER,
  IMPULSES     NUMBER,
  IS_COPYED    NUMBER
)
TABLESPACE USERS
NOCOMPRESS ;

