--
-- LOAD_FIL_PERIODS  (Table) 
--
CREATE TABLE MASTER.LOAD_FIL_PERIODS
(
  ID           NUMBER(10)                       NOT NULL,
  FILIAL_ID    NUMBER(10)                       NOT NULL,
  DATE_REPORT  DATE,
  FILENAME     VARCHAR2(100 BYTE),
  DATE_LOAD    DATE,
  USER_LOAD    VARCHAR2(240 BYTE),
  REP_TYPE_ID  NUMBER(10)                       NOT NULL,
  STATUS       NUMBER(2)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.LOAD_FIL_PERIODS IS '����������� �������� ����';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.ID IS 'ID ��������';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.FILIAL_ID IS 'ID �������';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.DATE_REPORT IS '�������� ����';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.FILENAME IS '����';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.DATE_LOAD IS '���� ����� ��������';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.USER_LOAD IS '������������';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.REP_TYPE_ID IS '��� ������������ ������';

COMMENT ON COLUMN MASTER.LOAD_FIL_PERIODS.STATUS IS '������ ������: 0-�������� � �����, 1-��������, 2-�������� � AZC_OPERATION';


