--
-- KLS_ST_RASH_KONS  (Table) 
--
CREATE TABLE MASTER.KLS_ST_RASH_KONS
(
  ID    NUMBER(10)                              NOT NULL,
  NAME  VARCHAR2(50 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_ST_RASH_KONS IS '����.����������: ������ �������';

COMMENT ON COLUMN MASTER.KLS_ST_RASH_KONS.ID IS '������ �������';

COMMENT ON COLUMN MASTER.KLS_ST_RASH_KONS.NAME IS '������������';


