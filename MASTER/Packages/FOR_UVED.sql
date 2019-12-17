--
-- FOR_UVED  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_UVED AS

/* ��������� */

  -- ������������ ����� ������� ���������
  FUNCTION GetMaxNumPos(pUVED_ID NUMBER) RETURN NUMBER;

  -- ������������ ����� ������� � ������� TEMP_UVED
  FUNCTION GetTempMaxNumPos RETURN NUMBER;
  
  /* ������� ������� ��������� */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER);

  /* ������� ��������� ��������� */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER);

  /* �������� ��������� ������� TEMP_UVED */
  PROCEDURE EMPTY_TEMP_UVED;

  /* �������������� ���������� ��������� ������� TEMP_UVED */
  PROCEDURE FILL_TEMP_UVED (pUVED_ID NUMBER, pUVED_DATE DATE, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER);

  /* �������� ������ � ������� TEMP_UVED */
  PROCEDURE ADD_TEMP_UVED (pREESTR_ID NUMBER);
  
    /* ������� ������ �� ������� TEMP_UVED */
  PROCEDURE DEL_TEMP_UVED (pREESTR_ID NUMBER);
  
  /* ��������� ������� �� TEMP_UVED � REESTR */
  PROCEDURE SAVE_TEMP_UVED (pUVED_ID NUMBER);

  /* ��������/�������� ��������� ��������� */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pUVED_NUM NUMBER, pUVED_DATE DATE, pLUKOMA_NUM NUMBER, pCHER_NUM NUMBER, pMPS_NUM NUMBER, pVETL_NUM NUMBER)
    RETURN NUMBER;

  /* ��������/�������� ������� ��������� */
  PROCEDURE AddRow(pCOMMIT NUMBER, pID NUMBER, pUVED_ID NUMBER, pUVED_POS NUMBER);

  /* ����������� ������� ��������� � ������ ���������
     ������������ �������� - ID ������� ��������� ��� NULL - ���� ������ �� ������� */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_UVED_ID NUMBER) RETURN NUMBER;

END;

/

