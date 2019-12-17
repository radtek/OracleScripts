--
-- TEMP_VALSVED  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE MASTER.TEMP_VALSVED
(
  KODIF_ID    NUMBER(10),
  TAG         VARCHAR2(10 BYTE),
  NAME        VARCHAR2(50 BYTE),
  VALUE       VARCHAR2(12 BYTE),
  NORMA       VARCHAR2(20 BYTE),
  FIELD_TYPE  VARCHAR2(1 BYTE),
  FIELD_LEN   NUMBER(3),
  FIELD_DEC   NUMBER(3),
  F_DEL       NUMBER(1),
  SORTBY      NUMBER(10)
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE MASTER.TEMP_VALSVED IS '��������� ������� ��� ����� ���������� �������� � ��������';

COMMENT ON COLUMN MASTER.TEMP_VALSVED.SORTBY IS '� �/�';


