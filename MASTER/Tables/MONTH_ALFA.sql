--
-- MONTH_ALFA  (Table) 
--
CREATE TABLE MASTER.MONTH_ALFA
(
  CON_ID              NUMBER(10)                NOT NULL,
  XCONFIRM            NUMBER(10)                DEFAULT 0,
  DATE_PLAN           DATE,
  KOL_NET             NUMBER(19,5)              DEFAULT 0,
  MON_DOB             NUMBER(2)                 DEFAULT 0,
  MON_DELIV           NUMBER(2)                 DEFAULT 0,
  N_MAR_POR           VARCHAR2(14 BYTE),
  N_MAR_DATE          DATE,
  PRODUCER_ID         NUMBER(10),
  PRODUCER_NAME       VARCHAR2(36 BYTE),
  ROUT_NAME           VARCHAR2(90 BYTE),
  CONTRACT            VARCHAR2(50 BYTE),
  CONTRACT_DATE       DATE,
  BUYER_ID            NUMBER(10),
  BUYER_NAME          VARCHAR2(75 BYTE),
  EXPED_ID            NUMBER(10),
  EXPED_NAME          VARCHAR2(75 BYTE),
  GROTP_ID            NUMBER(10),
  GROTP_NAME          VARCHAR2(75 BYTE),
  POLUCH_ID           NUMBER(10),
  POLUCH_NAME         VARCHAR2(75 BYTE),
  INCOTERMS_RUS_ID    NUMBER(10),
  INCOTERMS_RUS_NAME  VARCHAR2(127 BYTE),
  STAN_ID             NUMBER(10),
  STAN_NAME           VARCHAR2(30 BYTE),
  STAN_KOD            VARCHAR2(12 BYTE),
  STATUS              NUMBER(10)                DEFAULT 2
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.MONTH_ALFA.CON_ID IS 'ID ���������� ������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.XCONFIRM IS 'N ���������� ������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.DATE_PLAN IS '������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.KOL_NET IS '���-�����';

COMMENT ON COLUMN MASTER.MONTH_ALFA.MON_DOB IS '����� ������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.MON_DELIV IS '����� �����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.N_MAR_POR IS 'N ����������� ���������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.N_MAR_DATE IS '���� ����������� ���������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.PRODUCER_ID IS '�������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.PRODUCER_NAME IS '�������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.ROUT_NAME IS '������� ���������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.CONTRACT IS '���������� ��������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.CONTRACT_DATE IS '���� ���������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.BUYER_ID IS '����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.BUYER_NAME IS '����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.EXPED_ID IS '����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.EXPED_NAME IS '����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.GROTP_ID IS '����������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.GROTP_NAME IS '����������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.POLUCH_ID IS '���������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.POLUCH_NAME IS '���������������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.INCOTERMS_RUS_ID IS '���������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.INCOTERMS_RUS_NAME IS '���������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.STAN_ID IS '������� ����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.STAN_NAME IS '������� ����������';

COMMENT ON COLUMN MASTER.MONTH_ALFA.STAN_KOD IS '������� ���������� (���)';

COMMENT ON COLUMN MASTER.MONTH_ALFA.STATUS IS '������ ������';



