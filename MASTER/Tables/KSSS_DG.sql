--
-- KSSS_DG  (Table) 
--
CREATE TABLE MASTER.KSSS_DG
(
  KUNNR  VARCHAR2(15 BYTE),
  NAME   VARCHAR2(50 BYTE),
  CITY   VARCHAR2(20 BYTE),
  OKPO   VARCHAR2(15 BYTE),
  INN    VARCHAR2(15 BYTE),
  KSSS   VARCHAR2(15 BYTE)
)
TABLESPACE USERS
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KSSS_DG IS '��������������� �� ��� ��������';


