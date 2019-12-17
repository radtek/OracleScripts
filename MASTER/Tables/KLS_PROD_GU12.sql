--
-- KLS_PROD_GU12  (Table) 
--
CREATE TABLE MASTER.KLS_PROD_GU12
(
  ID             VARCHAR2(10 BYTE)              NOT NULL,
  NAME           VARCHAR2(40 BYTE),
  NAME_GU12      VARCHAR2(40 BYTE),
  ORDER_GDPL     NUMBER(2),
  NAME_GDPL      VARCHAR2(40 BYTE),
  STAT_NAGR      NUMBER(3),
  GD_VAGTYPE_ID  NUMBER(10),
  GD_GROUP_ID    NUMBER(10),
  GROUP_PLAN     VARCHAR2(40 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_PROD_GU12 IS '������ ��������� (��� ��-12)';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.ID IS '������ �/��������� (��� ��-12)';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.NAME IS '������������';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.NAME_GU12 IS '������������ (��� ��-12)';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.ORDER_GDPL IS '������� � ��������� �����';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.NAME_GDPL IS '������������ � ��������� �����';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.STAT_NAGR IS '����.��������';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.GD_VAGTYPE_ID IS '��� ������ (��� ��-12)';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.GD_GROUP_ID IS '������ �/� �����';

COMMENT ON COLUMN MASTER.KLS_PROD_GU12.GROUP_PLAN IS '������ ������������';



