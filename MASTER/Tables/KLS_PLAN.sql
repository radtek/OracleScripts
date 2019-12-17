--
-- KLS_PLAN  (Table) 
--
CREATE TABLE MASTER.KLS_PLAN
(
  ID              NUMBER(2)                     NOT NULL,
  PLAN_NAME       VARCHAR2(30 BYTE),
  PLAN_KIND_ID    NUMBER(10),
  BROTHER_ID      NUMBER(2),
  PLAN_OWNER_ID   NUMBER(6),
  SHORT_NAME      VARCHAR2(10 BYTE),
  GLOBAL_PLAN_ID  NUMBER(10),
  SHORT_GLOBAL    VARCHAR2(20 BYTE),
  ONLY_SNP        NUMBER(1),
  ONLY_UNP        NUMBER(1)                     DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.KLS_PLAN.PLAN_NAME IS '������������ ����� (���������, ����������)';

COMMENT ON COLUMN MASTER.KLS_PLAN.GLOBAL_PLAN_ID IS 'ID ������ �����';

COMMENT ON COLUMN MASTER.KLS_PLAN.ONLY_SNP IS '1-������ �� ���';


