--
-- KLS_GD_GROUP  (Table) 
--
CREATE TABLE MASTER.KLS_GD_GROUP
(
  ID    NUMBER(10)                              NOT NULL,
  ABBR  VARCHAR2(10 BYTE),
  NAME  VARCHAR2(30 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_GD_GROUP IS '������ �/� ������';

COMMENT ON COLUMN MASTER.KLS_GD_GROUP.ID IS '������ �/� �����';

COMMENT ON COLUMN MASTER.KLS_GD_GROUP.ABBR IS '���';

COMMENT ON COLUMN MASTER.KLS_GD_GROUP.NAME IS '������������';


