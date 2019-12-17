--
-- FOR_TAX_DOCS  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_TAX_DOCS as

  -- Author  : VTAUBIN
  -- Created : 09.02.2010 13:42:30
  -- Purpose : 

 /* Добавить/Изменить ДОКУМЕНТ*/
  --FUNCTION AddPackage(pPACK_NUM VARCHAR2, pPACK_DATE DATE) RETURN NUMBER;

  FUNCTION AddDoc(pDOC_NUM VARCHAR2, pDOC_DATE DATE, pFILE_NAME VARCHAR2, pFILE_POS NUMBER, pCONTR_NAME VARCHAR2,pUSER_NAME VARCHAR2,pSOURCE_ID NUMBER)
                  RETURN NUMBER;
  Procedure FillPackage(pPack_id number);
  FUNCTION AddPackage(pPACK_NUM VARCHAR2, pPACK_DATE DATE ) RETURN NUMBER;
  --procedure FillPackage(pID_DOC number);
  
  --function AssignParent(pDoc number, pParent_doc number) return number;

end FOR_TAX_DOCS; 
/

