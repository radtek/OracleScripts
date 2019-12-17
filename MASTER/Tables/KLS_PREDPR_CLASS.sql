--
-- KLS_PREDPR_CLASS  (Table) 
--
CREATE TABLE MASTER.KLS_PREDPR_CLASS
(
  ID        NUMBER(10)                          NOT NULL,
  NAME      VARCHAR2(100 BYTE),
  KOD_STAT  NUMBER(10),
  KOD_MOSC  NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_PREDPR_CLASS IS '������������� ����������� �� ����� ���.������������ (������������ � ���������)';

COMMENT ON COLUMN MASTER.KLS_PREDPR_CLASS.ID IS '������������� �����������';

COMMENT ON COLUMN MASTER.KLS_PREDPR_CLASS.NAME IS '������������';

COMMENT ON COLUMN MASTER.KLS_PREDPR_CLASS.KOD_STAT IS '��� ����������';

COMMENT ON COLUMN MASTER.KLS_PREDPR_CLASS.KOD_MOSC IS '��� ��� ������';


