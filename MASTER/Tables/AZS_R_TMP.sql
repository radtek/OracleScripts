--
-- AZS_R_TMP  (Table) 
--
CREATE TABLE MASTER.AZS_R_TMP
(
  AZS_R       VARCHAR2(4 BYTE),
  NREC_R      NUMBER(4)                         DEFAULT 0,
  VDATE_R     DATE,
  DATE_R      DATE,
  TRK_R       VARCHAR2(2 BYTE)                  DEFAULT '?',
  GUN_R       CHAR(2 BYTE)                      DEFAULT '?',
  REZ_R       VARCHAR2(2 BYTE)                  DEFAULT '?',
  TYPE_R      CHAR(1 BYTE)                      DEFAULT '?',
  MODEPAY_R   NUMBER(3)                         DEFAULT 0,
  SNOMEN_R    VARCHAR2(20 BYTE)                 DEFAULT '?',
  UNIT_R      VARCHAR2(10 BYTE)                 DEFAULT '?',
  NNOMEN_R    NUMBER(4)                         DEFAULT 0,
  SVOL_R      NUMBER(7,3)                       DEFAULT 0,
  FVOL_R      NUMBER(7,3)                       DEFAULT 0,
  PRICE_R     NUMBER(12,5)                      DEFAULT 0,
  SUMM_R      NUMBER(12,5)                      DEFAULT 0,
  SUMMDISC_R  NUMBER(12,5)                      DEFAULT 0,
  PL_R        NUMBER(6,5)                       DEFAULT 1,
  CARD_R      VARCHAR2(50 BYTE),
  HDATE_R     DATE,
  ERROR_R     NUMBER(3)                         DEFAULT -1,
  ACTUAL_R    NUMBER(3)                         DEFAULT 1,
  RNPARUS_R   NUMBER(17)                        DEFAULT -1,
  USER_R      VARCHAR2(20 BYTE)                 DEFAULT USER,
  USERDATE_R  DATE                              DEFAULT SYSDATE,
  AUTODATE_R  DATE                              DEFAULT SYSDATE
)
TABLESPACE USERS2
NOCOMPRESS ;


