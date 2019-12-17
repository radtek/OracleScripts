--
-- KVIT_ALFA  (Table) 
--
CREATE TABLE MASTER.KVIT_ALFA
(
  CON_ID     NUMBER(10)                         NOT NULL,
  KVIT_ID    NUMBER(16)                         NOT NULL,
  VES        NUMBER(19,5)                       DEFAULT 0,
  KOL_NET    NUMBER(19,5)                       DEFAULT 0,
  DATE_OTGR  DATE
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.KVIT_ALFA.CON_ID IS 'ID ���������� ������';

COMMENT ON COLUMN MASTER.KVIT_ALFA.KVIT_ID IS '���������';

COMMENT ON COLUMN MASTER.KVIT_ALFA.VES IS '���-������';

COMMENT ON COLUMN MASTER.KVIT_ALFA.KOL_NET IS '���-�����';



