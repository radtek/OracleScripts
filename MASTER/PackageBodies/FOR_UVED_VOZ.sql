--
-- FOR_UVED_VOZ  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_UVED_VOZ
AS
/* УВЕДОМЛЕНИЯ о СЛИВЕ */

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;

  -- Максимальный номер позиции ДОКУМЕНТА
  FUNCTION GetMaxNumPos(pUVED_ID NUMBER) RETURN NUMBER AS
    MaxNum REESTR_IN.UVED_POS%TYPE;
    CurNum REESTR_IN.UVED_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(REESTR_IN.UVED_POS) as MAX_NUM
                 FROM REESTR_IN
				WHERE UVED_ID=pUVED_ID)
    LOOP
      CurNum:=NVL(lcur.MAX_NUM,0);
	  EXIT;
    END LOOP;
	MaxNum:=CurNum+1;
    RETURN MaxNum;
  END;

  -- Максимальный номер позиции в таблице TEMP_UVED
  FUNCTION GetTempMaxNumPos RETURN NUMBER AS
    MaxNum TEMP_UVED.UVED_POS%TYPE;
    CurNum TEMP_UVED.UVED_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(UVED_POS) as MAX_NUM
                 FROM TEMP_UVED)
    LOOP
      CurNum:=NVL(lcur.MAX_NUM,0);
	  EXIT;
    END LOOP;
	MaxNum:=CurNum+1;
    RETURN MaxNum;
  END;
  
  /* Удалить позицию ДОКУМЕНТА */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER) AS
  BEGIN
    UPDATE REESTR_IN SET UVED_ID=NULL, UVED_POS=NULL WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* УДАЛИТЬ заголовок ДОКУМЕНТА */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER) AS
    vCNT NUMBER;
  BEGIN
    -- Проверяем наличие позиций
	SELECT COUNT(*) INTO vCNT FROM REESTR_IN WHERE UVED_ID=pID;
	IF vCNT>0 THEN
      RaiseError('Накладную нельзя удалить - есть позиции!');
	END IF;

    DELETE FROM UVED WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* Очистить временную таблицу TEMP_UVED */
  PROCEDURE EMPTY_TEMP_UVED AS
  BEGIN
    DELETE TEMP_UVED;
  END;

  /* Первоначальное заполнение временной таблицы TEMP_UVED */
  PROCEDURE FILL_TEMP_UVED (pUVED_ID NUMBER, pSRC_REESTR_ID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER) AS
    vRow REESTR_IN%ROWTYPE;
    vSved SVED_IN%ROWTYPE;
  BEGIN
    EMPTY_TEMP_UVED;
	
	IF NVL(pUVED_ID,0)<>0 THEN
	  -- Если редактирование накладной
      INSERT INTO TEMP_UVED (UVED_POS, REESTR_ID, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    PROD_NAME, VAGOWNER_NAME, SVED_DATE,NAKL_NUM,VES_CIST) 
      SELECT
	    reestr_in.UVED_POS,
  	    reestr_in.ID as REESTR_ID,
		sved_in.SVED_NUM,
        reestr_in.NUM_CIST,
	    reestr_in.VES,
        sved_in.DATE_OFORML,
	    KLS_PROD.ABBR_NPR as PROD_NAME,
        KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
		sved_in.SVED_DATE,
        nakl.NAKL_NUM,
		reestr_in.VES_CIST
      from reestr_in, sved_in, KLS_VAGOWNER, KLS_PROD,nakl
      where reestr_in.sved_in_id=sved_in.id
	    and sved_in.prod_id_npr=kls_prod.id_npr(+)
        and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		and reestr_in.NAKL_ID=nakl.ID(+)
        and reestr_in.UVED_id=pUVED_ID
      ORDER BY
        reestr_in.UVED_POS, reestr_in.ID;
	ELSE
	  -- Отбираем реквизиты вагона
	  BEGIN
  	    SELECT * INTO vRow FROM reestr_in
         WHERE ID=pSRC_REESTR_ID;
	  EXCEPTION
	    WHEN OTHERS THEN
	      RETURN;
	  END;
	  -- Отбираем реквизиты сведения
	  BEGIN
  	    SELECT * INTO vSved FROM sved_in
         WHERE ID=vRow.SVED_IN_ID;
	  EXCEPTION
	    WHEN OTHERS THEN
	      RETURN;
  	  END;

	  -- Если добавление нового	    
      INSERT INTO TEMP_UVED (UVED_POS, REESTR_ID, VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,NAKL_NUM,VES_ALL,VES_CIST,VES_UPAK) 
      SELECT
 	    ROWNUM as UVED_POS,
        REESTR_ID,
        VETKA_OTP_NAME,
        POD_NUM,
        SVED_NUM,
        NUM_CIST,
        VES,
        DATE_OFORML,
        NOM_ZD,
        STAN_NAME,
        PROD_NAME,
        VAGOWNER_NAME,
        PLOUCH_NAME,
		SVED_DATE,
		PASP_NUM,
		VAG_STATUS,
		NAKL_NUM,
		VES_ALL,
		VES_CIST,
		UPAK_VES
      FROM
        (
      SELECT
	    reestr_in.UVED_POS,
  	    reestr_in.ID as REESTR_ID,
		null as VETKA_OTP_NAME,
	    null as POD_NUM,
		sved_in.SVED_NUM,
        reestr_in.NUM_CIST,
	    reestr_in.VES,
        sved_in.DATE_OFORML,
		null as NOM_ZD,
        null as stan_name,
	    KLS_PROD.ABBR_NPR as PROD_NAME,
        KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
	    null as PLOUCH_NAME,
		sved_in.SVED_DATE,
		null as PASP_NUM,
		null as VAG_STATUS,
        nakl.NAKL_NUM,
		null as VES_ALL,
		reestr_in.VES_CIST,
		null as UPAK_VES
      from reestr_in, sved_in, kls_stan stan_voz,KLS_VAGOWNER, KLS_PROD,nakl
      where reestr_in.sved_in_id=sved_in.id
	  	and reestr_in.STAN_VOZ_ID=stan_voz.id(+)
	    and sved_in.prod_id_npr=kls_prod.id_npr(+)
        and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		and reestr_in.NAKL_ID=nakl.ID(+)
        and sved_in.MESTO_ID=pMESTO_ID
        and sved_in.PROD_ID_NPR=vSved.PROD_ID_NPR -- тот же продукт, что и в эталонном сведении
        and reestr_in.UVED_id is null -- не входят в уведомление
        and sved_in.SVED_DATE BETWEEN vSved.SVED_DATE-1 AND vSved.SVED_DATE+1
        ORDER BY
          sved_in.SVED_DATE,
          sved_in.SVED_NUM,
          reestr_in.SVED_POS
        );
	END IF;		  
  END;

  /* Добавить запись в таблицу TEMP_UVED */
  PROCEDURE ADD_TEMP_UVED (pREESTR_ID NUMBER) AS
  BEGIN
    IF NVL(pREESTR_ID,0)<>0 THEN
      INSERT INTO TEMP_UVED (UVED_POS, REESTR_ID) VALUES (GetTempMaxNumPos, pREESTR_ID);

  	  UPDATE TEMP_UVED
	  SET (VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,NAKL_NUM,VES_ALL,
		VES_CIST,VES_UPAK)=
        (SELECT
		null as VETKA_OTP_NAME,
	    null as POD_NUM,
		sved_in.SVED_NUM,
        reestr_in.NUM_CIST,
	    reestr_in.VES,
        sved_in.DATE_OFORML,
		null as NOM_ZD,
        stan_voz.STAN_NAME as stan_name,
	    KLS_PROD.ABBR_NPR as PROD_NAME,
        KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
	    null as PLOUCH_NAME,
		sved_in.SVED_DATE,
		sved_in.PASP_NUM,
		null as VAG_STATUS,
        nakl.NAKL_NUM,
		null as VES_ALL,
		reestr_in.VES_CIST,
		null as VES_UPAK
      from reestr_in, sved_in, kls_stan stan_voz,KLS_VAGOWNER, KLS_PROD,nakl
      where reestr_in.sved_in_id=sved_in.id
	  	and reestr_in.STAN_VOZ_ID=stan_voz.id(+)
	    and sved_in.prod_id_npr=kls_prod.id_npr(+)
        and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		and reestr_in.NAKL_ID=nakl.ID(+)
        and reestr_in.ID=pREESTR_ID)
	  WHERE REESTR_ID=pREESTR_ID
	    AND EXISTS (SELECT NULL FROM reestr_in WHERE reestr_in.ID=pREESTR_ID);
	END IF;		  
  END;

  /* Добавить запись в таблицу TEMP_UVED */
  PROCEDURE DEL_TEMP_UVED (pREESTR_ID NUMBER) AS
  BEGIN
	DELETE FROM TEMP_UVED WHERE REESTR_ID=pREESTR_ID;
	COMMIT;
  END;

  
  /* Перенести позиции из TEMP_UVED в REESTR */
  PROCEDURE SAVE_TEMP_UVED (pUVED_ID NUMBER) AS
    vTmp NUMBER;
  BEGIN
    IF NVL(pUVED_ID,0)<>0 THEN
      UPDATE reestr_in SET UVED_ID=NULL, UVED_POS=NULL WHERE UVED_ID=pUVED_ID;
      FOR lcur IN (SELECT * FROM TEMP_UVED)
	  LOOP
  	    AddRow(0,lcur.REESTR_ID,pUVED_ID,lcur.UVED_POS);
	  END LOOP;
	END IF;
  END;

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pUVED_NUM NUMBER, pUVED_DATE DATE, pLUKOMA_NUM NUMBER, pCHER_NUM NUMBER, pMPS_NUM NUMBER, pVETL_NUM NUMBER, pOPERSGS_ID NUMBER, pPROD_ID_NPR VARCHAR2 DEFAULT NULL)
    RETURN NUMBER AS

	vID UVED.ID%TYPE;
	vADD NUMBER(1);
	vTmp NUMBER;
  BEGIN

    -- ID
	IF NVL(pID,0)=0 THEN
	  vADD:=1;
      SELECT SEQ_ID.nextval INTO vID FROM DUAL;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM UVED
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Уведомление нельзя отредактировать - оно удалено!');
		END IF;
	END;

	-- Обновляем документ
	UPDATE UVED SET (UVED_NUM, UVED_DATE, MESTO_ID, LOAD_TYPE_ID, LUKOMA_NUM, MPS_NUM, CHER_NUM, VETL_NUM, OPERSGS_ID,PROD_ID_NPR)=
	  (SELECT pUVED_NUM, pUVED_DATE, pMESTO_ID, pLOAD_TYPE_ID, pLUKOMA_NUM, pMPS_NUM, pCHER_NUM, pVETL_NUM, pOPERSGS_ID, pPROD_ID_NPR FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем документ
      INSERT INTO UVED (ID,UVED_NUM, UVED_DATE, MESTO_ID, LOAD_TYPE_ID, LUKOMA_NUM, MPS_NUM, CHER_NUM, VETL_NUM, OPERSGS_ID,PROD_ID_NPR)
	  VALUES (vID, pUVED_NUM, pUVED_DATE, pMESTO_ID, pLOAD_TYPE_ID, pLUKOMA_NUM, pMPS_NUM, pCHER_NUM, pVETL_NUM, pOPERSGS_ID,pPROD_ID_NPR);
	END IF;

	-- Сохранение позиций из временной таблицы TEMP_UVED
	SAVE_TEMP_UVED(vID);

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* Добавить/Изменить позицию ДОКУМЕНТА */
  PROCEDURE AddRow(pCOMMIT NUMBER, pID NUMBER, pUVED_ID NUMBER, pUVED_POS NUMBER) AS
	vID REESTR_IN.ID%TYPE;
	vADD NUMBER(1);
	vTmp NUMBER;
	vPos NUMBER;
  BEGIN
    vID:=pID;

	-- Проверка существования позиции
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM REESTR_IN
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Позицию нельзя включить в уведомление - вагон удален!');
	END;

	vPos:=NVL(pUVED_POS,GetMaxNumPos(pUVED_ID));

	-- Обновляем позицию
	UPDATE REESTR_IN SET UVED_ID=pUVED_ID, UVED_POS=vPos WHERE ID=vID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  /* Скопировать позицию уведомления в другоеуведомление 
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_UVED_ID NUMBER) RETURN NUMBER AS
	vRow REESTR_IN%ROWTYPE;
	vTmp NUMBER;
  BEGIN
    vRow.ID:=NULL;

	-- Считываем запись из накладной
	BEGIN
	  SELECT * INTO vRow
	    FROM REESTR_IN
	   WHERE ID=pREESTR_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vRow.ID:=NULL;
	END;

	IF vRow.ID IS NULL THEN
	  -- Переносить нечего, такой записи в накладной нет
	  RETURN NULL;
	END IF;

	-- Проверка существования документа-назначения
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM UVED
	   WHERE ID=pNEW_UVED_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Уведомление в которую переносится вагон - удалено!');
	END;

    -- Переносим вагон из накладной в накладную
	AddRow(0,vRow.ID,pNEW_UVED_ID,NULL);

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vRow.ID;
  END;

END;
/

