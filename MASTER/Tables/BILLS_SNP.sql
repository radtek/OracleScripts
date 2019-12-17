--
-- BILLS_SNP  (Table) 
--
CREATE TABLE MASTER.BILLS_SNP
(
  NOM_DOK        NUMBER(7)                      NOT NULL,
  NOM_SF         NUMBER(7),
  NPO_SF         VARCHAR2(200 BYTE),
  DATE_VYP_SF    DATE,
  DATE_KVIT      DATE,
  DATE_BUXG      DATE,
  DATE_MOS       DATE,
  SUMMA_DOK      NUMBER(15,2),
  NDS_DOK        NUMBER(15,2),
  GSM_DOK        NUMBER(15,2),
  AKCIZ_DOK      NUMBER(15,2),
  PRIM           VARCHAR2(65 BYTE),
  FIO_ISPOL      VARCHAR2(40 BYTE),
  KOL_DN         NUMBER(5),
  OLD_NOM_DOK    NUMBER(7),
  NOM_ZD         VARCHAR2(12 BYTE),
  OWNER_ID       NUMBER(6),
  DOG_ID         NUMBER(5),
  USL_NUMBER     NUMBER(3),
  PROD_ID_NPR    VARCHAR2(5 BYTE),
  CAT_CEN_ID     NUMBER(10),
  NPR_PRICES_ID  NUMBER(10),
  OLD_NOM_SF     NUMBER(7),
  IS_AGENT       NUMBER(1)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.BILLS_SNP IS '�����-������� ���, ������������ � ��������� �������';



