--
-- REPL_ANSW_IN  (Table) 
--
CREATE TABLE MASTER.REPL_ANSW_IN
(
  REPL_ID     NUMBER(17)                        NOT NULL,
  REPL_LIST   NUMBER(10),
  SRC_SITE    NUMBER(10),
  DST_SITE    NUMBER(10),
  REPL_ANSW   DATE,
  REPLSTATUS  NUMBER(1)                         DEFAULT 0,
  REPL_ERROR  VARCHAR2(100 BYTE),
  OSUSER      VARCHAR2(30 BYTE),
  FILE_TYPE   NUMBER(10),
  REPL_SQL1   VARCHAR2(250 BYTE),
  REPL_SQL2   VARCHAR2(250 BYTE),
  REPL_SQL3   VARCHAR2(250 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.REPL_ANSW_IN IS '������� �������� �������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_ID IS '������ � �������������� �������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_LIST IS '����������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.SRC_SITE IS '����-��������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.DST_SITE IS '����-����������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_ANSW IS '���� ������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPLSTATUS IS '������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_ERROR IS '������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.OSUSER IS '������������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.FILE_TYPE IS '��� ������������� �����';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_SQL1 IS '�������� ������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_SQL2 IS '�������� ������';

COMMENT ON COLUMN MASTER.REPL_ANSW_IN.REPL_SQL3 IS '�������� ������';



