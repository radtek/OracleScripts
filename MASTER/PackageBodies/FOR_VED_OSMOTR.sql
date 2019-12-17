--
-- FOR_VED_OSMOTR  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_VED_OSMOTR AS

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;

  
  -- Максимальный номер позиции "Ведомости предварительного осмотра"
  FUNCTION GetMaxNumPos(pVED_ID NUMBER) RETURN NUMBER AS
    MaxNum NUMBER;
    CurNum NUMBER;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(VED_OSMOTR_ROW.POD_POS) as MAX_NUM
                 FROM VED_OSMOTR_ROW
				WHERE VED_ID=pVED_ID)
    LOOP
      CurNum:=NVL(lcur.MAX_NUM,0);
	  EXIT;
    END LOOP;
	MaxNum:=CurNum+1;
    RETURN MaxNum;
  END;
  
  /* УДАЛИТЬ ПОЗИЦИЮ "Ведомости предварительного осмотра" */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER) AS
    vCNT NUMBER;
  BEGIN
    -- Проверяем наличие позиций ведомости подачи 
	SELECT COUNT(*) INTO vCNT FROM VED_POD_ROW WHERE VED_OSMOTR_ROW_ID=pID;
	IF vCNT>0 THEN
      RaiseError('Позицию ведомости осмотра нельзя удалить - есть позиции ведомости подачи!');
	END IF;

    DELETE FROM VED_OSMOTR_ROW WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* УДАЛИТЬ заголовок "Ведомости предварительного осмотра" */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER) AS
    vCNT NUMBER;
  BEGIN
    -- Проверяем наличие позиций
	SELECT COUNT(*) INTO vCNT FROM VED_OSMOTR_ROW WHERE VED_ID=pID;
	IF vCNT>0 THEN
      RaiseError('Ведомость осмотра нельзя удалить - есть позиции!');
	END IF;
	 
    DELETE FROM VED_OSMOTR WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* Добавить/Изменить заголовок "Ведомости предварительного осмтора" */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
     pVED_NUM NUMBER, pVED_DATE DATE, pFROM_DATE DATE, pTO_DATE DATE, 
	 pFIO1 VARCHAR2, pFIO2 VARCHAR2, pFIO3 VARCHAR2, pSIGN1 VARCHAR2) RETURN NUMBER AS

	vID NUMBER;
	vADD NUMBER;
	vTmp NUMBER;
  BEGIN

    -- ID
	IF NVL(pID,0)<=0 THEN
	  vADD:=1;
      SELECT SEQ_ID.NEXTVAL INTO vID FROM DUAL;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ VED_NUM
        INTO vTmp
	 	FROM VED_OSMOTR
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Ведомость осмотра нельзя отредактировать - она удалена!');
		END IF;
	END;

	-- Обновляем ведомость
	UPDATE VED_OSMOTR SET (VED_NUM, VED_DATE, FROM_DATE, TO_DATE, 
	  FIO1, FIO2, FIO3, SIGN1, MESTO_ID, LOAD_TYPE_ID)=
	  (SELECT pVED_NUM, pVED_DATE, pFROM_DATE, pTO_DATE, 
	  pFIO1, pFIO2, pFIO3, pSIGN1, pMESTO_ID, pLOAD_TYPE_ID FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем ведомость
      INSERT INTO VED_OSMOTR (ID,VED_NUM, VED_DATE, FROM_DATE, TO_DATE, 
	                     FIO1, FIO2, FIO3, SIGN1, MESTO_ID, LOAD_TYPE_ID)
	  VALUES (vID, pVED_NUM, pVED_DATE, pFROM_DATE, pTO_DATE, 
  	          pFIO1, pFIO2, pFIO3, pSIGN1, pMESTO_ID, pLOAD_TYPE_ID);
	END IF;

	-- Обновляем справочники фамилий
	INSERT INTO VED_OSMOTR_SMENA (NAME)
	  SELECT pFIO1 FROM dual
	  WHERE pFIO1||' '<>' ' AND
	    NOT EXISTS (SELECT NULL FROM VED_OSMOTR_SMENA a 
	                     WHERE NLS_UPPER(a.NAME)=NLS_UPPER(pFIO1) ); 

	INSERT INTO VED_OSMOTR_SMENA (NAME)
	  SELECT pFIO2 FROM dual
	  WHERE pFIO2||' '<>' ' AND
	    NOT EXISTS (SELECT NULL FROM VED_OSMOTR_SMENA a 
	                     WHERE NLS_UPPER(a.NAME)=NLS_UPPER(pFIO2) ); 
						 
	INSERT INTO VED_OSMOTR_SMENA (NAME)
	  SELECT pFIO3 FROM dual
	  WHERE pFIO3||' '<>' ' AND
	    NOT EXISTS (SELECT NULL FROM VED_OSMOTR_SMENA a 
	                     WHERE NLS_UPPER(a.NAME)=NLS_UPPER(pFIO3) ); 

	INSERT INTO VED_OSMOTR_PODPIS (NAME)
	  SELECT pSIGN1 FROM dual
	  WHERE pSIGN1||' '<>' ' AND
	    NOT EXISTS (SELECT NULL FROM VED_OSMOTR_PODPIS a 
	                     WHERE NLS_UPPER(a.NAME)=NLS_UPPER(pSIGN1) ); 

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* Скопировать позицию из ДОКУМЕНТА в ДОКУМЕНТ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pROW_ID NUMBER, pNEW_TITLE_ID NUMBER) RETURN NUMBER AS
	vTitle VED_OSMOTR%ROWTYPE;
	vRow VED_OSMOTR_ROW%ROWTYPE;
	vTmp NUMBER;
  BEGIN
    vRow.ID:=NULL;

	-- Считываем запись из ведомости
	BEGIN
	  SELECT * INTO vRow
	    FROM VED_OSMOTR_ROW
	   WHERE ID=pROW_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vRow.ID:=NULL;
	END;

	IF vRow.ID IS NULL THEN
	  -- Добавлять нечего, такой записи в ведомости нет
	  RETURN NULL;
	END IF;

	-- Проверка существования документа-назначения
	BEGIN
	  SELECT * INTO vTitle
	    FROM VED_OSMOTR
	   WHERE ID=pNEW_TITLE_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Ведомость осмотра в которую переносится вагон - удалена!');
	END;

    -- Переносим вагон из ведомости в ведомость
	UPDATE VED_OSMOTR_ROW SET VED_ID=pNEW_TITLE_ID WHERE ID=vRow.ID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vRow.ID;
  END;
  
  /* Проверка вагона на уникальность
     Возвращаемое значение - номер ведомости, в которой данный вагон уже есть */
  FUNCTION CHECK_UNIQ (pLOAD_TYPE_ID NUMBER, pNUM_CIST VARCHAR2, pID NUMBER, pDATE DATE) RETURN NUMBER AS
  PRAGMA AUTONOMOUS_TRANSACTION;
    vRes NUMBER;
	vWorklen NUMBER;
  BEGIN
    IF pLOAD_TYPE_ID=1 THEN
	  vWorklen:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','WORKLEN#1',FOR_INIT.GetCurrUser);
	ELSE
	  vWorklen:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','WORKLEN#2',FOR_INIT.GetCurrUser);
	END IF;
    SELECT a.VED_NUM INTO vRes
	  FROM VED_OSMOTR_ROW b,VED_OSMOTR a
	 WHERE b.VED_ID=a.ID
	   AND a.VED_DATE>=pDATE-2
	   AND b.NUM_CIST=pNUM_CIST
	   AND b.ID<>pID
	   AND (TRUNC(a.VED_DATE)=TRUNC(pDATE) OR
	        ABS(hours_between(a.VED_DATE,pDATE))<vWorklen);
    ROLLBACK;
    RETURN vRes;
  EXCEPTION
    WHEN OTHERS THEN
	  ROLLBACK;
	  RETURN NULL;
  END;

END;

/

