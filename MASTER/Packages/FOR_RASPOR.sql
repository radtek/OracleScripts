--
-- FOR_RASPOR  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_RASPOR AS

  /* РАЗРЕШЕНИЕ на отгрузку */


  /* Удалить позицию ДОКУМЕНТА */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER);

  /* Добавить/Изменить заголовок ДОКУМЕНТА
     Возвращаемое занчение - ID документа */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pNUM_NAR NUMBER, pDATE_NAR DATE,
	   pDATE_BEG DATE, pDATE_END DATE, pDOVER_ID NUMBER DEFAULT NULL)
    RETURN VARCHAR2;

  /* Заполнить временную таблицу TEMP_NAR_LINE */
  PROCEDURE FILL_TEMPNL (pNARIAD_ID NUMBER, pDATE_BEG DATE, pDATE_END DATE, pLOAD_TYPE_ID NUMBER);

  /* Перенести значения из TEMP_NAR_LINE в KLS_NAR_LINE */
  PROCEDURE SAVE_TEMPNL (pNARIAD_ID NUMBER);

  /* УДАЛИТЬ заголовок ДОКУМЕНТА */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID VARCHAR2);

  /* Определить дату начала действия распоряжения */
  FUNCTION GetDATE_BEG (pDATE DATE, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER) RETURN DATE;

  /* Определить дату окончания действия распоряжения */
  FUNCTION GetDATE_END (pDATE_BEG DATE, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER) RETURN DATE;
END;

/

