--
-- GR_INTEGR  (Table) 
--
CREATE TABLE MASTER.GR_INTEGR
(
  ELEM_BAL       NUMBER(3)                      NOT NULL,
  VID_OBEKT_RAB  NUMBER(3)                      NOT NULL,
  VID_RASH       NUMBER(3)                      NOT NULL,
  N_OB           NUMBER(8)                      NOT NULL,
  SYB_RNK        NUMBER(3)                      NOT NULL,
  N_GR_INTEGR    NUMBER(4)                      NOT NULL,
  TYP_POK        NUMBER(4)                      NOT NULL,
  INTERV         NUMBER(3),
  VAR_VR_ZON     NUMBER(3)                      DEFAULT 0                     NOT NULL,
  DAT_START      DATE,
  DAT_END        DATE,
  N_KON          NUMBER(10),
  TXT            VARCHAR2(80 BYTE),
  KTO            VARCHAR2(15 BYTE),
  DAT            DATE,
  N_GR_KON       NUMBER(3),
  SYB_RNK_K      NUMBER(3),
  N_OB_K         NUMBER(8),
  TYPE           NUMBER(1)                      DEFAULT 0                     NOT NULL,
  AB             VARCHAR2(1 BYTE),
  IS_COPYED      INTEGER
)
TABLESPACE USERS2
NOCOMPRESS ;


