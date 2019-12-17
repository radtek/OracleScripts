--
-- FOR_ENVIRONMENT  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Environment AS

-- ���������� �������� ���������� 
FUNCTION GET_ENV(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2, pNETUSER VARCHAR2:=NULL) RETURN VARCHAR2;
FUNCTION GET_ENV_USER(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2) RETURN VARCHAR2;

-- ��������� �������� ���������� (���� ��� - ��������)  
PROCEDURE SET_ENV(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2, pENV_VALUE VARCHAR2:=NULL, pNETUSER VARCHAR2:=NULL);
PROCEDURE SET_ENV_USER(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2, pENV_VALUE VARCHAR2:=NULL);

-- ������� ����������
PROCEDURE DEL_ENV(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2, pNETUSER VARCHAR2:=NULL);
PROCEDURE DEL_ENV_USER(pAPPL_NAME VARCHAR2, pGRP_NAME VARCHAR2, pENV_NAME VARCHAR2, pNETUSER VARCHAR2:=NULL);

END;

/
