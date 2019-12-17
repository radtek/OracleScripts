--
-- PARUS_STORE_ORG_STRU_LINK  (Table) 
--
CREATE TABLE MASTER.PARUS_STORE_ORG_STRU_LINK
(
  ID            NUMBER(10)                      NOT NULL,
  STORE_RN      NUMBER(15),
  ORG_STRU_ID   NUMBER(10),
  IS_AUTO_LINK  NUMBER(1)                       DEFAULT 1,
  IS_MAIN       NUMBER(1)                       DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.PARUS_STORE_ORG_STRU_LINK IS '����� "����� (�����) - �������������"';

COMMENT ON COLUMN MASTER.PARUS_STORE_ORG_STRU_LINK.STORE_RN IS 'RN ������ � ������';

COMMENT ON COLUMN MASTER.PARUS_STORE_ORG_STRU_LINK.ORG_STRU_ID IS 'ID �������������';

COMMENT ON COLUMN MASTER.PARUS_STORE_ORG_STRU_LINK.IS_AUTO_LINK IS '������� �������������� �����';

COMMENT ON COLUMN MASTER.PARUS_STORE_ORG_STRU_LINK.IS_MAIN IS '��������';


