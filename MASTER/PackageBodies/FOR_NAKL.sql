--
-- FOR_NAKL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_NAKL
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
    MaxNum REESTR.NAKL_POS%TYPE;
    CurNum REESTR.NAKL_POS%TYPE;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(REESTR.NAKL_POS) as MAX_NUM
                 FROM REESTR
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
    UPDATE REESTR SET NAKL_ID=NULL, NAKL_POS=NULL WHERE ID=pID;
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
	SELECT COUNT(*) INTO vCNT FROM REESTR WHERE NAKL_ID=pID;
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
    vRow REESTR%ROWTYPE;
    vSved SVED%ROWTYPE;
  BEGIN
    EMPTY_TEMP_NAKL;

	IF NVL(pNAKL_ID,0)<>0 THEN
	  -- Если редактирование накладной
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID, VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,VES_ALL,VES_CIST,VES_UPAK)
      SELECT
	    reestr.NAKL_POS,
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
		reestr.VES_ALL,
		reestr.VES_CIST,
		reestr.UPAK_VES
      from reestr, sved, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status
      where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
        and reestr.ved_pod_row_id=ved_pod_row.id(+)
	    and ved_pod_row.ved_pod_id=ved_pod.id(+)
        and month.stan_id=kls_stan.id(+)
	    and month.poluch_id=poluch.id(+)
        and reestr.vetka_otp_id=kls_vetka_otp.id(+)
	    and sved.prod_id_npr=kls_prod.id_npr(+)
        and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
        and reestr.nakl_id=pNAKL_ID
      ORDER BY
        reestr.NAKL_POS, reestr.ID;
	ELSE
	  -- Отбираем реквизиты вагона
	  BEGIN
  	    SELECT * INTO vRow FROM reestr
         WHERE ID=pSRC_REESTR_ID;
	  EXCEPTION
	    WHEN OTHERS THEN
	      RETURN;
	  END;
	  -- Отбираем реквизиты сведения
	  BEGIN
  	    SELECT * INTO vSved FROM sved
         WHERE ID=vRow.SVED_ID;
	  EXCEPTION
	    WHEN OTHERS THEN
	      RETURN;
  	  END;

	  -- Если добавление нового
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID, VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,VES_ALL,VES_CIST,VES_UPAK)
      SELECT
 	    ROWNUM as NAKL_POS,
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
		VES_ALL,
		VES_CIST,
		UPAK_VES
      FROM
        (
        SELECT /*+ ordered */
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
		  reestr.VES_ALL,
		  reestr.VES_CIST,
		  reestr.UPAK_VES
        from sved, reestr, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status
        where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
          and reestr.ved_pod_row_id=ved_pod_row.id(+)
    	  and ved_pod_row.ved_pod_id=ved_pod.id(+)
          and month.stan_id=kls_stan.id(+)
    	  and month.poluch_id=poluch.id(+)
          and reestr.vetka_otp_id=kls_vetka_otp.id(+)
    	  and sved.prod_id_npr=kls_prod.id_npr(+)
          and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
  		  and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
          and sved.MESTO_ID=pMESTO_ID
          and sved.load_type_id=pLOAD_TYPE_ID
          and reestr.nar_line_id is not null -- Вагон заадресован
          and reestr.nakl_id is null -- не включен в накладную
          and reestr.vag_status_id=0 -- исправный
          and reestr.ves<>0 -- с весом
		  and sved.PASP_ID IS NOT NULL -- в сведении указан паспорт
          and sved.NOM_ZD=vSved.NOM_ZD -- тот же номер задания, что и в эталонном сведении
          and sved.PROD_ID_NPR=vSved.PROD_ID_NPR -- тот же продукт, что и в эталонном сведении
          and reestr.formnakl_id=vRow.FORMNAKL_ID -- тот же тип накладной, что и в эталонном вагоне
          and sved.SVED_DATE BETWEEN vSved.SVED_DATE-1 AND vSved.SVED_DATE+1
          and ((reestr.formnakl_id in (2,5) and reestr.id=pSRC_REESTR_ID) or
               (reestr.formnakl_id in (6,7)
        	    and NVL(reestr.vagowner_id,0)=
      	           (CASE
    		          WHEN pLOAD_TYPE_ID=1 AND (/*month.is_exp<>0 OR */reestr.formnakl_id<>7) AND vRow.VAGOWNER_ID=3 THEN 3
    		          ELSE NVL(reestr.vagowner_id,0)
    		        END)
        	    and NVL(reestr.vagowner_id,0)<>
      	           (CASE
    		          WHEN pLOAD_TYPE_ID=1 AND (/*month.is_exp<>0 OR */reestr.formnakl_id<>7) AND vRow.VAGOWNER_ID<>3 THEN 3
    		          ELSE -1
    		        END)
     	        )
    	      )
        ORDER BY
          NVL(ved_pod.POD_DATE,sved.DATE_OFORML),
          NVL(ved_pod_row.POD_POS,0)
        );
	END IF;
  END;

  /* Добавить запись в таблицу TEMP_NAKL */
  PROCEDURE ADD_TEMP_NAKL (pREESTR_ID NUMBER) AS
  BEGIN
    IF NVL(pREESTR_ID,0)<>0 THEN
      INSERT INTO TEMP_NAKL (NAKL_POS, REESTR_ID) VALUES (GetTempMaxNumPos, pREESTR_ID);

  	  UPDATE TEMP_NAKL
	  SET (VETKA_OTP_NAME, POD_NUM, SVED_NUM,  NUM_CIST, VES, DATE_OFORML,
 	    NOM_ZD, STAN_NAME, PROD_NAME, VAGOWNER_NAME, POLUCH_NAME,SVED_DATE,PASP_NUM,VAG_STATUS,VES_ALL,VES_CIST,VES_UPAK)=
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
		  reestr.VES_ALL,
		  reestr.VES_CIST,
		  reestr.UPAK_VES
        from reestr, sved, month, ved_pod_row, ved_pod, kls_stan, kls_vetka_otp, KLS_VAGOWNER, KLS_PROD, KLS_PREDPR poluch,kls_vag_status
        where reestr.sved_id=sved.id and sved.nom_zd=month.nom_zd(+)
          and reestr.ved_pod_row_id=ved_pod_row.id(+)
    	  and ved_pod_row.ved_pod_id=ved_pod.id(+)
          and month.stan_id=kls_stan.id(+)
    	  and month.poluch_id=poluch.id(+)
          and reestr.vetka_otp_id=kls_vetka_otp.id(+)
    	  and sved.prod_id_npr=kls_prod.id_npr(+)
          and reestr.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
		  and reestr.VAG_STATUS_ID=kls_vag_status.ID(+)
          and reestr.ID=pREESTR_ID)
	  WHERE REESTR_ID=pREESTR_ID
	    AND EXISTS (SELECT NULL FROM reestr WHERE reestr.ID=pREESTR_ID);
	END IF;
  END;

  /* Добавить запись в таблицу TEMP_NAKL */
  PROCEDURE DEL_TEMP_NAKL (pREESTR_ID NUMBER) AS
  BEGIN
	DELETE FROM TEMP_NAKL WHERE REESTR_ID=pREESTR_ID;
	COMMIT;
  END;


  /* Перенести позиции из TEMP_NAKL в REESTR */
  PROCEDURE SAVE_TEMP_NAKL (pNAKL_ID NUMBER) AS
    vTmp NUMBER;
  BEGIN
    IF NVL(pNAKL_ID,0)<>0 THEN
      UPDATE reestr SET NAKL_ID=NULL, NAKL_POS=NULL WHERE NAKL_ID=pNAKL_ID;
      FOR lcur IN (SELECT * FROM TEMP_NAKL)
	  LOOP
  	    AddRow(0,lcur.REESTR_ID,pNAKL_ID,lcur.NAKL_POS);
	  END LOOP;
	END IF;
  END;

  /* Добавить/Изменить заголовок ДОКУМЕНТА */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
       pNAKL_NUM NUMBER, pNAKL_DATE DATE, pFORMNAKL_ID NUMBER, pNOM_ZD VARCHAR2, pPROD_ID_NPR VARCHAR2,
	   pOPERNALIV_ID NUMBER, pIS_EXP NUMBER, pDOG_ID NUMBER, pSTAN_ID NUMBER, pK_TAR VARCHAR2, pNUM_KVIT VARCHAR2)
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
	UPDATE NAKL SET (NAKL_NUM, NAKL_DATE, MESTO_ID, LOAD_TYPE_ID, FORMNAKL_ID,NOM_ZD,PROD_ID_NPR,
	    IS_EXP, DOG_ID, STAN_ID, K_TAR, OPERNALIV_ID)=
	  (SELECT pNAKL_NUM, pNAKL_DATE, pMESTO_ID, pLOAD_TYPE_ID, pFORMNAKL_ID,pNOM_ZD,pPROD_ID_NPR,
	    pIS_EXP, pDOG_ID, pSTAN_ID, pK_TAR, pOPERNALIV_ID FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем документ
      INSERT INTO NAKL (ID,NAKL_NUM, NAKL_DATE, MESTO_ID, LOAD_TYPE_ID, FORMNAKL_ID,NOM_ZD,PROD_ID_NPR,
	     IS_EXP, DOG_ID, STAN_ID, K_TAR, OPERNALIV_ID)
	  VALUES (vID, pNAKL_NUM, pNAKL_DATE, pMESTO_ID, pLOAD_TYPE_ID, pFORMNAKL_ID,pNOM_ZD,pPROD_ID_NPR,
	     pIS_EXP, pDOG_ID, pSTAN_ID, pK_TAR, pOPERNALIV_ID);
	END IF;

	-- Сохранение позиций из временной таблицы TEMP_NAKL
	SAVE_TEMP_NAKL(vID);

	-- Номер квитанции
	UPDATE REESTR SET NUM_KVIT=pNUM_KVIT WHERE ID=vID;
 
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* Добавить/Изменить позицию ДОКУМЕНТА */
  PROCEDURE AddRow(pCOMMIT NUMBER, pID NUMBER, pNAKL_ID NUMBER, pNAKL_POS NUMBER) AS
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

	vPos:=NVL(pNAKL_POS,FOR_NAKL.GetMaxNumPos(pNAKL_ID));

	-- Обновляем позицию
	UPDATE REESTR SET NAKL_ID=pNAKL_ID, NAKL_POS=vPos WHERE ID=vID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  /* Скопировать позицию НАКЛАДНОЙ в другую НАКЛАДНУЮ
     Возвращаемое занчение - ID позиции документа или NULL - если запись не найдена */
  FUNCTION MoveRow (pCOMMIT NUMBER, pREESTR_ID NUMBER, pNEW_NAKL_ID NUMBER) RETURN NUMBER AS
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

/* Проверка вагона на наличие всех необходимых для печати накладной реквизитов */
FUNCTION CHECK_REESTR(pREESTR_ID NUMBER) RETURN NUMBER AS
BEGIN
 /*
*********************************************************************
* Процедура CheckKvit
* Назначение  - проверка окончания редактирования отгрузки
*********************************************************************
FUNCTION CheckKvit
PARAMETERS ViewMes,IsSved
PRIVATE Flag,stor_sele,m.num_pasp,m.num_rez,m.dins,m.num_otgr,m.kod_npr,m.tip,m.wes,;
        m.osc,m.vzliv,m.pl,m.kodpasp,m.gd_track,m.mesto,m.tip_otgr

  WAIT "Ждите.... Идет проверка!" WINDOW NOWAIT

  IF EMPTY(IsSved)
    IsSved=.F.
  ELSE
    IsSved=.T.
  ENDIF
  Flag=.T.
  m.num_pasp=num_pasp
  m.num_rez=num_rez
  m.dins=dins
  m.num_otgr=num_otgr
  m.kod_npr=kod_npr
  m.tip=tip
  m.wes=wes
  m.osc=osc
  m.vzliv=vzliv
  m.pl=pl
  m.kodpasp=ALLT(kodpasp)
  m.gd_track=gd_track
  m.mesto=mesto
  m.tip_otgr=tip_otgr

  stor_sele=SELECT()

  && Проверка наличия номера транспортного средства
  IF EMPTY(num_otgr)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание','Отсутствует N '+TSName('чего'))
    ENDIF
    SELECT (stor_sele)
    RETURN 'num_otgr'
  ENDIF

  IF _g_tipotgr=1
    IF !conrt_cist(num_otgr)
      IF ViewMes
        IF 1 = mes_dial(7,'Внимание','\rНедопустимый номер вагона '+;
          ALLT(m.num_otgr)+' !!!\rУточните номер!!!\r',2,;
          '\!Отказ', '\?Продолжить')
          RETURN 'num_otgr'
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  && Проверка наличия накладной
  IF EMPTY(forma) OR !SEEK(forma,'FORMA')
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан тип накладной "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'forma'
  ENDIF

  && Проверка наличия пути отгрузки
  IF EMPTY(gd_track) OR !SEEK(gd_track,'TRACKS')
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан путь отгрузки "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'gd_track'
  ENDIF

  && Проверка времени и даты отгрузки
  IF EMPTY(np_data_o)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указана дата отгрузки "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'np_data_o'
  ENDIF

  && Правильность времени отгрузки
  IF EMPTY(np_timep)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указано время отгрузки "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'np_timep'
  ENDIF

  && Проверка заполнения паспорта и его соответствия справочнику
  IF EMPTY(num_pasp)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан N паспорта на н/п "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'num_pasp'
  ENDIF

  IF EMPTY(num_rez)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан N резервуара "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'num_rez'
  ENDIF

  IF EMPTY(dins)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указана дата паспорта на н/п "+TSName("у")+" "+ALLT(num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'dins'
  ENDIF

  SELECT zagpasp
  IF !SEEK(m.kodpasp,'ZAGPASP') AND ;
      (!EMPTY(m.num_pasp) OR !EMPTY(m.num_rez) OR !EMPTY(m.dins))
    && № паспорта есть, а ID в справочнике не найден
    m.kodpasp=loca_pasp(m.num_pasp,m.num_rez,m.dins,m.mesto,m.tip_otgr)
    IF ALLT(m.kodpasp)<>'нет пасп.'
      DO LogIt WITH m._g_id,evCheckDB,SYS(16),;
        'Восстановление kvit.kodpasp';
        IN logs.prg
      SELECT (stor_sele)
      REPLACE kodpasp WITH ALLT(m.kodpasp)
    ENDIF
  ENDIF
  SELECT zagpasp
  LOCATE FOR ALLT(zagpasp.num_pasp)=ALLT(m.num_pasp) ;
         AND ALLT(zagpasp.num_rez)=ALLT(m.num_rez) ;
         AND zagpasp.dins=m.dins ;
         AND ALLT(zagpasp.kodpasp)=ALLT(m.kodpasp)
  IF !FOUND() OR ALLT(m.kodpasp)='нет пасп.'
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"В справочнике не найден паспорт на н/п "+TSName("для")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'num_pasp'
  ENDIF

  IF zagpasp.kod_npr <> m.kod_npr
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Н/продукт "+TSName("в")+" "+ALLT(m.num_otgr)+" не соответствует н/продукту в паспорте")
    ENDIF
    SELECT (stor_sele)
    RETURN 'num_pasp'
  ENDIF

  SELECT (stor_sele)
  && Проверка принадлежности к дорогам СНГ
  IF m._g_tipotgr<>2 AND EMPTY(ncistdop)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указаны принадлежность к дорогам "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'numcistdop'
  ENDIF

  && Проверка собственника
  IF m._g_tipotgr<>2 AND EMPTY(tipv)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан собственник "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'tipv'
  ENDIF

  && Проверка типа вагона
  IF m._g_tipotgr<>2 AND EMPTY(tip) AND (rodv=6 or rodv=1)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан тип "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'tip'
  ENDIF

  && Проверка типа вагона
  IF m._g_tipotgr=1 AND (EMPTY(osc) OR EMPTY(wes))
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указана грузоподъемность "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'wes'
  ENDIF

  IF m._g_tipotgr<>2 AND (rodv=6 or rodv=1)

    IF !USED('cist_typ')
      USE (_g_pathdbf + 'cist_typ') ORDER TAG tip IN 0
    ENDIF

    SELECT cist_typ

    && Наличие типа цистерны в справочнике cist_typ
    Flag=SEEK(SUBSTR(m.tip,1,3),'cist_typ')
    IF !Flag
      IF ViewMes
      IF 1=mes_dial(5,'Внимание!','\rВозможно неверно указан тип '+m.tip+' '+TSName('у')+' '+ALLT(m.num_otgr)+'\rЧто делать?\r',;
        2,'\? Исправить','\! Продолжить')
        SELECT (stor_sele)
        RETURN 'tip'
      ENDIF
      ENDIF
    ENDIF

    && Соответствие типа цистерны данным указанным в CIST_TIP
    IF Flag
      IF cist_typ.gru<>m.wes OR cist_typ.koo<>m.osc
        IF ViewMes
*        IF 1=mes_dial(5,'Внимание!','\rВозможно неверно указана грузоподъемность '+TSName("у")+" "+ALLT(m.num_otgr)+'\rЧто делать?\r',;
*          2,'\? Исправить','\! Продолжить')
*          SELECT (stor_sele)
*          RETURN 'tip'
*        ENDIF
        ENDIF
      ENDIF
    ENDIF

    SELECT (stor_sele)
  ENDIF

  && Проверка взлива для случая замера МЕТР-ШТОКОМ
  IF NOT EMPTY(vzliv)

*    IF EMPTY(vzliv)
*      IF ViewMes
*        WAIT CLEAR
*        =mes_dial(7,'Внимание',"Не указан взлив "+TSName("у")+" "+ALLT(m.num_otgr))
*      ENDIF
*      SELECT (stor_sele)
*      RETURN 'vzliv'
*    ENDIF

    IF m._g_tipotgr<>2
      IF !USED('cist_vsl')
        USE (_g_pathdbf + 'cist_vsl') ORDER TAG cist_vsl IN 0
      ENDIF

      SELECT cist_vsl

      && Наличие взлива в справочнике cist_vsl
      Flag=SEEK(SUBSTR(m.tip,1,3)+STR(m.vzliv,3),'cist_vsl')
      IF !Flag
        IF ViewMes
          IF 1=mes_dial(5,'Внимание!','\rВозможно неверно указан взлив '+STR(m.vzliv,3)+' '+TSName("у")+" "+ALLT(m.num_otgr)+'\rЧто делать?\r',;
            2,'\? Исправить','\! Продолжить')
            SELECT (stor_sele)
            RETURN 'vzliv'
          ENDIF
        ENDIF
      ENDIF
    ENDIF

    SELECT (stor_sele)

    && Проверка фактической плотности
    IF EMPTY(xpl) AND !IsSved
      IF ViewMes
        WAIT CLEAR
        =mes_dial(7,'Внимание',"Не указан факт.уд.вес "+TSName("у")+" "+ALLT(m.num_otgr))
      ENDIF
      SELECT (stor_sele)
      RETURN 'xpl'
    ENDIF

  ENDIF

  SELECT (stor_sele)
  && Проверка веса
  IF (EMPTY(ves) OR EMPTY(fakt)) AND !IsSved
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан вес н/п "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'ves'
  ENDIF

*  IF EMPTY(vzliv) AND EMPTY(tara_all)
*    IF ViewMes
*      WAIT CLEAR
*      =mes_dial(7,'Внимание',"Не указан вес тары "+TSName("у")+" "+ALLT(m.num_otgr))
*    ENDIF
*    SELECT (stor_sele)
*    RETURN 'tara_all'
*  ENDIF

  IF defi_mass<>1 AND EMPTY(kol_all) AND !IsSved &&tracks.defi_mass=2
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не указан вес брутто "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'kol_all'
  ENDIF

  IF m._g_tipotgr=1 AND ves<30 AND !IsSved
    IF ViewMes
      IF 1=mes_dial(5,'Внимание!',"\rСлишком малый вес "+ALLT(STR(ves,12,3))+" "+TSName("у")+" "+ALLT(m.num_otgr)+"(возможно неверный взлив)"+"\rВы уверены, что все верно?\r",;
        2,'\? Исправить',"\! Продолжить")
        SELECT (stor_sele)
        RETURN 'ves'
      ENDIF
    ENDIF
  ENDIF

  && Проверка плательщика провозной платы
  IF m._g_tipotgr<>2 AND EMPTY(kod_tex_pd)
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не выбран плательщик тарифа "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'kod_tex_pd'
  ENDIF

  && Проверка наличия пломб
  IF m._g_tipotgr<>2 AND LEFT(kod_npr,3)<>'130' AND LEFT(kod_npr,3)<>'131' AND rodv=6 AND EMPTY(plomba1) AND !INLIST(forma,5,7) AND !IsSved
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не введена пломба 1 "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'plomba1'
  ENDIF

  IF m._g_tipotgr=1 AND LEFT(kod_npr,3)<>'130' AND LEFT(kod_npr,3)<>'131' AND rodv=6 AND EMPTY(plomba2) AND osc>4 AND !INLIST(forma,5,7) AND !IsSved
    IF ViewMes
      WAIT CLEAR
      =mes_dial(7,'Внимание',"Не введена пломба 2 "+TSName("у")+" "+ALLT(m.num_otgr))
    ENDIF
    SELECT (stor_sele)
    RETURN 'plomba2'
  ENDIF

  SELECT (stor_sele)
  WAIT CLEAR
*/
  RETURN 1;
END;


/* Ж/д наименование продукта с учетом Темп.вспышки */
FUNCTION GET_GD_NAME_NPR(pGD_NAME_NPR VARCHAR2, pT_VSP NUMBER) RETURN VARCHAR2 AS
BEGIN
/*
  IF TVsp_61
    s=STRTRAN(s,'НИЖЕ','ВЫШЕ')
  ELSE
    s=STRTRAN(s,'ВЫШЕ','НИЖЕ')
  ENDIF
*/
  RETURN pGD_NAME_NPR;
END;

/* Ж/д код продукта с учетом Темп.вспышки */
FUNCTION GET_GD_KOD_NPR(pPROD_GU12_ID VARCHAR2, pT_VSP NUMBER) RETURN VARCHAR2 AS
BEGIN
  /*
  IF TVsp_61 AND prod.kod_gr='214043'
    s='214039'
  ELSE
    IF NOT TVsp_61 AND prod.kod_gr='214039'
      s='214043'
    ELSE
      s=prod.kod_gr
    ENDIF
  ENDIF
*/
  RETURN pPROD_GU12_ID;
END;


/* Аварийная карта (наименование) */
FUNCTION GET_AV_KART_NAME(pPROD_ID_NPR VARCHAR2, pPROD_AV_KART NUMBER, pT_VSP NUMBER) RETURN VARCHAR2 AS
BEGIN
/*    IF prod.kod='90000'
    RETURN ''
  ENDIF
  IF !EMPTY(prod.av_kart)
    IF prod.av_kart>0 AND prod.kod_gr='10400' AND TVsp_61
      RETURN 'Ав.карта N 901'
    ELSE
      IF prod.av_kart<0
        RETURN ''
      ELSE
        RETURN 'Ав.карта N '+ALLT(STR(prod.av_kart))
      ENDIF
    ENDIF
  end if
*/
  RETURN 'Аварийная карта прилагается';
END;

/*Добавление шаблона экспортной накладной*/
FUNCTION AddShabExp(pCommit NUMBER,pId NUMBER,pFlg_dostup NUMBER,pDog_id NUMBER,pProd_id_npr VARCHAR2,
		 			pStan_id NUMBER,pPrim_dog VARCHAR2,
		 			pOsob1 VARCHAR2,pOsob2 VARCHAR2,pOsob3 VARCHAR2,pOsob4 VARCHAR2,pPol1 VARCHAR2,pPol2 VARCHAR2,
					pPol3 VARCHAR2,pPol4 VARCHAR2,pNeob1 VARCHAR2,pNeob2 VARCHAR2,pNeob3 VARCHAR2,pNeob4 VARCHAR2,
					pStan1 VARCHAR2,pStan2 VARCHAR2,pStan3 VARCHAR2,pStan4 VARCHAR2,pDorst1 VARCHAR2,pDorst2 VARCHAR2,
					pNm_gr1 VARCHAR2,pNm_gr2 VARCHAR2,pNm_gr3 VARCHAR2,pNm_gr4 VARCHAR2,pNm_gr5 VARCHAR2,pNm_gr6 VARCHAR2,
					pNm_gr7 VARCHAR2,pNm_gr8 VARCHAR2,pNm_gr9 VARCHAR2,pPlt_ot1 VARCHAR2,pPlt_ot2 VARCHAR2,pPlt_ot3 VARCHAR2,
					pPlt_ot4 VARCHAR2,pDocs1 VARCHAR2,pDocs2 VARCHAR2,pDocs3 VARCHAR2,pDocs4 VARCHAR2,pTam1 VARCHAR2,
					pTam2 VARCHAR2,pPos33 VARCHAR2,pPos34 VARCHAR2,pPos35 VARCHAR2,pPos36 VARCHAR2,pShtamp1 VARCHAR2,
					pShtamp2 VARCHAR2,pShtamp3 VARCHAR2,pShtamp4 VARCHAR2,pShtamp5 VARCHAR2,pGr1_txt_ex VARCHAR2,pGr2_txt_ex VARCHAR2,
					pMesto_pay VARCHAR2,pCnt_ved NUMBER,pTex_pd_id NUMBER) RETURN NUMBER 
AS
vID KLS_SHABEXP.ID%TYPE;
vTmp NUMBER;
vAdd NUMBER;
BEGIN
    -- ID
	IF pID=-1 OR pID IS NULL THEN
	  vADD:=1;
      SELECT SEQ_SHAB_EXP.nextval INTO vTmp FROM DUAL;
	  vID:=vTmp;	  
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ id
        INTO vTmp
	 	FROM kls_shabexp
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Шаблон нельзя отредактировать - он удален!');
		END IF;
	END;

	-- Обновляем 
	UPDATE KLS_SHABEXP SET (Flg_dostup,Dog_id,Prod_id_npr,Stan_id,Prim_dog,Osob1,Osob2,Osob3,Osob4,Pol1,Pol2,
					Pol3,Pol4,Neob1,Neob2,Neob3,Neob4,Stan1,Stan2,Stan3,Stan4,Dorst1,Dorst2,Nm_gr1,Nm_gr2,Nm_gr3,
					Nm_gr4,Nm_gr5,Nm_gr6,Nm_gr7,Nm_gr8,Nm_gr9,Plt_ot1,Plt_ot2,Plt_ot3,Plt_ot4,Docs1,Docs2,Docs3,
					Docs4,Tam1,Tam2,Pos33,Pos34,Pos35,Pos36,Shtamp1,Shtamp2,Shtamp3,Shtamp4,Shtamp5,Gr1_txt_ex,
					Gr2_txt_ex,Mesto_pay,Cnt_ved,Tex_pd_id)=
	  (SELECT pFlg_dostup,pDog_id,pProd_id_npr,pStan_id,pPrim_dog,pOsob1,pOsob2,pOsob3,pOsob4,pPol1,pPol2,
					pPol3,pPol4,pNeob1,pNeob2,pNeob3,pNeob4,pStan1,pStan2,pStan3,pStan4,pDorst1,pDorst2,pNm_gr1,
					pNm_gr2,pNm_gr3,pNm_gr4,pNm_gr5,pNm_gr6,pNm_gr7,pNm_gr8,pNm_gr9,pPlt_ot1,pPlt_ot2,pPlt_ot3,
					pPlt_ot4,pDocs1,pDocs2,pDocs3,pDocs4,pTam1,pTam2,pPos33,pPos34,pPos35,pPos36,pShtamp1,pShtamp2,
					pShtamp3,pShtamp4,pShtamp5,pGr1_txt_ex,pGr2_txt_ex,pMesto_pay,pCnt_ved,pTex_pd_id FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем 
      INSERT INTO KLS_SHABEXP (Id,Flg_dostup,Dog_id,Prod_id_npr,Stan_id,Prim_dog,Osob1,Osob2,Osob3,Osob4,Pol1,Pol2,
					Pol3,Pol4,Neob1,Neob2,Neob3,Neob4,Stan1,Stan2,Stan3,Stan4,Dorst1,Dorst2,Nm_gr1,Nm_gr2,Nm_gr3,
					Nm_gr4,Nm_gr5,Nm_gr6,Nm_gr7,Nm_gr8,Nm_gr9,Plt_ot1,Plt_ot2,Plt_ot3,Plt_ot4,Docs1,Docs2,Docs3,
					Docs4,Tam1,Tam2,Pos33,Pos34,Pos35,Pos36,Shtamp1,Shtamp2,Shtamp3,Shtamp4,Shtamp5,Gr1_txt_ex,
					Gr2_txt_ex,Mesto_pay,Cnt_ved,Tex_pd_id)
	  VALUES (vId,pFlg_dostup,pDog_id,pProd_id_npr,pStan_id,pPrim_dog,pOsob1,pOsob2,pOsob3,pOsob4,pPol1,pPol2,
					pPol3,pPol4,pNeob1,pNeob2,pNeob3,pNeob4,pStan1,pStan2,pStan3,pStan4,pDorst1,pDorst2,pNm_gr1,
					pNm_gr2,pNm_gr3,pNm_gr4,pNm_gr5,pNm_gr6,pNm_gr7,pNm_gr8,pNm_gr9,pPlt_ot1,pPlt_ot2,pPlt_ot3,
					pPlt_ot4,pDocs1,pDocs2,pDocs3,pDocs4,pTam1,pTam2,pPos33,pPos34,pPos35,pPos36,pShtamp1,pShtamp2,
					pShtamp3,pShtamp4,pShtamp5,pGr1_txt_ex,pGr2_txt_ex,pMesto_pay,pCnt_ved,pTex_pd_id);
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

PROCEDURE DelShabExp(pCommit NUMBER,pId NUMBER)
AS
BEGIN
    UPDATE kls_shabexp SET flg_dostup=0 WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
END;

END;

/

