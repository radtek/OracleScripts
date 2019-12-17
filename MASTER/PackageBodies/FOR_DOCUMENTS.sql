--
-- FOR_DOCUMENTS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_Documents AS

-- Ошибка
PROCEDURE RaiseError (pText VARCHAR2) AS
BEGIN
  ROLLBACK;
  RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
END;

-- Найти документ по реквизитам (ID<>pDocId)
-- Возвращаемое значение:
-- 				>0 - Номер найденного документа
--				0 - не существует
-- 				<0 - Ошибка
FUNCTION CHECK_EXIST(pDocType NUMBER, pMestoId NUMBER, pDocId VARCHAR2, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE) RETURN NUMBER AS
res NUMBER;
vFIELD_PREFIX VARCHAR2(50);
vFIELD_NUM VARCHAR2(50);
vFIELD_DATE VARCHAR2(50);
vFIELD_ID VARCHAR2(50);
vFIELD_ID_TYPE VARCHAR2(50);
vTABLENAME VARCHAR2(50);
vFIELD_MESTO VARCHAR2(50);
vAND VARCHAR2(10);
vSQL VARCHAR2(4000);
cur INTEGER; -- Курсор
fdbk INTEGER; -- Результат  EXECUTE
BEGIN
  res:=FOR_SCRIPTS.SG$NO_ROW;
  FOR lcur IN (SELECT a.DOC_RULE_ID, a.FROM_DATE, a.TO_DATE,
                      b.FIELD_NUM, b.FIELD_DATE, b.FIELD_PREFIX, b.FIELD_ID,
					  b.TABLENAME, b.FIELD_MESTO, b.FIELD_ID_TYPE
               FROM KLS_DOC_NUMS a, KLS_DOC_TYPES b
			   WHERE a.DOC_TYPE_ID=b.ID AND a.DOC_TYPE_ID=pDocType
			     AND a.MESTO_ID=pMestoId AND a.DOC_PREFIX||' '=pDocPrefix||' '
			     AND (a.DOC_RULE_ID<>2 OR pDocDate BETWEEN a.FROM_DATE AND a.TO_DATE)
			   )
  LOOP
    -- Описание данного типа документа для указанного места оформления найдено

	-- Подготовим запрос на поиск документа
	vFIELD_ID:=NLS_UPPER(lcur.FIELD_ID);
	vFIELD_ID_TYPE:=NLS_UPPER(lcur.FIELD_ID_TYPE);
	vFIELD_NUM:=NLS_UPPER(lcur.FIELD_NUM);
	vFIELD_DATE:=NLS_UPPER(lcur.FIELD_DATE);
	vFIELD_PREFIX:=NLS_UPPER(lcur.FIELD_PREFIX);
	vFIELD_MESTO:=NLS_UPPER(lcur.FIELD_MESTO);
	vTABLENAME:=NLS_UPPER(lcur.TABLENAME);

	vSQL:='SELECT /*+ RULE */ '||vFIELD_NUM||' as DOC_NUM FROM '||vTABLENAME;
	vAND:=' WHERE ';

	IF vFIELD_ID||' '<>' ' THEN
	  IF vFIELD_ID_TYPE='NUMBER' THEN
	    IF NVL(TO_NUMBER(pDocId),0)<>0 THEN
          vSQL:=vSQL||vAND||vFIELD_ID||'<>'||pDocId;
          vAND:=' AND ';
	    END IF;
	  END IF;
	  IF vFIELD_ID_TYPE='VARCHAR2' THEN
	    IF pDocId||' '<>' ' THEN
          vSQL:=vSQL||vAND||vFIELD_ID||'<>'''||pDocId||'''';
          vAND:=' AND ';
	    END IF;
	  END IF;
	END IF;
	IF vFIELD_NUM||' '<>' ' THEN
      vSQL:=vSQL||vAND||vFIELD_NUM||'='||TO_CHAR(pDocNum);
      vAND:=' AND ';
	END IF;
    IF vFIELD_MESTO||' '<>' ' THEN
	  vSQL:=vSQL||vAND||vFIELD_MESTO||'='||TO_CHAR(pMestoId);
      vAND:=' AND ';
	END IF;
	IF lcur.DOC_RULE_ID=2 AND vFIELD_DATE||' '<>' ' THEN
	  vSQL:=vSQL||vAND||'('||vFIELD_DATE||' BETWEEN TO_DATE('''||TO_CHAR(lcur.FROM_DATE,'dd.mm.yyyy')||''',''dd.mm.yyyy'') AND TO_DATE('''||TO_CHAR(lcur.TO_DATE,'dd.mm.yyyy')||''',''dd.mm.yyyy'') )';
      vAND:=' AND ';
	END IF;
	IF vFIELD_PREFIX||' '<>' ' THEN
	  vSQL:=vSQL||vAND||vFIELD_PREFIX||'||'' ''='''||TO_CHAR(pDocPrefix)||' ''';
      vAND:=' AND ';
	END IF;

    -- Проверяем наличие документа с аналогичными реквизитами
    -- Открываем курсор
    cur := DBMS_SQL.OPEN_CURSOR;
    -- парсинг запроса
    DBMS_SQL.PARSE(cur,vSQL,DBMS_SQL.NATIVE);
    -- Определяем поля
    DBMS_SQL.DEFINE_COLUMN (cur, 1, res);
    -- Осуществляем перебор записей
	res:=0;
    fdbk := DBMS_SQL.EXECUTE (cur);
    LOOP
      EXIT WHEN DBMS_SQL.FETCH_ROWS (cur) = 0;
	  -- Читаем поле
      DBMS_SQL.COLUMN_VALUE (cur, 1, res);
	  res:=NVL(res,0);
	  EXIT;
  	END LOOP;
  	-- закрываем запрос
    DBMS_SQL.CLOSE_CURSOR (cur);
    EXIT;
  END LOOP;

  RETURN res;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FOR_SCRIPTS.SG$ERROR;
END;


-- Проверить номер документа в списках на резервирование других пользователей
-- Возвращаемое значение:
-- 				1 - уже существует
--				0 - не существует
-- 				<0 - Ошибка
FUNCTION CHECK_RESERV(pDocType NUMBER, pMestoId NUMBER, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE) RETURN NUMBER AS
BEGIN
  FOR lcur IN (SELECT 1 as IS_EXIST
               FROM KLS_DOC_RESERV a, KLS_DOC_NUMS b
			   WHERE a.DOC_TYPE_ID=pDocType AND a.MESTO_ID=pMestoId
			     AND a.NEXT_DOC_NUM=pDocNum AND (a.DOC_PREFIX||' '=pDocPrefix||' ')
			     AND (b.DOC_RULE_ID<>2 OR pDocDate BETWEEN b.FROM_DATE AND b.TO_DATE)
			     AND NOT
				      (TERMINAL_NAME=For_Init.GetCurrTerm AND
                       OSUSER_NAME=For_Init.GetCurrUser)
			  )
  LOOP
    -- Документ данного типа с таким же номером уже зарезервирован
	RETURN 1;
  END LOOP;

  RETURN 0;
END;

-- Очистить список зарезервированных номеров текущего пользователя для типа документа
PROCEDURE CLEAR_RESERV (pDocType NUMBER, pMestoId NUMBER) AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  DELETE FROM KLS_DOC_RESERV
   WHERE TERMINAL_NAME=For_Init.GetCurrTerm
     AND OSUSER_NAME=For_Init.GetCurrUser
	 AND DOC_TYPE_ID=pDocType
	 AND MESTO_ID=pMestoId;
  COMMIT;
END;

-- Получить диапазон номеров из которого зарезервирован номер
-- 0 - нет зарезервированного номер
-- >0 - KLS_DOC_NUMS.ID
FUNCTION GET_DOC_NUMS_RESERV (pDocType NUMBER, pMestoId NUMBER) RETURN NUMBER AS
res NUMBER;
BEGIN
  SELECT DOC_NUMS_ID INTO res FROM  KLS_DOC_RESERV
   WHERE TERMINAL_NAME=For_Init.GetCurrTerm
     AND OSUSER_NAME=For_Init.GetCurrUser
	 AND DOC_TYPE_ID=pDocType
	 AND MESTO_ID=pMestoId;
  RETURN res;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;

-- Получить зарезервированный номер
-- 0 - нет зарезервированного номер
-- >0 - зарезервированный номер
FUNCTION GET_RESERV (pDocType NUMBER, pMestoId NUMBER) RETURN NUMBER AS
res NUMBER;
BEGIN
  SELECT NEXT_DOC_NUM INTO res FROM  KLS_DOC_RESERV
   WHERE TERMINAL_NAME=For_Init.GetCurrTerm
     AND OSUSER_NAME=For_Init.GetCurrUser
	 AND DOC_TYPE_ID=pDocType
	 AND MESTO_ID=pMestoId;
  RETURN res;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;

-- Определить следующий номер документа
-- Возвращаемое значение - номер документа
FUNCTION GET_NEXT_NUM(pDocType NUMBER, pMestoId NUMBER, pDocPrefix VARCHAR2, pDocDate DATE) RETURN NUMBER AS
PRAGMA AUTONOMOUS_TRANSACTION;
res NUMBER;
i NUMBER;
BEGIN
  res:=FOR_SCRIPTS.SG$NO_ROW;

  FOR lcur IN (SELECT *
               FROM KLS_DOC_NUMS
			   WHERE DOC_TYPE_ID=pDocType AND MESTO_ID=pMestoId
			     AND (DOC_RULE_ID<>2 OR pDocDate BETWEEN FROM_DATE AND TO_DATE)
				 AND DOC_PREFIX||' '=Trim(pDocPrefix)||' '
			   FOR UPDATE)
  LOOP
    -- Описание данного типа документа для указанного места оформления найдено

    -- 1.Определяем диапазон номеров из которого уже зарезервирован номер
	res:=0;
  	i:=GET_DOC_NUMS_RESERV(pDocType,pMestoId);
	IF i=lcur.ID THEN
	  -- Если совершается попытка зарезервировать номер из диапазона, из которого уже
	  -- зарезервирован номер, то возвращаем старый зарезервированный номер
	  res:=GET_RESERV(pDocType,pMestoId);
	  IF res>0 THEN
        -- Проверяем наличие документа с аналогичными реквизитами в БД
	    IF CHECK_EXIST(pDocType,pMestoId,0,pDocPrefix,res,pDocDate)=0 THEN
          -- Проверяем на наличие номера в списках резерва других пользователей
	      IF CHECK_RESERV(pDocType,pMestoId,pDocPrefix,res,pDocDate)=0 THEN
		    ROLLBACK;
	        RETURN res;
		  END IF;
		END IF;
	  END IF;
	END IF;

	-- 2. Если диапазон номеров изменился или резервирования не производилось
	-- то резервируем по новому

	-- Очищаем список резервирования текущего пользователя
    CLEAR_RESERV(pDocType,pMestoId);

    res:=NVL(lcur.LAST_DOC_NUM,0);

    -- Задаем максимальное кол-во проверок на наличие документа для
	-- исключения зацикливания
    i:=1000;
    WHILE i>0 LOOP
  	  -- Получаем следующий номер
	  res:=res+1;

      -- Проверяем на минимально допустимый
      IF res<lcur.MIN_DOC_NUM THEN
	    res:=lcur.MIN_DOC_NUM;
  	  END IF;
      -- Проверяем на максимально допустимый
	  IF res>NVL(lcur.MAX_DOC_NUM,0) AND NVL(lcur.MAX_DOC_NUM,0)<>0 THEN
	    res:=lcur.MIN_DOC_NUM;
  	  END IF;

  	  -- Проверяем наличие документа c аналогичными реквизитами в БД
	  IF CHECK_EXIST(pDocType,pMestoId,0,pDocPrefix,res,pDocDate)=0 THEN
    	-- Проверяем на наличие номера в списках резерва других пользователей
	    IF CHECK_RESERV(pDocType,pMestoId,pDocPrefix,res,pDOcDate)=0 THEN
	      -- Номер не занят, резервируем
		  INSERT INTO KLS_DOC_RESERV (DOC_TYPE_ID, MESTO_ID, NEXT_DOC_NUM,DOC_NUMS_ID,DOC_PREFIX)
 		     VALUES(pDocType,pMestoId,res,lcur.ID,pDocPrefix);
		  COMMIT;
		  RETURN res;
	    ELSE
	      i:=i-1;
	    END IF;
      ELSE
	    i:=i-1;
	  END IF;
	END LOOP;

    -- Если дошли до этого места, значит номер не был найден
	-- и надо сгенерить ошибку
    ROLLBACK;
    RaiseError('Не удается получить номер документа!');
    EXIT;
  END LOOP;

  ROLLBACK;
  IF res=FOR_SCRIPTS.SG$NO_ROW THEN
    RaiseError('Диапазон номеров за указанный период не определен в справочнике номеров документов!');
  END IF;

  RETURN res;
END;


-- Сохранить номер документа
PROCEDURE SET_NUM(pDocType NUMBER, pMestoId NUMBER, pDocId VARCHAR2, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE) AS
res NUMBER;
i NUMBER;
BEGIN
  IF pDocNum<=0 THEN
    RaiseError('Документ с номером <=0 нельзя сохранить! Введите правильный номер.');
  END IF;

  -- 1.Очищаем список резервирования текущего пользователя
  CLEAR_RESERV(pDocType,pMestoId);

  -- 2.Сохраняем номер документа
  res:=FOR_SCRIPTS.SG$NO_ROW;
  FOR lcur IN (SELECT *
               FROM KLS_DOC_NUMS
			   WHERE DOC_TYPE_ID=pDocType AND MESTO_ID=pMestoId
			     AND (DOC_RULE_ID<>2 OR pDocDate BETWEEN FROM_DATE AND TO_DATE)
				 AND (DOC_PREFIX||' '=pDocPrefix||' ')
			   FOR UPDATE)
  LOOP
    -- Описание данного типа документа для указанного места оформления найдено

	-- Проверяем на наличие документа с аналогичными реквизитами в БД
	IF CHECK_EXIST(pDocType,pMestoId,pDocId,pDocPrefix,pDocNum,pDocDate)=0 THEN
      -- Документ отсутствует
	  IF NVL(lcur.LAST_DOC_NUM,0)<pDocNum THEN
		-- Обновляем номер последнего документа
		UPDATE KLS_DOC_NUMS SET LAST_DOC_NUM=pDocNum WHERE ID=lcur.ID;
	    RETURN;
	  ELSE
		-- НЕ обновляем номер последнего документа
		-- поскольку он уже был обновлен другим пользователем
		RETURN;
	  END IF;
	END IF;

    -- Если дошли до этого места, значит сохраняемый номер уже занят
	-- и надо сгенерить ошибку
    RaiseError('Документ с номером '||pDocPrefix||' '||TO_CHAR(pDocNum)||' уже существует!');
    RETURN;
  END LOOP;

  IF res=FOR_SCRIPTS.SG$NO_ROW THEN
    RaiseError('Диапазон номеров за указанный период не определен в справочнике номеров документов!');
  END IF;
END;

END;
/

