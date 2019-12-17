--
-- FOR_PODACHA  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_PODACHA AS

  /* ВЕДОМОСТИ ПОДАЧИ */

  -- Максимальный номер позиции ДОКУМЕНТА
  FUNCTION GetMaxNumPos(pVED_ID NUMBER) RETURN NUMBER;

  /* Удалить позицию ДОКУМЕНТА */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER);

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
  	 pPOD_NUM NUMBER, pPOD_DATE DATE, pTECH_TIME VARCHAR2, pGOTOV_TIME VARCHAR2, pBEG_NALIV_TIME VARCHAR2, pEND_NALIV_TIME VARCHAR2,
     pVETKA_OTP_ID NUMBER) RETURN NUMBER;

  /* УДАЛИТЬ заголовок ДОКУМЕНТА */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER);

  /* Скопировать позицию из ДОКУМЕНТА в ДОКУМЕНТ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pROW_ID NUMBER, pNEW_TITLE_ID NUMBER) RETURN NUMBER;

  /* Проверка вагона на уникальность
     Возвращаемое значение - номер ведомости, в которой данный вагон уже есть */
  FUNCTION CHECK_UNIQ (pLOAD_TYPE_ID NUMBER, pNUM_CIST VARCHAR2, pID NUMBER, pDATE DATE) RETURN NUMBER;

  /* Добавить/Изменить позицию ДОКУМЕНТА
     Возвращаемое занчение - ID позиции документа */
  FUNCTION AddRow(pCOMMIT NUMBER, pID NUMBER, pVED_POD_ID NUMBER, pPOD_POS NUMBER,
    pNUM_CIST VARCHAR2, pNCISTDOP NUMBER, pAXES NUMBER, pCAPACITY VARCHAR2, pVES_CIST NUMBER,
	pVAGONTYPE_ID NUMBER, pKALIBR_ID VARCHAR2, pVAGOWNER_ID NUMBER,
	pVETKA_POD_ID NUMBER, pVETKA_NAPR_ID NUMBER, pVAG_STATUS_ID NUMBER,
	pPROD_ID_NPR VARCHAR2, pVZLIV NUMBER, pVOLUME NUMBER, pTEMPER NUMBER, 
	pZPU_TYPE1 NUMBER, pZPU_TYPE2 NUMBER, pPLOMBA1 VARCHAR2, pPLOMBA2 VARCHAR2, pROSINSPL1 VARCHAR2,
	pROSINSPL2 VARCHAR2, pBAD_NUM NUMBER, pRAZMET_FACT VARCHAR2) RETURN VARCHAR2;

  /* Скопировать позицию ВЕДОМОСТИ ОСМОТРА в ВЕДОМОСТЬ ПОДАЧИ
     Возвращаемое занчение - ID позиции документа */
  FUNCTION CopyVedOsmotrRow (pCOMMIT NUMBER, pVED_OSMOTR_ROW_ID NUMBER, pVED_POD_ID NUMBER) RETURN NUMBER;
END;

/

