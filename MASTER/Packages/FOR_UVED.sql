--
-- FOR_UVED  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_UVED AS

/* НАКЛАДНЫЕ */

  -- Максимальный номер позиции ДОКУМЕНТА
  FUNCTION GetMaxNumPos(pUVED_ID NUMBER) RETURN NUMBER;

  -- Максимальный номер позиции в таблице TEMP_UVED
  FUNCTION GetTempMaxNumPos RETURN NUMBER;
  
  /* Удалить позицию ДОКУМЕНТА */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER);

  /* УДАЛИТЬ заголовок ДОКУМЕНТА */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER);

  /* Очистить временную таблицу TEMP_UVED */
  PROCEDURE EMPTY_TEMP_UVED;

  /* Первоначальное заполнение временной таблицы TEMP_UVED */
  PROCEDURE FILL_TEMP_UVED (pUVED_ID NUMBER, pUVED_DATE DATE, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER);

  /* Добавить запись в таблицу TEMP_UVED */
  PROCEDURE ADD_TEMP_UVED (pREESTR_ID NUMBER);
  
    /* Удалить запись из таблицы TEMP_UVED */
  PROCEDURE DEL_TEMP_UVED (pREESTR_ID NUMBER);
  
  /* Перенести позиции из TEMP_UVED в REESTR */
  PROCEDURE SAVE_TEMP_UVED (pUVED_ID NUMBER);

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pUVED_NUM NUMBER, pUVED_DATE DATE, pLUKOMA_NUM NUMBER, pCHER_NUM NUMBER, pMPS_NUM NUMBER, pVETL_NUM NUMBER)
    RETURN NUMBER;

  /* Добавить/Изменить позицию ДОКУМЕНТА */
  PROCEDURE AddRow(pCOMMIT NUMBER, pID NUMBER, pUVED_ID NUMBER, pUVED_POS NUMBER);

  /* Скопировать позицию НАКЛАДНОЙ в другую НАКЛАДНУЮ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_UVED_ID NUMBER) RETURN NUMBER;

END;

/

