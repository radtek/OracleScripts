--
-- FOR_UVED  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_UVED
AS

/* НАКЛАДНЫЕ */

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;

  -- Максимальный номер позиции ДОКУМЕНТА
  FUNCTION GetMaxNumPos(pUVED_ID NUMBER) RETURN NUMBER AS
    MaxNum REESTR.UVED_POS%TYPE;
    CurNum REESTR.UVED_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(REESTR.UVED_POS) as MAX_NUM
                 FROM REESTR
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
    UPDATE REESTR SET UVED_ID=NULL, UVED_POS=NULL WHERE ID=pID;
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
	SELECT COUNT(*) INTO vCNT FROM REESTR WHERE UVED_ID=pID;
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
  PROCEDURE FILL_TEMP_UVED (pUVED_ID NUMBER, pUVED_DATE DATE, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER) AS
  BEGIN
    EMPTY_TEMP_UVED;
	
	IF NVL(pUVED_ID,0)<>0 THEN
	  -- Если редактирование накладной
      INSERT INTO TEMP_UVED (UVED_POS, REESTR_ID, VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,NAKL_NUM,VES_ALL,VES_CIST,VES_UPAK) 
      SELECT
	    reestr.UVED_POS,
  	    reestr.ID as REESTR_ID,
        KLS_VETKA_OTP.SHORT_NAME as VETKA_OTP_NAME,
	    ved_pod.POD_NUM,
	    sved.SVED_NUM,
        REESTR.NUM_CIST,
	    reestr.VES,
        SVED.DATE_OFORML,
        SVED.NOM_ZD,
        KLS_STAN.STAN_NAME,
	    KLS_PROD.ABBR_NPR as PROD_NAME,
        KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
	    poluch.SHORT_NAME as PLOUCH_NAME,
		sved.SVED_DATE,
		sved.PASP_NUM,
		KLS_VAG_STATUS.NAME as VAG_STATUS,
        nakl.NAKL_NUM,
		reestr.VES_ALL,
		reestr.VES_CIST,
		reestr.UPAK_VES
      from reestr, sved, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status,nakl
      where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
        and reestr.ved_pod_row_id=ved_pod_row.id(+) 
	    and ved_pod_row.ved_pod_id=ved_pod.id(+)
        and month.stan_id=kls_stan.id(+)
	    and month.poluch_id=poluch.id(+)
        and reestr.vetka_otp_id=kls_vetka_otp.id(+)
	    and sved.prod_id_npr=kls_prod.id_npr(+)
        and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
		and reestr.NAKL_ID=nakl.ID(+)
        and reestr.UVED_id=pUVED_ID
      ORDER BY
        reestr.UVED_POS, reestr.ID;
	ELSE
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
	      reestr.ID as REESTR_ID,
          KLS_VETKA_OTP.SHORT_NAME as VETKA_OTP_NAME,
    	  ved_pod.POD_NUM,
	      sved.SVED_NUM,
          REESTR.NUM_CIST,
    	  reestr.VES,
          SVED.DATE_OFORML,
          SVED.NOM_ZD,
          KLS_STAN.STAN_NAME,
    	  KLS_PROD.ABBR_NPR as PROD_NAME,
          KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
    	  poluch.SHORT_NAME as PLOUCH_NAME,
		  sved.SVED_DATE,
		  sved.PASP_NUM,
		  KLS_VAG_STATUS.NAME as VAG_STATUS,
          nakl.NAKL_NUM,
		  reestr.VES_ALL,
		  reestr.VES_CIST,
		  reestr.UPAK_VES
        from reestr, sved, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status,nakl
        where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
          and reestr.ved_pod_row_id=ved_pod_row.id(+) 
    	  and ved_pod_row.ved_pod_id=ved_pod.id(+)
          and month.stan_id=kls_stan.id(+)
    	  and month.poluch_id=poluch.id(+)
          and reestr.vetka_otp_id=kls_vetka_otp.id(+)
    	  and sved.prod_id_npr=kls_prod.id_npr(+)
          and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
  		  and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
  		  and reestr.NAKL_ID=nakl.ID(+)
          and sved.MESTO_ID=pMESTO_ID
          and sved.load_type_id=pLOAD_TYPE_ID
          and reestr.NAKL_id is not null -- вагоны из накладных
          and reestr.UVED_id is null -- не входят в уведомление
          and sved.SVED_DATE BETWEEN TRUNC(pUVED_DATE)-1 AND TRUNC(pUVED_DATE)+1 --за период
        ORDER BY
          NVL(ved_pod.POD_DATE,sved.DATE_OFORML),
          NVL(ved_pod_row.POD_POS,0)
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
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,NAKL_NUM,VES_ALL,VES_CIST,VES_UPAK)=
        (SELECT
          KLS_VETKA_OTP.SHORT_NAME as VETKA_OTP_NAME,
    	  ved_pod.POD_NUM,
	      sved.SVED_NUM,
          REESTR.NUM_CIST,
    	  reestr.VES,
          SVED.DATE_OFORML,
          SVED.NOM_ZD,
          KLS_STAN.STAN_NAME,
    	  KLS_PROD.ABBR_NPR as PROD_NAME,
          KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
    	  poluch.SHORT_NAME as PLOUCH_NAME,
		  sved.SVED_DATE,
		  sved.PASP_NUM,
		  KLS_VAG_STATUS.NAME as VAG_STATUS,
          nakl.NAKL_NUM,
		  reestr.VES_ALL,
		  reestr.VES_CIST,
		  reestr.UPAK_VES
        from reestr, sved, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status,nakl
        where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
          and reestr.ved_pod_row_id=ved_pod_row.id(+) 
    	  and ved_pod_row.ved_pod_id=ved_pod.id(+)
          and month.stan_id=kls_stan.id(+)
    	  and month.poluch_id=poluch.id(+)
          and reestr.vetka_otp_id=kls_vetka_otp.id(+)
    	  and sved.prod_id_npr=kls_prod.id_npr(+)
          and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		  and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
		  and reestr.NAKL_ID=nakl.ID(+)
          and reestr.ID=pREESTR_ID)
	  WHERE REESTR_ID=pREESTR_ID
	    AND EXISTS (SELECT NULL FROM reestr WHERE reestr.ID=pREESTR_ID);
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
      UPDATE reestr SET UVED_ID=NULL, UVED_POS=NULL WHERE UVED_ID=pUVED_ID;
      FOR lcur IN (SELECT * FROM TEMP_UVED)
	  LOOP
  	    AddRow(0,lcur.REESTR_ID,pUVED_ID,lcur.UVED_POS);
	  END LOOP;
	END IF;
  END;

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pUVED_NUM NUMBER, pUVED_DATE DATE, pLUKOMA_NUM NUMBER, pCHER_NUM NUMBER, pMPS_NUM NUMBER, pVETL_NUM NUMBER)
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
          RaiseError('Накладную нельзя отредактировать - она удалена!');
		END IF;
	END;

	-- Обновляем документ
	UPDATE UVED SET (UVED_NUM, UVED_DATE, MESTO_ID, LOAD_TYPE_ID, LUKOMA_NUM, MPS_NUM, CHER_NUM, VETL_NUM)=
	  (SELECT pUVED_NUM, pUVED_DATE, pMESTO_ID, pLOAD_TYPE_ID, pLUKOMA_NUM, pMPS_NUM, pCHER_NUM, pVETL_NUM FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем документ
      INSERT INTO UVED (ID,UVED_NUM, UVED_DATE, MESTO_ID, LOAD_TYPE_ID, LUKOMA_NUM, MPS_NUM, CHER_NUM, VETL_NUM)
	  VALUES (vID, pUVED_NUM, pUVED_DATE, pMESTO_ID, pLOAD_TYPE_ID, pLUKOMA_NUM, pMPS_NUM, pCHER_NUM, pVETL_NUM);
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
	vID REESTR.ID%TYPE;
	vADD NUMBER(1);
	vTmp NUMBER;
	vPos NUMBER;
  BEGIN
    vID:=pID;

	-- Проверка существования позиции
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM REESTR
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Позицию нельзя включить в накладную - вагон удален!');
	END;

	vPos:=NVL(pUVED_POS,FOR_UVED.GetMaxNumPos(pUVED_ID));

	-- Обновляем позицию
	UPDATE REESTR SET UVED_ID=pUVED_ID, UVED_POS=vPos WHERE ID=vID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  /* Скопировать позицию НАКЛАДНОЙ в другую НАКЛАДНУЮ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_UVED_ID NUMBER) RETURN NUMBER AS
	vRow REESTR%ROWTYPE;
	vTmp NUMBER;
  BEGIN
    vRow.ID:=NULL;

	-- Считываем запись из накладной
	BEGIN
	  SELECT * INTO vRow
	    FROM REESTR
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
        RaiseError('Накладная в которую переносится отгрузка - удалена!');
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

