--
-- KLS_TYPE_ZAKAZ  (Table) 
--
CREATE TABLE MASTER.KLS_TYPE_ZAKAZ
(
  ID    NUMBER(10)                              NOT NULL,
  NAME  VARCHAR2(50 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_TYPE_ZAKAZ IS '���� ������� �����������';

COMMENT ON COLUMN MASTER.KLS_TYPE_ZAKAZ.ID IS 'ID';

COMMENT ON COLUMN MASTER.KLS_TYPE_ZAKAZ.NAME IS '������������';


