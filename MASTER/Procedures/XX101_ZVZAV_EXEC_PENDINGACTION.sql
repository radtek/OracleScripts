--
-- XX101_ZVZAV_EXEC_PENDINGACTION  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Xx101_Zvzav_Exec_Pendingaction IS
  vVetkaId NUMBER;
  vGu12AId NUMBER;
  v_dat DATE;
  vSORTBY NUMBER;
  vLoadKol NUMBER;
  vLoadVes NUMBER;
  vKoeffVes NUMBER;
  vLinkId NUMBER;
  vLinkHistId NUMBER;
  vID NUMBER;
  vHistID NUMBER;
  vNomZD VARCHAR2(16);
  vAddLinkHistId NUMBER;
  vGu12BId NUMBER;
  vMinDate DATE;
  vMaxDate DATE;
BEGIN

  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
      FROM ARH_DATE WHERE ARH_DATE.TABLENAME='MONTH';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

  vMinDate:=TO_DATE('31.12.2049','dd.mm.yyyy');
  vMaxDate:=TO_DATE('31.12.1899','dd.mm.yyyy');

  -- Перебор заявок
  FOR lcur_zav IN (SELECT * FROM (SELECT * FROM XX101_ZVZAV_TO_MONTH B
               WHERE propagatestatus IS NULL AND /* doc302_id in (3020106488) and OR  doc301_id = '3010046762'
               and */(date_plan>=TO_DATE('01.04.2008','dd.mm.yyyy') or actioncode=3)
               ORDER BY filename,TO_NUMBER(filerownum))
               --where rownum<50
               )
  LOOP
    IF lcur_zav.date_plan<vMinDate THEN
      vMinDate:=lcur_zav.date_plan;
    END IF;
    IF lcur_zav.date_plan>vMaxDate THEN
      vMaxDate:=lcur_zav.date_plan;
    END IF;

    -- обновляем справочники
    vVetkaId:=0;
    IF lcur_zav.vetka_name||' '<>' ' THEN
      -- Ветки получателя
      UPDATE KLS_VETKA SET vetka_name=lcur_zav.vetka_name WHERE vetka_name=lcur_zav.vetka_name;
      IF SQL%NOTFOUND THEN
        INSERT INTO KLS_VETKA(ID,VETKA_NAME)  
        (SELECT SEQ_KLS_VETKA.NEXTVAL,lcur_zav.vetka_NAME FROM dual);
      END IF;
      BEGIN
        SELECT id INTO vVetkaid FROM KLS_VETKA WHERE lcur_zav.vetka_name=KLS_VETKA.VETKA_NAME;
      EXCEPTION
        WHEN OTHERS THEN
          vVetkaId:=1;
      END; 
    ELSE
      vVetkaId:=1;     
    END IF;
    -- выводим коэффициент для килограммов (10,07,2008 Романов Ю.И.)
    -- При операциях с Month делим на него.
    vKoeffVes:=1;
    IF (trim(lcur_zav.measureunit)='т') or (trim(lcur_zav.measureunit)='Т') or (trim(lcur_zav.measureunit)='t') or (trim(lcur_zav.measureunit)='T') THEN
     vKoeffVes:=1;
    else
     vKoeffVes:=1000;
    end if;  
    -- ищем (и добавляем при необходимости) план перевозок
    vGu12AId:=0;
    vGu12BId:=0;
    IF lcur_zav.NOM_ETRAN||' '<>' ' THEN
      -- ищем заголовок плана
      BEGIN
        IF lcur_zav.is_exp=0 THEN
          -- внутренний рынок
          SELECT a.id INTO vGu12AId 
            FROM GU12_A a 
		   WHERE trim(a.nom_z) IS NOT NULL
             AND trim(a.nom_z)=SUBSTR(lcur_zav.NOM_ETRAN,1,10) 
             AND (NVL(a.PLATTAR_ID,0)>0 AND a.plattar_id=lcur_zav.plattarif_id)
             AND TO_CHAR(a.prod_id)=lcur_zav.prod_gu12_id
             AND TRUNC(a.from_date,'MONTH')=lcur_zav.date_plan
             AND ROWNUM=1;
        ELSE
          -- экспорт    
          SELECT a.id INTO vGu12AId 
            FROM GU12_A a 
		   WHERE trim(a.nom_z) IS NOT NULL
             AND trim(a.nom_z)=SUBSTR(lcur_zav.NOM_ETRAN,1,10) 
             AND DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID)=lcur_zav.exped_id
             AND TO_CHAR(a.prod_id)=lcur_zav.prod_gu12_id
             AND TRUNC(a.from_date,'MONTH')=lcur_zav.date_plan
             AND ROWNUM=1;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN       
          vGu12AId:=0;
      END;
      
      IF vGu12AId=0 THEN
        -- план перевозок не найден - добавляем
        INSERT INTO GU12_A 
        (
         id,
         nom_z,
         from_date,
         TO_DATE,
         reg_date,
         dogovor,
         stanotpr_id,
         grotp_id,
         exped_id,
         gr_gruz_id,
         vidsoob_id,
         podach_id,
         sogl,
         plattar_id,
         prod_id,
         priznotpr_id,
         vladput_id,
         rodvag_id
        ) VALUES
        (
         0,
         SUBSTR(lcur_zav.NOM_ETRAN,1,10),
         lcur_zav.date_plan,
         LAST_DAY(lcur_zav.date_plan),
         lcur_zav.date_plan,
         (CASE
           WHEN lcur_zav.is_exp=0 THEN TO_CHAR(lcur_zav.tex_pd_id)
           ELSE ''
          END),
         lcur_zav.stanotp_id,
         4175,
         (CASE
           WHEN lcur_zav.is_exp=0 THEN NULL
           WHEN lcur_zav.exped_id=3490 THEN 1219
           ELSE lcur_zav.exped_id
          END),
         lcur_zav.gr_gruz_id,
         (CASE
           WHEN lcur_zav.is_exp=0 THEN 1
           ELSE 2
          END),
         6,
         1,
         lcur_zav.plattarif_id,
         lcur_zav.prod_gu12_id,
         1,
         1111,
         lcur_zav.rodvag_id         
        ); 
        
        BEGIN
          IF lcur_zav.is_exp=0 THEN
            -- внутренний рынок
            SELECT a.id INTO vGu12AId 
              FROM GU12_A a 
		     WHERE trim(a.nom_z) IS NOT NULL
               AND trim(a.nom_z)=SUBSTR(lcur_zav.NOM_ETRAN,1,10) 
               AND (NVL(a.PLATTAR_ID,0)>0 AND a.plattar_id=lcur_zav.plattarif_id)
               AND TO_CHAR(a.prod_id)=lcur_zav.prod_gu12_id
               AND TRUNC(a.from_date,'MONTH')=lcur_zav.date_plan
               AND ROWNUM=1;
          ELSE
            -- экспорт    
            SELECT a.id INTO vGu12AId 
              FROM GU12_A a 
		     WHERE trim(a.nom_z) IS NOT NULL
               AND trim(a.nom_z)=SUBSTR(lcur_zav.NOM_ETRAN,1,10) 
               AND DECODE(a.EXPED_ID,1219,3490,a.EXPED_ID)=lcur_zav.exped_id
               AND TO_CHAR(a.prod_id)=lcur_zav.prod_gu12_id
               AND TRUNC(a.from_date,'MONTH')=lcur_zav.date_plan
               AND ROWNUM=1;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN       
            vGu12AId:=0;
        END;
      END IF;  -- добавление плана
    
      IF vGu12AId>0 THEN
        -- ищем рейс
        BEGIN
          SELECT b.id INTO vGu12BId 
            FROM GU12_B b 
		   WHERE b.id_a=vGu12AId
             AND b.STAN_ID=lcur_zav.stan_id
             AND b.iscor in (0,1)
             AND ROWNUM=1;
        EXCEPTION
          WHEN OTHERS THEN       
            vGu12BId:=0;
        END;
      
        IF vGu12BId=0 THEN
          -- рейс не найден - добавляем
          INSERT INTO GU12_B 
          (
           id,
           id_a,
           stan_id,
           vidotpr_id,
           plat_id,
           iscor
          ) VALUES
          (
           0,
           vGu12AId,
           lcur_zav.stan_id,
           1,
           lcur_zav.plat_id,
           0         
          ); 

          BEGIN
            SELECT b.id INTO vGu12BId 
              FROM GU12_B b 
	  	     WHERE b.id_a=vGu12AId
               AND b.STAN_ID=lcur_zav.stan_id
               AND b.iscor in (0,1)
               AND ROWNUM=1;
          EXCEPTION
            WHEN OTHERS THEN       
              vGu12BId:=0;
          END;
        END IF; -- добавение рейса  
      END IF; -- vGu12BId
      
    END IF; -- план перевозок      
    
    -- определяем наличие заказа УНП
    vID:=lcur_zav.doc301_id;
    BEGIN
      SELECT id INTO vID FROM ZAKAZ WHERE id=lcur_zav.doc301_id;
    EXCEPTION 
      WHEN OTHERS THEN
        vID:=0;
    END;        

    -- определяем наличие позиции заказа УНП
    vHistID:=lcur_zav.doc302_id;
    BEGIN
      SELECT id INTO vHistID FROM ZAKAZ_HIST WHERE id=lcur_zav.doc302_id AND zakaz_id=vID;
    EXCEPTION 
      WHEN OTHERS THEN
        vHistID:=0;
    END;        

    -- определяем наличие разнарядки
    vNomZD:=lcur_zav.doc302_id;
    BEGIN
      SELECT nom_zd INTO vNomZD FROM MONTH WHERE nom_zd=trim(lcur_zav.doc302_id);
    EXCEPTION 
      WHEN OTHERS THEN
        vNomZD:='';
    END;        

    -- определяем наличие связанной позиции заказа СНП
    vLinkId:=NULL;
    vLinkHistId:=NULL;
    IF (lcur_zav.date_plan<to_date('01.03.2009','dd.mm.yyyy') and lcur_zav.plat_id=2641) or (lcur_zav.date_plan>=to_date('01.03.2009','dd.mm.yyyy') and lcur_zav.plat_id=10) THEN -- только для СНП
      IF vID>0 THEN
        -- если заказ УНП уже существует, то сначала поищем связь в нем
        BEGIN
          SELECT link_id,link_hist_id INTO vLinkId,vLinkHistId
            FROM ZAKAZ WHERE id=vID;
          SELECT zakaz_id,id INTO vLinkId,vLinkHistId
            FROM ZAKAZ_HIST WHERE zakaz_id=vLinkId AND id=vLinkHistId;
        EXCEPTION
          WHEN OTHERS THEN
            vLinkId:=NULL;
            vLinkHistId:=NULL;
        END;
      END IF;
    
      IF vLinkID IS NULL THEN
        -- теперь поищем заказ СНП, пришедший из ИСУ  
        BEGIN  
          SELECT zakaz_id,id INTO vLinkId,vLinkHistId
            FROM ZAKAZ_HIST WHERE zakaz_id=lcur_zav.link_id AND id=lcur_zav.link_hist_id;
        EXCEPTION
          WHEN OTHERS THEN
            vLinkId:=NULL;
            vLinkHistId:=NULL;
        END;  
      END IF;
      
      --IF vLinkHistId IS NOT NULL then
         -- берем реквизиты из заказа СНП
         -- ?????? пока не надо
     -- END IF;   
    END IF;

    ----------------------------
    -- ОБРАБОТКА
    ----------------------------
    IF lcur_zav.actioncode=3 THEN
      
      -- удаление разнарядки 
      DELETE FROM MONTH A WHERE nom_zd=vNomZD;
      
      -- уменьшаем объем заказа и удаляем позицию заказа
      BEGIN
        SELECT NVL(load_kol,0), NVL(load_ves,0) INTO vLoadKol,vLoadVes
        FROM ZAKAZ_HIST WHERE zakaz_id=vID AND id=vHistID;

        --снимаем вес с заказа
        UPDATE ZAKAZ A SET KOL=NVL(KOL,0)-vLoadKol, VES=NVL(VES,0)-vLoadVes WHERE id=vID;
        COMMIT;   

        --удаляем позицию
        BEGIN
          For_Zakaz.DelZakazHist(0, vHistID, 0);
        EXCEPTION
          WHEN OTHERS THEN  
            DELETE FROM ZAKAZ_HIST A WHERE zakaz_id=vID AND id=vHistID;
        END;    
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;      

      -- флаг обработки  
      UPDATE XX101_ZVZAV_DATA A SET A.PROPAGATESTATUS=1 WHERE a.filename=lcur_zav.filename AND a.filerownum=lcur_zav.filerownum;
      COMMIT;   

      --удаляем заказ
      BEGIN
        UPDATE ZAKAZ SET is_accept=0 WHERE id=vID;
        For_Zakaz.DelZakaz(0, vID, 0);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;  
      END;    
         
    ELSE  
      
      -- обновялем заказ УНП
      UPDATE ZAKAZ SET 
        (date_plan,
         client_number,
         client_date,
         begin_date,
         plat_id,
         dog_id,
         prod_id_npr,
         usl_opl_id,
         load_abbr,
         stan_id,
         vetka_id,
         poluch_id,
         potreb_id,
         planstru_id,
         prim,
         gr4
        )= 
        (SELECT
           lcur_zav.date_plan,
           lcur_zav.input_num,
           lcur_zav.input_date,
           lcur_zav.begin_date,
           lcur_zav.plat_id,
           lcur_zav.dog_id,
           lcur_zav.prod_id_npr,
           lcur_zav.usl_opl_id,
           lcur_zav.load_abbr,
           lcur_zav.stan_id,
           vVetkaId,
           lcur_zav.poluch_id,
           lcur_zav.potreb_id,
           lcur_zav.planstru_id,
           lcur_zav.prim,
           lcur_zav.gr4
         FROM dual)  
      WHERE ID=vID;

      IF SQL%NOTFOUND THEN
        -- добавляем заказ УНП
        vID:=For_Zakaz.AddZakaz(0, lcur_zav.doc301_id, 0, 1, lcur_zav.DATE_PLAN , lcur_zav.INPUT_NUM ,
             lcur_zav.INPUT_DATE, lcur_zav.doc301_id, lcur_zav.INPUT_DATE, lcur_zav.BEGIN_DATE ,
	         1, 31, lcur_zav.PLAT_ID, lcur_zav.DOG_ID, lcur_zav.PROD_ID_NPR, lcur_zav.USL_OPL_ID, 
             lcur_zav.LOAD_ABBR, lcur_zav.STAN_ID,  vVetkaID, lcur_zav.POLUCH_ID, lcur_zav.POTREB_ID, '',
	         '', 10, lcur_zav.PLANSTRU_ID, 0, 0, 0, 0, 0, 0,
	         lcur_zav.PRIM, lcur_zav.GR4, NULL,NULL,NULL,NULL, vLinkId, vLinkHistId, 1, 1, 1);

        -- повторно проверяем наличие связанной позиции заказа СНП (могла добавиться)
        vLinkId:=NULL;
        vLinkHistId:=NULL;
        BEGIN
          SELECT link_id,link_hist_id INTO vLinkId,vLinkHistId
          FROM ZAKAZ WHERE id=vID;

          SELECT zakaz_id,id INTO vLinkId,vLinkHistId
          FROM ZAKAZ_HIST WHERE zakaz_id=vLinkId AND id=vLinkHistId;
        EXCEPTION
          WHEN OTHERS THEN
            vLinkId:=NULL;
            vLinkHistId:=NULL;
        END;  

        -- Проставляем связи в редактируемом заказе
  	    For_Zakaz.SetZakazLink(vID,vLINKID,vLINKHISTID);

      END IF; --добавление заказа УНП  

      -- определяем объем позиции заказа до изменения
      BEGIN
        SELECT NVL(load_kol,0), NVL(load_ves,0) INTO vLoadKol,vLoadVes
        FROM ZAKAZ_HIST WHERE zakaz_id=vID AND id=vHistID;
      EXCEPTION
        WHEN OTHERS THEN
          vLoadKol:=0;
          vLoadVes:=0;
      END;      
      
      -- обновляем позицию заказа УНП
      UPDATE ZAKAZ_HIST SET 
        (client_number,
         client_date,
         prod_id_npr,
         stan_id,
         poluch_id,
         load_ves,
         load_kol,
         nom_zd,
         begin_date,
         potreb_id,
         kod_isu
        )= 
        (SELECT
           lcur_zav.input_num,
           lcur_zav.input_date,
           lcur_zav.prod_id_npr,
           lcur_zav.stan_id,
           lcur_zav.poluch_id,
           lcur_zav.ves,
           lcur_zav.kol,
           lcur_zav.doc302_id,
           lcur_zav.begin_date,
           lcur_zav.potreb_id,
           lcur_zav.doc301_id
         FROM dual)  
      WHERE zakaz_ID=vID AND id=vHistID;

      IF SQL%NOTFOUND THEN
        -- проверяем, что связанная позиция заказа СНП не ссылается на какую-либо позицию заказа УНП
        BEGIN
          SELECT a.id INTO vAddLinkHistId FROM ZAKAZ_HIST a, ZAKAZ_HIST b WHERE a.id=vLINKHISTID AND a.link_hist_id=b.id AND b.id<>lcur_zav.doc302_id;
          vAddLinkHistId:=NULL;
        EXCEPTION
          WHEN OTHERS THEN
            vAddLinkHistId:=vLINKHISTID;
        END;       
        
        -- добавляем позицию заказа УНП
        vHistId:=For_Zakaz.AddZakazHist(0, lcur_zav.doc302_id, 0, 0, vID, 20, lcur_zav.input_num,
             lcur_zav.input_date, '', lcur_zav.input_date, lcur_zav.prod_id_npr,
	         NULL, lcur_zav.STAN_ID, lcur_zav.POLUCH_ID, lcur_zav.POTREB_ID, 0, 0,
	         0, 0, 0, lcur_zav.doc302_id, lcur_zav.ves, lcur_zav.kol, 0, 0,
	         vGu12AID, lcur_zav.BEGIN_DATE, vLINKID, vAddLinkHistId, lcur_zav.doc301_id, 1);

        -- повторно проверяем наличие связанной позиции заказа СНП (могла добавиться)
        vAddLinkHistId:=NULL;
        BEGIN
          SELECT link_hist_id INTO vAddLinkHistId
          FROM ZAKAZ_HIST WHERE id=vHistID;

          SELECT id INTO vAddLinkHistId
          FROM ZAKAZ_HIST WHERE zakaz_id=vLinkId AND id=vAddLinkHistId;
        EXCEPTION
          WHEN OTHERS THEN
            vAddLinkHistId:=NULL;
        END;  
             
  	    For_Zakaz.SetZakazHistLink(vAddLinkHistId,vID,vHISTID);
  	    For_Zakaz.SetZakazHistLink(vHISTID,vLINKID,vAddLinkHistId);
      END IF; --добавление позиции заказа УНП  

      -- обновляем разнарядку
     /* UPDATE MONTH SET 
        (stanotp_id,
         stan_id,
         vetka_id,
         poluch_id,
         tex_pd_id,
         nazn_otg_id,
         load_abbr,
         dog_id,
         usl_number,
         prod_id_npr,
         tonn_declared,
         cist_declared,
         date_plan,
         prim,
         cena,
         cena_otp,
         sum_zd,
         gr4,
         input_date,
         update_date,
         potreb_id,
         planstru_id,
         tonn_r,
         cist_r,
         transport,
         is_exp,
         tonn_raznar,
         cist_raznar,
         zakaz_id,
         exped_id,
         gu12_a_id,
         zakaz_hist_id,
         zakaz_kod_isu
        )= 
        (SELECT
         lcur_zav.stanotp_id,
         lcur_zav.stan_id,
         vVetkaId,
         lcur_zav.poluch_id,
         lcur_zav.tex_pd_id,
         lcur_zav.nazn_otg_id,
         lcur_zav.load_abbr,
         lcur_zav.dog_id,
         lcur_zav.usl_number,
         lcur_zav.prod_id_npr,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         lcur_zav.date_plan,
         lcur_zav.prim,
         lcur_zav.cena,
         lcur_zav.cena_otp,
         lcur_zav.sum_zd,
         lcur_zav.gr4,
         lcur_zav.begin_date,
         lcur_zav.update_date,
         lcur_zav.potreb_id,
         lcur_zav.planstru_id,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         lcur_zav.transport,
         lcur_zav.is_exp,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         vID,
         lcur_zav.exped_id,
         vGu12AId,
         vHistID,
         lcur_zav.doc301_id
         FROM dual) 
      WHERE nom_zd=vNomZD;*/
      
      IF SQL%NOTFOUND THEN
        -- добавляем разнарядку УНП
        INSERT INTO MONTH  
        (nom_zd,
         stanotp_id,
         npr_sobstv_id,
         --stan_id,
         --vetka_id,
         --poluch_id,
         tex_pd_id,
         nazn_otg_id,
         load_abbr,
         dog_id,
         usl_number,
         prod_id_npr,
         tonn_declared,
         cist_declared,
         date_plan,
         prim,
         cena,
         cena_otp,
         sum_zd,
         --gr4,
         input_date,
         update_date,
         --potreb_id,
         --planstru_id,
         grotp_id,
         tonn_r,
         cist_r,
         transport,
         is_exp,
         supplier_id,
         tonn_raznar,
         cist_raznar,
         --zakaz_id,
         exped_id,
         gu12_a_id--,
         --zakaz_hist_id,
         --zakaz_kod_isu
        )
        VALUES 
        (lcur_zav.doc302_id,
         lcur_zav.stanotp_id,
         4175,
         --lcur_zav.stan_id,
         --vVetkaId,
         --lcur_zav.poluch_id,
         lcur_zav.tex_pd_id,
         lcur_zav.nazn_otg_id,
         lcur_zav.load_abbr,
         lcur_zav.dog_id,
         lcur_zav.usl_number,
         lcur_zav.prod_id_npr,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         lcur_zav.date_plan,
         lcur_zav.prim,
         lcur_zav.cena,
         lcur_zav.cena_otp,
         lcur_zav.sum_zd,
         --lcur_zav.gr4,
         lcur_zav.begin_date,
         lcur_zav.update_date,
         --lcur_zav.potreb_id,
         --lcur_zav.planstru_id,
         4175,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         lcur_zav.transport,
         lcur_zav.is_exp,
         4175,
         lcur_zav.ves/vKoeffVes,
         lcur_zav.kol,
         --vID,
         lcur_zav.exped_id,
         vGu12AId--,
         --vHistID,
         --lcur_zav.doc301_id
        ); 
        
        vNomzd:=lcur_zav.doc302_id;
      END IF; --добавление заказа УНП        
      
      update month set
        stan_id= null,
        vetka_id= null,
        poluch_id= null,
        prim= null,
        gr4= null,
        potreb_id= null,
        planstru_id= null,
        zakaz_id= null
        where date_plan >='1-may-2018';
--        where date_plan >='01.05.2018';
        
        
       -- обновляем объем заказа
      UPDATE ZAKAZ A SET KOL=NVL(KOL,0)-vLoadKol+lcur_zav.kol, VES=NVL(VES,0)-vLoadVes+lcur_zav.ves/vKoeffVes WHERE id=vID;
      -- флаг обработки  
      UPDATE XX101_ZVZAV_DATA A SET A.PROPAGATESTATUS=1 WHERE a.filename=lcur_zav.filename AND a.filerownum=lcur_zav.filerownum;
      COMMIT;   
    END IF; -- acctioncode
  END LOOP;               
                  
-- пересчитать факт
For_Zakaz.FillFact(0,TRUNC(vMinDate,'MONTH'),LAST_DAY(vMaxDate));  
for_zakaz.FillFactThisMonth;

COMMIT;                                
END Xx101_Zvzav_Exec_Pendingaction;

/

