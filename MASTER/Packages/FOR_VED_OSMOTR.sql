--
-- FOR_VED_OSMOTR  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_VED_OSMOTR AS


  -- Максимальный номер позиции "Ведомости предварительного осмотра"
  FUNCTION GetMaxNumPos(pVED_ID NUMBER) RETURN NUMBER;

  /* УДАЛИТЬ ПОЗИЦИЮ "Ведомости предварительного осмотра" */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER);

  /* Добавить/Изменить заголовок "Ведомости предварительного осмтора" */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
     pVED_NUM NUMBER, pVED_DATE DATE, pFROM_DATE DATE, pTO_DATE DATE, 
	 pFIO1 VARCHAR2, pFIO2 VARCHAR2, pFIO3 VARCHAR2, pSIGN1 VARCHAR2) RETURN NUMBER;

  /* УДАЛИТЬ заголовок "Ведомости предварительного осмотра" */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER);

  /* Скопировать позицию из ДОКУМЕНТА в ДОКУМЕНТ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pROW_ID NUMBER, pNEW_TITLE_ID NUMBER) RETURN NUMBER;

  /* Проверка вагона на уникальность
     Возвращаемое значение - номер ведомости, в которой данный вагон уже есть */
  FUNCTION CHECK_UNIQ (pLOAD_TYPE_ID NUMBER, pNUM_CIST VARCHAR2, pID NUMBER, pDATE DATE) RETURN NUMBER;
  
END;

/

