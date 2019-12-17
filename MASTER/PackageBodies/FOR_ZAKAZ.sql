--
-- FOR_ZAKAZ  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_Zakaz AS

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;

  -- Очищаем временную таблицу
  PROCEDURE EmptyTemp(pIS_AGENT NUMBER) AS
  BEGIN
	DELETE FROM V_ZAKAZ_TEMP WHERE IS_AGENT=pIS_AGENT;
    COMMIT;
  END;

  -- Добавить данные во временную таблицу
  PROCEDURE FillTemp(pIS_AGENT NUMBER, pBEGIN_DATE DATE, pEND_DATE DATE, pZAKAZ_ID NUMBER DEFAULT NULL) AS
	vCNT NUMBER;
  BEGIN
    /* Считываем запись из заявки */
	IF (pIS_AGENT<>9) THEN
  	  FOR vZAKAZ IN (SELECT DISTINCT
					   NVL(FILIAL_ID,-1) AS FILIAL_ID,
					   PROD_ID_NPR,
					   NVL(DOG_ID,-1) AS DOG_ID,
					   NVL(PLAT_ID,-1) AS PLAT_ID
					  FROM ZAKAZ
	                 WHERE (ID=pZAKAZ_ID OR NVL(pZAKAZ_ID,0)=0)
                       AND Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
				    )
      LOOP
        /* СНП */
       	IF pIS_AGENT=2 THEN

          /* ПЛАНЫ  */
    	  -- Найти запись
    	  SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
    	   WHERE IS_AGENT=pIS_AGENT
    	     AND KIND_VALUE=1
    		 AND FILIAL_ID=vZAKAZ.FILIAL_ID
    		 AND PROD_ID_NPR=vZAKAZ.PROD_ID_NPR;

    	  IF vCNT=0 THEN
    	    -- Добавим запись
            INSERT INTO ZAKAZ_TEMP
    	      (IS_AGENT,KIND_VALUE,FILIAL_ID,PROD_ID_NPR,
    		   PLAN_NB,PLAN_TRAN,PLAN_VNCORPTR,PLAN_OTHER)
            SELECT
    	      pIS_AGENT,1,vZAKAZ.FILIAL_ID,vZAKAZ.PROD_ID_NPR,
              SUM(NVL(plan_NB,0)) AS PLAN_NB,
              SUM(NVL(plan_TRAN,0)) AS PLAN_TRAN,
              SUM(NVL(plan_VNCORPTR,0)) AS PLAN_VNCORPTR,
              SUM(NVL(plan_OTHER,0)) AS PLAN_OTHER
            FROM
            (
            SELECT
              /* План поставок */
              PLAN_POST.Prod_id_npr,
              DECODE(NVL(TIP_REAL_ID,0),1,PLAN_POST.plan_ves,0) AS PLAN_NB,
              DECODE(NVL(TIP_REAL_ID,0),2,PLAN_POST.plan_ves,0) AS PLAN_TRAN,
              DECODE(NVL(TIP_REAL_ID,0),0,DECODE(spf_group_name,'ВНУТРИКОРПОРАТИВНЫЙ ТРАНЗИТ',PLAN_POST.plan_ves,0),0) AS PLAN_VNCORPTR,
              DECODE(NVL(TIP_REAL_ID,0),0,DECODE(spf_group_name,'ПРОЧЕЕ',PLAN_POST.plan_ves,0),0) AS PLAN_OTHER
            FROM PLAN_PERIODS,PLAN_POST,
            (
             SELECT * FROM v_Kls_planstru
              WHERE v_Kls_planstru.IS_SNP=1 /* План по ЛУКОЙЛ-СНП */
              AND v_Kls_planstru.IS_TO_HRAN=0 /* Без отгрузки на хранение */
              AND DECODE (v_Kls_planstru.Region_id, 21, 40, 31) = vZAKAZ.Filial_id
              AND v_Kls_planstru.Parent_id<>218
            ) PS
            WHERE PLAN_POST.Plan_per_id = PLAN_PERIODS.ID
              AND (
			       (PLAN_POST.Plan_id=1 AND pBEGIN_DATE<TO_DATE('01.01.2005','dd.mm.yyyy')) /* Рабочий план */
                OR (PLAN_POST.Plan_id IN (12,13) AND pBEGIN_DATE>=TO_DATE('01.01.2005','dd.mm.yyyy')) /* планы СНП*/
	              )
              AND PLAN_PERIODS.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
              AND PLAN_POST.Planstru_id=PS.ID
            ) PP,
            (
            SELECT Link_id_Npr
               FROM v_prod_linked_grp_4
              WHERE fact_id_npr = vZAKAZ.prod_id_npr
            ) Prods
            WHERE Prods.Link_Id_npr =  PP.Prod_id_npr;
    	  END IF;

    	  /* ПРОДУКТ-ЗАЯВЛЕНО-ОТГРУЖЕНО */
    	  -- Найти запись
    	  SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
    	   WHERE IS_AGENT=pIS_AGENT
    	     AND KIND_VALUE=2
    		 AND FILIAL_ID=vZAKAZ.FILIAL_ID
    		 AND PROD_ID_NPR=vZAKAZ.PROD_ID_NPR
    		 AND DOG_ID=vZAKAZ.DOG_ID
    		 AND PLAT_ID=vZAKAZ.PLAT_ID;

    	  IF vCNT=0 THEN
    	    -- Добавим запись
            INSERT INTO ZAKAZ_TEMP
    	      (IS_AGENT,KIND_VALUE,FILIAL_ID,PROD_ID_NPR,DOG_ID,PLAT_ID,
    		   PROD_NAME,
    		   ZAYV_ALL_PROD,ZAYV_ACCEPT_PROD,ZAYV_FACT_PROD,
    		   ZAYV_ALL_DOG,ZAYV_ACCEPT_DOG,ZAYV_FACT_DOG,
    		   ZAYV_ALL_PLAT,ZAYV_ACCEPT_PLAT,ZAYV_FACT_PLAT)
            SELECT
    	      pIS_AGENT,2,vZAKAZ.FILIAL_ID,vZAKAZ.PROD_ID_NPR,vZAKAZ.DOG_ID,vZAKAZ.PLAT_ID,
              Prods.GROUP_NAME_NPR AS PROD_NAME,
              SUM(VES) AS ZAYV_ALL_PROD,
              SUM(DECODE(IS_ACCEPT,1,VES,0)) AS zayv_accept_prod,
              SUM(FACT_VES) AS ZAYV_FACT_PROD,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,VES,0)) AS zayv_all_dog,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,DECODE(IS_ACCEPT,1,VES,0),0)) AS zayv_accept_dog,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,FACT_VES,0)) AS zayv_fact_dog,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,VES,0)) AS zayv_all_plat,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,DECODE(IS_ACCEPT,1,VES,0),0)) AS zayv_accept_plat,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,FACT_VES,0)) AS zayv_fact_plat
            FROM ZAKAZ mon,
            (
            SELECT Link_id_Npr,GROUP_NAME_NPR
               FROM v_prod_linked_grp_4
              WHERE fact_id_npr = vZAKAZ.prod_id_npr
            ) Prods
            WHERE mon.is_agent=2
              AND mon.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
              AND mon.filial_id=vZAKAZ.FILIAL_ID
              AND mon.PROD_ID_NPR=Prods.Link_Id_npr
            GROUP BY Prods.GROUP_NAME_NPR;
    	  END IF;

    	  /* ЗАДОЛЖЕННОСТЬ */
		  IF NVL(vZAKAZ.DOG_ID,0)<>0 THEN
      	    -- Найти запись
      	    SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
             WHERE IS_AGENT=pIS_AGENT
             AND KIND_VALUE=3
        	 AND DOG_ID=vZAKAZ.DOG_ID;

            IF vCNT=0 THEN
              -- Добавим запись
            /*  INSERT INTO ZAKAZ_TEMP
	           (IS_AGENT,KIND_VALUE,DOG_ID,SALDO)
              SELECT
	            pIS_AGENT,3,vZAKAZ.DOG_ID,
		        NVL(SUM(-NFACT_INGOOD_SUM+NFACT_OUTGOOD_SUM+NPLAN_OUTSERV_SUM+NFACT_OUTPAY_SUM-NFACT_INPAY_SUM),0) AS SALDO
              FROM parus.V_contracts@oracle.world f, KLS_DOG_PARUS
              WHERE KLS_DOG_PARUS.DOG_ID=vZAKAZ.dog_id
                AND TRIM (f.sdoc_pref) || TRIM (f.sdoc_numb)=KLS_DOG_PARUS.BASE_NUMB;*/
			  NULL;
	        END IF;
	      END IF;
        END IF;

        /* АГЕНТ, УНП */
	    IF pIS_AGENT=1 THEN

          /* ПЛАНЫ */
	      -- Найти запись
	      SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
	       WHERE IS_AGENT=pIS_AGENT
	         AND KIND_VALUE=1
		     AND FILIAL_ID=vZAKAZ.FILIAL_ID
			 AND PROD_ID_NPR=vZAKAZ.PROD_ID_NPR
		     AND DOG_ID=vZAKAZ.DOG_ID;

	      IF vCNT=0 THEN
	        -- Добавим запись
            INSERT INTO ZAKAZ_TEMP
	          (IS_AGENT,KIND_VALUE,FILIAL_ID,PROD_ID_NPR,DOG_ID,
		       PLAN_PROD,PLAN_DOG)
            SELECT
	          pIS_AGENT,1,vZAKAZ.FILIAL_ID,vZAKAZ.PROD_ID_NPR,vZAKAZ.DOG_ID,
              SUM(NVL(plan_PROD,0)) AS plan_PROD,
              SUM(NVL(plan_DOG,0)) AS plan_DOG
            FROM
            (
            SELECT /* */
              -- План поставок
              PLAN_POST.Prod_id_npr,
              PLAN_POST.plan_ves AS PLAN_PROD,
              DECODE(NVL(PLAN_POST.dog_id,0),vZAKAZ.DOG_ID,PLAN_POST.plan_ves,0) AS PLAN_DOG
            FROM PLAN_PERIODS,PLAN_POST,
            (
             SELECT * FROM v_Kls_planstru
              WHERE /*v_Kls_planstru.IS_SNP=0 -- НЕ СНП
              AND*/ v_Kls_planstru.IS_TO_HRAN=0 -- Без отгрузки на хранение
            ) PS
            WHERE PLAN_POST.Plan_per_id = PLAN_PERIODS.ID
              AND PLAN_POST.Plan_id IN (2,3)  -- Московский план + ОБР
              AND PLAN_PERIODS.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
              AND PLAN_POST.Planstru_id=PS.ID
            ) PP,
            (
            SELECT Link_id_Npr
               FROM v_prod_linked_grp_4
              WHERE fact_id_npr = vZAKAZ.prod_id_npr
            ) Prods
            WHERE Prods.Link_Id_npr =  PP.Prod_id_npr;
	      END IF;

	      /* ПРОДУКТ-ЗАЯВЛЕНО-ОТГРУЖЕНО */
	      -- Найти запись
	      SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
	       WHERE IS_AGENT=pIS_AGENT
	         AND KIND_VALUE=2
		     AND FILIAL_ID=vZAKAZ.FILIAL_ID
		     AND PROD_ID_NPR=vZAKAZ.PROD_ID_NPR
		     AND DOG_ID=vZAKAZ.DOG_ID
		     AND PLAT_ID=vZAKAZ.PLAT_ID;

	      IF vCNT=0 THEN
	        -- Добавим запись
            INSERT INTO ZAKAZ_TEMP
	          (IS_AGENT,KIND_VALUE,FILIAL_ID,PROD_ID_NPR,DOG_ID,PLAT_ID,
		       PROD_NAME,
		       ZAYV_ALL_PROD,ZAYV_ACCEPT_PROD,ZAYV_FACT_PROD,
		       ZAYV_ALL_DOG,ZAYV_ACCEPT_DOG,ZAYV_FACT_DOG,
		       ZAYV_ALL_PLAT,ZAYV_ACCEPT_PLAT,ZAYV_FACT_PLAT)
            SELECT
	          pIS_AGENT,2,vZAKAZ.FILIAL_ID,vZAKAZ.PROD_ID_NPR,vZAKAZ.DOG_ID,vZAKAZ.PLAT_ID,
              Prods.GROUP_NAME_NPR AS PROD_NAME,
              SUM(VES) AS ZAYV_ALL_PROD,
              SUM(DECODE(IS_ACCEPT,1,VES,0)) AS zayv_accept_prod,
              SUM(FACT_VES) AS ZAYV_FACT_PROD,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,VES,0)) AS zayv_all_dog,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,DECODE(IS_ACCEPT,1,VES,0),0)) AS zayv_accept_dog,
              SUM(DECODE(NVL(DOG_ID,0),vZAKAZ.DOG_ID,FACT_VES,0)) AS zayv_fact_dog,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,VES,0)) AS zayv_all_plat,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,DECODE(IS_ACCEPT,1,VES,0),0)) AS zayv_accept_plat,
              SUM(DECODE(NVL(PLAT_ID,0),vZAKAZ.PLAT_ID,FACT_VES,0)) AS zayv_fact_plat
            FROM ZAKAZ mon,
            (
            SELECT Link_id_Npr,GROUP_NAME_NPR
               FROM v_prod_linked_grp_4
              WHERE fact_id_npr = vZAKAZ.prod_id_npr
            ) Prods
            WHERE /*mon.is_agent IN (1,2,3,4,5)
              AND */mon.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
              AND mon.filial_id=vZAKAZ.FILIAL_ID
              AND mon.PROD_ID_NPR=Prods.Link_Id_npr
            GROUP BY Prods.GROUP_NAME_NPR;
	      END IF;
        END IF;
      END LOOP;
	END IF;

    /* ПАРУС */
	IF pIS_AGENT=9 THEN

  	  FOR vZAKAZ_PARUS IN (SELECT DISTINCT
	                    FILIAL_ID,PARUS_NOMEN_TAG,PARUS_DOGOVOR,PARUS_AGENT_TAG
					  FROM ZAKAZ_PARUS
	                 WHERE (PARUS_RN=pZAKAZ_ID OR NVL(pZAKAZ_ID,0)=0)
                       AND Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
				    )
      LOOP
  	    /* ПЛАНЫ */
	    -- Найти запись
	    SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
	     WHERE IS_AGENT=pIS_AGENT
	       AND KIND_VALUE=1
		   AND FILIAL_ID=vZAKAZ_PARUS.FILIAL_ID
		   AND PARUS_NOMEN_TAG=vZAKAZ_PARUS.PARUS_NOMEN_TAG;

	    IF vCNT=0 THEN
	      -- Добавим запись
          INSERT INTO ZAKAZ_TEMP
	        (IS_AGENT,KIND_VALUE,FILIAL_ID,PARUS_NOMEN_TAG,
		     PLAN_NB,PLAN_AZS,PLAN_TRAN,PLAN_VNCORPTR)
          SELECT
	        pIS_AGENT,1,vZAKAZ_PARUS.FILIAL_ID,vZAKAZ_PARUS.PARUS_NOMEN_TAG,
            SUM(NVL(plan_NB,0)) AS plan_NB,
            SUM(NVL(plan_AZS,0)) AS plan_AZS,
            SUM(NVL(plan_TRAN,0)) AS plan_TRAN,
            SUM(NVL(plan_VNCORPTR,0)) AS plan_VNCORPTR
          FROM
          (
          SELECT /* */
            -- План реализации
            PLAN_REALIZ.Prod_id_npr,
            DECODE(NVL(TIP_REAL_ID,0),1,DECODE(ORG_KIND_ID,1,PLAN_REALIZ.VES,0),0) AS PLAN_NB,
            DECODE(NVL(TIP_REAL_ID,0),1,DECODE(ORG_KIND_ID,5,PLAN_REALIZ.VES,0),0) AS PLAN_AZS,
            DECODE(NVL(TIP_REAL_ID,0),2,PLAN_REALIZ.ves,0) AS PLAN_TRAN,
            DECODE(NVL(TIP_REAL_ID,0),3,PLAN_REALIZ.ves,0) AS PLAN_VNCORPTR
          FROM PLAN_REALIZ
          WHERE PLAN_REALIZ.ORG_STRU_ID=vZAKAZ_PARUS.FILIAL_ID
		    AND PLAN_REALIZ.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
          ) PR,
          (
          SELECT Link_id_Npr
             FROM v_prod_linked_grp_4,KLS_PROD_NOMENKLATOR
            WHERE KLS_PROD_NOMENKLATOR.is_actual=1
              AND fact_id_npr = KLS_PROD_NOMENKLATOR.prod
        	  AND KLS_PROD_NOMENKLATOR.MODIF=vZAKAZ_PARUS.PARUS_NOMEN_TAG
          ) Prods
          WHERE Prods.Link_Id_npr =  PR.Prod_id_npr;
        END IF;

	    /* ПРОДУКТ-ЗАЯВЛЕНО-ОТГРУЖЕНО */
	    -- Найти запись
	    SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
	     WHERE IS_AGENT=pIS_AGENT
	       AND KIND_VALUE=2
		   AND FILIAL_ID=vZAKAZ_PARUS.FILIAL_ID
		   AND PARUS_NOMEN_TAG=vZAKAZ_PARUS.PARUS_NOMEN_TAG
		   AND PARUS_DOGOVOR=vZAKAZ_PARUS.PARUS_DOGOVOR
		   AND PARUS_AGENT_TAG=vZAKAZ_PARUS.PARUS_AGENT_TAG;

	    IF vCNT=0 THEN
	      -- Добавим запись
          INSERT INTO ZAKAZ_TEMP
	        (IS_AGENT,KIND_VALUE,FILIAL_ID,PARUS_NOMEN_TAG,PARUS_DOGOVOR,PARUS_AGENT_TAG,
		     PROD_NAME,
		     ZAYV_ALL_PROD,ZAYV_ACCEPT_PROD,ZAYV_FACT_PROD,
		     ZAYV_ALL_DOG,ZAYV_ACCEPT_DOG,ZAYV_FACT_DOG,
		     ZAYV_ALL_PLAT,ZAYV_ACCEPT_PLAT,ZAYV_FACT_PLAT)
          SELECT
	        pIS_AGENT,2,vZAKAZ_PARUS.FILIAL_ID,vZAKAZ_PARUS.PARUS_NOMEN_TAG,vZAKAZ_PARUS.PARUS_DOGOVOR,vZAKAZ_PARUS.PARUS_AGENT_TAG,
            mon.PARUS_NOMEN_NAME AS PROD_NAME,
            SUM(VES) AS ZAYV_ALL_PROD,
            SUM(DECODE(IS_ACCEPT+IS_WORK,2,VES,0)) AS zayv_accept_prod,
            SUM(FACT_VES) AS ZAYV_FACT_PROD,
            SUM(DECODE(PARUS_DOGOVOR,vZAKAZ_PARUS.PARUS_DOGOVOR,VES,0)) AS zayv_all_dog,
            SUM(DECODE(PARUS_DOGOVOR,vZAKAZ_PARUS.PARUS_DOGOVOR,DECODE(IS_ACCEPT+IS_WORK,2,VES,0),0)) AS zayv_accept_dog,
            SUM(DECODE(PARUS_DOGOVOR,vZAKAZ_PARUS.PARUS_DOGOVOR,FACT_VES,0)) AS zayv_fact_dog,
            SUM(DECODE(PARUS_AGENT_TAG,vZAKAZ_PARUS.PARUS_AGENT_TAG,VES,0)) AS zayv_all_plat,
            SUM(DECODE(PARUS_AGENT_TAG,vZAKAZ_PARUS.PARUS_AGENT_TAG,DECODE(IS_ACCEPT+IS_WORK,2,VES,0),0)) AS zayv_accept_plat,
            SUM(DECODE(PARUS_AGENT_TAG,vZAKAZ_PARUS.PARUS_AGENT_TAG,FACT_VES,0)) AS zayv_fact_plat
          FROM ZAKAZ_PARUS mon
          WHERE mon.Date_plan BETWEEN TRUNC(pBEGIN_DATE,'MONTH') AND TRUNC(pEND_DATE,'MONTH')
            AND mon.filial_id=vZAKAZ_PARUS.FILIAL_ID
            AND mon.PARUS_NOMEN_TAG=vZAKAZ_PARUS.PARUS_NOMEN_TAG
          GROUP BY
            mon.PARUS_NOMEN_NAME;
	    END IF;

	    /* ЗАДОЛЖЕННОСТЬ */
		IF vZAKAZ_PARUS.PARUS_DOGOVOR||' '<>' ' THEN
	      -- Найти запись
	      SELECT COUNT(*) INTO vCNT FROM V_ZAKAZ_TEMP
	       WHERE IS_AGENT=pIS_AGENT
	         AND KIND_VALUE=3
		     AND PARUS_DOGOVOR=vZAKAZ_PARUS.PARUS_DOGOVOR;

	      IF vCNT=0 THEN
	        -- Добавим запись
         /*   INSERT INTO ZAKAZ_TEMP
	          (IS_AGENT,KIND_VALUE,PARUS_DOGOVOR,SALDO)
            SELECT
	          pIS_AGENT,3,vZAKAZ_PARUS.PARUS_DOGOVOR,
		      NVL(SUM(-NFACT_INGOOD_SUM+NFACT_OUTGOOD_SUM+NPLAN_OUTSERV_SUM+NFACT_OUTPAY_SUM-NFACT_INPAY_SUM),0) AS SALDO
            FROM parus.V_contracts@oracle.world f
            WHERE TRIM (f.sdoc_pref) || TRIM (f.sdoc_numb)=vZAKAZ_PARUS.PARUS_DOGOVOR;*/
			NULL;
	      END IF;
	  	END IF;
	  END LOOP;
    END IF;

    COMMIT;
  END;

  -- Добавить номер разнарядки к списку
  FUNCTION CHANGE_NOM_ZD(pNOM_ZD_LIST VARCHAR2,pOLD_NOM_ZD VARCHAR2,pNEW_NOM_ZD VARCHAR2) RETURN VARCHAR2 AS
    i NUMBER;
	s VARCHAR2(200);
  BEGIN
    IF pOLD_NOM_ZD||' '<>' ' THEN
      i:=INSTR(pNOM_ZD_LIST,pOLD_NOM_ZD);
	  IF i>0 THEN
	    -- В списке есть старый номер задания - заменим его на новый
		s:=TRIM(REPLACE(pNOM_ZD_LIST,pOLD_NOM_ZD,pNEW_NOM_ZD));
		s:=REPLACE(s,'; ;',';');
		s:=REPLACE(s,';;',';');
		IF s=';' THEN
		  s:='';
		END IF;
		IF SUBSTR(s,1,1)=';' THEN
		  s:=TRIM(SUBSTR(s,2,999));
		END IF;
		RETURN s;
	  END IF;
	END IF;
    IF pNEW_NOM_ZD||' '<>' ' AND LENGTH(pNOM_ZD_LIST||'; '||pNEW_NOM_ZD)<=150 THEN
      -- Добавим новый в конец списка
	  IF pNOM_ZD_LIST||' '<>' ' THEN
	    RETURN pNOM_ZD_LIST||'; '||pNEW_NOM_ZD;
	  ELSE
	    RETURN pNEW_NOM_ZD;
	  END IF;
	END IF;
    RETURN '';
  END;

  -- Присвоить/снять NOM_ZD позиции "К отгрузке"
  PROCEDURE SetNOM_ZD(pCOMMIT NUMBER, pZAKAZ_ID NUMBER, pZAKAZ_HIST_ID NUMBER, pOLD_ZD VARCHAR2, pNEW_ZD VARCHAR2, pLOAD_VES NUMBER, pLOAD_KOL NUMBER, pFACT_VES NUMBER, pFACT_KOL NUMBER) AS
  BEGIN
    IF NVL(pZAKAZ_HIST_ID,0)<>0 THEN
	  -- Есть ссылка на конкретную позицию заказа
	  FOR lcur IN (SELECT ID,LINK_HIST_ID,IS_AUTO_MONTH FROM ZAKAZ_HIST
	                WHERE ID=pZAKAZ_HIST_ID AND STATUS_ZAKAZ_ID=20)
	  LOOP
	    -- Обновляем позиции
	    IF lcur.IS_AUTO_MONTH=1 THEN
	      UPDATE ZAKAZ_HIST SET NOM_ZD=pNEW_ZD,LOAD_VES=pLOAD_VES,LOAD_KOL=pLOAD_KOL,FACT_VES=pFACT_VES,FACT_KOL=pFACT_KOL
	       WHERE ID IN (lcur.ID,lcur.LINK_HIST_ID);
		ELSE
   	      UPDATE ZAKAZ_HIST SET NOM_ZD=pNEW_ZD,FACT_VES=pFACT_VES,FACT_KOL=pFACT_KOL
	       WHERE ID IN (lcur.ID,lcur.LINK_HIST_ID);
	    END IF;
	    -- Удаляем автоматические позиции
        IF pNEW_ZD||' '=' ' AND lcur.IS_AUTO_MONTH=1 THEN
 	  	  BEGIN
		    DelZakazHist(0,lcur.ID);
		  EXCEPTION
		    WHEN OTHERS THEN
			  NULL;
		  END;
		END IF;
	  END LOOP;
	ELSE
      IF pOLD_ZD||' '<>' ' THEN
	    -- Убрать ссылку на со старой разнарядки
	    FOR lcur IN (SELECT ID,LINK_HIST_ID,IS_AUTO_MONTH FROM ZAKAZ_HIST WHERE ZAKAZ_ID=pZAKAZ_ID AND NOM_ZD=pOLD_ZD AND STATUS_ZAKAZ_ID=20)
	    LOOP
  	      -- Обновляем позиции
	      IF lcur.IS_AUTO_MONTH=1 THEN
  	        UPDATE ZAKAZ_HIST SET NOM_ZD=pNEW_ZD,LOAD_VES=pLOAD_VES,LOAD_KOL=pLOAD_KOL,FACT_VES=pFACT_VES,FACT_KOL=pFACT_KOL
	          WHERE ID IN (lcur.ID,lcur.LINK_HIST_ID);
		  ELSE
   	        UPDATE ZAKAZ_HIST SET NOM_ZD=pNEW_ZD,FACT_VES=pFACT_VES,FACT_KOL=pFACT_KOL
	          WHERE ID IN (lcur.ID,lcur.LINK_HIST_ID);
	      END IF;
		  -- Удаляем автоматические позиции
          IF pNEW_ZD||' '=' ' AND lcur.IS_AUTO_MONTH=1 THEN
 	  	    BEGIN
		      DelZakazHist(0,lcur.ID);
		    EXCEPTION
		      WHEN OTHERS THEN
			    NULL;
		    END;
		  END IF;
	  	END LOOP;
      END IF;
	END IF;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  -- Обновить факт исполнения разнарядки ФИНАНСЫ
  PROCEDURE FillFact (pCOMMIT NUMBER, pBEGIN_DATE DATE, pEND_DATE DATE, pNOM_ZD VARCHAR2 DEFAULT NULL) AS
  BEGIN
    -- Обновить факт отгрузки
	UPDATE /*+ ORDERED INDEX(month) */ MONTH SET (TONN_LOADED,CIST_LOADED)=
	  (SELECT NVL(SUM(KVIT.ves_brutto),0),NVL(COUNT(*),0) FROM KVIT
	    WHERE KVIT.nom_zd=MONTH.nom_zd)
	WHERE DATE_PLAN BETWEEN pBEGIN_DATE AND pEND_DATE
	  AND (NOM_ZD=pNOM_ZD OR pNOM_ZD IS NULL);
     -- and (NOM_ZD='1212-36611' or NOM_ZD='1201-46582');
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  -- Обновить факт исполнения разнарядки ФИНАНСЫ для реестра контроля СНП
  PROCEDURE FillFactThisMonth  AS
  BEGIN
    -- Обновить факт отгрузки
	UPDATE /*+ ORDERED INDEX(month) */ MONTH SET (TONN_LOADED,CIST_LOADED)=
	  (SELECT NVL(SUM(KVIT.ves_brutto),0),NVL(COUNT(*),0) FROM KVIT
	    WHERE KVIT.nom_zd=MONTH.nom_zd)
	WHERE DATE_PLAN=TRUNC(SYSDATE,'Month');
    COMMIT;
  END;

  PROCEDURE SetZakazLink(pID NUMBER,pLINK_ID NUMBER,pLINK_HIST_ID NUMBER) AS
  BEGIN
    UPDATE ZAKAZ SET LINK_ID=pLINK_ID, LINK_HIST_ID=pLINK_HIST_ID WHERE ID=pID;
  END;

  PROCEDURE SetZakazHistLink(pID NUMBER,pLINK_ID NUMBER,pLINK_HIST_ID NUMBER) AS
  BEGIN
    UPDATE ZAKAZ_HIST SET LINK_ID=pLINK_ID, LINK_HIST_ID=pLINK_HIST_ID WHERE ID=pID;
  END;

  /* ДОБАВИТЬ/ИЗМЕНИТЬ ЗАКАЗ */
  FUNCTION AddZakaz(pCOMMIT NUMBER, pID NUMBER, pIS_AUTO NUMBER, pIS_AGENT NUMBER, pDATE_PLAN DATE, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pBEGIN_DATE DATE,
	pIS_ACCEPT NUMBER, pFILIAL_ID NUMBER, pPLAT_ID NUMBER, pDOG_ID NUMBER,
	pPROD_ID_NPR VARCHAR2, pUSL_OPL_ID NUMBER, pLOAD_ABBR VARCHAR2, pSTAN_ID NUMBER,
	pVETKA_ID NUMBER, pPOLUCH_ID NUMBER, pPOTREB_ID NUMBER, pPOTREB_NAME VARCHAR2,
	pNEFTEBASA VARCHAR2, pPAYFORM_ID NUMBER, pPLANSTRU_ID NUMBER, pPRICE_CLIENT NUMBER,
	pPRICE NUMBER, pVES NUMBER, pKOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER,
	pPRIM VARCHAR2, pGR4 VARCHAR2, pZAKAZ_PREV_ID NUMBER,pGOSPROG_ID NUMBER,pGP_NAPR_ID NUMBER,
	pLUKDOG_ID NUMBER, pLINK_ID NUMBER, pLINK_HIST_ID NUMBER, pPERIOD_ID NUMBER DEFAULT 1, pTIP_CORP_ID NUMBER DEFAULT 1, pISU_ADD NUMBER DEFAULT 0) RETURN NUMBER AS

	vID NUMBER;
	vHIST_ID NUMBER;
	vOWNER_ZAKAZ NUMBER;
	vOldOWNER_ZAKAZ NUMBER;
	vLINK_ID NUMBER;
	vLINK_HIST_ID NUMBER;
	vLINK_IS_AUTO NUMBER;
	vLINK_HIST_IS_AUTO NUMBER;
	vNUM_1 VARCHAR2(100);
	vNUM_2 VARCHAR2(100);

	vOldDOG_ID NUMBER;
	vOldLUKDOG_ID NUMBER;
	vOldIS_ACCEPT NUMBER;
	vOldCLIENT_NUMBER VARCHAR2(100);
	vOldCLIENT_DATE DATE;
	vOldINPUT_NUMBER VARCHAR2(100);
	vOldINPUT_DATE DATE;

	vNewDOG_ID NUMBER;
	vNewLUKDOG_ID NUMBER;
	vNewIS_ACCEPT NUMBER;
	vNewCLIENT_NUMBER VARCHAR2(100);
	vNewCLIENT_DATE DATE;
	vNewINPUT_NUMBER VARCHAR2(100);
	vNewINPUT_DATE DATE;

	vVES NUMBER;
	vKOL NUMBER;
	vSPEED_VES NUMBER;
	vSPEED_KOL NUMBER;
	vADD NUMBER;
	i NUMBER;
  BEGIN
	vLINK_ID:=pLINK_ID;
	IF NVL(vLINK_ID,0)<=0 THEN
	  vLINK_ID:=NULL;
	END IF;
	vLINK_HIST_ID:=pLINK_HIST_ID;
	IF NVL(vLINK_HIST_ID,0)<=0 THEN
	  vLINK_HIST_ID:=NULL;
	END IF;

    -- ID
	IF NVL(pID,0)<=0 THEN
	  vADD:=1;
      SELECT SEQ_MONTH_ALL.NEXTVAL INTO vID FROM DUAL;
	  IF pIS_AUTO=0 THEN
	    vLINK_ID:=NULL;
	    vLINK_HIST_ID:=NULL;
	  END IF;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;
    
    IF pISU_ADD=1 THEN
      vADD:=pISU_ADD;
    END IF;  

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ DOG_ID,LUKDOG_ID,IS_ACCEPT,CLIENT_NUMBER,CLIENT_DATE,INPUT_NUMBER,INPUT_DATE
        INTO vOldDOG_ID,vOldLUKDOG_ID,vOldIS_ACCEPT,vOldCLIENT_NUMBER,vOldCLIENT_DATE,vOldINPUT_NUMBER,vOldINPUT_DATE
	 	FROM ZAKAZ
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Заказ нельзя отредактировать - он удален!');
		END IF;
  	    vOldDOG_ID:=pDOG_ID;
        vOldLUKDOG_ID:=pLUKDOG_ID;
		vOldIS_ACCEPT:=pIS_ACCEPT;
		vOldCLIENT_NUMBER:=pCLIENT_NUMBER;
		vOldCLIENT_DATE:=pCLIENT_DATE;
		vOldINPUT_NUMBER:=pINPUT_NUMBER;
		vOldINPUT_DATE:=pINPUT_DATE;
	END;

	IF pDOG_ID=-1 THEN
	  -- Необходимо сохранить договор
  	  vNewDOG_ID:=vOldDOG_ID;
	ELSE
  	  vNewDOG_ID:=pDOG_ID;
	END IF;
	IF NVL(vNewDOG_ID,0)<=0 THEN
	  vNewDOG_ID:=NULL;
	END IF;
	IF NVL(vOldDOG_ID,0)<=0 THEN
	  vOldDOG_ID:=NULL;
	END IF;

	IF pLUKDOG_ID=-1 THEN
	  -- Необходимо сохранить договор
  	  vNewLUKDOG_ID:=vOldLUKDOG_ID;
	ELSE
  	  vNewLUKDOG_ID:=pLUKDOG_ID;
	END IF;
	IF NVL(vNewLUKDOG_ID,0)<=0 THEN
	  vNewLUKDOG_ID:=NULL;
	END IF;
	IF NVL(vOldLUKDOG_ID,0)<=0 THEN
	  vOldLUKDOG_ID:=NULL;
	END IF;

	IF pCLIENT_NUMBER='-1' THEN
	  -- Необходимо сохранить
	  vNewCLIENT_NUMBER:=vOldCLIENT_NUMBER;
  	  vNewCLIENT_DATE:=vOldCLIENT_DATE;
	ELSE
  	  vNewCLIENT_NUMBER:=pCLIENT_NUMBER;
  	  vNewCLIENT_DATE:=pCLIENT_DATE;
	END IF;

    IF vNewCLIENT_NUMBER||' '=' ' OR vNewCLIENT_NUMBER='-1' THEN
	  vNewCLIENT_NUMBER:='?';
	END IF;
  	vNewCLIENT_DATE:=NVL(vNewCLIENT_DATE,TRUNC(SYSDATE));

	IF pINPUT_NUMBER='-1' THEN
	  -- Необходимо сохранить
	  vNewINPUT_NUMBER:=vOldINPUT_NUMBER;
  	  vNewINPUT_DATE:=vOldINPUT_DATE;
	ELSE
  	  vNewINPUT_NUMBER:=pINPUT_NUMBER;
  	  vNewINPUT_DATE:=pINPUT_DATE;
	END IF;
	IF vNewINPUT_NUMBER||' '=' ' OR vNewINPUT_NUMBER='-1' THEN
	  vNewINPUT_NUMBER:='?';
	END IF;
  	vNewINPUT_DATE:=NVL(vNewINPUT_DATE,TRUNC(SYSDATE));

	IF pIS_ACCEPT=-1 THEN
	  -- Необходимо сохранить
  	  vNewIS_ACCEPT:=vOldIS_ACCEPT;
	ELSE
  	  vNewIS_ACCEPT:=pIS_ACCEPT;
	END IF;
	IF vNewIS_ACCEPT=-1 OR vNewIS_ACCEPT IS NULL THEN
	  vNewIS_ACCEPT:=0;
	END IF;
	IF vOldINPUT_NUMBER='?' AND vNewINPUT_NUMBER<>'?' AND pIS_AGENT=1 THEN
	  vNewIS_ACCEPT:=1;
	END IF;
	IF vOldINPUT_NUMBER<>'?' AND vNewINPUT_NUMBER='?' AND pIS_AGENT=1 THEN
	  vNewIS_ACCEPT:=0;
	END IF;

  	-- По умолчанию
	IF vAdd=1 AND pIS_AGENT=1 AND vNewINPUT_NUMBER<>'?' THEN
	  vNewIS_ACCEPT:=1;
	ELSE
	  vNewIS_ACCEPT:=vNewIS_ACCEPT;
	END IF;

	IF pIS_AGENT=1 THEN
	  -- Если это заказы УНП

      -- Определение старого владельца заказа (1-УНП, 2-СНП)
      vOldOWNER_ZAKAZ:=pIS_AGENT;
  	  IF vOldDOG_ID IS NOT NULL THEN
        BEGIN
          SELECT IS_AGENT INTO vOldOWNER_ZAKAZ
	        FROM KLS_DOG_MAIN
  	       WHERE pDATE_PLAN BETWEEN FROM_DATE AND TO_DATE
		     AND (DOG_ID=vOldDOG_ID OR HRAN_DOG_ID=vOldDOG_ID)
		     AND IS_AGENT=2;
   	    EXCEPTION
	      WHEN OTHERS THEN
		    vOldOWNER_ZAKAZ:=pIS_AGENT;
 	    END;
      END IF;

      -- Определение нового владельца заказа (1-УНП, 2-СНП)
      vOWNER_ZAKAZ:=pIS_AGENT;
  	  IF vNewDOG_ID IS NOT NULL THEN
        BEGIN
	      SELECT IS_AGENT INTO vOWNER_ZAKAZ
		    FROM KLS_DOG_MAIN
		   WHERE pDATE_PLAN BETWEEN FROM_DATE AND TO_DATE
		     AND (DOG_ID=vNewDOG_ID OR HRAN_DOG_ID=vNewDOG_ID)
		     AND IS_AGENT=2;
   	    EXCEPTION
	      WHEN OTHERS THEN
		    vOWNER_ZAKAZ:=pIS_AGENT;
 	    END;
	  END IF;

	  IF vOWNER_ZAKAZ<>vOldOWNER_ZAKAZ THEN
	    -- Изменился владелец договора (СНП <-> УНП)
        RaiseError('Нельзя менять договор - удалите заказ и создайте повторно с новым договором!');
	  END IF;
	END IF;

	-- Обновляем заказ
	UPDATE ZAKAZ SET (CLIENT_NUMBER, CLIENT_DATE,
	    INPUT_NUMBER, INPUT_DATE, BEGIN_DATE, IS_ACCEPT, FILIAL_ID, PLAT_ID,
		DOG_ID, PROD_ID_NPR, USL_OPL_ID, LOAD_ABBR, STAN_ID, VETKA_ID,
		POLUCH_ID, POTREB_ID, POTREB_NAME, NEFTEBASA, PAYFORM_ID, PLANSTRU_ID,
		PRICE_CLIENT, PRICE, VES, KOL, SPEED_VES, SPEED_KOL,
		PRIM, GR4, ZAKAZ_PREV_ID,GOSPROG_ID,GP_NAPR_ID,LUKDOG_ID,LINK_ID,LINK_HIST_ID, PERIOD_ID, TIP_CORP_ID)=
	  (SELECT vNewCLIENT_NUMBER, vNewCLIENT_DATE,
	    vNewINPUT_NUMBER, vNewINPUT_DATE, pBEGIN_DATE, vNewIS_ACCEPT, pFILIAL_ID, pPLAT_ID,
		vNewDOG_ID, pPROD_ID_NPR, pUSL_OPL_ID, pLOAD_ABBR, pSTAN_ID, pVETKA_ID,
		pPOLUCH_ID, pPOTREB_ID, pPOTREB_NAME, pNEFTEBASA, pPAYFORM_ID, pPLANSTRU_ID,
		pPRICE_CLIENT, pPRICE, pVES, pKOL, pSPEED_VES, pSPEED_KOL,
		pPRIM, pGR4, pZAKAZ_PREV_ID,pGOSPROG_ID,pGP_NAPR_ID,vNewLUKDOG_ID,vLINK_ID,vLINK_HIST_ID, pPERIOD_ID, pTIP_CORP_ID FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем заказ
      INSERT INTO ZAKAZ (ID, IS_AGENT, IS_AUTO, DATE_PLAN, CLIENT_NUMBER, CLIENT_DATE,
	    INPUT_NUMBER, INPUT_DATE, BEGIN_DATE, IS_ACCEPT, FILIAL_ID, PLAT_ID,
		DOG_ID, PROD_ID_NPR, USL_OPL_ID, LOAD_ABBR, STAN_ID, VETKA_ID,
		POLUCH_ID, POTREB_ID, POTREB_NAME, NEFTEBASA, PAYFORM_ID, PLANSTRU_ID,
		PRICE_CLIENT, PRICE, VES, KOL, SPEED_VES, SPEED_KOL,
		PRIM, GR4, ZAKAZ_PREV_ID,GOSPROG_ID,GP_NAPR_ID,LUKDOG_ID,LINK_ID,LINK_HIST_ID, PERIOD_ID, TIP_CORP_ID)
	  VALUES (vID, pIS_AGENT, pIS_AUTO, pDATE_PLAN, vNewCLIENT_NUMBER, vNewCLIENT_DATE,
	    vNewINPUT_NUMBER, vNewINPUT_DATE, pBEGIN_DATE, vNewIS_ACCEPT, pFILIAL_ID, pPLAT_ID,
		vNewDOG_ID, pPROD_ID_NPR, pUSL_OPL_ID, pLOAD_ABBR, pSTAN_ID, pVETKA_ID,
		pPOLUCH_ID, pPOTREB_ID, pPOTREB_NAME, pNEFTEBASA, pPAYFORM_ID, pPLANSTRU_ID,
		pPRICE_CLIENT, pPRICE, pVES, pKOL, pSPEED_VES, pSPEED_KOL,
		pPRIM, pGR4, pZAKAZ_PREV_ID,pGOSPROG_ID,pGP_NAPR_ID,vNewLUKDOG_ID,vLINK_ID,vLINK_HIST_ID, pPERIOD_ID, pTIP_CORP_ID);
	END IF;

    IF pIS_AUTO=0 THEN
	  -- Если добавление/обновление заказа - НЕ автоматическое

	  IF pIS_AGENT=2 THEN
        -- Если заказ добавляется/обновляется в Заказах СНП
	    -- Больше ничего не делаем
	    NULL;
	  END IF;

	  IF pIS_AGENT=1 THEN
  	    -- Если заказ добавляется/обновляется в Заказах УНП

        IF vOWNER_ZAKAZ=2 AND pDATE_PLAN>=TO_DATE('01.01.2005','dd.mm.yyyy') THEN
          
  	      vHIST_ID:=NULL;
          IF pDATE_PLAN<TO_DATE('01.04.2008','dd.mm.yyyy') THEN -- до интерфейса с ИСУ
  	        -- Если владелец заказов - СНП, то попробуем восстановить позицию заказа, для обеспечения
            -- корректных ссылок 

  		    -- Ищем позицию "К отгрузке"
		    BEGIN
		      SELECT LINK_HIST_ID INTO vHIST_ID
			    FROM ZAKAZ_HIST
			   WHERE LINK_ID=vID -- позиция СНП ссылается на редактируемый заказ
			     AND ID=vLINK_HIST_ID -- редактируемый заказ ссылается на позицию СНП
			     AND ZAKAZ_ID=vLINK_ID -- редактируемый заказ ссылается на позицию СНП
			     AND STATUS_ZAKAZ_ID=20;
		    EXCEPTION
		      WHEN OTHERS THEN
			    vLINK_HIST_ID:=NULL;
			    vHIST_ID:=NULL;
		    END;

		    IF vHIST_ID IS NOT NULL THEN
		      -- Проверяем
		      BEGIN
		        SELECT ID INTO vHIST_ID
			      FROM ZAKAZ_HIST
			     WHERE ID=vHIST_ID -- искомая позиция
			       AND ZAKAZ_ID=vID -- редактируемый заказ
			       AND STATUS_ZAKAZ_ID=20;
		      EXCEPTION
		        WHEN OTHERS THEN
			      vHIST_ID:=NULL;
		      END;
		    END IF;

		    IF vHIST_ID IS NULL THEN
		      -- Ищем первую позицию
		      FOR lcur IN (SELECT ID FROM ZAKAZ_HIST
			              WHERE ZAKAZ_ID=vID -- позиции редактируемого заказа
                            AND STATUS_ZAKAZ_ID=20
						 ORDER BY ID)
			  LOOP
			    vHIST_ID:=lcur.ID;
			    EXIT;
			  END LOOP;
		    END IF;

		    IF vHIST_ID IS NULL THEN
		      -- Позиций "К отгрузке" нет - добавляем
              vHIST_ID:=ToLoadZakaz(0,vID,pIS_AUTO,NULL,vNewINPUT_DATE,pBEGIN_DATE,pPROD_ID_NPR,
			                      pSTAN_ID,pPOLUCH_ID,pPOTREB_ID,pPRICE,NULL,pVES, pKOL, pSPEED_VES, pSPEED_KOL,0,0,
								  NULL);
			  IF NVL(vHIST_ID,0)<=0 THEN
			    vHIST_ID:=NULL;
			  END IF;
		    END IF;
          END IF;
          
	      -- Проверяем заказ СНП и его позицию
		  IF NOT ZakazExist(vLINK_ID,vLINK_IS_AUTO) THEN
	        -- Проверяем заказ СНП
		     vLINK_ID:=NULL;
	      END IF;

          IF vLINK_ID IS NULL OR
		    NOT ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
	        -- Проверяем позцию заказа СНП
			vLINK_HIST_ID:=NULL;
		  END IF;

		  vNUM_1:=SUBSTR(vNewCLIENT_NUMBER,1,INSTR(vNewCLIENT_NUMBER,'/')-1);
		  vNUM_2:=SUBSTR(vNewCLIENT_NUMBER,INSTR(vNewCLIENT_NUMBER,'/')+1,999);
		  IF vLINK_ID IS NULL THEN
	        -- Если связанного заказа нет - Добавляем
			vLINK_ID:=AddZakaz(0,NULL,1,2,pDATE_PLAN,NULL,NULL,vNUM_1,vNewCLIENT_DATE,
			          pBEGIN_DATE,0,pFILIAL_ID,pPLAT_ID,NULL,pPROD_ID_NPR,pUSL_OPL_ID,pLOAD_ABBR,pSTAN_ID,
	                  pVETKA_ID,pPOLUCH_ID,pPOTREB_ID,pPOTREB_NAME,
	                  pNEFTEBASA,pPAYFORM_ID,pPLANSTRU_ID,NULL,NULL,pVES,pKOL,pSPEED_VES,pSPEED_KOL,
	                  pPRIM,pGR4,NULL,pGOSPROG_ID,pGP_NAPR_ID,vNewDOG_ID,NULL,NULL, pPERIOD_ID, pTIP_CORP_ID);
		  ELSE
		    -- Если связанный заказ есть - проверяем, был ли он добавлен автоматически
			IF vLINK_IS_AUTO=1 THEN
			  -- Если автоматически - обновляем
  			  -- vLINK_ID:=AddZakaz(COMMIT=0, ID=vLINK_ID, IS_AUTO=1,LINK_ID=NULL,LINK_HIST_ID=NULL,DOG_ID=-1,LUKDOG_ID=pDOG_ID);
			  NULL;
			ELSE
			  -- Если вручную - ничего не делаем
			  NULL;
			END IF;
		  END IF;
		  IF NVL(vLINK_ID,0)<=0 THEN
			vLINK_ID:=NULL;
		  END IF;

		  IF vLINK_HIST_ID IS NULL AND vLINK_ID IS NOT NULL THEN
	        -- Если связанной позиции заказа нет - Добавляем
			vLINK_HIST_ID:=AddZakazHist(0,NULL,1,0,vLINK_ID,20,vNUM_1,vNewCLIENT_DATE,
                           vNUM_2, vNewCLIENT_DATE, pPROD_ID_NPR, NULL, pSTAN_ID,
						   pPOLUCH_ID, pPOTREB_ID, pPRICE, 0, 0, pSPEED_VES, pSPEED_KOL,
						   NULL, pVES, pKOL, 0, 0, NULL, pBEGIN_DATE, vID, vHIST_ID);
		  ELSE
		    -- Если связанная позиция заказа есть - проверяем, был ли она добавлена автоматически
			IF vLINK_HIST_IS_AUTO=1 THEN
			  -- Если автоматически - обновляем
  			  -- vLINK_HIST_ID:=AddZakazHist(COMMIT=0, ID=vLINK_HIST_ID, IS_AUTO=1,LINK_ID=vID,LINK_HIST_ID=vHIST_ID);
			  NULL;
			ELSE
			  -- Если вручную - ничего не делаем
			  NULL;
		  	END IF;
		  END IF;
		  IF NVL(vLINK_HIST_ID,0)<=0 THEN
			vLINK_HIST_ID:=NULL;
		  END IF;

		  -- Проставляем связи в редактируемом заказе
		  SetZakazLink(vID,vLINK_ID,vLINK_HIST_ID);
		  SetZakazHistLink(vHIST_ID,vLINK_ID,vLINK_HIST_ID);
	    ELSE
	      -- Если владелец заказов - УНП
		  -- больше ничего не делаем
	  	  NULL;
	    END IF;
	  END IF;
	END IF;

	-- Обновляем номер в позициях "К отгрузке"
	FOR lcur IN (SELECT ID FROM ZAKAZ_HIST WHERE ZAKAZ_ID=vID AND STATUS_ZAKAZ_ID=20)
	LOOP
	  UPDATE ZAKAZ_HIST SET CLIENT_NUMBER=vNewINPUT_NUMBER WHERE ID=lcur.ID;
	  i:=GetMaxNum(vID);
	  UPDATE ZAKAZ_HIST SET INPUT_NUMBER=TO_CHAR(i+1)
	   WHERE ID=lcur.ID AND CLIENT_NUMBER<>'?' AND INPUT_NUMBER='?';
	END LOOP;

	-- Обновляем позицию "Первоначальная"
	vHIST_ID:=NULL;
	vVES:=pVES;
	vKOL:=pKOL;
	vSPEED_VES:=pSPEED_VES;
	vSPEED_KOL:=pSPEED_KOL;
	FOR lcur IN (SELECT ID,VES,KOL,SPEED_VES,SPEED_KOL FROM ZAKAZ_HIST WHERE ZAKAZ_ID=vID AND STATUS_ZAKAZ_ID=10)
	LOOP
	  vHIST_ID:=lcur.ID;
	  vVES:=lcur.VES;
	  vKOL:=lcur.KOL;
	  vSPEED_VES:=lcur.SPEED_VES;
	  vSPEED_KOL:=lcur.SPEED_KOL;
	END LOOP;
    vHIST_ID:=For_Zakaz.AddZakazHist(0,vHIST_ID,1,1,vID,10,vNewCLIENT_NUMBER,
	      vNewCLIENT_DATE, vNewINPUT_NUMBER, vNewINPUT_DATE, pPROD_ID_NPR,
		  NULL, pSTAN_ID, pPOLUCH_ID, pPOTREB_ID,pPRICE, vVES, vKOL,
		  vSPEED_VES, vSPEED_KOL, '',0,0,0,0,NULL,pBEGIN_DATE,NULL,NULL);

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* УДАЛИТЬ ЗАКАЗ */
  PROCEDURE DelZakaz(pCOMMIT NUMBER, pID NUMBER, pIS_AUTO NUMBER DEFAULT 0) AS
    vLINK_ID NUMBER;
	vLINK_HIST_ID NUMBER;
	vIS_AUTO NUMBER;
	vIS_AGENT NUMBER;
	vLINK_IS_AUTO NUMBER;
	vLINK_HIST_IS_AUTO NUMBER;
    vDATE_PLAN DATE;
  BEGIN

	BEGIN
	  SELECT LINK_ID,LINK_HIST_ID,IS_AUTO,IS_AGENT,DATE_PLAN
	    INTO vLINK_ID,vLINK_HIST_ID,vIS_AUTO,vIS_AGENT,vDATE_PLAN
		FROM ZAKAZ
	   WHERE ID=pID;
	EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	    RETURN;
	END;

    -- проверка на наличие позиций IS_AUTO=0
	FOR lcur IN (SELECT NULL FROM ZAKAZ_HIST WHERE ZAKAZ_ID=pID
	                AND IS_AUTO=0)
	LOOP
      -- Есть такие позиции
	  IF vIS_AGENT=1 THEN
	    RaiseError('Удалите позиции из истории заказа в заказах ЛУКОЙЛ-УНП!');
	  ELSE
	    RaiseError('Удалите позиции из истории заказа!');
	  END IF;
	END LOOP;

    -- проверка на наличие позиций NOM_ZD is not NULL
	FOR lcur IN (SELECT NULL FROM ZAKAZ_HIST WHERE ZAKAZ_ID=pID
	                AND NOM_ZD IS NOT NULL)
	LOOP
      -- Есть такие позиции
 	  RaiseError('В истории заказа есть позиция "К отгрузке", привязанная к заданию из Комплекса ФИНАНСЫ - удалите вначале эту позицию!');
	END LOOP;

	IF pIS_AUTO=0 THEN
	  -- Заказ удаляется вручную
	  IF vIS_AGENT=1 AND
	     ZakazExist(vLINK_ID,vLINK_IS_AUTO) AND
	     ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
		-- Заказ СНП в заказах УНП
		IF vIS_AUTO=1 THEN
		  -- Удаляемый заказ создан автоматически
		  RaiseError('Заказ создан ЛУКОЙЛ-СНП и может быть удален только владельцем заказа!');
		ELSE
		  -- Удаляемый заказ создан НЕ автоматически
		  IF vLINK_HIST_IS_AUTO=0 AND vDATE_PLAN<TO_DATE('01.04.2008','dd.mm.yyyy') THEN
		    -- Связанный заказ добавлен НЕ автоматически
		    RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		  END IF;
		END IF;
	  END IF;

  	  -- Удаляем автоматические позиций заказа
      FOR lcur IN (SELECT ID FROM ZAKAZ_HIST WHERE ZAKAZ_ID=pID)
	  LOOP
	    DelZakazHist(0,lcur.ID,pIS_AUTO);
 	  END LOOP;
	END IF;

    DELETE FROM ZAKAZ WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  END;

  -- Проверка наличия заказа
  FUNCTION ZakazExist(pID IN OUT NUMBER, pIS_AUTO IN OUT NUMBER) RETURN BOOLEAN AS
    vRes BOOLEAN;
  BEGIN
	pIS_AUTO:=1;
	vRes:=FALSE;
	IF pID IS NOT NULL THEN
	  -- Проверяем заказ
      BEGIN
        SELECT ID,IS_AUTO INTO pID,pIS_AUTO
 	      FROM ZAKAZ WHERE ID=pID;
		vRes:=TRUE;
	  EXCEPTION
		WHEN OTHERS THEN
		  pID:=NULL;
		  pIS_AUTO:=NULL;
		  vRes:=FALSE;
      END;
    END IF;
    RETURN vRes;
  END;

  -- Проверка наличия позиции заказа
  FUNCTION ZakazHistExist(pID IN OUT NUMBER, pIS_AUTO IN OUT NUMBER) RETURN BOOLEAN AS
    vRes BOOLEAN;
  BEGIN
	pIS_AUTO:=1;
	vRes:=FALSE;
	IF pID IS NOT NULL THEN
	  -- Проверяем заказ
      BEGIN
        SELECT ID,IS_AUTO INTO pID,pIS_AUTO
 	      FROM ZAKAZ_HIST WHERE ID=pID;
		vRes:=TRUE;
	  EXCEPTION
		WHEN OTHERS THEN
		  pID:=NULL;
		  pIS_AUTO:=NULL;
		  vRes:=FALSE;
      END;
    END IF;
    RETURN vRes;
  END;

  /* ИНИЦИИРОВАТЬ ОБНОВЛЕНИЕ ЗАКАЗА */
  PROCEDURE RefreshZakazHist(pCOMMIT NUMBER, pID NUMBER, pIS_AUTO NUMBER DEFAULT 0) AS
    v_zakaz_hist ZAKAZ_HIST%ROWTYPE;
	vID NUMBER;
  BEGIN
    
    -- Считываем заказ
	SELECT * INTO v_zakaz_hist
	  FROM ZAKAZ_HIST
	 WHERE ID=pID;
	 
    vID:=AddZakazHist(pCOMMIT, pID, pIS_AUTO, v_zakaz_hist.SORTBY, v_zakaz_hist.ZAKAZ_ID, 
	   v_zakaz_hist.STATUS_ZAKAZ_ID, v_zakaz_hist.CLIENT_NUMBER,
       v_zakaz_hist.CLIENT_DATE, v_zakaz_hist.INPUT_NUMBER, v_zakaz_hist.INPUT_DATE, 
	   v_zakaz_hist.PROD_ID_NPR, v_zakaz_hist.OLD_STAN_ID, v_zakaz_hist.STAN_ID, 
	   v_zakaz_hist.POLUCH_ID, v_zakaz_hist.POTREB_ID, v_zakaz_hist.PRICE, 
	   v_zakaz_hist.VES, v_zakaz_hist.KOL, v_zakaz_hist.SPEED_VES, v_zakaz_hist.SPEED_KOL,
	   v_zakaz_hist.NOM_ZD,	v_zakaz_hist.LOAD_VES, v_zakaz_hist.LOAD_KOL, 
	   v_zakaz_hist.FACT_VES, v_zakaz_hist.FACT_KOL, v_zakaz_hist.GU12_A_ID, 
	   v_zakaz_hist.BEGIN_DATE, v_zakaz_hist.LINK_ID, v_zakaz_hist.LINK_HIST_ID);
	   
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  RETURN;
  END;	
  
  
  /* ДОБАВИТЬ/ИЗМЕНИТЬ ПОЗИЦИЮ ЗАКАЗА */
  FUNCTION AddZakazHist(pCOMMIT NUMBER, pID NUMBER, pIS_AUTO NUMBER, pSORTBY NUMBER, pZAKAZ_ID NUMBER, pSTATUS_ZAKAZ_ID NUMBER, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pPROD_ID_NPR VARCHAR2,
	pOLD_STAN_ID NUMBER, pSTAN_ID NUMBER, pPOLUCH_ID NUMBER, pPOTREB_ID NUMBER, pPRICE NUMBER, pVES NUMBER,
	pKOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER, pNOM_ZD VARCHAR2,
	pLOAD_VES NUMBER, pLOAD_KOL NUMBER, pFACT_VES NUMBER, pFACT_KOL NUMBER,
	pGU12_A_ID NUMBER,  pBEGIN_DATE DATE,pLINK_ID NUMBER, pLINK_HIST_ID NUMBER, pKOD_ISU VARCHAR2 DEFAULT '*', pISU_ADD NUMBER DEFAULT 0) RETURN NUMBER AS

	vID NUMBER;
	vSORTBY NUMBER;
	vLINK_ID NUMBER;
	vLINK_HIST_ID NUMBER;
    v_zakaz ZAKAZ%ROWTYPE;
	vLINK_IS_AUTO NUMBER;
	vLINK_HIST_IS_AUTO NUMBER;
	vOWNER_ZAKAZ NUMBER;
	vCLIENT_NUMBER VARCHAR2(100);
	vCLIENT_DATE DATE;
	vINPUT_NUMBER VARCHAR2(100);
	vINPUT_DATE DATE;
	vAdd NUMBER;
	vAGENT_ID NUMBER;
	DOG_IS_AGENT NUMBER;
	vIsReg BOOLEAN;
	vNOM_ZD MONTH.NOM_ZD%TYPE;
  BEGIN
	vLINK_ID:=pLINK_ID;
	IF NVL(vLINK_ID,0)<=0 THEN
	  vLINK_ID:=NULL;
	END IF;
	vLINK_HIST_ID:=pLINK_HIST_ID;
	IF NVL(vLINK_HIST_ID,0)<=0 THEN
	  vLINK_HIST_ID:=NULL;
	END IF;

    -- ID
	IF NVL(pID,0)<=0 THEN
      SELECT SEQ_MONTH_ALL.NEXTVAL INTO vID FROM DUAL;
	  vADD:=1;
	  IF pIS_AUTO=0 THEN
	    vLINK_ID:=NULL;
	    vLINK_HIST_ID:=NULL;
	  END IF;
	ELSE
	  vID:=pID;
	  vADD:=0;
	END IF;

    IF pISU_ADD=1 THEN
      vADD:=pISU_ADD;
    END IF;  

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ ID
        INTO v_zakaz.ID
	 	FROM ZAKAZ
	   WHERE ID=pZAKAZ_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('Заказ удален!');
	END;
	BEGIN
	  SELECT /*+ RULE */ ID
        INTO vID
	 	FROM ZAKAZ_HIST
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Позицию заказа нельзя отредактировать - она удалена!');
		END IF;
	END;

	-- Определяем SORTBY
	IF NVL(pSORTBY,0)<=0 THEN
	  BEGIN
	    SELECT NVL(MAX(SORTBY),0) INTO vSORTBY FROM ZAKAZ_HIST WHERE ZAKAZ_ID=pZAKAZ_ID;
	  EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	      vSORTBY:=0;
	  END;
	  vSORTBY:=vSORTBY+1;
	ELSE
	  vSORTBY:=pSORTBY;
	END IF;

    -- Считываем заказ
	SELECT * INTO v_zakaz
	  FROM ZAKAZ
	 WHERE ID=pZAKAZ_ID;

	vINPUT_NUMBER:=pINPUT_NUMBER;
	IF pINPUT_NUMBER||' '=' ' THEN
	  IF pSTATUS_ZAKAZ_ID=20 THEN
	    vINPUT_NUMBER:=TO_CHAR(For_Zakaz.GetMaxNum(pZAKAZ_ID)+1);
	  ELSE
	    vINPUT_NUMBER:='?';
	  END IF;
	END IF;
  	vINPUT_DATE:=NVL(pINPUT_DATE,TRUNC(SYSDATE));
	
	vNOM_ZD:=pNOM_ZD;

	-- Проставляем ссылку на заказ УНП в разнарядке на отгрузку
	IF v_zakaz.IS_AGENT=1 AND pSTATUS_ZAKAZ_ID=20 AND vNOM_ZD||' '<>' ' THEN
	  BEGIN
	    UPDATE MONTH SET ZAKAZ_HIST_ID=vID WHERE NOM_ZD=vNOM_ZD;
	  EXCEPTION
	    WHEN OTHERS THEN
		  NULL;
	  END;
	END IF;

	-- Данные договора 
    BEGIN
	  SELECT IS_AGENT,AGENT_ID INTO DOG_IS_AGENT,vAGENT_ID
		  FROM KLS_DOG
		 WHERE ID=v_zakaz.LUKDOG_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vAGENT_ID:=NULL;
		DOG_IS_AGENT:=NULL;
	END;
		
	-- Обновляем позицию
	UPDATE ZAKAZ_HIST SET (SORTBY, CLIENT_NUMBER,
	      CLIENT_DATE, INPUT_NUMBER, INPUT_DATE, PROD_ID_NPR, OLD_STAN_ID, STAN_ID,
		  POLUCH_ID, POTREB_ID, PRICE, VES, KOL,SPEED_VES,SPEED_KOL,
		  NOM_ZD, LOAD_VES, LOAD_KOL, GU12_A_ID, BEGIN_DATE,
		  LINK_ID,LINK_HIST_ID)=
	    (SELECT vSORTBY, pCLIENT_NUMBER,
	      pCLIENT_DATE, vINPUT_NUMBER, vINPUT_DATE, pPROD_ID_NPR, DECODE(pOLD_STAN_ID,0,NULL,pOLD_STAN_ID), pSTAN_ID,
		  pPOLUCH_ID, pPOTREB_ID, pPRICE, pVES, pKOL,pSPEED_VES,pSPEED_KOL,
		  vNOM_ZD, pLOAD_VES, pLOAD_KOL, DECODE(pGU12_A_ID,0,NULL,pGU12_A_ID), pBEGIN_DATE,
		  vLINK_ID,vLINK_HIST_ID FROM dual)
	 WHERE ID=vID;
   
	IF v_zakaz.IS_AGENT=2 and pSTATUS_ZAKAZ_ID=20 AND DOG_IS_AGENT=8 AND vAGENT_ID<>8 AND vAGENT_ID<>4175 THEN
	  -- Заказы по поставкам с других НПЗ  
	  vNOM_ZD:=pCLIENT_NUMBER;
  	  UPDATE ZAKAZ_HIST SET (NOM_ZD, FACT_VES, FACT_KOL)=
	    (SELECT vNOM_ZD,NVL(pFACT_VES,0), NVL(pFACT_KOL,0) FROM dual)
  	   WHERE ID=vID;
	END IF;   
	 
	IF SQL%NOTFOUND THEN
  	  -- Добавляем позицию
      INSERT INTO ZAKAZ_HIST (ID, ZAKAZ_ID, SORTBY, STATUS_ZAKAZ_ID, CLIENT_NUMBER,
	      CLIENT_DATE, INPUT_NUMBER, INPUT_DATE, PROD_ID_NPR, OLD_STAN_ID, STAN_ID,
		  POLUCH_ID, POTREB_ID, PRICE, VES, KOL,SPEED_VES,SPEED_KOL,
		  NOM_ZD, LOAD_VES, LOAD_KOL, FACT_VES, FACT_KOL, GU12_A_ID,IS_AUTO, BEGIN_DATE,
		  LINK_ID,LINK_HIST_ID)
	  VALUES (vID,pZAKAZ_ID, vSORTBY, pSTATUS_ZAKAZ_ID, pCLIENT_NUMBER,
	      pCLIENT_DATE, vINPUT_NUMBER, vINPUT_DATE, pPROD_ID_NPR, pOLD_STAN_ID, pSTAN_ID,
		  pPOLUCH_ID, pPOTREB_ID, pPRICE, pVES, pKOL,pSPEED_VES,pSPEED_KOL,
		  vNOM_ZD, pLOAD_VES, pLOAD_KOL, pFACT_VES, pFACT_KOL, pGU12_A_ID, pIS_AUTO, pBEGIN_DATE,
		  vLINK_ID,vLINK_HIST_ID);
	END IF;

    IF pKOD_ISU<>'*' THEN
      UPDATE ZAKAZ_HIST SET KOD_ISU=pKOD_ISU WHERE ID=vID;
    END IF;    
    
    IF pIS_AUTO=0 AND pSTATUS_ZAKAZ_ID=20 THEN
	  -- Если добавление/обновление позиции "К отгрузке" - НЕ автоматическое

	  IF v_zakaz.IS_AGENT=2 AND v_zakaz.DATE_PLAN>=TO_DATE('01.01.2005','dd.mm.yyyy') AND v_zakaz.DATE_PLAN<TO_DATE('01.04.2008','dd.mm.yyyy') AND (vAGENT_ID=8 or vAGENT_ID=4175) THEN
        -- Если позиция добавляется/обновляется в Заказах СНП
        -- Проверяем заказ УНП и его позицию
		IF NOT ZakazExist(vLINK_ID,vLINK_IS_AUTO) THEN
	      -- Проверяем заказ УНП
		  vLINK_ID:=NULL;
		ELSE
		  IF vLINK_IS_AUTO=0 THEN
            RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		  END IF;
	    END IF;

        IF vLINK_ID IS NULL THEN
		  IF NOT ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
	        -- Проверяем позцию заказа СНП
		    vLINK_HIST_ID:=NULL;
		  ELSE
		    IF vLINK_HIST_IS_AUTO=0 THEN
              RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		    END IF;
		  END IF;
		END IF;

     	vIsReg:=FALSE;
		IF vLINK_ID IS NULL THEN
		  vLINK_ID:=AddZakaz(0,vLINK_ID,1,1,v_zakaz.DATE_PLAN,pCLIENT_NUMBER||'/'||vINPUT_NUMBER,vINPUT_DATE,'?',NULL,
			          pBEGIN_DATE,-1,v_zakaz.FILIAL_ID,NULL,v_zakaz.LUKDOG_ID,pPROD_ID_NPR,v_zakaz.USL_OPL_ID,v_zakaz.LOAD_ABBR,v_zakaz.STAN_ID,
	                  v_zakaz.VETKA_ID,v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID,v_zakaz.POTREB_NAME,
	                  v_zakaz.NEFTEBASA,v_zakaz.PAYFORM_ID,v_zakaz.PLANSTRU_ID,v_zakaz.PRICE,NULL,pLOAD_VES,pLOAD_KOL,pSPEED_VES,pSPEED_KOL,
	                  v_zakaz.PRIM,v_zakaz.GR4,NULL,v_zakaz.GOSPROG_ID,v_zakaz.GP_NAPR_ID,NULL,pZAKAZ_ID,vID);
		ELSE
		  UPDATE ZAKAZ
		   SET (CLIENT_NUMBER,CLIENT_DATE,VES,KOL,SPEED_VES,SPEED_KOL,PROD_ID_NPR,
		        LOAD_ABBR,STAN_ID,VETKA_ID,POLUCH_ID,POTREB_ID,PRIM,GR4)=
			   (SELECT pCLIENT_NUMBER||'/'||vINPUT_NUMBER,vINPUT_DATE,pLOAD_VES,pLOAD_KOL,pSPEED_VES,pSPEED_KOL,pPROD_ID_NPR,
			    v_zakaz.LOAD_ABBR,v_zakaz.STAN_ID,v_zakaz.VETKA_ID,v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID,v_zakaz.PRIM,v_zakaz.GR4 FROM dual)
		  WHERE ID=vLINK_ID AND (INPUT_NUMBER IS NULL OR INPUT_NUMBER='?');
       	  vIsReg:=SQL%NOTFOUND;
		END IF;
		IF NVL(vLINK_ID,0)<=0 THEN
		  vLINK_ID:=NULL;
		ELSE
		  IF vLINK_HIST_ID IS NULL THEN
		    vLINK_HIST_ID:=AddZakazHist(0, vLINK_HIST_ID,1,0, vLINK_ID,20,'?',NULL,'?',NULL,
                 pPROD_ID_NPR,NULL,v_zakaz.STAN_ID,v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID,
				 NULL, 0,0,pSPEED_VES,pSPEED_KOL, vNOM_ZD,
	            pLOAD_VES, pLOAD_KOL, pFACT_VES, pFACT_KOL,pGU12_A_ID,pBEGIN_DATE,pZAKAZ_ID,vID);
		  ELSE
		    IF NOT vIsReg THEN
		      -- Если заказ еще не зарегистрирован
		      UPDATE ZAKAZ_HIST
		        SET (LOAD_VES,LOAD_KOL,SPEED_VES,SPEED_KOL,PROD_ID_NPR,
		          STAN_ID,POLUCH_ID,POTREB_ID)=
			     (SELECT pLOAD_VES,pLOAD_KOL,pSPEED_VES,pSPEED_KOL,pPROD_ID_NPR,
			      v_zakaz.STAN_ID,v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID FROM dual)
		      WHERE ID=vLINK_HIST_ID;
		      IF pGU12_A_ID IS NOT NULL THEN
		        UPDATE ZAKAZ_HIST SET GU12_A_ID=pGU12_A_ID WHERE ID=vLINK_HIST_ID;
		      END IF;
			END IF;
		  END IF;	  
		END IF;
	    IF NVL(vLINK_HIST_ID,0)<=0 THEN
		  vLINK_HIST_ID:=NULL;
		END IF;

		-- Проставляем связи в редактируемой позиции заказа
		SetZakazHistLink(vID,vLINK_ID,vLINK_HIST_ID);
	  END IF;

	  IF v_zakaz.IS_AGENT=1 AND v_zakaz.DATE_PLAN>=TO_DATE('01.01.2005','dd.mm.yyyy') THEN
  	    -- Если позиция добавляется/обновляется в Заказах УНП

        -- Определение владельца заказа (1-УНП, 2-СНП)
        vOWNER_ZAKAZ:=v_zakaz.IS_AGENT;
    	IF v_zakaz.DOG_ID IS NOT NULL THEN
          BEGIN
	        SELECT IS_AGENT INTO vOWNER_ZAKAZ
		      FROM KLS_DOG_MAIN
		     WHERE v_zakaz.DATE_PLAN BETWEEN FROM_DATE AND TO_DATE
		       AND (DOG_ID=v_zakaz.DOG_ID OR HRAN_DOG_ID=v_zakaz.DOG_ID)
		       AND IS_AGENT=2;
   	      EXCEPTION
	        WHEN OTHERS THEN
		      vOWNER_ZAKAZ:=v_zakaz.IS_AGENT;
 	      END;
	    END IF;

	    IF vOWNER_ZAKAZ=2 THEN
		  -- Владелец - СНП

          -- Проверяем заказ СНП и его позицию
		  IF NOT ZakazExist(vLINK_ID,vLINK_IS_AUTO) THEN
	        -- Проверяем заказ СНП
		     vLINK_ID:=NULL;
	      END IF;

          IF vLINK_ID IS NULL OR
		    NOT ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
	        -- Проверяем позцию заказа СНП
		    vLINK_HIST_ID:=NULL;
		  END IF;

		  IF vLINK_ID IS NULL THEN
	        -- Если связанный заказ не указан - возьмем из шапки заказа
		    vLINK_ID:=v_zakaz.LINK_ID;
		  END IF;
  	      IF NVL(vLINK_ID,0)<=0 THEN
		    vLINK_ID:=NULL;
		  END IF;

		  IF vLINK_ID IS NOT NULL THEN
		    IF vLINK_HIST_ID IS NULL  THEN
	          -- Если связанной позиции заказа нет - Добавляем
			  BEGIN
			    SELECT CLIENT_NUMBER,CLIENT_DATE,INPUT_NUMBER,INPUT_DATE
			      INTO vCLIENT_NUMBER,vCLIENT_DATE,vINPUT_NUMBER,vINPUT_DATE
			      FROM ZAKAZ_HIST
			     WHERE ID=v_zakaz.LINK_HIST_ID;
			  EXCEPTION
			    WHEN OTHERS THEN
			      vCLIENT_NUMBER:=SUBSTR(vCLIENT_NUMBER,1,INSTR(vCLIENT_NUMBER,'/')-1);
				  vCLIENT_DATE:=v_zakaz.CLIENT_DATE;
				  vINPUT_NUMBER:=SUBSTR(vCLIENT_NUMBER,INSTR(vCLIENT_NUMBER,'/')+1,999);
				  vINPUT_DATE:=v_zakaz.CLIENT_DATE;
			  END;
		      vLINK_HIST_ID:=AddZakazHist(0, vLINK_HIST_ID,1,0, vLINK_ID,20,
			     vCLIENT_NUMBER,vCLIENT_DATE,vINPUT_NUMBER,vINPUT_DATE,
                 pPROD_ID_NPR,NULL,v_zakaz.STAN_ID,v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID,
				 NULL, 0,0,0,0, vNOM_ZD,
	            0,0, pFACT_VES,pFACT_KOL,pGU12_A_ID,pBEGIN_DATE,pZAKAZ_ID,vID);
		    ELSE
		      -- Если связанная позиция заказа есть - проверяем, был ли она добавлена автоматически
		      IF vLINK_HIST_IS_AUTO=1 THEN
		        -- Если автоматически - обновляем
				NULL;
		      ELSE
			    -- Если вручную - ничего не делаем
		        NULL;
		      END IF;
			END IF;
		  END IF;
		END IF;
		IF NVL(vLINK_HIST_ID,0)<=0 THEN
		  vLINK_HIST_ID:=NULL;
		END IF;

		-- Проставляем связи в редактируемой позиции заказа
		SetZakazHistLink(vID,vLINK_ID,vLINK_HIST_ID);
	  END IF;
	END IF;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  RETURN -1;
  END;

  /* УДАЛИТЬ ПОЗИЦИЮ ЗАКАЗА */
  PROCEDURE DelZakazHist(pCOMMIT NUMBER, pID NUMBER, pIS_AUTO NUMBER DEFAULT 0) AS
    vNOM_ZD VARCHAR2(50);
	vLINK_HIST_ID NUMBER;
	vIS_AUTO NUMBER;
	vZAKAZ_ID NUMBER;
	vIS_AGENT NUMBER;
	vLINK_HIST_IS_AUTO NUMBER;
	vLINK_IS_AUTO NUMBER;
	vLINK_ID NUMBER;
	vINPUT_NUMBER VARCHAR2(100);
	vLUKDOG_ID NUMBER;
	DOG_IS_AGENT NUMBER;
	vAGENT_ID NUMBER;
  BEGIN
    -- Считываем позицию заказа
	SELECT NOM_ZD,LINK_ID,LINK_HIST_ID,IS_AUTO,ZAKAZ_ID
	  INTO vNOM_ZD,vLINK_ID,vLINK_HIST_ID,vIS_AUTO,vZAKAZ_ID
	  FROM ZAKAZ_HIST
	 WHERE ID=pID;

    -- Считываем заказ
	SELECT IS_AGENT,LUKDOG_ID INTO vIS_AGENT,vLUKDOG_ID
	  FROM ZAKAZ
	 WHERE ID=vZAKAZ_ID;
	 
	-- Данные договора 
    BEGIN
	  SELECT IS_AGENT,AGENT_ID INTO DOG_IS_AGENT,vAGENT_ID
		  FROM KLS_DOG
		 WHERE ID=vLUKDOG_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vAGENT_ID:=NULL;
		DOG_IS_AGENT:=NULL;
	END;

    -- Проверка
	IF pIS_AUTO=0 THEN
	  -- Удаление вручную
	  IF vNOM_ZD IS NOT NULL AND (vAGENT_ID=8 or vAGENT_ID=4175) THEN
        RaiseError('Позиция привязана к заданию из Комплекса ФИНАНСЫ!');
	  END IF;

	  IF vIS_AGENT=1 AND ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
		IF vIS_AUTO=1 THEN
          RaiseError('Заказ создан ЛУКОЙЛ-СНП и может быть удален только владельцем заказа!');
		ELSE
		  IF vLINK_HIST_IS_AUTO=0 THEN
			RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		  ELSE
	        -- Убираем связь
	        SetZakazHistLink(pID,NULL,NULL);
	        -- Удаляем связанную позицию
	        DelZakazHist(0,vLINK_HIST_ID,1);
		  END IF;
		END IF;
	  END IF;

	  IF vIS_AGENT=2 AND
	     ZakazExist(vLINK_ID,vLINK_IS_AUTO) AND
	     ZakazHistExist(vLINK_HIST_ID,vLINK_HIST_IS_AUTO) THEN
	    IF vIS_AUTO=1 THEN
          RaiseError('Заказ создан ЛУКОЙЛ-УНП и может быть удален только владельцем заказа!');
		ELSE
		  IF vLINK_HIST_IS_AUTO=0 THEN
			RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		  ELSE
  	        -- Убираем связь
	        SetZakazHistLink(pID,NULL,NULL);
		    -- Удаляем связанную позицию
	        DelZakazHist(0,vLINK_HIST_ID,1);
		  END IF;
		  IF vLINK_IS_AUTO=0 THEN
			RaiseError('Оба связанных заказа созданы НЕ автоматически!');
		  ELSE
		    SELECT INPUT_NUMBER INTO vINPUT_NUMBER
			  FROM ZAKAZ WHERE ID=vLINK_ID;
			IF vINPUT_NUMBER||' '<>' ' AND vINPUT_NUMBER<>'?' THEN
		  	  RaiseError('Заказ ЛУКОЙЛ-СНП зарегистрирован в ЛУКОЙЛ-УНП! Для удаления - отмените регистрацию!');
			END IF;
  	        -- Убираем связь
	        SetZakazLink(pID,NULL,NULL);
		    -- Удаляем связанный заказ
	        DelZakaz(0,vLINK_ID,1);
		  END IF;
		END IF;
	  END IF;
	END IF;

    DELETE FROM ZAKAZ_HIST WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* Отказ */
  FUNCTION CancelZakaz(pCOMMIT NUMBER, pCANCEL_ID NUMBER, pIS_AUTO NUMBER, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE,
	pBEGIN_DATE DATE,
    pVES NUMBER, pKOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER) RETURN NUMBER AS
  v_zakaz ZAKAZ%ROWTYPE;
  BEGIN
    -- Считываем заказ
	SELECT * INTO v_zakaz
	  FROM ZAKAZ
	 WHERE ID=pCANCEL_ID;
	 -- Добавляем отказ
	 RETURN AddZakazHist(pCOMMIT,NULL,pIS_AUTO,NULL,pCANCEL_ID,50,pCLIENT_NUMBER,pCLIENT_DATE,
	      pINPUT_NUMBER,pINPUT_DATE,v_zakaz.PROD_ID_NPR,NULL,v_zakaz.STAN_ID,
		  v_zakaz.POLUCH_ID,v_zakaz.POTREB_ID,v_zakaz.PRICE,-pVes,-pKol,-pSPEED_VES,-pSPEED_KOL,
		  '',0,0,0,0,NULL,pBEGIN_DATE,NULL,NULL);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  RETURN -1;
  END;

  /* Отказ+Добавить */
  FUNCTION CancelAddZakaz(pCOMMIT NUMBER, pCANCEL_ID NUMBER, pIS_AUTO NUMBER, pIS_AGENT NUMBER, pDATE_PLAN DATE, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pBEGIN_DATE DATE,
	pFILIAL_ID NUMBER, pPLAT_ID NUMBER, pDOG_ID NUMBER,
	pPROD_ID_NPR VARCHAR2, pUSL_OPL_ID NUMBER, pLOAD_ABBR VARCHAR2, pSTAN_ID NUMBER,
	pVETKA_ID NUMBER, pPOLUCH_ID NUMBER, pPOTREB_ID NUMBER, pPOTREB_NAME VARCHAR2,
	pNEFTEBASA VARCHAR2, pPAYFORM_ID NUMBER, pPLANSTRU_ID NUMBER, pPRICE_CLIENT NUMBER,
	pPRICE NUMBER, pVES NUMBER, pKOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER,
	pPRIM VARCHAR2, pGR4 VARCHAR2,pGOSPROG_ID NUMBER,pGP_NAPR_ID NUMBER,pLUKDOG_ID NUMBER) RETURN NUMBER AS
  v_zakaz ZAKAZ%ROWTYPE;
  vID NUMBER;
  BEGIN
	-- Добавляем отказ;
    vID:=CancelZakaz(pCOMMIT, pCANCEL_ID,pIS_AUTO,pCLIENT_NUMBER,pCLIENT_DATE,pINPUT_NUMBER,pINPUT_DATE,
	                 pBEGIN_DATE,pVES,pKOL,pSPEED_VES,pSPEED_KOL);
	-- Формируем новый заказ
	IF vID<>-1 THEN
	  vID:=AddZakaz(pCOMMIT,NULL,pIS_AUTO,pIS_AGENT,pDATE_PLAN,
	     pCLIENT_NUMBER,pCLIENT_DATE,pINPUT_NUMBER,pINPUT_DATE,
		 pBEGIN_DATE,0,pFILIAL_ID,pPLAT_ID,pDOG_ID,
 	     pPROD_ID_NPR,pUSL_OPL_ID,pLOAD_ABBR,pSTAN_ID,
	     pVETKA_ID,pPOLUCH_ID, pPOTREB_ID, pPOTREB_NAME,
	     pNEFTEBASA,pPAYFORM_ID,pPLANSTRU_ID,pPRICE_CLIENT,
	     pPRICE, pVES, pKOL, pSPEED_VES, pSPEED_KOL,
	     pPRIM, pGR4, pCANCEL_ID,pGOSPROG_ID,pGP_NAPR_ID,pLUKDOG_ID,NULL,NULL);
    END IF;
	RETURN vID;
  END;

  /* Переадресация */
  FUNCTION ReAddrZakaz(pCOMMIT NUMBER, pZAKAZ_ID NUMBER, pIS_AUTO NUMBER, pSTATUS_ZAKAZ_ID NUMBER, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pBEGIN_DATE DATE, pSTAN_ID NUMBER) RETURN NUMBER AS
  v_zakaz ZAKAZ%ROWTYPE;
  BEGIN
    -- Считываем заказ
	SELECT * INTO v_zakaz
	  FROM ZAKAZ
	 WHERE ID=pZAKAZ_ID;
	 -- Добавляем переадресацию
	 RETURN AddZakazHist(pCOMMIT,NULL,pIS_AUTO,NULL,pZAKAZ_ID,pSTATUS_ZAKAZ_ID,pCLIENT_NUMBER,pCLIENT_DATE,
	      pINPUT_NUMBER,pINPUT_DATE,v_zakaz.PROD_ID_NPR,v_zakaz.STAN_ID,pSTAN_ID,
		  v_zakaz.POLUCH_ID, v_zakaz.POTREB_ID,0,0,0,0,0,
		  '',0,0,0,0,NULL,pBEGIN_DATE,NULL,NULL);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  RETURN -1;
  END;

  /* Переадресация+Добавить */
  FUNCTION ReAddrAddZakaz(pCOMMIT NUMBER, pZAKAZ_ID NUMBER, pIS_AUTO NUMBER, pSTATUS_ZAKAZ_ID NUMBER,
    pIS_AGENT NUMBER, pDATE_PLAN DATE, pCLIENT_NUMBER VARCHAR2,
    pCLIENT_DATE DATE, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pBEGIN_DATE DATE,
	pFILIAL_ID NUMBER, pPLAT_ID NUMBER, pDOG_ID NUMBER,
	pPROD_ID_NPR VARCHAR2, pUSL_OPL_ID NUMBER, pLOAD_ABBR VARCHAR2, pSTAN_ID NUMBER,
	pVETKA_ID NUMBER, pPOLUCH_ID NUMBER, pPOTREB_ID NUMBER, pPOTREB_NAME VARCHAR2,
	pNEFTEBASA VARCHAR2, pPAYFORM_ID NUMBER, pPLANSTRU_ID NUMBER, pPRICE_CLIENT NUMBER,
	pPRICE NUMBER, pVES NUMBER, pKOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER,
	pPRIM VARCHAR2, pGR4 VARCHAR2,pGOSPROG_ID NUMBER,pGP_NAPR_ID NUMBER,pLUKDOG_ID NUMBER) RETURN NUMBER AS
  v_zakaz ZAKAZ%ROWTYPE;
  vID NUMBER;
  BEGIN
    BEGIN
      -- Считываем заказ
	  SELECT * INTO v_zakaz
	    FROM ZAKAZ
	   WHERE ID=pZAKAZ_ID;
	   -- Добавляем переадресацию
	   vID:=AddZakazHist(pCOMMIT,NULL,pIS_AUTO,NULL,pZAKAZ_ID,pSTATUS_ZAKAZ_ID,pCLIENT_NUMBER,pCLIENT_DATE,
	      pINPUT_NUMBER,pINPUT_DATE,v_zakaz.PROD_ID_NPR,v_zakaz.STAN_ID,pSTAN_ID,
		  v_zakaz.POLUCH_ID, v_zakaz.POTREB_ID,0,-pVes,-pKol,-pSpeed_ves,-pSpeed_kol,
		  '',0,0,0,0,NULL,pBEGIN_DATE,NULL,NULL);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
	    vID:=-1;
    END;
	-- Формируем новый заказ
	IF vID<>-1 THEN
	  vID:=AddZakaz(pCOMMIT, NULL,pIS_AUTO,pIS_AGENT,pDATE_PLAN,pCLIENT_NUMBER,
         pCLIENT_DATE,pINPUT_NUMBER,pINPUT_DATE,pBEGIN_DATE,
	     0,pFILIAL_ID,pPLAT_ID,pDOG_ID,
 	     pPROD_ID_NPR,pUSL_OPL_ID,pLOAD_ABBR,pSTAN_ID,
	     pVETKA_ID,pPOLUCH_ID, pPOTREB_ID, pPOTREB_NAME,
	     pNEFTEBASA,pPAYFORM_ID,pPLANSTRU_ID,pPRICE_CLIENT,
	     pPRICE, pVES, pKOL, pSPEED_VES, pSPEED_KOL,
	     pPRIM, pGR4, pZAKAZ_ID,pGOSPROG_ID,pGP_NAPR_ID,pLUKDOG_ID,NULL,NULL);
    END IF;
	RETURN vID;
  END;

  /* К отгрузке */
  FUNCTION ToLoadZakaz(pCOMMIT NUMBER, pZAKAZ_ID NUMBER, pIS_AUTO NUMBER, pINPUT_NUMBER VARCHAR2, pINPUT_DATE DATE, pBEGIN_DATE DATE, pPROD_ID_NPR VARCHAR2,
	pSTAN_ID NUMBER, pPOLUCH_ID NUMBER, pPOTREB_ID NUMBER, pPRICE NUMBER,
	pNOM_ZD VARCHAR2, pLOAD_VES NUMBER, pLOAD_KOL NUMBER, pSPEED_VES NUMBER, pSPEED_KOL NUMBER, pFACT_VES NUMBER, pFACT_KOL NUMBER,
	pGU12_A_ID NUMBER, pKOD_ISU VARCHAR2 DEFAULT '*') RETURN NUMBER AS
  v_zakaz ZAKAZ%ROWTYPE;
  vINPUT_NUMBER NUMBER;
  vID NUMBER;
  BEGIN
    -- Считываем заказ
	SELECT * INTO v_zakaz
	  FROM ZAKAZ
	 WHERE ID=pZAKAZ_ID;

    -- Добавляем "К отгрузке"
	RETURN AddZakazHist(pCOMMIT,NULL,pIS_AUTO,NULL,pZAKAZ_ID,20,v_zakaz.INPUT_NUMBER,v_zakaz.INPUT_DATE,
	      vINPUT_NUMBER,pINPUT_DATE,pPROD_ID_NPR,NULL,pSTAN_ID,
		  pPOLUCH_ID, pPOTREB_ID,pPRICE,0,0,pSPEED_VES, pSPEED_KOL,
		  pNOM_ZD,pLOAD_VES,pLOAD_KOL,pFACT_VES,pFACT_KOL,pGU12_A_ID,pBEGIN_DATE,NULL,NULL,pKOD_ISU);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  RETURN -1;
  END;

  /* Подготовить график к заполнению */
  PROCEDURE FillGrafik(pZAKAZ_HIST_ID NUMBER) AS
  BEGIN
    -- Очистить временный график
	EmptyGrafik;
	-- Заполнить временный график
    INSERT INTO V_ZAKAZ_GRAFIK_TEMP (DATE_LOAD, TONN_LOAD, CIST_LOAD)
 	 SELECT DATE_LOAD, TONN_LOAD, CIST_LOAD FROM ZAKAZ_GRAFIK
		 WHERE ZAKAZ_HIST_ID=pZAKAZ_HIST_ID;
	COMMIT;
  END;

  /* Добавить запись в график */
  PROCEDURE AddGrafik(pDATE_LOAD DATE, pTONN_LOAD NUMBER, pCIST_LOAD NUMBER) AS
    vDATE DATE;
  BEGIN
    SELECT DATE_LOAD INTO vDATE
	  FROM V_ZAKAZ_GRAFIK_TEMP
	 WHERE DATE_LOAD=pDATE_LOAD;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO V_ZAKAZ_GRAFIK_TEMP (DATE_LOAD, TONN_LOAD, CIST_LOAD)
 	   SELECT pDATE_LOAD, pTONN_LOAD, pCIST_LOAD FROM dual;
	  COMMIT;
  END;

  /* Удалить запись из графика */
  PROCEDURE DelGrafik(pDATE_LOAD DATE) AS
  BEGIN
    DELETE FROM V_ZAKAZ_GRAFIK_TEMP WHERE DATE_LOAD=pDATE_LOAD;
	COMMIT;
  END;

  /* Сохранить график */
  PROCEDURE SaveGrafik(pZAKAZ_HIST_ID NUMBER) AS
    vGRAFIK VARCHAR2(500);
	vPREV_DAY NUMBER(2);
	vPREV_MON NUMBER(2);
	vCUR_DAY NUMBER(2);
	vCUR_MON NUMBER(2);
	vLAST_DAY NUMBER(2);
	vLAST_MON NUMBER(2);
  BEGIN
    -- Очищаем рабочий  график
	DELETE FROM ZAKAZ_GRAFIK WHERE ZAKAZ_HIST_ID=pZAKAZ_HIST_ID;
	-- Формируем строку для ZAKAZ_HIST
	vLAST_DAY:=0;
	vPREV_DAY:=0;
	vPREV_MON:=0;
	vGRAFIK:='';
	FOR lcur IN (SELECT DATE_LOAD,TONN_LOAD,CIST_LOAD
	               FROM V_ZAKAZ_GRAFIK_TEMP
--				  WHERE TONN_LOAD<>0 OR CIST_LOAD<>0
				  ORDER BY DATE_LOAD)
    LOOP
	  vCUR_DAY:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'DD'));
	  vCUR_MON:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'MM'));
	  IF vPREV_DAY>0 THEN
	    -- Уже были
	    IF vCUR_MON<>vPREV_MON OR vCUR_DAY>vPREV_DAY+1 THEN
		  -- Изменился месяц или разница больше 1 дня
		  IF vLAST_DAY<>vPREV_DAY THEN
		    -- Период больше 1 дня
		    vGRAFIK:=vGRAFIK||'-'||TRIM(TO_CHAR(vPREV_DAY,'00'))||'.'||TRIM(TO_CHAR(vPREV_MON,'00'))||', '||TRIM(TO_CHAR(vCUR_DAY,'00'));
		  ELSE
		    -- Период в 1 день
		    vGRAFIK:=vGRAFIK||'.'||TRIM(TO_CHAR(vPREV_MON,'00'))||', '||TRIM(TO_CHAR(vCUR_DAY,'00'));
		  END IF;
		  vLAST_DAY:=vCUR_DAY;
	    END IF;
	  ELSE
	    -- В первый раз
	    vGRAFIK:=TRIM(TO_CHAR(vCUR_DAY,'00'));
		vLAST_DAY:=vCUR_DAY;
	  END IF;
	  vPREV_DAY:=vCUR_DAY;
	  vPREV_MON:=vCUR_MON;
	  -- Заполняем рабочий график
	  INSERT INTO ZAKAZ_GRAFIK (ZAKAZ_HIST_ID, DATE_LOAD, TONN_LOAD, CIST_LOAD)
       VALUES (pZAKAZ_HIST_ID,lcur.DATE_LOAD,lcur.TONN_LOAD,lcur.CIST_LOAD);
	END LOOP;
	IF vPREV_DAY>0 THEN
	  IF vLAST_DAY<>vPREV_DAY THEN
	    -- Период больше 1 дня
		vGRAFIK:=vGRAFIK||'-'||TRIM(TO_CHAR(vPREV_DAY,'00'))||'.'||TRIM(TO_CHAR(vPREV_MON,'00'));
	  ELSE
	    -- Период в 1 день
	    vGRAFIK:=vGRAFIK||'.'||TRIM(TO_CHAR(vPREV_MON,'00'));
	  END IF;
    END IF;
	-- Записываем ZAKAZ_HIST.GRAFIK
	UPDATE ZAKAZ_HIST SET GRAFIK=SUBSTR(vGRAFIK,1,100) WHERE ID=pZAKAZ_HIST_ID;
	--
	COMMIT;
  END;

-- Загрузка заказов потребителей из Паруса в Заказы потребителей в Master
PROCEDURE LOAD_CONSORDS (DATE_BEG VARCHAR2,DATE_END VARCHAR2) AS
  pDATE_BEG VARCHAR2(200);
  pDATE_END VARCHAR2(200);
  dDateBeg DATE;
  dDateEnd DATE;

BEGIN
  IF DATE_BEG ||' '=' ' THEN
    pDATE_BEG:=TO_CHAR(SYSDATE,'dd.mm.yyyy');
  ELSE
    pDATE_BEG:=DATE_BEG;
  END IF;

  IF DATE_END ||' '=' ' THEN
    pDATE_END:=TO_CHAR(SYSDATE,'dd.mm.yyyy');
  ELSE
    pDATE_END:=DATE_END;
  END IF;

  dDateBeg:=TRUNC(TRUNC(TO_DATE(pDATE_BEG,'dd.mm.yyyy'),'MONTH')-1,'MONTH');
  dDateEnd:=LAST_DAY(LAST_DAY(TO_DATE(pDATE_END,'dd.mm.yyyy'))+1);

  UPDATE ZAKAZ_PARUS A SET
	(PARUS_PRN, IS_ACCEPT, IS_WORK, INPUT_NUMBER, INPUT_DATE, VES, DATE_PLAN, LOAD_ABBR,
	 USL_OPL_ID, FILIAL_ID, PRICE, POLUCH_NAME, PARUS_AGENT_RN,
	 PARUS_AGENT_TAG, PARUS_AGENT_NAME, PARUS_DOGOVOR, PARUS_NOMEN_RN, PARUS_NOMEN_TAG,
	 PARUS_NOMEN_NAME, PARUS_MODIF_RN, PARUS_MODIF_TAG, PARUS_MODIF_NAME,FACT_VES) =
    (SELECT B.nPRN,DECODE(B.nORD_STATE,1,1,0), DECODE(B.nBLOCKED,1,0,1), B.sINPUT_NUMBER, B.dINPUT_DATE,B.VES_TONN, B.dPLAN_DATE, B.LOAD_ABBR,
	   B.USL_OPL_ID,B.FILIAL_ID,B.PRICE_TONN,B.sAGENTNAME,B.nAGENT,
	   B.sAGENT,B.sAGENTNAME,B.sDOG_NUMB, B.NNOMEN, B.SNOMEN,
	   B.SNOMENNAME, B.NNOMMODIF, B.SNOMMODIF, B.SMODIFNAME,0
	 FROM V_PARUS_CONSORDS B
	 WHERE B.NRN=A.PARUS_RN
	   AND B.dPLAN_DATE>=dDateBeg
	   AND B.dPLAN_DATE<=dDateEnd)
  WHERE A.PARUS_RN IS NOT NULL
	AND A.DATE_PLAN>=dDateBeg
	AND A.DATE_PLAN<=dDateEnd
	AND EXISTS
    (SELECT NULL FROM V_PARUS_CONSORDS B
	  WHERE B.NRN=A.PARUS_RN
	    AND B.dPLAN_DATE>=dDateBeg
	    AND B.dPLAN_DATE<=dDateEnd);

  INSERT INTO ZAKAZ_PARUS
	(PARUS_RN, PARUS_PRN, IS_ACCEPT, IS_WORK, INPUT_NUMBER, INPUT_DATE, VES, DATE_PLAN, LOAD_ABBR,
	 USL_OPL_ID, FILIAL_ID, PRICE, POLUCH_NAME, PARUS_AGENT_RN,
	 PARUS_AGENT_TAG, PARUS_AGENT_NAME, PARUS_DOGOVOR, PARUS_NOMEN_RN, PARUS_NOMEN_TAG,
	 PARUS_NOMEN_NAME, PARUS_MODIF_RN, PARUS_MODIF_TAG, PARUS_MODIF_NAME,FACT_VES)
    (SELECT B.nRN, B.nPRN, DECODE(B.nORD_STATE,1,1,0), DECODE(B.nBLOCKED,1,0,1), B.sINPUT_NUMBER, B.dINPUT_DATE, B.VES_TONN, B.dPLAN_DATE, B.LOAD_ABBR,
	   B.USL_OPL_ID,B.FILIAL_ID,B.PRICE_TONN,B.sAGENTNAME,B.nAGENT,
	   B.sAGENT,B.sAGENTNAME,B.sDOG_NUMB, B.NNOMEN, B.SNOMEN,
	   B.SNOMENNAME, B.NNOMMODIF, B.SNOMMODIF, B.SMODIFNAME, 0
	 FROM V_PARUS_CONSORDS B
	 WHERE NOT EXISTS (SELECT NULL FROM ZAKAZ_PARUS A WHERE A.PARUS_RN=B.nRN)
	   AND B.dPLAN_DATE>=dDateBeg
	   AND B.dPLAN_DATE<=dDateEnd);

  DELETE FROM ZAKAZ_PARUS A
   WHERE NOT EXISTS
    (SELECT NULL FROM V_PARUS_CONSORDS B WHERE B.NRN=A.PARUS_RN
 	    AND B.dPLAN_DATE>=dDateBeg
	    AND B.dPLAN_DATE<=dDateEnd)
	 AND A.DATE_PLAN>=dDateBeg
	 AND A.DATE_PLAN<=dDateEnd
	 AND A.PARUS_RN IS NOT NULL
	 AND A.PARUS_RN<>1;

  -- Факт отгрузки	 
  FOR lcur IN (SELECT ORD_RN, ORD_NUMB, T_RN, AGENT_RN, AGENT_TAG, AGENT_NAME, DOG_NUMB, o.FILIAL_ID,
                 TRUNC(B.DOCDATE,'MONTH') as DATE_PLAN, NOMEN_RN, NOMEN_TAG, NOMEN_NAME, SUM(MASSA/1000) as FACT_VES
             	 FROM V_PARUS_CONSORD_FACT B, PARUS_STORE_ORG_STRU_LINK pl, V_ORG_STRUCTURE o
         	    WHERE B.DOCDATE>=dDateBeg
	              AND B.DOCDATE<=dDateEnd
				  AND B.STORE=pl.STORE_RN
				  AND pl.ORG_STRU_ID=o.ID
--				  AND b.dog_numb='СНП-066670004'
				GROUP BY ORD_RN, ORD_NUMB, T_RN, AGENT_RN, AGENT_TAG, AGENT_NAME, DOG_NUMB, o.FILIAL_ID,
                 TRUNC(B.DOCDATE,'MONTH'), NOMEN_RN, NOMEN_TAG, NOMEN_NAME
                ORDER BY ORD_RN, ORD_NUMB, T_RN, AGENT_RN, AGENT_TAG, AGENT_NAME, DOG_NUMB, o.FILIAL_ID,
                 TRUNC(B.DOCDATE,'MONTH'), NOMEN_RN, NOMEN_TAG, NOMEN_NAME ) LOOP  	 
    
	IF lcur.ORD_RN IS NOT NULL THEN
	  -- Если есть заказ 
      UPDATE ZAKAZ_PARUS A SET FACT_VES=NVL(FACT_VES,0)+lcur.FACT_VES
	   WHERE A.PARUS_PRN=lcur.ORD_RN
	     AND A.PARUS_NOMEN_RN=lcur.NOMEN_RN
	     AND ROWNUM=1;
	ELSE
	  -- Ищем подходящий
      UPDATE ZAKAZ_PARUS A SET FACT_VES=NVL(FACT_VES,0)+lcur.FACT_VES
	   WHERE A.PARUS_DOGOVOR=lcur.DOG_NUMB
	     AND A.PARUS_NOMEN_RN=lcur.NOMEN_RN
   	     AND A.DATE_PLAN=lcur.DATE_PLAN
		 AND A.FILIAL_ID=lcur.FILIAL_ID
	     AND A.PARUS_RN IS NOT NULL
	     AND A.PARUS_RN<>1
	     AND ROWNUM=1;
	END IF;	 
    IF SQL%NOTFOUND THEN
	     INSERT INTO ZAKAZ_PARUS (PARUS_RN, INPUT_NUMBER, INPUT_DATE, DATE_PLAN, IS_ACCEPT, FILIAL_ID, PARUS_AGENT_RN, PARUS_AGENT_TAG, PARUS_AGENT_NAME, PARUS_DOGOVOR, 
		 PARUS_NOMEN_RN, PARUS_NOMEN_TAG, PARUS_NOMEN_NAME, VES, FACT_VES, IS_WORK, PARUS_PRN)
		 VALUES (lcur.T_RN, NVL(lcur.ORD_NUMB,'?'), lcur.DATE_PLAN, lcur.DATE_PLAN, 0, lcur.FILIAL_ID, lcur.AGENT_RN, lcur.AGENT_TAG, lcur.AGENT_NAME, lcur.DOG_NUMB, 
		 lcur.NOMEN_RN, lcur.NOMEN_TAG, lcur.NOMEN_NAME, 0, lcur.FACT_VES, 1, 0);
	END IF;	 
  END LOOP;	   
  
  COMMIT;
  
END;

/* Очистить временный график */
PROCEDURE EmptyGrafik AS
BEGIN
  DELETE FROM V_ZAKAZ_GRAFIK_TEMP;
END;

-- Заполнить временный график из заказа на перевозку
PROCEDURE FillGrafikFromGU (pPLAT_ID NUMBER, pPROD_GU12_ID VARCHAR2, pSTAN_ID NUMBER, pGU12_A_ID NUMBER) AS
BEGIN
  -- Очистить временный график
  EmptyGrafik;
  -- Заполнить временный график
  INSERT INTO V_ZAKAZ_GRAFIK_TEMP (DATE_LOAD, TONN_LOAD, CIST_LOAD)
 	SELECT GU12_BR.DATE_R, SUM(GU12_BR.VES), SUM(GU12_BR.KOL_VAG)
	  FROM GU12_A,GU12_B,GU12_BR
	 WHERE GU12_A.ID=pGU12_A_ID
	   AND GU12_A.PROD_ID=TO_NUMBER(pPROD_GU12_ID)
	   AND GU12_A.ID=GU12_B.ID_A
	   AND GU12_B.KOL_VAG>0 -- Исключая корректировки
	   AND GU12_B.STAN_ID=pSTAN_ID
	   AND GU12_B.PLAT_ID=pPLAT_ID
	   AND GU12_B.ID=GU12_BR.ID_B
	 GROUP BY GU12_BR.DATE_R
	 ORDER BY GU12_BR.DATE_R;
  COMMIT;
END;

-- Максимальный номер позиции "К отгрузке"
FUNCTION GetMaxNum(pZAKAZ_ID NUMBER) RETURN NUMBER AS
  MaxNum NUMBER;
  CurNum NUMBER;
BEGIN
  MaxNum:=0;
  FOR lcur IN (SELECT ZAKAZ_HIST.INPUT_NUMBER
                 FROM ZAKAZ_HIST,ZAKAZ A, ZAKAZ B
				WHERE A.ID=pZAKAZ_ID
				  AND A.INPUT_NUMBER=B.INPUT_NUMBER
				  AND B.ID=ZAKAZ_HIST.ZAKAZ_ID
				  AND ZAKAZ_HIST.STATUS_ZAKAZ_ID=20)
  LOOP
    BEGIN
	  CurNum:=TO_NUMBER(lcur.INPUT_NUMBER);
	EXCEPTION
	  WHEN OTHERS THEN
	    CurNum:=0;
	END;
	IF CurNum>MaxNum THEN
	  MaxNum:=CurNum;
	END IF;
  END LOOP;
  RETURN MaxNum;
END;


/* График в виде строки */
FUNCTION GrafikToStr(pNOM_ZD VARCHAR2, pGRAFIK_TO DATE) RETURN VARCHAR2 AS
    vGRAFIK VARCHAR2(2000);
	vPART VARCHAR2(2000);
	vPREV_DAY NUMBER(2);
	vPREV_MON NUMBER(2);
	vCUR_DAY NUMBER(2);
	vCUR_MON NUMBER(2);
	vLAST_DAY NUMBER(2);
	vLAST_MON NUMBER(2);
	vCUR_VAG NUMBER(5);
	vPREV_VAG NUMBER(5);
	vREPEAT NUMBER(1);
BEGIN
  vLAST_DAY:=0;
  vPREV_DAY:=0;
  vPREV_MON:=0;
  vPREV_VAG:=0;
  vGRAFIK:='';
  FOR lcur IN (SELECT GU12_BR.DATE_R AS DATE_LOAD, SUM(GU12_BR.KOL_VAG) AS KOL_VAG 
                   FROM GU12_A,GU12_B,GU12_BR,MONTH
                  WHERE MONTH.nom_zd=pNOM_ZD
                    AND MONTH.GU12_A_ID=GU12_A.id
                    AND GU12_A.id=GU12_B.id_a
                    AND GU12_B.STAN_ID=MONTH.STAN_ID
                    AND GU12_B.id=GU12_BR.id_b
                    AND GU12_BR.date_r<=pGRAFIK_TO
			  	    AND GU12_B.ISCOR<>2
                  GROUP BY GU12_BR.DATE_R
				  HAVING SUM(GU12_BR.KOL_VAG)>0
                  ORDER BY GU12_BR.DATE_R)
  LOOP
	vCUR_DAY:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'DD'));
	vCUR_MON:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'MM'));
	vCUR_VAG:=lcur.KOL_VAG;
	  
	IF vPREV_DAY>0 THEN
      -- Уже были
      IF vCUR_MON<>vPREV_MON OR vCUR_VAG<>vPREV_VAG THEN
         -- Изменился месяц или кол-во вагонов
		IF vREPEAT=1 THEN
		  vPART:='по '||vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
		ELSE   
		  vPART:=vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
		END IF;
		IF vGRAFIK||' '<>' ' THEN  
 		  vGRAFIK:=vGRAFIK||'; '||vPART;
		ELSE  
 		  vGRAFIK:=vPART;
		END IF;  
		vREPEAT:=0;
		vPART:=TRIM(TO_CHAR(vCUR_VAG))||'ц - '||TRIM(TO_CHAR(vCUR_DAY,'00'));
 	  ELSE
		vPART:=vPART||','||TRIM(TO_CHAR(vCUR_DAY,'00'));
		vREPEAT:=1;
	  END IF;
	ELSE
	  -- В первый раз
	  vPART:=TRIM(TO_CHAR(vCUR_VAG))||'ц - '||TRIM(TO_CHAR(vCUR_DAY,'00'));
	  vREPEAT:=0;
	END IF;
	vPREV_DAY:=vCUR_DAY;
	vPREV_MON:=vCUR_MON;
	vPREV_VAG:=vCUR_VAG;
  END LOOP;
  IF vPREV_DAY>0 THEN
    IF vREPEAT=1 THEN
	  vPART:='по '||vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
    ELSE   
	  vPART:=vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
	END IF;
	IF vGRAFIK||' '<>' ' THEN  
 	  vGRAFIK:=vGRAFIK||'; '||vPART;
	ELSE  
 	  vGRAFIK:=vPART;
	END IF;  
  END IF;

  RETURN vGRAFIK;	
END;

/* Создать в заказе СНП позицию "К отгрузке", привязанную к уже имеющемуся непривязанному заказу УНП */
PROCEDURE LinkSNPWithUNP(pSNP_ZAKAZ_ID NUMBER, pNOM_ZD VARCHAR2) AS
  vSNP ZAKAZ%ROWTYPE;
  vUNP ZAKAZ%ROWTYPE;
  vUNP_HIST ZAKAZ_HIST%ROWTYPE;
  vSNP_HIST_ID NUMBER;
BEGIN
   -- Ищем не привязанный заказ УНП
   BEGIN
     SELECT * INTO vUNP_HIST FROM ZAKAZ_HIST  WHERE NOM_ZD=pNOM_ZD AND LINK_ID IS NULL;
     SELECT * INTO vUNP FROM ZAKAZ  WHERE ID=vUNP_HIST.ZAKAZ_ID;
   EXCEPTION
     WHEN OTHERS THEN
	   RETURN;
   END;
   
   -- Ищем заказ СНП
   BEGIN
     SELECT * INTO vSNP FROM ZAKAZ  WHERE ID=pSNP_ZAKAZ_ID;
   EXCEPTION
     WHEN OTHERS THEN
	   RETURN;
   END;

   -- Формируем позицию "К отгрузке" в заказе СНП	   	 
   vSNP_HIST_ID:=ToLoadZakaz(1, pSNP_ZAKAZ_ID, 1, '', vSNP.INPUT_DATE, vSNP.BEGIN_DATE, vSNP.PROD_ID_NPR,
     	vSNP.STAN_ID, vSNP.POLUCH_ID, vSNP.POTREB_ID, vSNP.PRICE,
	    pNOM_ZD, 0, 0, 0, 0, 0, 0,	vUNP_HIST.GU12_A_ID);     
    
   -- Проставляем связи
  SetZakazLink(vUNP.ID,pSNP_ZAKAZ_ID,vSNP_HIST_ID);
  SetZakazHistLink(vUNP_HIST.ID,pSNP_ZAKAZ_ID,vSNP_HIST_ID);
  SetZakazHistLink(vSNP_HIST_ID,vUNP.ID,vUNP_HIST.ID);
END;


END; 
/

