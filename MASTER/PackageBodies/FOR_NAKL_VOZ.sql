--
-- FOR_NAKL_VOZ  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_NAKL_VOZ
AS

/* НАКЛАДНЫЕ */

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;

  -- Максимальный номер позиции ДОКУМЕНТА
  FUNCTION GetMaxNumPos(pNAKL_ID NUMBER) RETURN NUMBER AS
    MaxNum REESTR_IN.NAKL_POS%TYPE;
    CurNum REESTR_IN.NAKL_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(REESTR_IN.NAKL_POS) as MAX_NUM
                 FROM REESTR_IN
				WHERE NAKL_ID=pNAKL_ID)
    LOOP
      CurNum:=NVL(lcur.MAX_NUM,0);
	  EXIT;
    END LOOP;
	MaxNum:=CurNum+1;
    RETURN MaxNum;
  END;

  -- Максимальный номер позиции в таблице TEMP_NAKL
  FUNCTION GetTempMaxNumPos RETURN NUMBER AS
    MaxNum TEMP_NAKL.NAKL_POS%TYPE;
    CurNum TEMP_NAKL.NAKL_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(NAKL_POS) as MAX_NUM
                 FROM TEMP_NAKL)
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
    UPDATE REESTR_IN SET NAKL_ID=NULL, NAKL_POS=NULL WHERE ID=pID;
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
	SELECT COUNT(*) INTO vCNT FROM REESTR_IN WHERE NAKL_ID=pID;
	IF vCNT>0 THEN
      RaiseError('Накладную нельзя удалить - есть позиции!');
	END IF;

    DELETE FROM NAKL WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* Очистить временную таблицу TEMP_NAKL */
  PROCEDURE EMPTY_TEMP_NAKL AS
  BEGIN
    DELETE TEMP_NAKL;
  END;

  /* Первоначальное заполнение временной таблицы TEMP_NAKL */
  PROCEDURE FILL_TEMP_NAKL (pNAKL_ID NUMBER, pSRC_REESTR_ID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER) AS
    vRow REESTR_IN%ROWTYPE;
    vSved SVED_IN%ROWTYPE;
  BEGIN
    EMPTY_TEMP_NAKL;

	IF NVL(pNAKL_ID,0)<>0 THEN
	  -- Если редактирование накладной
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID, SVED_NUM,  NUM_CIST, DATE_OFORML,
 	    VAGOWNER_NAME, SVED_DATE,VES_CIST)
      SELECT
	    reestr_in.NAKL_POS,
  	    reestr_in.ID as REESTR_ID,
	    sved_in.SVED_NUM,
        REESTR_in.NUM_CIST,
        SVED_IN.DATE_OFORML,
        KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
		sved_in.SVED_DATE,
		reestr_in.VES_CIST
      from reestr_in, sved_in, KLS_VAGOWNER
      where reestr_in.sved_in_id=sved_in.id 
        and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
        and reestr_in.nakl_id=pNAKL_ID
      ORDER BY
        reestr_in.NAKL_POS, reestr_in.ID;
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
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID, SVED_NUM,  NUM_CIST, DATE_OFORML,
 	    VAGOWNER_NAME, SVED_DATE,VES_CIST)
      SELECT
 	    ROWNUM as NAKL_POS,
        REESTR_ID,
        SVED_NUM,
        NUM_CIST,
        DATE_OFORML,
        VAGOWNER_NAME,
		SVED_DATE,
		VES_CIST
      FROM
        (
        SELECT /*+ ordered */
	      reestr_in.ID as REESTR_ID,
	      sved_in.SVED_NUM,
          REESTR_in.NUM_CIST,
          SVED_in.DATE_OFORML,
          KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
		  sved_in.SVED_DATE,
		  reestr_in.VES_CIST
        from reestr_in, sved_in, KLS_VAGOWNER
        where reestr_in.sved_in_id=sved_in.id  
          and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
          and sved_in.MESTO_ID=pMESTO_ID
          and sved_in.PROD_ID_NPR=vSved.PROD_ID_NPR -- тот же продукт, что и в эталонном сведении
          and reestr_in.nakl_id is null -- не включен в накладную
		  and reestr_in.plomba1||' '<>' ' -- если введена пломба 1
          and sved_in.SVED_DATE BETWEEN vSved.SVED_DATE-1 AND vSved.SVED_DATE+1
        ORDER BY
          sved_in.SVED_DATE,
          sved_in.SVED_NUM,
          reestr_in.SVED_POS
        );
	END IF;
  END;

  /* Добавить запись в таблицу TEMP_NAKL */
  PROCEDURE ADD_TEMP_NAKL (pREESTR_ID NUMBER) AS
  BEGIN
    IF NVL(pREESTR_ID,0)<>0 THEN
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID) VALUES (GetTempMaxNumPos, pREESTR_ID);

  	  UPDATE TEMP_NAKL
	  SET (SVED_NUM,  NUM_CIST, DATE_OFORML,
 	    VAGOWNER_NAME,SVED_DATE,VES_CIST)=
        (SELECT
	      sved_in.SVED_NUM,
          REESTR_in.NUM_CIST,
          SVED_in.DATE_OFORML,
          KLS_VAGOWNER.DISPLAY_NAME as VAGOWNER_NAME,
		  sved_in.SVED_DATE,
		  reestr_in.VES_CIST
        from reestr_in, sved_in, KLS_VAGOWNER
        where reestr_in.sved_in_id=sved_in.id 
          and reestr_in.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
          and reestr_in.ID=pREESTR_ID)
	  WHERE REESTR_ID=pREESTR_ID
	    AND EXISTS (SELECT NULL FROM reestr_in WHERE reestr_in.ID=pREESTR_ID);
	END IF;
  END;

  /* Добавить запись в таблицу TEMP_NAKL */
  PROCEDURE DEL_TEMP_NAKL (pREESTR_ID NUMBER) AS
  BEGIN
	DELETE FROM TEMP_NAKL WHERE REESTR_ID=pREESTR_ID;
	COMMIT;
  END;


  /* Перенести позиции из TEMP_NAKL в REESTR_IN */
  PROCEDURE SAVE_TEMP_NAKL (pNAKL_ID NUMBER) AS
    vTmp NUMBER;
  BEGIN
    IF NVL(pNAKL_ID,0)<>0 THEN
      UPDATE reestr_in SET NAKL_ID=NULL, NAKL_POS=NULL WHERE NAKL_ID=pNAKL_ID;
      FOR lcur IN (SELECT * FROM TEMP_NAKL)
	  LOOP
  	    AddRow(0,lcur.REESTR_ID,pNAKL_ID,lcur.NAKL_POS);
	  END LOOP;
	END IF;
  END;

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pNAKL_NUM NUMBER, pNAKL_DATE DATE, pFORMNAKL_ID NUMBER,pSHABVOZ_ID NUMBER, pOPERNALIV_ID NUMBER, pPROD_ID_NPR VARCHAR2 DEFAULT NULL)
    RETURN NUMBER AS

	vID NAKL.ID%TYPE;
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
	 	FROM NAKL
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Накладную нельзя отредактировать - она удалена!');
		END IF;
	END;

	-- Обновляем документ
	UPDATE NAKL SET (NAKL_NUM, NAKL_DATE, MESTO_ID, LOAD_TYPE_ID, FORMNAKL_ID,SHABVOZ_ID, OPERNALIV_ID, PROD_ID_NPR)=
	  (SELECT pNAKL_NUM, pNAKL_DATE, pMESTO_ID, pLOAD_TYPE_ID, pFORMNAKL_ID,pSHABVOZ_ID, pOPERNALIV_ID, pPROD_ID_NPR FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем документ
      INSERT INTO NAKL (ID,NAKL_NUM, NAKL_DATE, MESTO_ID, LOAD_TYPE_ID, FORMNAKL_ID,SHABVOZ_ID, OPERNALIV_ID, PROD_ID_NPR)
	  VALUES (vID, pNAKL_NUM, pNAKL_DATE, pMESTO_ID, pLOAD_TYPE_ID, pFORMNAKL_ID,pSHABVOZ_ID, pOPERNALIV_ID, pPROD_ID_NPR);
	END IF;

	-- Сохранение позиций из временной таблицы TEMP_NAKL
	SAVE_TEMP_NAKL(vID);

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* Добавить/Изменить позицию ДОКУМЕНТА */
  PROCEDURE AddRow(pCOMMIT NUMBER, pID NUMBER, pNAKL_ID NUMBER, pNAKL_POS NUMBER) AS
	vID REESTR_in.ID%TYPE;
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
        RaiseError('Позицию нельзя включить в накладную - вагон удален!');
	END;

	vPos:=NVL(pNAKL_POS,FOR_NAKL.GetMaxNumPos(pNAKL_ID));

	-- Обновляем позицию
	UPDATE REESTR_IN SET NAKL_ID=pNAKL_ID, NAKL_POS=vPos WHERE ID=vID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  /* Скопировать позицию НАКЛАДНОЙ в другую НАКЛАДНУЮ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_NAKL_ID NUMBER) RETURN NUMBER AS
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
	 	FROM NAKL
	   WHERE ID=pNEW_NAKL_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Накладная в которую переносится отгрузка - удалена!');
	END;

    -- Переносим вагон из накладной в накладную
	AddRow(0,vRow.ID,pNEW_NAKL_ID,NULL);

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vRow.ID;
  END;

FUNCTION AddShabVoz(pCommit NUMBER,pId NUMBER,pStanotp_id NUMBER,pTex_pd_id NUMBER,pGrotp_id NUMBER,
		  			 pStan_id NUMBER,pVetka_id NUMBER,pPoluch_id NUMBER,pFlg_forma_2 NUMBER,
		   					 pProd_id_npr VARCHAR2,pPrim VARCHAR2,pGr4 VARCHAR2,pK_tar VARCHAR2,pInput_date DATE,
							 pTransport VARCHAR2,pIs_exp NUMBER,pExped_id NUMBER,pGu12_a_id NUMBER,pVzisk_id NUMBER,
							 pGrotp_bank VARCHAR2,pGrotp_rs VARCHAR2,pTex_pd_bank VARCHAR2,pTtex_pd_rs VARCHAR2,pShab_num NUMBER,
							 pShab_date DATE) RETURN NUMBER 
AS
vID KLS_SHABVOZ.ID%TYPE;
vTmp NUMBER;
vAdd NUMBER;
BEGIN
    -- ID
	IF pID||' '=' ' OR pID IS NULL THEN
	  vADD:=1;
      SELECT SEQ_SHAB_VOZ.nextval INTO vTmp FROM DUAL;
	  vID:=vTmp;	  
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ ID
        INTO vTmp
	 	FROM kls_shabvoz
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Шаблон нельзя отредактировать - он удален!');
		END IF;
	END;

	-- Обновляем 
	UPDATE KLS_SHABVOZ SET (id,stanotp_id,tex_pd_id,grotp_id,stan_id,vetka_id,poluch_id,flg_forma_2,
		   					 prod_id_npr,prim,gr4,k_tar,input_date,transport,is_exp,exped_id,gu12_a_id,
							 vzisk_id,grotp_bank,grotp_rs,tex_pd_bank,tex_pd_rs,shab_num,shab_date)=
	  (SELECT vId,pStanotp_id,pTex_pd_id,pGrotp_id,pStan_id,pVetka_id,pPoluch_id,pFlg_forma_2,pProd_id_npr,
	  		  pPrim,pGr4,pK_tar,pInput_date,pTransport,pIs_exp,pExped_id,pGu12_a_id,pVzisk_id,pGrotp_bank,pGrotp_rs,
			  pTex_pd_bank,pTtex_pd_rs,pShab_num,pShab_date FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем 
      INSERT INTO KLS_SHABVOZ (Id,stanotp_id,tex_pd_id,grotp_id,stan_id,vetka_id,poluch_id,flg_forma_2,
		   					 prod_id_npr,prim,gr4,k_tar,input_date,transport,is_exp,exped_id,gu12_a_id,
							 vzisk_id,grotp_bank,grotp_rs,tex_pd_bank,tex_pd_rs,shab_num,shab_date)
	  VALUES (vId,pStanotp_id,pTex_pd_id,pGrotp_id,pStan_id,pVetka_id,pPoluch_id,pFlg_forma_2,pProd_id_npr,
	  		  pPrim,pGr4,pK_tar,pInput_date,pTransport,pIs_exp,pExped_id,pGu12_a_id,pVzisk_id,pGrotp_bank,pGrotp_rs,
			  pTex_pd_bank,pTtex_pd_rs,pShab_num,pShab_date);
	END IF;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
END;
						
FUNCTION get_next_num RETURN NUMBER
AS
res NUMBER;
BEGIN
	 select SEQ_SHABVOZ_NUM.nextval into res from dual;
	 return res;
END;

END;
/

