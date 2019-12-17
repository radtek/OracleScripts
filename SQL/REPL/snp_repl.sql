CREATE OR REPLACE PACKAGE For_Repl AS


gREPL_NAME CONSTANT VARCHAR2(20):='SNP_REPL';

gRepl_init REPL_INIT%ROWTYPE; -- Настройки репликации текущего узла
gErrApplCode NUMBER;
gErrApplMsg VARCHAR2(500);
gErrOraCode NUMBER;
gErrOraMsg VARCHAR2(500);

/* События со статусом >-100 - не критические */

fr_REPL_OK CONSTANT NUMBER:=1; -- Ошибок нет
fr_REPL_INFO CONSTANT NUMBER:=2; -- Ошибок нет, но нужно записать в лог
fr_REPL_ERROR CONSTANT NUMBER:=-100; -- Критическая ошибка
fr_REPL_ERROR_NON_CRITICAL CONSTANT NUMBER:=-2; -- Не критическая ошибка
fr_REPL_ACTIVE CONSTANT NUMBER:=-101; -- Ошибка при логине пользователем SNP_REPL - такой пользователь уже прилогинился
fr_REPL_INIT CONSTANT NUMBER:=-102;		 -- Ошибка при чтении настроек репликации
fr_REPL_ROW_NOTFOUND CONSTANT NUMBER:=-3; -- Ошибка при построении оператора: в таблице репликации есть строка, для которой нет записи в реплицируемой таблице
fr_REPL_DBLINK_NOTSEND CONSTANT NUMBER:=-104; -- Ошибка передачи операторов через DBLINK
fr_REPL_SQL_EMPTY CONSTANT NUMBER:=-105; -- Сформированный оператор - пустой
fr_REPL_NO_REPL CONSTANT NUMBER:=-106; -- Попытка запуска процедуры репликации не от имени репликатора

fr_CALL_ERR CONSTANT NUMBER:=-110; -- Статус исполнения оператора: ошибка
fr_CALL_NOTSEND CONSTANT NUMBER:=0; -- Статус оператора: подготовлен
fr_CALL_RESEND CONSTANT NUMBER:=1; -- Статус оператора: повтор
fr_CALL_SEND CONSTANT NUMBER:=2; -- Статус оператора: отослан
fr_CALL_WAIT CONSTANT NUMBER:=3; -- Статус оператора: ждет результата предыдущего оператора
fr_CALL_SKIP CONSTANT NUMBER:=100; -- Статус оператора: пропущен на этапе анализа (дублирование)
fr_CALL_OK CONSTANT NUMBER:=101; -- Статус оператора: успешно выполнен
fr_CALL_SKIP_MODE_NODELETE CONSTANT NUMBER:=102; -- Статус оператора: пропущен - режим без удалений (REPL_MODE=0)
fr_CALL_SKIP_MODE_CHECKDATE CONSTANT NUMBER:=103; -- Статус оператора: пропущен - устарел (REPL_MODE=2)
fr_CALL_NO_DATA_FOUND CONSTANT NUMBER:=104; -- При выполнении оператора UPDATE или DELETE - запись не найдена
fr_CALL_USER_DELETED CONSTANT NUMBER:=-111; -- Оператор удален пользователем на текущем узле
fr_CALL_DEST_USER_DELETED CONSTANT NUMBER:=-112; -- Оператор удален пользователем на узле-назначении
fr_CALL_USER_RESTORED CONSTANT NUMBER:=-11; -- Оператор восстановлен пользователем на текущем узле
fr_CALL_DEST_USER_RESTORED CONSTANT NUMBER:=-113; -- Оператор восстановлен пользователем на узле-назначении

fr_REPL_MODE_NODELETE CONSTANT NUMBER:=0; -- Режим репликации - без удалений
fr_REPL_MODE_FULL CONSTANT NUMBER:=1; -- Режим репликации - полный
fr_REPL_MODE_CHECKDATE CONSTANT NUMBER:=2; -- Режим репликации - проверка даты модификации

/* Проверить наличие другой сессии SNP_REPL */
FUNCTION Check_Login(pSessionID NUMBER) RETURN NUMBER ;

/* Удаление записи из REPL_CALL_OUT */
PROCEDURE DeleteCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pSTATUS NUMBER, pDATE_EXEC DATE DEFAULT NULL);

/* Восстановление из архива записи в REPL_CALL_OUT */
PROCEDURE RestoreCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER);

/* Добавление записи в REPL_ANSW */
FUNCTION AddAnswOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,
					pSTATUS NUMBER, pNOTE VARCHAR2) RETURN NUMBER;

/* Удаление записи из REPL_CALL */
PROCEDURE DeleteCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pStatus NUMBER, pDATE_EXEC DATE DEFAULT NULL);

/* Восстановление записи в REPL_CALL */
PROCEDURE RestoreCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER);

/* Обработка входящих ответов поступивших от узла pSITE_DEST_RN на узел pSITE_SOURCE_RN */
FUNCTION Answ_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Исполнение входящих запросов поступивших от узла pSITE_SOURCE_RN на узел pSITE_DEST_RN */
FUNCTION Call_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER;

/* Формирование исходящих запросов с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN по схеме pSCHEMA_RN */
FUNCTION Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER;

/* Анализ исходящих запросов с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN на предмет дублирования
   (с последующим переносом из REPL_CALL_OUT в REPL_CALL) */
FUNCTION Analyze_Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Передача через DBLink с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN исходящих ответов и запросов */
FUNCTION SendDBLink(pSessionID NUMBER,pTYPE VARCHAR2,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pREPL_SCHEMANAME VARCHAR2,pDBLINK VARCHAR2) RETURN NUMBER;

/* Процесс репликации: Обработка входящих ответов */
FUNCTION ExecAnswIn(pSessionID NUMBER) RETURN NUMBER;

/* Процесс репликации: Обработка входящих запросов */
FUNCTION ExecCallIn(pSessionID NUMBER) RETURN NUMBER;

/* Процесс репликации: Формирование исходящих запросов */
FUNCTION ExecCallOut(pSessionID NUMBER)  RETURN NUMBER;

/* Процесс передачи через DBLink */
FUNCTION ExecDBLINK(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Уникальный ID */
FUNCTION GetFileSeq RETURN NUMBER;

/* Начало загрузки настроек репликации */
FUNCTION START_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Завершение загрузки настроек репликации */
FUNCTION FINISH_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Начало выгрузки настроек репликации */
FUNCTION START_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Завершение выгрузки настроек репликации */
FUNCTION FINISH_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Начало выгрузки данных репликации */
FUNCTION START_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Начало выгрузки данных репликации */
FUNCTION START_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Завершение выгрузки данных репликации */
FUNCTION FINISH_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Завершение выгрузки данных репликации */
FUNCTION FINISH_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* Наличие данных для выгрузки */
FUNCTION EXPORT_READY_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Наличие данных для выгрузки */
FUNCTION EXPORT_READY_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* Наличие данных для исполнения */
FUNCTION EXECUTE_READY_CALL(pSessionID NUMBER) RETURN NUMBER;


END;
/

CREATE OR REPLACE PACKAGE BODY For_Repl AS

/* Функция замены одинарных кавычек на двойные */
FUNCTION ReplaceKav (p_str VARCHAR2) RETURN VARCHAR2 AS
BEGIN
  RETURN REPLACE(p_str,'''','"');
END;

/* Проверить наличие другой сессии SNP_REPL */
FUNCTION Check_Login(pSessionID NUMBER) RETURN NUMBER AS
vCnt NUMBER;
BEGIN
  vCnt:=0;
  IF USER<>gREPL_NAME THEN
    RETURN fr_REPL_NO_REPL;
  END IF;
  select COUNT(*) INTO vCnt
    from v_$session
   where AUDSID<>userenv('sessionid')
     and status IN ('ACTIVE','INACTIVE')
     and username=USER;
  IF vCnt=0 THEN
    RETURN fr_REPL_OK;
  ElSE
    RETURN fr_REPL_ACTIVE;
  END IF;
END;

/* Запись в ЛОГ */
PROCEDURE AddLog(pSessionID NUMBER,pSiteRN NUMBER,pCallRN NUMBER,pDateLog DATE,pApplCode NUMBER, pApplMsg VARCHAR2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
i NUMBER;
BEGIN
  gErrApplCode:=pApplCode;
  gErrApplMsg:=ReplaceKav(SUBSTR(pApplMsg,1,500));
  gErrOraCode:=SQLCODE;
  gErrOraMsg:=ReplaceKav(SUBSTR(SQLERRM,1,500));
  i:=FOR_SESSION.WriteToLog(pSessionId,pApplCode,pApplMsg,pSiteRN,'FOR_REPL',pDateLog,pCallRN);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
END;

/* Удаление записи из REPL_CALL_OUT */
PROCEDURE DeleteCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pSTATUS NUMBER, pDATE_EXEC DATE DEFAULT NULL) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  IF pSTATUS=fr_CALL_USER_DELETED THEN
    -- Если оператор удаляется из интерфейса, то нужно удалить
	-- парный оператор также
	BEGIN
	  -- Выясняем подробности об удаляемом операторе
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_OUT
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- Удалять нечего
		RETURN;
	END;
    -- Ищем парный оператор
	IF vOPERATION='D' THEN
	  -- у DELETE нет парных операторов
      vALTER_RN:=0;
	ELSIF vOPERATION='I' THEN
	  -- у INSERT'а есть парный оператор UPDATE
	  vALTER_RN:=vUPDATE_RN;
	ELSIF vOPERATION='U' THEN
	  -- у UPDATE'а есть парный оператор INSERT
	  vALTER_RN:=0;
      BEGIN
	    -- Ищем INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_OUT
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN;
	  EXCEPTION
	    WHEN OTHERS THEN
		  -- Парного нет
		  vALTER_RN:=0;
	  END;
	END IF;
	vALTER_RN:=NVL(vALTER_RN,0);
  END IF;

  IF pSTATUS<>fr_CALL_SKIP THEN
    -- Обновляем статус
    UPDATE /*+ RULE */ REPL_CALL_OUT SET STATUS=pSTATUS
     WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
       AND SITE_DEST_RN=pSITE_DEST_RN
       AND (RN=pCallOutRN OR RN=vALTER_RN);
    -- Переносим в архив
    INSERT INTO REPL_CALL_OUT_HIST (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL_OUT
      WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
        AND SITE_DEST_RN=pSITE_DEST_RN
        AND (RN=pCallOutRN OR RN=vALTER_RN);
  END IF;		

  -- Удаляем
  DELETE /*+ RULE */ FROM REPL_CALL_OUT
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
END;

/* Восстановление записи в REPL_CALL_OUT */
PROCEDURE RestoreCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  -- Если оператор восстанавливается из интерфейса, то нужно восстановить
  -- парный оператор также
  BEGIN
	-- Выясняем подробности о восстанавливаемом операторе
	SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_OUT_HIST
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN;
  EXCEPTION
	WHEN OTHERS THEN
	  -- Восстанавливать нечего
	  RETURN;
  END;
  -- Ищем парный оператор
  IF vOPERATION='D' THEN
    -- у DELETE нет парных операторов
    vALTER_RN:=0;
  ELSIF vOPERATION='I' THEN
    -- у INSERT'а есть парный оператор UPDATE
    vALTER_RN:=vUPDATE_RN;
  ELSIF vOPERATION='U' THEN
    -- у UPDATE'а есть парный оператор INSERT
    vALTER_RN:=0;
    BEGIN
	  -- Ищем INSERT
 	  SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_OUT_HIST
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- Парного нет
	    vALTER_RN:=0;
	END;
  END IF;
  vALTER_RN:=NVL(vALTER_RN,0);
  -- Обновляем статус
  UPDATE /*+ RULE */ REPL_CALL_OUT_HIST SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
  -- Восстанавливаем из архива
  INSERT INTO REPL_CALL_OUT (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
   SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_OUT_HIST
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
      AND SITE_DEST_RN=pSITE_DEST_RN
      AND (RN=pCallOutRN OR RN=vALTER_RN);
  -- Удаляем из архива
  DELETE /*+ RULE */ FROM REPL_CALL_OUT_HIST
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
END;

/* Обработка входящих ответов поступивших от узла pSITE_DEST_RN на узел pSITE_SOURCE_RN */
FUNCTION Answ_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER AS
vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;

  -- Перебираем записи из входящего буфера
  FOR lcur IN (
               SELECT /*+ RULE */ A.*
			   FROM REPL_ANSW A
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
			   ORDER BY A.RN
			  )
  LOOP
    IF lcur.STATUS>=fr_CALL_OK THEN
	  -- Оператор выполнен успешно
	  -- Удаление записи из REPL_CALL_OUT
	  DeleteCallOut(pSessionId,lcur.CALL_OUT_RN,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.STATUS,lcur.DATE_LOG);
    ELSE
	  CASE
	    WHEN lcur.STATUS=fr_CALL_USER_DELETED THEN
		  -- Оператор удален на текущем узле
		  NULL;
	    WHEN lcur.STATUS=fr_CALL_DEST_USER_DELETED THEN
		  -- Оператор удален на узле-назначении
 	      UPDATE REPL_CALL_OUT SET STATUS=lcur.STATUS
	       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	         AND SITE_DEST_RN=pSITE_DEST_RN
		     AND RN=lcur.CALL_OUT_RN;
	    WHEN lcur.STATUS=fr_CALL_USER_RESTORED THEN
		  -- Оператор восстановлен на текущем узле
		  NULL;
	    WHEN lcur.STATUS=fr_CALL_DEST_USER_RESTORED THEN
		  -- Оператор восстановлен на узле-назначении
		  NULL;
		ELSE
 	      -- Обновляем счетчик повторов
	      -- Сбрасываем флаг отправлено
 	      UPDATE REPL_CALL_OUT SET COUNTER=COUNTER+1, STATUS=fr_CALL_RESEND
	       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	         AND SITE_DEST_RN=pSITE_DEST_RN
		     AND RN=lcur.CALL_OUT_RN;
	  END CASE;
      -- В журнал
      AddLog(pSessionId,pSITE_DEST_RN,lcur.CALL_OUT_RN,lcur.DATE_LOG,lcur.STATUS,lcur.NOTE);
      vResult:=fr_REPL_ERROR;
	END IF;

    DELETE FROM REPL_ANSW A
     WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
       AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
	   AND A.RN=lcur.RN;

  END LOOP;
  RETURN vResult;
END;

/* Проверка возможности исполнения оператора */
FUNCTION CheckReplMode (pSessionID NUMBER,pREPL_USERNAME VARCHAR2, pREPL_TABLENAME VARCHAR2,
     pREPL_TABLERN NUMBER, pREPL_MODE NUMBER, pREPL_TABLE VARCHAR2,
	 pOPERATION VARCHAR2, pMODIFDATE DATE, pCALL_RN NUMBER) RETURN NUMBER AS
  vSQLText VARCHAR2(4000);
  vCnt NUMBER;
BEGIN
  IF pREPL_MODE=fr_REPL_MODE_NODELETE AND pOPERATION='D' THEN
    -- Проверяем на возможность удаления
    RETURN fr_CALL_SKIP_MODE_NODELETE;
  END IF;
  IF pREPL_MODE=fr_REPL_MODE_CHECKDATE THEN
    -- Проверяем на наличие более свежих изменений
    BEGIN
	  vSQLText:='SELECT COUNT(*) FROM '||pREPL_TABLE||' WHERE REPL_USERNAME='''||pREPL_USERNAME||''''||
	  ' AND REPL_TABLENAME='''||pREPL_TABLENAME||''''||
	  ' AND REPL_TABLERN='||pREPL_TABLERN||
	  ' AND REPL_MODIFDATE>:MODIFDATE '||
      ' AND REPL_AUTHID<>'''||gRepl_Init.REPL_SCHEMANAME||''''|| -- Исключить модификации, сделанные репликатором
	  ' AND ROWNUM=1 ';
	  EXECUTE IMMEDIATE vSQLText INTO vCnt USING pMODIFDATE;
	  IF vCnt>0 THEN
        RETURN fr_CALL_SKIP_MODE_CHECKDATE;
	  END IF;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- Если ошибка - скорее всего отсутствует таблица репликации
		-- или у нее некорректная структура
		AddLog(pSessionId,gRepl_init.SITE_RN,pCALL_RN,SYSDATE,fr_CALL_ERR,'Ошибка при обращении к таблице '||pREPL_TABLE||': '||SQLERRM);
	END;
  END IF;
  RETURN fr_CALL_OK;
END;

/* Исполнение оператора */
FUNCTION ExecuteSQL(pEXEC_MODE VARCHAR2,pSessionID NUMBER,pOPERATION VARCHAR2,pUSERNAME VARCHAR2,pTABLENAME VARCHAR2,pSQLText VARCHAR2,pCallRN NUMBER) RETURN NUMBER AS
  vSQLText VARCHAR2(8000);
  cur INTEGER; -- Курсор
  vCnt NUMBER;
BEGIN
  IF pOPERATION='I' THEN
    vSQLText:='INSERT INTO '||pUSERNAME||'.'||pTABLENAME;
  ELSE
    IF pOPERATION='U' THEN
      vSQLText:='UPDATE '||pUSERNAME||'.'||pTABLENAME;
	ELSE
      vSQLText:='DELETE FROM '||pUSERNAME||'.'||pTABLENAME;
	END IF;
  END IF;

  SAVEPOINT repl_exec;

  -- Открываем курсор
  cur := DBMS_SQL.OPEN_CURSOR;
  -- парсинг запроса
  DBMS_SQL.PARSE(cur,vSQLText||' '||pSQLText,DBMS_SQL.NATIVE);
  -- исполнение запроса
  vCnt := DBMS_SQL.EXECUTE (cur);
  -- Закрываем курсор
  DBMS_SQL.CLOSE_CURSOR (cur);
  IF vCnt=0 THEN
    RETURN fr_CALL_NO_DATA_FOUND;
  ELSE
    RETURN fr_CALL_OK;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO repl_exec;
	IF pEXEC_MODE<>'NO_ERROR' THEN
  	  AddLog(pSessionId,gRepl_init.SITE_RN,pCallRN,SYSDATE,fr_CALL_ERR,SQLERRM);
	END IF;
    RETURN fr_CALL_ERR;
END;

/* Добавление записи в REPL_ANSW */
FUNCTION AddAnswOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,
					pSTATUS NUMBER, pNOTE VARCHAR2) RETURN NUMBER as
  vRN NUMBER;
BEGIN
  vRN:=GET_SEQ_LOCAL();
  INSERT INTO REPL_ANSW (RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,STATUS,NOTE,DATE_LOG)
	   VALUES(vRN,pSITE_SOURCE_RN,pSITE_DEST_RN,pCallOutRN,pSTATUS,SUBSTR(pNOTE,1,500),SYSDATE);
  RETURN vRN;
END;


/* Удаление записи из REPL_CALL */
PROCEDURE DeleteCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pStatus NUMBER, pDATE_EXEC DATE DEFAULT NULL) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  IF pSTATUS=fr_CALL_USER_DELETED THEN
    -- Если оператор удаляется из интерфейса, то нужно удалить
	-- парный оператор также
	BEGIN
	  -- Выясняем подробности об удаляемом операторе
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN
		 AND ROWNUM=1;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- Удалять нечего
		RETURN;
	END;
    -- Ищем парный оператор
	IF vOPERATION='D' THEN
	  -- у DELETE нет парных операторов
      vALTER_RN:=0;
	ELSIF vOPERATION='I' THEN
	  -- у INSERT'а есть парный оператор UPDATE
	  vALTER_RN:=vUPDATE_RN;
	ELSIF vOPERATION='U' THEN
	  -- у UPDATE'а есть парный оператор INSERT
	  vALTER_RN:=0;
      BEGIN
	    -- Ищем INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN
		   AND ROWNUM=1;
	  EXCEPTION
	    WHEN OTHERS THEN
		  -- Парного нет
		  vALTER_RN:=0;
	  END;
	END IF;
	vALTER_RN:=NVL(vALTER_RN,0);
  END IF;

  IF pStatus<fr_CALL_OK THEN
    -- Обновляем статус
	UPDATE /*+ RULE*/ REPL_CALL SET STATUS=pStatus
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
	UPDATE /*+ RULE*/ REPL_CALL SET STATUS=pStatus
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
    -- Переносим ошибочный оператор
    INSERT INTO REPL_CALL_ERR (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
  	  SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
    INSERT INTO REPL_CALL_ERR (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
  	  SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
  END IF;
  -- Удаляем оператор
  DELETE /*+ RULE */ FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
  DELETE /*+ RULE */ FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
END;

/* Восстановление записи в REPL_CALL */
PROCEDURE RestoreCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  -- Если оператор восстанавливается из интерфейса, то нужно удалить
  -- парный оператор также
  BEGIN
	  -- Выясняем подробности об операторе
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_ERR
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN
		 AND ROWNUM=1;
  EXCEPTION
	  WHEN OTHERS THEN
	    -- Восстанавливать нечего
		RETURN;
  END;
  -- Ищем парный оператор
  IF vOPERATION='D' THEN
	  -- у DELETE нет парных операторов
      vALTER_RN:=0;
  ELSIF vOPERATION='I' THEN
	  -- у INSERT'а есть парный оператор UPDATE
	  vALTER_RN:=vUPDATE_RN;
  ELSIF vOPERATION='U' THEN
	  -- у UPDATE'а есть парный оператор INSERT
    vALTER_RN:=0;
    BEGIN
	    -- Ищем INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_ERR
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN
		   AND ROWNUM=1;
	EXCEPTION
	    WHEN OTHERS THEN
		  -- Парного нет
		  vALTER_RN:=0;
    END;
  END IF;
  vALTER_RN:=NVL(vALTER_RN,0);

  -- Обновляем статус
  UPDATE /*+ RULE */ REPL_CALL_ERR SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND RN=pCallOutRN
	 AND ROWNUM=1;
  UPDATE /*+ RULE */ REPL_CALL_ERR SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND RN=vALTER_RN
	 AND ROWNUM=1;
  -- Переносим ошибочный оператор
  INSERT INTO REPL_CALL (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	 AND ROWNUM=1;
  INSERT INTO REPL_CALL (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	 AND ROWNUM=1;
  -- Удаляем оператор
  DELETE /*+ RULE */ FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	 AND ROWNUM=1;
  DELETE /*+ RULE */ FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	 AND ROWNUM=1;
END;

/* Исполнение одиночного запроса */
FUNCTION OneCallIn (pEXEC_MODE VARCHAR2,pSessionId NUMBER,pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER,
                    pSQL_TEXT VARCHAR2, pRN NUMBER, pREPL_USERNAME VARCHAR2, pREPL_TABLENAME VARCHAR2,
					pUSERNAME VARCHAR2,pTABLENAME VARCHAR2,
                    pTABLERN NUMBER, pREPL_MODE NUMBER, pREPL_TABLE VARCHAR2,
                    pOPERATION VARCHAR2, pMODIFDATE DATE) RETURN NUMBER AS
  vSQLText VARCHAR2(8000);
  vInsertSQLText VARCHAR2(8000);
  vStatusANSW NUMBER;
  vInsertRN NUMBER;
  vInsertSQL1 NUMBER;
  vInsertSQL2 NUMBER;
  vRN NUMBER;
  vNote VARCHAR2(500);
  vInsertNote VARCHAR2(500);
  vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;
  vStatusANSW:=fr_CALL_OK;
  vInsertRN:=0;
  vNote:='';
  vInsertNote:='';
  IF pOPERATION='U' THEN
    -- Если это UPDATE - ищем парный INSERT
	BEGIN
	  SELECT /*+ RULE */ A.RN,A.SQL1_TEXT||A.SQL2_TEXT as SQL_TEXT
		INTO vInsertRN,vInsertSQLText
		FROM REPL_CALL A
        WHERE A.UPDATE_RN=pRN -- по RN UPDATE'а
		  AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
          AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
		  AND A.OPERATION='I';
    EXCEPTION
      WHEN OTHERS THEN
	    vInsertRN:=0;
	END;
  END IF;

  -- Формируем оператор
  vSQLText:=pSQL_TEXT;
  -- Проверяем возможность исполнения
  gErrApplMsg:='';
  vStatusANSW:=CheckReplMode (pSessionId,
                    pREPL_USERNAME, pREPL_TABLENAME,
                    pTABLERN, pREPL_MODE, pREPL_TABLE,
                    pOPERATION, pMODIFDATE, pRN);
  vNote:=gErrApplMsg;
  IF vStatusANSW=fr_CALL_OK THEN
	-- Исполнение
  	gErrApplMsg:='';
	vStatusANSW:=ExecuteSQL(pEXEC_MODE,pSessionId,pOPERATION,pUSERNAME,pTABLENAME,vSQLText,pRN);
    vNote:=gErrApplMsg;
	IF pOPERATION='U' AND vStatusANSW=fr_CALL_NO_DATA_FOUND AND vInsertRN<>0 THEN
	  -- Если UPDDATE не удался из-за отсутствия записи и есть INSERT
      -- Выполняем оператор INSERT
 	  gErrApplMsg:='';
      vStatusANSW:=ExecuteSQL(pEXEC_MODE,pSessionId,'I',pUSERNAME,pTABLENAME,vInsertSQLText,pRN);
	  vInsertNote:=gErrApplMsg;
	END IF;
  END IF;

  -- Формируем ответ на UPDATE или DELETE
  IF vStatusANSW>=fr_CALL_OK THEN
	vNote:='';
	vInsertNote:='';
    IF pEXEC_MODE='NO_ERROR' AND vStatusANSW=fr_CALL_NO_DATA_FOUND THEN
	  vResult:=fr_CALL_NO_DATA_FOUND;
	END IF;
  ELSE
	vResult:=fr_REPL_ERROR;
  END IF;
  -- Если режим "Без ошибок", то подтверждаем и удаляем только успешные
  IF pEXEC_MODE<>'NO_ERROR' OR vResult=fr_REPL_OK THEN
    vRN:=AddAnswOut(pSessionId,pRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,vNote);
    IF vInsertRN<>0 THEN
	  -- Формируем ответ на INSERT
  	  vRN:=AddAnswOut(pSessionId,vInsertRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,vInsertNote);
    END IF;
    -- Удаляем оператор из буфера REPL_CALL
    DeleteCall(pSessionId,pRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,SYSDATE);
    IF vInsertRN<>0 THEN
  	  DeleteCall(pSessionId,vInsertRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,SYSDATE);
    END IF;
  END IF;
--  IF pEXEC_MODE<>'NO_ERROR' THEN
    COMMIT;
--  END IF;
  RETURN vResult;
END;

/* Исполнение входящих запросов поступивших от узла pSITE_SOURCE_RN на узел pSITE_DEST_RN */
FUNCTION Call_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER AS
  vStatus NUMBER;
  vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;
  -- 1-ый проход: без регистрации ошибок, без удаления ошибочных операторов,
  -- без промежуточных COMMIT'ов и в том порядке, в котором операторы
  -- предположительно исполнялись
  -- Цикл, пока хотя-бы 1 успешный оператор
  LOOP
    vResult:=fr_REPL_ERROR; -- Чтобы не зациклится при отсутствии операторов
    FOR lcur IN (
               SELECT /*+ RULE */ A.*, A.SQL1_TEXT ||A.SQL2_TEXT as SQL_TEXT,
			          C.REPL_MODE, C.REPL_TABLE,
					  D.REPL_USERNAME, D.REPL_TABLENAME,
					  D.USERNAME, D.TABLENAME
			   FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
			     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
                 AND A.SITE_DEST_RN=B.SITE_DEST_RN
				 AND A.SCHEMA_RN=B.RN
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_DEST_RN=D.RN -- Таблица на узле-назначении
				 AND A.OPERATION IN ('U','D') -- только DELETE и UPDATE
				 AND B.IS_ACTIVE=1 -- Активная схема
				 AND C.IS_ACTIVE=1 -- Активная строка схема
				 AND A.STATUS>fr_REPL_ERROR -- Контроль статуса
			   ORDER BY A.MODIFDATE,A.REPL_RN
			  )
    LOOP
      vStatus:=OneCallIn ('NO_ERROR',pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,
                    lcur.SQL_TEXT,lcur.RN,lcur.REPL_USERNAME,lcur.REPL_TABLENAME,
                    lcur.USERNAME,lcur.TABLENAME,
                    lcur.TABLERN,lcur.REPL_MODE,lcur.REPL_TABLE,
                    lcur.OPERATION,lcur.MODIFDATE);
	  IF vStatus>fr_REPL_ERROR AND vStatus<>fr_CALL_NO_DATA_FOUND THEN
	    vResult:=fr_REPL_OK;
	  END IF;
    END LOOP;
    EXIT WHEN vResult=fr_REPL_ERROR;
  END LOOP;
  COMMIT;

  vResult:=fr_REPL_OK;
  -- 2-ой проход: с регистрацией ошибок
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, A.SQL1_TEXT ||A.SQL2_TEXT as SQL_TEXT,
			          C.REPL_MODE, C.REPL_TABLE,
					  D.REPL_USERNAME, D.REPL_TABLENAME,
					  D.USERNAME, D.TABLENAME
			   FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
			     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
                 AND A.SITE_DEST_RN=B.SITE_DEST_RN
				 AND A.SCHEMA_RN=B.RN
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_DEST_RN=D.RN -- Таблица на узле-назначении
				 AND A.OPERATION IN ('D','U') -- только DELETE и UPDATE
				 AND B.IS_ACTIVE=1 -- Активная схема
				 AND C.IS_ACTIVE=1 -- Активная строка схема
				 AND A.STATUS>fr_REPL_ERROR -- Контроль статуса
			   ORDER BY B.SORTBY,C.SORTBY,A.TABLERN
			  )
  LOOP
    vStatus:=OneCallIn ('FULL',pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,
                    lcur.SQL_TEXT,lcur.RN,lcur.REPL_USERNAME,lcur.REPL_TABLENAME,
                    lcur.USERNAME,lcur.TABLENAME,
                    lcur.TABLERN,lcur.REPL_MODE,lcur.REPL_TABLE,
                    lcur.OPERATION,lcur.MODIFDATE);
	IF vStatus<=fr_REPL_ERROR THEN
	  vResult:=fr_REPL_ERROR;
	END IF;
	COMMIT;
  END LOOP;

  RETURN vResult;
END;

/* Добавление записи в REPL_CALL_OUT */
FUNCTION AddCallOut(pSessionID NUMBER,pSQLText VARCHAR2,pUpdate_RN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,pSCHEMA_RN NUMBER, pSCHEMAROW_RN NUMBER,
					pTABLERN NUMBER,
			        pReplRN NUMBER,pOperation VARCHAR2,pModifdate DATE) RETURN NUMBER as
  vRN NUMBER;
  vSQL1 VARCHAR2(4000);
  vSQL2 VARCHAR2(4000);
BEGIN
  vSQL1:=SUBSTR(pSQLText,1,4000);
  vSQL2:=SUBSTR(pSQLText,4001,8000);
  IF vSQL1||' '<>' ' THEN
	-- REPL_CALL_OUT
	vRN:=GET_SEQ_LOCAL();
    INSERT INTO REPL_CALL_OUT
	   (RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,
	    REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SQL1_TEXT,SQL2_TEXT)
	  VALUES(
		vRN,pUpdate_RN,pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,pSCHEMAROW_RN,pTABLERN,
			pReplRN,pOperation,pModifdate,1,fr_CALL_NOTSEND,vSQL1,vSQL2);
  ELSE
    vRN:=fr_REPL_SQL_EMPTY;
  END IF;
  RETURN vRN;
END;


/* Формирование исходящих запросов с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN по схеме pSCHEMA_RN */
FUNCTION Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER AS
TYPE ReplCursor_type IS REF CURSOR;
ReplCursor ReplCursor_type;

vReplRN NUMBER; -- RN таблицы репликации
vTableRN NUMBER; -- RN реплицируемой таблицы из таблицы репликации
vOrigRN NUMBER; -- RN реплицируемой таблицы из самой таблицы
vOperation VARCHAR2(1); -- Операция
vModifdate DATE;  -- Дата модификации

cur INTEGER; -- Курсор

f_number NUMBER; -- Поле типа NUMBER
f_varchar2 VARCHAR2(2000); -- Поле типа VARCHAR2
f_date DATE; -- Поле типа DATE

fdbk INTEGER; -- Результат  EXECUTE

vSQLFields VARCHAR2(2000); -- Список реплицируемых полей
vSQLFieldsD VARCHAR2(2000); -- Список реплицируемых полей (с приставкой D.)
vSQLText VARCHAR2(4000); -- Запрос на удаление или обновление
vSQLTextINS VARCHAR2(4000); -- Запрос на добавление
vStatus NUMBER; -- Статус для таблицы REPL_STATUS
vResult NUMBER; -- Результат функции

TYPE Column_rec IS RECORD (
      COLUMN_ID NUMBER,
	  COLUMN_NAME VARCHAR2(30),
      DATA_TYPE VARCHAR2(120),
	  DATA_LENGTH NUMBER
   ); -- Тип: описание поля
TYPE Columns_type IS TABLE OF Column_rec INDEX BY BINARY_INTEGER; -- Тип: список полей
ColList Columns_type; -- Список полей
ColListCount NUMBER; -- Кол-во полей
zpt VARCHAR2(1);
i NUMBER;
s VARCHAR2(4000);
vUpdate_RN NUMBER;
vRN NUMBER;
BEGIN

  vResult:=fr_REPL_OK;

  -- Открываем курсор
  cur := DBMS_SQL.OPEN_CURSOR;

  -- Перебираем таблицы, описанные в схеме репликации
  FOR lcur IN (
               SELECT
			     A.RN as SCHEMAROW_RN,
			     B.REPL_USERNAME, B.REPL_TABLENAME, -- Таблица из таблицы репликации
			     B.USERNAME, B.TABLENAME, -- Таблица/представление, над которой будут выполняться операторы
				 B.RNNAME, -- Имя уникального ID
				 Trim(A.SQL_FIELDS) as SQL_FIELDS, -- Список полей
				 Trim(A.SQL_WHERE) as SQL_WHERE, -- Доп. условие
				 Trim(A.REPL_TABLE) as REPL_TABLE, -- Локальная таблица/представление репликации
				 A.REPL_MODE, -- Режим репликации
				 A.SORTBY -- Порядок
			   FROM REPL_SCHEMA_ROW A, REPL_TABLE B
			   WHERE A.TABLE_SOURCE_RN=B.RN -- Таблица на узле-источнике
			     AND A.IS_ACTIVE=1  -- Активная строка схемы
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- Узел ИСТОЧНИК
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел НАЗНАЧЕНИЕ
                 AND A.SCHEMA_RN=pSCHEMA_RN -- Схема репликации
			   ORDER BY A.SORTBY,B.USERNAME,B.TABLENAME
			  )
  LOOP
    EXIT WHEN vResult<=fr_REPL_ERROR;
    ColListCount:=0;
	vSQLFields:=lcur.SQL_FIELDS;
	-- Если список полей пустой
	if vSQLFields||' ' = ' ' then
	  vSQLFields:='*';
	end if;
	vSQLFields:=','||vSQLFields||',';
	vSQLFields:=NLS_UPPER(Replace(vSQLFields,' ',''));
	-- Проверям наличие поля RN (если нет - добавляем в список полей)
    IF INSTR(vSQLFields,','||lcur.RNNAME||',')<=0 AND vSQLFields<>',*,' THEN
	  vSQLFields:=vSQLFields||lcur.RNNAME||',';
    END IF;

    -- Определяем список полей в виде массива
	FOR cs IN (SELECT C.COLUMN_ID,C.COLUMN_NAME,C.DATA_TYPE, C.DATA_LENGTH
                      FROM SYS.ALL_TAB_COLUMNS C
					 WHERE C.OWNER=lcur.USERNAME
					   AND C.TABLE_NAME=lcur.TABLENAME
                     ORDER BY C.COLUMN_ID)
    LOOP
	  IF INSTR(vSQLFields,','||cs.COLUMN_NAME||',')>0 OR vSQLFields=',*,' THEN
	    ColListCount:=ColListCount+1;
		ColList(ColListCount):=cs;
	  END IF;
	END LOOP;

    -- Определяем список полей в виде строки
	vSQLFields:='';
	vSQLFieldsD:='';
	zpt:='';
	FOR i IN 1..ColListCount LOOP
	  vSQLFields:=vSQLFields||zpt||ColList(i).COLUMN_NAME;
	  vSQLFieldsD:=vSQLFieldsD||zpt||'D.'||ColList(i).COLUMN_NAME;
	  zpt:=',';
	END LOOP;

    -- Строим курсор на выборку данных
    vSQLText:=
        'SELECT /*+ RULE */ A.REPL_RN,A.REPL_TABLERN,A.REPL_OPERATION,A.REPL_MODIFDATE, D.' || lcur.RNNAME ||' as REPL_RN_ORIG, '||vSQLFieldsD;
    vSQLText:=vSQLText || ' FROM ' || lcur.REPL_TABLE || ' A, ';
	vSQLText:=vSQLText || lcur.USERNAME || '.' || lcur.TABLENAME || ' D ' ||
        ' WHERE A.REPL_TABLERN=D.' || lcur.RNNAME || '(+)'||
		'   AND NOT EXISTS (SELECT NULL FROM REPL_STATUS B ' ||
        '                    WHERE B.SITE_SOURCE_RN=' || TO_CHAR(pSITE_SOURCE_RN) ||
        '                      AND B.SITE_DEST_RN=' || TO_CHAR(pSITE_DEST_RN) ||
        '                      AND B.SCHEMA_RN=' || TO_CHAR(pSCHEMA_RN) ||
        '                      AND B.SCHEMAROW_RN=' || TO_CHAR(lcur.SCHEMAROW_RN) ||
        '                      AND B.REPL_RN=A.REPL_RN) ' ||
		'   AND A.REPL_USERNAME='''||lcur.REPL_USERNAME||'''' ||
		'   AND A.REPL_TABLENAME='''||lcur.REPL_TABLENAME||'''' ||
	    '   AND A.REPL_AUTHID<>'''||gRepl_Init.REPL_SCHEMANAME||''''; -- Исключить модификации, сделанные репликатором
	-- Учтем режим репликации
	CASE
	  WHEN lcur.REPL_MODE=0 THEN
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION IN (''I'',''U'')';  -- Только IU
	  WHEN lcur.REPL_MODE=3 THEN
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION = ''D'''; -- Только D
  	  ELSE
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION IN (''I'',''U'',''D'')'; -- Только IUD
	END CASE;
	IF lcur.SQL_WHERE||' '<>' ' THEN
	  vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	END IF;
	vSQLText:=vSQLText||' ORDER BY A.REPL_RN ';

    -- Промежуточная точка отката
    SAVEPOINT repl_pars;

	BEGIN
  	  -- парсинг запроса
      DBMS_SQL.PARSE(cur,vSQLText,DBMS_SQL.NATIVE);

	  -- Определяем поля
	  -- Служебные
      DBMS_SQL.DEFINE_COLUMN (cur, 1, vReplRN);
      DBMS_SQL.DEFINE_COLUMN (cur, 2, vTableRN);
      DBMS_SQL.DEFINE_COLUMN (cur, 3, vOperation, 1);
      DBMS_SQL.DEFINE_COLUMN (cur, 4, vModifdate);
      DBMS_SQL.DEFINE_COLUMN (cur, 5, vOrigRN);

	  -- Данные
	  FOR i IN 1..ColListCount LOOP
	    IF ColList(i).DATA_TYPE='NUMBER' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_number);
	    END IF;
	    IF ColList(i).DATA_TYPE='VARCHAR2' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_varchar2,ColList(i).DATA_LENGTH);
	    END IF;
	    IF ColList(i).DATA_TYPE='DATE' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_date);
	    END IF;
	  END LOOP;

	  -- Осуществляем перебор реплицируемых записей таблицы
      fdbk := DBMS_SQL.EXECUTE (cur);
      LOOP
        EXIT WHEN DBMS_SQL.FETCH_ROWS (cur) = 0;
        EXIT WHEN vResult<=fr_REPL_ERROR;
	    -- Читаем слежебные поля
        DBMS_SQL.COLUMN_VALUE (cur, 1, vReplRN);
        DBMS_SQL.COLUMN_VALUE (cur, 2, vTableRN);
        DBMS_SQL.COLUMN_VALUE (cur, 3, vOperation);
        DBMS_SQL.COLUMN_VALUE (cur, 4, vModifdate);
        DBMS_SQL.COLUMN_VALUE (cur, 5, vOrigRN);

	    vSQLText:='';
	    vStatus:=fr_REPL_OK;
	    -- Читаем поля с данными и формируем оператор
	    IF vOperation='D' THEN
	      -- Удаление
		  vSQLText:='WHERE '||lcur.RNNAME||'='||TO_CHAR(vTableRN);
 	      IF lcur.SQL_WHERE||' '<>' ' THEN
	        vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	      END IF;
		  vSQLTextINS:='';
	    ELSE
	      IF vOrigRN IS NOT NULL THEN
		    vOperation:='U';
  	        -- Обновление или добавление
	  	    -- 1. Запрос на обновление
		    vSqlText:='SET ';
		    -- 2. Запрос на добавление
		    vSqlTextINS:='('||vSQLFields||') VALUES (';
		    zpt:=' ';
		    -- Перебираем поля
  	        FOR i IN 1..ColListCount LOOP
	          IF ColList(i).DATA_TYPE='NUMBER' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_number);
		  	    if f_number IS NULL then
			      s:='NULL';
			    else
			      s:=TO_CHAR(f_number);
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
		      END IF;
  	          IF ColList(i).DATA_TYPE='VARCHAR2' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_varchar2);
			    if f_varchar2 IS NULL then
			      s:='NULL';
			    else
			      s:=Replace(f_varchar2,'''','''''');
			      s:=''''||s||'''';
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
  	          END IF;
 	          IF ColList(i).DATA_TYPE='DATE' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_date);
			    if f_date IS NULL then
			      s:='NULL';
			    else
			      s:='TO_DATE('''||TO_CHAR(f_date,'DD.MM.YYYY HH24:MI:SS')||''',''DD.MM.YYYY HH24:MI:SS'')';
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
	          END IF;
	        END LOOP;
		    -- Завершаем формирование запросов
            vSQLText:=vSQLText||' WHERE '||lcur.RNNAME||'='||TO_CHAR(vTableRN);
		    -- Добавляем в UPDATE доп.условие
 	        IF lcur.SQL_WHERE||' '<>' ' THEN
	          vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	        END IF;
            vSQLTextINS:=vSQLTextINS||')';
		  ELSE
		    -- U или I, а записи нет
		    vStatus:=fr_REPL_ROW_NOTFOUND;
		  END IF;
  	    END IF;

	    -- Промежуточная точка отката
        SAVEPOINT repl_row;

	    -- Заполняем буфер исходящих запросов
	    IF vStatus=fr_REPL_OK then
	      -- Основной запрос
		  vUpdate_RN:=NULL;
		  vUpdate_RN:=AddCallOut(pSessionId,vSQLText,vUpdate_RN,
		                       pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,
							   vTableRN,
			                   vReplRN,vOperation,vModifdate);
	      IF vUpdate_RN<0 THEN
		    vStatus:=vUpdate_RN;
		    vUpdate_RN:=NULL;
		  END IF;
	    END IF;

	    IF vStatus=fr_REPL_OK AND vSQLTextINS||' '<>' ' Then
	      -- Запрос на добавление
		  vRN:=AddCallOut(pSessionId,vSQLTextINS,vUpdate_RN,
		                       pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,
							   vTableRN,
			                   vReplRN,'I',vModifdate);
	    END IF;

	    IF vStatus > fr_REPL_ERROR then
	      -- Запись была отреплицирована удачно
	      -- Добавляем запись в таблицу статусов
		  UPDATE REPL_STATUS SET
		    STATUS=vStatus,TABLERN=vTableRN
		  WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
		    AND SITE_DEST_RN=pSITE_DEST_RN
			AND SCHEMA_RN=pSCHEMA_RN
			AND SCHEMAROW_RN=lcur.SCHEMAROW_RN
			AND REPL_RN=vReplRN;
		  IF SQL%NOTFOUND THEN
  	        vRN:=GET_SEQ_LOCAL();
  		    INSERT INTO REPL_STATUS (RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,REPL_RN,STATUS,TABLERN)
		      VALUES(vRN,pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,vReplRN,vStatus,vTableRN);
		  END IF;
	    ELSE
	      -- Запись была отреплицирована неудачно - нужно слегка откатиться
          ROLLBACK TO repl_row;
		  vResult:=fr_REPL_ERROR;
	    END IF;
      END LOOP;
    EXCEPTION
	  WHEN OTHERS THEN
		ROLLBACK TO repl_pars;
	    vResult:=fr_REPL_ERROR;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при формировании исходящих запросов (REPL_SCHEMA_ROW.RN='||TO_CHAR(lcur.SCHEMAROW_RN)||'): '||SQLERRM);
	END;
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR (cur);

  RETURN vResult;
END;


/* Установить статус записи в REPL_CALL_OUT */
PROCEDURE SetCallOutStatus(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pRN NUMBER,pSTATUS NUMBER) AS
BEGIN
  UPDATE /*+ RULE */ REPL_CALL_OUT SET STATUS=pSTATUS
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
	 AND RN=pRN;
END;


/* Анализ исходящих запросов с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN на предмет дублирования
   (с последующим копированием из REPL_CALL_OUT в REPL_CALL) */
FUNCTION Analyze_Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vLastUserName VARCHAR2(30);
  vLastTableName VARCHAR2(50);
  vLastTableRn NUMBER;
  vLastOperation VARCHAR2(1);
BEGIN

  -- Для всех таблиц
  -- Перебираем НЕ отправленные операторы UPDATE или DELETE в REPL_CALL_OUT 
  -- в обратном порядке (чтобы оставались только последние изменения)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- Не отправленные
				 AND A.OPERATION IN ('U','D') -- Только UPDATE или DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, A.MODIFDATE DESC, A.REPL_RN DESC
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
	   -- Та же запись
	   IF vLastOperation='D' and lcur.OPERATION='D'  THEN
		 -- Если предыдущая операция была удаление,
         -- и текущая - тоже удаление
	     SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
	   ELSE
	     IF vLastOperation = 'U' and lcur.OPERATION='U' THEN
		   -- Если предыдущая операция была обновление,
           -- и текущая - тоже обновление
	       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
		 ELSE
		   -- Предыдущая и текущая операция - разные
	       vLastOperation:=lcur.OPERATION;
		 END IF;
	   END IF;
	ELSE
	   -- Запись изменилась
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
    END IF;
  END LOOP;

  -- Только для DOCLINKS
  -- Перебираем НЕ отправленные операторы UPDATE или DELETE в REPL_CALL_OUT 
  -- с DELETE в начале списка (чтобы исключить INSERT/UPDATE после DELETE)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- Не отправленные
				 AND A.OPERATION IN ('U','D') -- Только UPDATE или DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
				 AND D.REPL_USERNAME='PARUS'
				 AND D.REPL_TABLENAME='DOCLINKS'
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, DECODE(A.OPERATION,'D',0,1)
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
	   -- Та же запись
	   IF vLastOperation='D' THEN
		 -- Если предыдущая операция была удаление,
         -- то все остальные - удаляем
	     SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
	   ELSE
	     IF vLastOperation = 'U' and lcur.OPERATION='U' THEN
		   -- Если предыдущая операция была обновление,
           -- и текущая - тоже обновление
	       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
		 ELSE
		   -- Предыдущая и текущая операция - разные
	       vLastOperation:=lcur.OPERATION;
		 END IF;
	   END IF;
	ELSE
	   -- Запись изменилась
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
    END IF;
  END LOOP;

  -- Определяем для всех оставшихся операторов состояние ожидания 
  -- (прямой порядок перебора - чтобы первый был отправлен, а остальные ждали его результата)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- Не отправленные
				 AND A.OPERATION IN ('U','D') -- Только UPDATE или DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, A.MODIFDATE, A.REPL_RN
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
       -- Все остальные операторы с таким же TABLERN
       -- переводим в состояние ожидания
       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_WAIT);
	ELSE
	   -- Запись изменилась
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
	   IF lcur.STATUS=fr_CALL_WAIT THEN
         -- Если оператор в состоянии ожидания
         -- то переводим его в состояние - к отправке
         SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_NOTSEND);
	   END IF;
    END IF;
  END LOOP;
  
  -- Приводим в соответствие статусы
  UPDATE /*+ RULE */ REPL_CALL_OUT A SET STATUS=
    (SELECT MAX(B.STATUS)
	   FROM REPL_CALL_OUT B
	  WHERE B.RN=A.UPDATE_RN
        AND B.SITE_SOURCE_RN=pSITE_SOURCE_RN
        AND B.SITE_DEST_RN=pSITE_DEST_RN)
   WHERE EXISTS (SELECT NULL
	               FROM REPL_CALL_OUT B
				  WHERE B.RN=A.UPDATE_RN
                    AND B.SITE_SOURCE_RN=pSITE_SOURCE_RN
	                AND B.SITE_DEST_RN=pSITE_DEST_RN)
     AND A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- Не отправленные
     AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
	 AND A.SITE_DEST_RN=pSITE_DEST_RN;

  -- Копируем неотправленные записи из REPL_CALL_OUT в REPL_CALL,
  INSERT INTO REPL_CALL
  SELECT /*+ RULE */ * FROM REPL_CALL_OUT A
   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND) --
     AND A.COUNTER<=2 -- Повторов минимум 2
     AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
	 AND A.SITE_DEST_RN=pSITE_DEST_RN
	 AND NOT EXISTS (  -- которых там еще нет
	    SELECT NULL FROM REPL_CALL B
		 WHERE B.SITE_SOURCE_RN=pSITE_SOURCE_RN
	       AND B.SITE_DEST_RN=pSITE_DEST_RN
		   AND B.RN=A.RN);

  -- Удаляем пропущенные записи
  FOR lcur IN (SELECT /*+ RULE */ * FROM REPL_CALL_OUT
               WHERE STATUS IN (fr_CALL_SKIP) -- Пропущено
                 AND SITE_SOURCE_RN=pSITE_SOURCE_RN
            	 AND SITE_DEST_RN=pSITE_DEST_RN)
  LOOP
--    AddLog(pSessionId,gRepl_init.SITE_RN,lcur.RN,SYSDATE,fr_CALL_SKIP,'Оператор пропущен при анализе и будет удален');
    DeleteCallOut(pSessionId,lcur.RN,pSITE_SOURCE_RN,pSITE_DEST_RN,fr_CALL_SKIP,NULL);
  END LOOP;

  RETURN fr_REPL_OK;
END;

/* Передача через DBLink с узла pSITE_SOURCE_RN на узел pSITE_DEST_RN исходящих ответов и запросов */
FUNCTION SendDBLink(pSessionID NUMBER,pTYPE VARCHAR2, pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pREPL_SCHEMANAME VARCHAR2,pDBLINK VARCHAR2) RETURN NUMBER AS
  SQLText VARCHAR2(4000);
  vStatus NUMBER;
BEGIN
  -- Отправка REPL_ANSW - ответы на входящие запросы
  IF pTYPE='REPL_ANSW' THEN
    BEGIN
	  -- Подготовка к передаче
	  vStatus:=START_EXPORT_ANSW(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN);
      -- Передача
	  IF vStatus>fr_REPL_ERROR THEN
        SQLText:='INSERT INTO '||pREPL_SCHEMANAME||'.REPL_ANSW';
        IF pDBLINK||' '<>' ' THEN
          SQLText:=SQLText||'@'||pDBLINK;
        END IF;
  	    SQLText:=SQLText||' (RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,SENDDATE,STATUS,NOTE,DATE_LOG) ';
        SQLText:=SQLText||' SELECT RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,SYSDATE,STATUS,NOTE,DATE_LOG '||
	    ' FROM REPL_ANSW WHERE SITE_SOURCE_RN='||TO_CHAR(pSITE_SOURCE_RN)||' AND SITE_DEST_RN='||TO_CHAR(pSITE_DEST_RN);
	    EXECUTE IMMEDIATE SQLText;
	    -- Завершение передачи
	    vStatus:=FINISH_EXPORT_ANSW(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN);
	  END IF;
	  IF vStatus<=fr_REPL_ERROR THEN
	    ROLLBACK;
	  END IF;
    EXCEPTION
      WHEN OTHERS THEN
	  BEGIN
        ROLLBACK;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_DBLINK_NOTSEND,'Попытка передачи на узел '||TO_CHAR(pSITE_SOURCE_RN)||' (схема '||pREPL_SCHEMANAME||') через DBLINK='||pDBLINK||': '||SQLERRM);
        RETURN fr_REPL_DBLINK_NOTSEND;
	  END;
    END;
  END IF;

  IF pTYPE='REPL_CALL' THEN
    -- Отправка REPL_CALL - исходящие запросы
    BEGIN
	  -- Перебираем операторы в REPL_CALL (первыми - INSERT)
      FOR lcur IN (SELECT * FROM REPL_CALL
                    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
					  AND SITE_DEST_RN=pSITE_DEST_RN
 	 			    ORDER BY UPDATE_RN NULLS FIRST, RN)
	  LOOP
	    -- Подготовка к передаче
  	    vStatus:=START_EXPORT_CALL(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN);
        -- Передача
		IF vStatus>fr_REPL_ERROR THEN
  	      SQLText:='INSERT INTO '||pREPL_SCHEMANAME||'.REPL_CALL';
          IF pDBLINK||' '<>' ' THEN
            SQLText:=SQLText||'@'||pDBLINK;
          END IF;
	      SQLText:=SQLText||' (RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SENDDATE,SQL1_TEXT,SQL2_TEXT) ';
          SQLText:=SQLText||' SELECT /*+ RULE */ RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SYSDATE,SQL1_TEXT,SQL2_TEXT '||
             ' FROM REPL_CALL WHERE RN='||TO_CHAR(lcur.RN)||' AND SITE_SOURCE_RN='||TO_CHAR(pSITE_SOURCE_RN)||' AND SITE_DEST_RN='||TO_CHAR(pSITE_DEST_RN);
	      EXECUTE IMMEDIATE SQLText;
		  -- Завершение передачи
	      vStatus:=FINISH_EXPORT_CALL(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN);
		END IF;
	    IF vStatus<=fr_REPL_ERROR THEN
	      ROLLBACK;
	    END IF;
	  END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
	  BEGIN
        ROLLBACK;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_DBLINK_NOTSEND,'Попытка передачи на узел '||TO_CHAR(pSITE_DEST_RN)||' (схема '||pREPL_SCHEMANAME||') через DBLINK='||pDBLINK||': '||SQLERRM);
        RETURN fr_REPL_DBLINK_NOTSEND;
	  END;
    END;
  END IF;
  RETURN fr_REPL_OK;
END;

/* Процесс репликации: Обработка входящих ответов */
FUNCTION ExecAnswIn(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- Предполагается что транспортные файлы уже загружены в буфер REPL_ANSW
  -- Либо эти буфер заполнен через DBLink

  -- Определяем текущий узел (1 запись)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'Ошибка при чтении информации о текущем узле:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- Проверяем возможность логина (для исключения двух одновременных репликаций)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' уже запущена');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не имеет права запускать репликацию');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не смогла запускать репликацию: Ошибка при логине');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- ВХОДЯЩИЕ ОТВЕТЫ
  -- Перебираем узлы, с которыми у текущего узла
  -- есть активные связи по ВЫХОДУ (Поскольку ответы на исходящие запросы)
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- Узлы НАЗНАЧЕНИЯ
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- Узел активный
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- Текущий узел: ИСТОЧНИК
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
	BEGIN
  	  vErr:=Answ_In(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при обработке входящих ответов:'||SQLERRM);
	END;
  END LOOP;

  COMMIT;
  RETURN vResult;
END;

/* Процесс репликации: Подготовка к репликации */
PROCEDURE START_REPL(pSessionID NUMBER) AS
BEGIN
  -- Отключаем регистрацию событий для текущей сессии
  parus.pkg_updatelist.drop_register(null,null);

  -- Подготовка списка товарных запасов (для пересчета)
  DELETE FROM SOJ_TMP;

  -- Записи из журнала складских операций (по ВХОДЯЩИМ операторам)
  INSERT INTO SOJ_TMP (SOJ_RN, OPERATION, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ DISTINCT A.TABLERN,A.OPERATION,E.GOODSSUPPLY
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.STOREOPERJOURN E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='STOREOPERJOURN'
	 AND A.TABLERN=E.RN(+);

  -- Записи из товарных запасов (по ВХОДЯЩИМ операторам)
  INSERT INTO SOJ_TMP (SOJ_RN, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0, A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='GOODSSUPPLY';

  -- Подготовка списка товарных запасов (для пересчета остатков по местам хранения)
  DELETE FROM SPOJ_TMP;

  -- Записи из журнала резервирования по местам хранения (по ВХОДЯЩИМ операторам)
  INSERT INTO SPOJ_TMP (SPOJ_RN, OPERATION, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ DISTINCT A.TABLERN,A.OPERATION,E.GOODSSUPPLY
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.STRPLOPRJRNL E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='STRPLOPRJRNL'
	 AND A.TABLERN=E.RN(+);

  -- Записи из товарных запасов (по ВХОДЯЩИМ операторам)
  INSERT INTO SPOJ_TMP (SPOJ_RN, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0, A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='GOODSSUPPLY';

  -- Подготовка списка лицевых счетов (для пересчета)
  DELETE FROM LN_TMP;

  -- Записи из журнала отгрузок (по ВХОДЯЩИМ операторам)
  INSERT INTO LN_TMP (LN_RN, OPERATION, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ A.TABLERN,A.OPERATION,E.FACEACC
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.LIABILITYNOTES E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='LIABILITYNOTES'
	 AND A.TABLERN=E.RN(+);

  -- Записи из журнала платежей (по ВХОДЯЩИМ операторам)
  INSERT INTO LN_TMP (LN_RN, OPERATION, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ A.TABLERN,A.OPERATION,E.FACEACC
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.PAYNOTES E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='PAYNOTES'
	 AND A.TABLERN=E.RN(+);

  -- Записи из лицевых счетов (по ВХОДЯЩИМ операторам)
  INSERT INTO LN_TMP (LN_RN, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0,A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- Входящие запросы
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- Активная схема
	 AND C.IS_ACTIVE=1 -- Активная строка схема
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='FACEACC';

  COMMIT;
END;

/* Процесс репликации: Завершение репликации */
PROCEDURE FINISH_REPL(pSessionID NUMBER) AS
BEGIN
  -- Подготовка списка товарных запасов (для пересчета)
  -- Проставим текущие значения STOREOPERJOURN.GOODSSUPPLY
  UPDATE SOJ_TMP SET (SUPPLY_AFTER)=
  (
    SELECT DISTINCT E.GOODSSUPPLY
      FROM PARUS.STOREOPERJOURN E
     WHERE E.RN=SOJ_TMP.SOJ_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.STOREOPERJOURN E
     WHERE E.RN=SOJ_TMP.SOJ_RN
  );

  COMMIT;

  -- Выполним пересчет товарных запасов
  FOR lcur IN (
               SELECT SUPPLY_BEFORE as GOODSSUPPLY_RN
                 FROM SOJ_TMP
				UNION
               SELECT SUPPLY_AFTER
                 FROM SOJ_TMP
				)
  LOOP
    IF lcur.GOODSSUPPLY_RN IS NOT NULL THEN
      snp_repl.recalc_supply(lcur.GOODSSUPPLY_RN);
	END IF;
  END LOOP;

  -- Подготовка списка товарных запасов (для пересчета остатков по местам хранения)
  -- Проставим текущие значения STRPLOPRJRNL.GOODSSUPPLY
  UPDATE SPOJ_TMP SET (SUPPLY_AFTER)=
  (
    SELECT DISTINCT E.GOODSSUPPLY
      FROM PARUS.STRPLOPRJRNL E
     WHERE E.RN=SPOJ_TMP.SPOJ_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.STRPLOPRJRNL E
     WHERE E.RN=SPOJ_TMP.SPOJ_RN
  );

  COMMIT;

  -- Выполним пересчет товарных запасов по местам хранения
  FOR lcur IN (
               SELECT SUPPLY_BEFORE as GOODSSUPPLY_RN
                 FROM SPOJ_TMP
				UNION
               SELECT SUPPLY_AFTER
                 FROM SPOJ_TMP
				)
  LOOP
    IF lcur.GOODSSUPPLY_RN IS NOT NULL THEN
      snp_repl.recalc_supcellvz(lcur.GOODSSUPPLY_RN);
	END IF;
  END LOOP;

  COMMIT;

  -- Подготовка списка лицевых счетов (для пересчета)
  -- Проставим текущие значения LIABILITYNOTES.FACEACC
  UPDATE LN_TMP SET (FACEACC_AFTER)=
  (
    SELECT DISTINCT E.FACEACC
      FROM PARUS.LIABILITYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.LIABILITYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  );

  -- Проставим текущие значения PAYNOTES.FACEACC
  UPDATE LN_TMP SET (FACEACC_AFTER)=
  (
    SELECT DISTINCT E.FACEACC
      FROM PARUS.PAYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.PAYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  );

  COMMIT;

  -- Выполним пересчет лицевых счетов
  FOR lcur IN (
               SELECT FACEACC_BEFORE as FACEACC_RN
                 FROM LN_TMP
				UNION
               SELECT FACEACC_AFTER
                 FROM LN_TMP
				)
  LOOP
    IF lcur.FACEACC_RN IS NOT NULL THEN
      PARUS.PR_CORR_FACEACC(lcur.FACEACC_RN);
	END IF;
  END LOOP;

  COMMIT;

  -- Включаем регистрацию событий для текущей сессии
  parus.pkg_updatelist.set_register(null,null);

END;

/* Процесс репликации: Обработка входящих запрсов */
FUNCTION ExecCallIn(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- Предполагается что транспортные файлы уже загружены в буфер REPL_CALL
  -- Либо этот буфер заполнен через DBLink

  -- Определяем текущий узел (1 запись)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'Ошибка при чтении информации о текущем узле:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- Проверяем возможность логина (для исключения двух одновременных репликаций)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' уже запущена');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не имеет права запускать репликацию');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не смогла запускать репликацию: Ошибка при логине');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;


  -- Подготовка к репликации
  START_REPL(pSessionId);

  vResult:=fr_REPL_OK;

  -- ВХОДЯЩИЕ ЗАПРОСЫ / ИСХОДЯЩИЕ ОТВЕТЫ
  -- Перебираем узлы, с которыми у текущего узла
  -- есть активные связи по ВХОДУ
  FOR lcur IN (
               SELECT A.RN as SCHEMA_RN, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- Узлы ИСТОЧНИКИ
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_SOURCE_RN=B.RN
				  AND B.IS_ACTIVE=1 -- Узел активный
				  AND A.SITE_DEST_RN=gRepl_init.SITE_RN -- Текущий узел: НАЗНАЧЕНИЕ
				  AND A.IS_ACTIVE=1 -- Связь активна
  			    ORDER BY B.SORTBY,A.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    -- Обработка входящих запросов
    BEGIN
  	  vErr:=Call_In(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.SCHEMA_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
  	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
 	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при обработке входящих запросов (REPL_SCHEMA.RN='||TO_CHAR(lcur.SCHEMA_RN)||'):'||SQLERRM);
	END;
  END LOOP;

  -- Завершение репликации
  FINISH_REPL(pSessionId);

  COMMIT;
  RETURN vResult;
END;

/* Процесс репликации: Формирование исходящих запросов */
FUNCTION ExecCallOut(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- Определяем текущий узел (1 запись)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'Ошибка при чтении информации о текущем узле:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- Проверяем возможность логина (для исключения двух одновременных репликаций)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' уже запущена');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не имеет права запускать репликацию');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не смогла запускать репликацию: Ошибка при логине');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- ИСХОДЯЩИЕ ЗАПРОСЫ
  -- Перебираем узлы, с которыми у текущего узла
  -- есть активные связи по ВЫХОДУ
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- Узлы НАЗНАЧЕНИЯ
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- Узел активный
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- Текущий узел: ИСТОЧНИК
				  AND A.IS_ACTIVE=1 -- Связь активна
  			    ORDER BY B.SORTBY
				)
  LOOP
    -- Формирование исходящих запросов по одному узлу - в одной транзакции
    SET TRANSACTION READ WRITE;
    -- Перебираем активные схемы репликации
    FOR lcur2 IN (
               SELECT DISTINCT A.SORTBY, A.RN as SCHEMA_RN -- Схема репликации
                 FROM REPL_SCHEMA A
                WHERE A.SITE_DEST_RN=lcur.SITE_DEST_RN -- Узлы НАЗНАЧЕНИЯ
				  AND A.SITE_SOURCE_RN=lcur.SITE_SOURCE_RN -- Текущий узел: ИСТОЧНИК
				  AND A.IS_ACTIVE=1 -- Связь активна
  			    ORDER BY A.SORTBY
				)
	LOOP
      SAVEPOINT repl_out; -- Промежуточная точка отката
      BEGIN
  	    vErr:=Call_Out(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN, lcur2.SCHEMA_RN);
	    IF vErr<=fr_REPL_ERROR THEN
	      vResult:=vErr;
	    END IF;
      EXCEPTION
	    WHEN OTHERS THEN
		  ROLLBACK TO repl_out; -- Откатимся на промежуточную точку
 	      vResult:=fr_REPL_ERROR;
 		  AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при формировании исходящих запросов (REPL_SCHEMA.RN='||TO_CHAR(lcur2.SCHEMA_RN)||'):'||SQLERRM);
      END;
	END LOOP;
	-- Завершаем транзакцию
    COMMIT;

	-- Анализ исходящих ответов
    SET TRANSACTION READ WRITE;
    BEGIN
	  vErr:=Analyze_Call_Out(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при анализе исходящих запросов:'||SQLERRM);
    END;
    COMMIT;
  END LOOP;

  COMMIT;
  RETURN vResult;
END;

/* Процесс передачи через DBLink */
FUNCTION ExecDBLINK(pSessionID NUMBER, pSITE_DEST_RN NUMBER)  RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- Предполагается что транспортные файлы уже загружены в буфера REPL_ANSW и REPL_CALL
  -- Либо эти буфера заполнены через DBLink

  -- Определяем текущий узел (1 запись)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'Ошибка при чтении информации о текущем узле:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- Проверяем возможность логина (для исключения двух одновременных репликаций)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' уже запущена');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не имеет права запускать репликацию');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Сессия '||USER||' не смогла запускать репликацию: Ошибка при логине');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- Передаем через DBLINK
  -- ИСХОДЯЩИЕ ОТВЕТЫ
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN, C.REPL_SCHEMANAME,C.DBLINK -- Узлы ИСТОЧНИКИ
                 FROM REPL_SCHEMA A,REPL_SITE B, REPL_INIT C
                WHERE A.SITE_SOURCE_RN=B.RN
				  AND B.IS_ACTIVE=1 -- Узел активный
				  AND A.SITE_SOURCE_RN=pSITE_DEST_RN -- Узел источник
				  AND A.SITE_DEST_RN=gRepl_init.SITE_RN -- Текущий узел: НАЗНАЧЕНИЕ
				  AND A.IS_ACTIVE=1 -- Связь активна
				  AND A.SITE_SOURCE_RN=C.SITE_RN
				  AND C.USE_DBLINK=1
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    BEGIN
      vErr:=SendDBLink(pSessionId,'REPL_ANSW',lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.REPL_SCHEMANAME,lcur.DBLINK);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
  	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'Ошибка при отправке через DBLINK исходящих ответов:'||SQLERRM);
    END;
  END LOOP;

  -- ИСХОДЯЩИЕ ЗАПРОСЫ
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN, C.REPL_SCHEMANAME,C.DBLINK -- Узлы НАЗНАЧЕНИЯ
                 FROM REPL_SCHEMA A,REPL_SITE B, REPL_INIT C
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- Узел активный
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- Текущий узел: ИСТОЧНИК
				  AND A.SITE_DEST_RN=pSITE_DEST_RN -- Узел-назначение
				  AND A.IS_ACTIVE=1 -- Связь активна
				  AND A.SITE_DEST_RN=C.SITE_RN
				  AND C.USE_DBLINK=1
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    BEGIN
      vErr:=SendDBLink(pSessionId,'REPL_CALL',lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.REPL_SCHEMANAME,lcur.DBLINK);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
    EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,VResult,'Ошибка при отправке через DBLINK исходящих запросов:'||SQLERRM);
	END;
  END LOOP;

  -- Завершаем транзакцию
  COMMIT;
  RETURN vResult;
END;

/* Уникальный ID */
FUNCTION GetFileSeq RETURN NUMBER AS
Res NUMBER;
BEGIN
  SELECT SEQ_FILE_LOCAL.nextval INTO Res FROM DUAL;
  RETURN Res;
END;

/* Начало загрузки настроек репликации */
FUNCTION START_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
BEGIN
  -- Отключение констрейнов и триггеров
  -- REPL_SCHEMA_ROW
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT REPL_SCHEMAROW_TABLE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT REPL_SCHEMAROW_TABLE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT SCHEMA_ROW_REPL_SCHEMA_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA_ROW DISABLE';

  -- REPL_SCHEMA
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA DISABLE CONSTRAINT SCHEMA_REPL_SITE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA DISABLE CONSTRAINT SCHEMA_REPL_SITE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA DISABLE';

  -- REPL_SITE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SITE DISABLE';

  -- REPL_TABLE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_TABLE DISABLE';

  -- Очистка таблиц
  DELETE FROM KLS_REPL_MODE;
  DELETE FROM KLS_EVENTS;
  DELETE FROM KLS_STATUS;
  DELETE FROM REPL_SCHEMA_ROW;
  DELETE FROM REPL_SCHEMA;
  DELETE FROM REPL_SITE;
  DELETE FROM REPL_TABLE;
  DELETE FROM CATALOG_LIST;
  DELETE FROM FCACGR_LIST;
  DELETE FROM STORE_LIST;

  COMMIT;
  RETURN fr_REPL_OK;
EXCEPTION
  WHEN OTHERS THEN
    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_ERROR,'Ошибка при подготовке к загрузке настроек репликации: '||SQLERRM);
    ROLLBACK;
    RETURN fr_REPL_ERROR;
END;

/* Завершение загрузки настроек репликации */
FUNCTION FINISH_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
BEGIN
  -- Включение констрейнов и триггеров
  -- REPL_SCHEMA_ROW
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT REPL_SCHEMAROW_TABLE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT REPL_SCHEMAROW_TABLE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT SCHEMA_ROW_REPL_SCHEMA_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA_ROW ENABLE';

  -- REPL_SCHEMA
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA ENABLE CONSTRAINT SCHEMA_REPL_SITE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA ENABLE CONSTRAINT SCHEMA_REPL_SITE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA ENABLE';

  -- REPL_SITE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SITE ENABLE';

  -- REPL_TABLE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_TABLE ENABLE';

  COMMIT;
  RETURN fr_REPL_OK;
EXCEPTION
  WHEN OTHERS THEN
    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_ERROR,'Ошибка при завершении загрузки настроек репликации: '||SQLERRM);
    ROLLBACK;
    RETURN fr_REPL_ERROR;
END;

/* Начало выгрузки настроек репликации */
FUNCTION START_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Завершение выгрузки настроек репликации */
FUNCTION FINISH_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Начало выгрузки данных репликации */
FUNCTION START_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  UPDATE /*+ RULE */ REPl_ANSW SET SENDDATE=SYSDATE, FILENAME=pFILENAME
	 WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Начало выгрузки данных репликации */
FUNCTION START_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  UPDATE /*+ RULE */ REPl_CALL_OUT SET STATUS=fr_CALL_SEND, SENDDATE=SYSDATE, FILENAME=pFILENAME
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0)
	 AND EXISTS (
           SELECT NULL FROM REPl_CALL
	        WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0)
			  AND RN=REPL_CALL_OUT.RN
			  );

  UPDATE /*+ RULE */ REPl_CALL SET STATUS=fr_CALL_SEND, SENDDATE=SYSDATE, FILENAME=pFILENAME
	 WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);

  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Завершение выгрузки данных репликации */
FUNCTION FINISH_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  DELETE FROM /*+ RULE*/ REPL_ANSW
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Завершение выгрузки данных репликации */
FUNCTION FINISH_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  DELETE FROM /*+ RULE*/ REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* Наличие данных для выгрузки */
FUNCTION EXPORT_READY_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vCnt NUMBER;
BEGIN
  vCnt:=0;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
	FROM REPl_ANSW
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN;
  EXCEPTION
    WHEN OTHERS THEN
      vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

/* Наличие данных для выгрузки */
FUNCTION EXPORT_READY_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vCnt NUMBER;
BEGIN
  vCnt:=0;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
    FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN
	  AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
	  vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

/* Наличие данных для исполнения */
FUNCTION EXECUTE_READY_CALL(pSessionID NUMBER) RETURN NUMBER AS
vCnt NUMBER;
BEGIN
  vCnt:=0;
  -- Определяем текущий узел (1 запись)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'Ошибка при чтении информации о текущем узле:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
    FROM REPL_CALL
    WHERE SITE_DEST_RN=gRepl_init.SITE_RN
	  AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
	  vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

END;
/
