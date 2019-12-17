--
-- FOR_PLANPOST  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_Planpost AS

-- Открыть плановый период
FUNCTION NewPeriod (PlanID NUMBER, DatePlan DATE, BeginDate DATE, EndDate DATE) RETURN NUMBER IS
BEGIN

  IF PlanId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан план');
  END IF;

  INSERT INTO PLAN_PERIODS (PLAN_ID,DATE_PLAN,NUM_IZM_POST,NUM_IZM_RESU,BEGIN_DATE,END_DATE)
    VALUES (PlanId,DatePlan,0,0,BeginDate,EndDate);
  COMMIT;

  RETURN PLAN_PERIODS_ID;
END;

-- Изменить плановый период
PROCEDURE ChangePeriod (PlanPerID NUMBER, DatePlan DATE, BeginDate DATE, EndDate DATE) IS
BEGIN

  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;

  UPDATE PLAN_PERIODS SET DATE_PLAN=DatePlan, BEGIN_DATE=BeginDate, END_DATE=EndDate
	WHERE ID=PlanPerId;
  COMMIT;
END;

-- Удалить плановый период
PROCEDURE DeletePeriod (PlanPerID NUMBER) IS
  v_tmp NUMBER;
BEGIN

  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;

  BEGIN
    SELECT NULL INTO v_tmp
	  FROM PLAN_POST
	 WHERE PLAN_PER_ID=PlanPerId;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$ROW_EXIST, 'Вначале удалите позиции плана');
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$MANY_ROWS, 'Вначале удалите позиции плана');
	WHEN NO_DATA_FOUND THEN
	  NULL;
	WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, For_Scripts.SG$NO_CORRECT_TXT);
  END;

  DELETE FROM PLAN_PERIODS WHERE ID=PlanPerId;
  COMMIT;
END;

-- Копирование плана
FUNCTION CopyPlan (PlanPerIdFrom NUMBER, PlanIdTo NUMBER) RETURN NUMBER IS
  v_DATE_PLAN DATE;
  v_NUM_IZM_POST NUMBER;
  v_NUM_IZM_RESU NUMBER;
  v_BEGIN_DATE DATE;
  v_END_DATE DATE;
  PlanPerIdTo NUMBER;
  v_tmp NUMBER;
BEGIN

  IF PlanPerIdFrom IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период-источник');
  END IF;

  IF PlanIdTo IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан план-назначение');
  END IF;

  -- Определяем параметры планового периода-источника
  BEGIN
    SELECT DATE_PLAN, NUM_IZM_POST, NUM_IZM_RESU, BEGIN_DATE, END_DATE
	  INTO v_DATE_PLAN, v_NUM_IZM_POST, v_NUM_IZM_RESU, v_BEGIN_DATE, v_END_DATE
	  FROM PLAN_PERIODS
	 WHERE ID=PlanPerIdFrom;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_ROW, 'Плановый период-источник не найден');
  END;

  -- Ищем плановый период-назначение
  BEGIN
    SELECT ID
	  INTO PlanPerIdTo
	  FROM PLAN_PERIODS
	 WHERE PLAN_ID=PlanIdTo
	   AND DATE_PLAN=v_DATE_PLAN
	   AND BEGIN_DATE=v_BEGIN_DATE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PlanPerIdTo:=0;
  END;

  IF PlanPerIdTo=0 THEN
    -- Создадим новый плановый период
	PlanPerIdTo:=NewPeriod(PlanIdTo,v_DATE_PLAN,v_BEGIN_DATE,v_END_DATE);
  ELSE
    -- Проверим, есть ли данные в этом периоде
    SELECT COUNT(*) INTO v_tmp
	  FROM PLAN_POST
	 WHERE PLAN_PER_ID=PlanPerIdTo;
	IF v_tmp>0 THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$MANY_ROWS, 'В плановом периоде-назначении есть какие-то данные');
	END IF;

    SELECT COUNT(*) INTO v_tmp
	  FROM PLAN_RESU
	 WHERE PLAN_PER_ID=PlanPerIdTo;
	IF v_tmp>0 THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$MANY_ROWS, 'В плановом периоде-назначении есть какие-то данные');
	END IF;

	-- Очистим историю
	DELETE FROM PLAN_POST_HIST WHERE PLAN_PER_ID=PlanPerIdTo;
	COMMIT;

	DELETE FROM PLAN_RESU_HIST WHERE PLAN_PER_ID=PlanPerIdTo;
	COMMIT;
  END IF;

  -- Установим текущее изменение
  NewIzm('POST',PlanPerIdTo,v_NUM_IZM_POST,0);
  NewIzm('RESU',PlanPerIdTo,v_NUM_IZM_RESU,0);

  -- Копируем данные
  INSERT INTO PLAN_POST (PLAN_CENA, PLAN_VES, PLAN_SUM, DATE_CENA, PLAN_ID, PLAN_PER_ID, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID)
  SELECT PLAN_CENA, PLAN_VES, PLAN_SUM, DATE_CENA, PlanIdTo, PlanPerIdTo, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID
    FROM PLAN_POST
   WHERE PLAN_PER_ID = PlanPerIdFrom;

  INSERT INTO PLAN_RESU (PLAN_UTMSK, HRAN_UTMSK, OSTAT_UTMSK, PLAN_ID, PLAN_PER_ID, PROD_ID_NPR, SOBSTV_ID, REFINER_ID)
  SELECT PLAN_UTMSK, HRAN_UTMSK, OSTAT_UTMSK, PlanIdTo, PlanPerIdTo, PROD_ID_NPR, SOBSTV_ID, REFINER_ID
    FROM PLAN_RESU
   WHERE PLAN_PER_ID = PlanPerIdFrom;

  COMMIT;
  RETURN PlanPerIdTo;
END;

-- Изменение плана
PROCEDURE NewIzm (TableID VARCHAR2 DEFAULT 'POST', PlanPerID NUMBER, NumIzm NUMBER, NumCheck NUMBER) IS
  v_NumIzm NUMBER;
  v_tmp NUMBER;
  v_TableID VARCHAR2(4);
BEGIN
  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;
  v_TableID:=UPPER(SUBSTR(TableID,1,4));
  v_NumIzm:=NVL(NumIzm,0);

  -- Проверям, а меняется ли что-либо?
  BEGIN
    SELECT DECODE(v_TableID,'RESU',NUM_IZM_RESU,NUM_IZM_POST)
      INTO v_tmp
      FROM PLAN_PERIODS
  	 WHERE ID=PlanPerId;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Плановый период не найден');
  END;

  IF NumCheck=1 THEN
    IF v_tmp>v_NumIzm THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, '№ изменения меньше текущего');
    END IF;
  END IF;

  IF v_tmp<>v_NumIzm THEN
    -- Удаление старой истории
	IF v_TableID='RESU' THEN
      DELETE FROM PLAN_RESU_HIST WHERE PLAN_PER_ID=PlanPerId AND NUM_IZM=v_tmp;
	ELSE
      DELETE FROM PLAN_POST_HIST WHERE PLAN_PER_ID=PlanPerId AND NUM_IZM=v_tmp;
	END IF;

    -- Обновление PLAN_PERIODS
	IF v_TableID='RESU' THEN
      UPDATE PLAN_PERIODS SET NUM_IZM_RESU=v_NumIzm WHERE ID=PlanPerId;
	ELSE
      UPDATE PLAN_PERIODS SET NUM_IZM_POST=v_NumIzm WHERE ID=PlanPerId;
    END IF;

    -- Перенос данных в истории
	IF v_TableID='RESU' THEN
      INSERT INTO PLAN_RESU_HIST (ID,NUM_IZM,PLAN_UTMSK, HRAN_UTMSK, OSTAT_UTMSK, PLAN_ID, PLAN_PER_ID, PROD_ID_NPR, SOBSTV_ID, REFINER_ID)
      SELECT ID,v_tmp,PLAN_UTMSK, HRAN_UTMSK, OSTAT_UTMSK, PLAN_ID, PLAN_PER_ID, PROD_ID_NPR, SOBSTV_ID, REFINER_ID
        FROM PLAN_RESU
       WHERE PLAN_PER_ID=PlanPerId;
	ELSE
      INSERT INTO PLAN_POST_HIST (ID,NUM_IZM, PLAN_CENA, PLAN_VES, PLAN_SUM, DATE_CENA, PLAN_ID, PLAN_PER_ID, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID)
      SELECT ID,v_tmp, PLAN_CENA, PLAN_VES, PLAN_SUM, DATE_CENA, PLAN_ID, PLAN_PER_ID, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID
        FROM PLAN_POST
       WHERE PLAN_PER_ID=PlanPerId;
	END IF;

	COMMIT;
  END IF;

END;

-- Заполнение временной таблицы для ввода/редактирования позиции плана
-- Возвращает уникальное имя временной таблицы
FUNCTION FillTempPayForms(IsAdd NUMBER, PlanId NUMBER, PlanPerId NUMBER, ProdId VARCHAR2, PlanStruId NUMBER, DogId NUMBER, RefineryId NUMBER DEFAULT 8, OrgStruId NUMBER DEFAULT NULL) RETURN VARCHAR2 IS
  v_tmp NUMBER;
  v_tablename VARCHAR2(20);
BEGIN

  IF PlanId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан план');
  END IF;

  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;

  -- Сформируем имя временной таблицы
  SELECT SEQ_TEMP_TABLES.NEXTVAL INTO v_tmp FROM DUAL;
  v_tablename := 'PLAN_POST_' || TO_CHAR(v_tmp);

  -- Заполним таблицу
  IF IsAdd=1 THEN

    INSERT INTO V_TEMPTABLE (APP_NAME, UNIT_NAME, TABLE_NAME, NUM1, CHAR2, NUM3, NUM4, NUM5)
    SELECT
	  'MASTER','PLAN_POST',v_tablename,
      ID AS PAYFORM_ID,
      PAYFORM_NAME,
      0 AS PLAN_CENA,
      0 AS PLAN_VES,
      0 AS PLAN_SUM
    FROM KLS_PAYFORM; 
	
    --FillTempPrices(v_tablename,PlanId,PlanPerId,ProdId,DogId);
  ELSE
    INSERT INTO V_TEMPTABLE (APP_NAME, UNIT_NAME, TABLE_NAME, NUM1, CHAR2, NUM3, NUM4, NUM5, NUM6, DATE7)
    SELECT
	  'MASTER','PLAN_POST',v_tablename,
      A.ID AS PAYFORM_ID,
      A.PAYFORM_NAME,
      NVL(B.PLAN_CENA,0) AS PLAN_CENA,
      NVL(B.PLAN_VES,0) AS PLAN_VES,
      NVL(B.PLAN_SUM,0) AS PLAN_SUM,
	  B.CAT_CEN_ID AS CAT_CEN_ID,
	  B.DATE_CENA AS DATE_CENA
    FROM KLS_PAYFORM A,
    (
     SELECT
       PAYFORM_ID,
       KLS_PAYFORM.PAYFORM_NAME,
       PLAN_CENA,
       PLAN_VES,
       PLAN_SUM,
	   CAT_CEN_ID,
	   DATE_CENA
     FROM PLAN_POST,KLS_PAYFORM
     WHERE PLAN_POST.PAYFORM_ID=KLS_PAYFORM.ID
       AND PLAN_POST.PLAN_ID=PlanId
       AND PLAN_POST.PLAN_PER_ID=PlanPerId
       AND PLAN_POST.PROD_ID_NPR=ProdId
       AND PLAN_POST.PLANSTRU_ID=PlanStruId
       AND PLAN_POST.DOG_ID=DogId
	   AND PLAN_POST.REFINERY_ID=RefineryId
	   AND PLAN_POST.ORGSTRU_ID=OrgStruId
    ) B
    WHERE A.ID=B.PAYFORM_ID(+);
  END IF;

  COMMIT;

  RETURN v_tablename;
END;

-- Заполнение цен во временной таблице
PROCEDURE FillTempPrices(PlanPerId NUMBER, ProdId VARCHAR2, DogId NUMBER) IS
  v_tmp NUMBER;
  v_price_id NUMBER;
  v_cat_cen NUMBER;
  v_date_cena DATE;
  v_cena NUMBER;
  v_beg DATE;
  v_end DATE;
BEGIN

  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;

  -- Определим период дат
  SELECT BEGIN_DATE, END_DATE INTO v_beg,v_end FROM PLAN_PERIODS
   WHERE ID=PlanPerId;

  -- Определим текущую цену
  BEGIN
    SELECT A.ID,A.CAT_CEN_ID,A.INPUT_DATE,A.CENA_OTP
        INTO v_price_id,v_cat_cen,v_date_cena,v_cena
        FROM NPR_PRICES A,USL_DOG
       WHERE A.PROD_ID_NPR=ProdId
         AND A.IS_ORIGINAL=1
  	     AND A.BEGIN_DATE<v_End+1
  	     AND NVL(A.END_DATE,LAST_DAY(BEGIN_DATE))>v_Beg-1
  	     AND A.CAT_CEN_ID=USL_DOG.CAT_CEN_ID
	     AND USL_DOG.USL_BAZ=1
  	     AND USL_DOG.DOG_ID=DogId
		 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
      v_price_id:=NULL;
	  v_cat_cen:=NULL;
      v_date_cena:=NULL;
  	  v_cena:=0;
  END;

  -- Запомним цены во временных переменных
  v_tmp:=FOR_TEMP.SET_VARI('PRICE_ID',v_price_id,'MASTER','PLAN_POST');
  v_tmp:=FOR_TEMP.SET_VARI('CAT_CEN_ID',v_cat_cen,'MASTER','PLAN_POST');
  v_tmp:=FOR_TEMP.SET_VARI('DATE_CENA',v_date_cena,'MASTER','PLAN_POST');
  v_tmp:=FOR_TEMP.SET_VARI('PLAN_CENA',v_cena,'MASTER','PLAN_POST');
END;

-- Сохранение изменений из временной таблицы в PLAN_POST
function AddPlanPost(EditId NUMBER, PlanId NUMBER, PlanPerId NUMBER, ProdId VARCHAR2, PlanStruId NUMBER, DogId NUMBER, 
                           RefineryId NUMBER, OrgStruId NUMBER, PayFormId NUMBER, Price NUMBER, Ves NUMBER, CatCenId NUMBER, DateCena DATE) RETURN NUMBER IS
  vID NUMBER;
BEGIN
  vID:=EditId;
  
  IF PlanId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан план');
  END IF;

  IF PlanPerId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан плановый период');
  END IF;

  IF ProdId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан продукт');
  END IF;

  IF PlanStruId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указана позиция плана');
  END IF;

  IF DogId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указан договор');
  END IF;

  IF PayFormId IS NULL THEN
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, 'Не указана форма оплаты');
  END IF;


  
  UPDATE PLAN_POST A SET
    (PLAN_CENA, PLAN_VES, PLAN_ID, PLAN_PER_ID, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, 
	 DATE_CENA, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID)=
	(SELECT Price,Ves,PlanId,PlanPerId,PlanStruId,DogId,ProdId,PayFormId,
	        DateCena,CatCenId,RefineryId,OrgStruId FROM dual)
  WHERE ID=vId;
  			
  IF SQL%NOTFOUND THEN
    SELECT SEQ_PLAN_POST.NEXTVAL INTO vID FROM dual;			
    INSERT INTO PLAN_POST 
      (ID,PLAN_CENA, PLAN_VES, PLAN_ID, PLAN_PER_ID, PLANSTRU_ID, DOG_ID, PROD_ID_NPR, PAYFORM_ID, 
	   DATE_CENA, CAT_CEN_ID, REFINERY_ID, ORGSTRU_ID)
	VALUES (vId,Price,Ves,PlanId,PlanPerId,PlanStruId,DogId,ProdId,PayFormId,
	        DateCena,CatCenId,RefineryId,OrgStruId);
  END IF;			

  COMMIT;
  RETURN vID;
END;

-- Очистка временной таблицы
PROCEDURE ClearTempPayForms(TempTableName VARCHAR2) IS
BEGIN
  DELETE FROM V_TEMPTABLE B
        WHERE B.APP_NAME='MASTER'
          AND B.UNIT_NAME='PLAN_POST'
          AND B.TABLE_NAME=TempTableName;

  COMMIT;
END;

-- Удалить позицию плана
PROCEDURE DeletePlanPost(EditId NUMBER) IS
BEGIN
  DELETE FROM PLAN_POST B
   WHERE ID=EditID;

  COMMIT;
END;

END;
/

