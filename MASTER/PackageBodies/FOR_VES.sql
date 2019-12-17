--
-- FOR_VES  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_VES
AS


/* Расчет факт.плотности по температуре и плотности при 20'C по ГОСТ 3900-85 */
FUNCTION GET_FACT_PL_390085(pTEMPER NUMBER, pPL20 NUMBER) RETURN NUMBER AS
  vO NUMBER;
  sg NUMBER;
  vTT NUMBER;
  vBASA NUMBER;
  vHVOST NUMBER;
  vKOEF NUMBER;
  vKOEF_NEXT NUMBER;
  vRes NUMBER;
BEGIN

  IF NVL(pPL20,0)<=0 THEN
    RETURN 0;
  END IF;

  IF pPL20=0.7142 AND pTEMPER=-5 THEN
    RETURN 0.7352;
  END IF;
  IF pPL20=0.6607 AND pTEMPER=-7 THEN
    RETURN 0.6852;
  END IF;
  IF pPL20=0.7605 AND pTEMPER=1 THEN
    RETURN 0.7752;
  END IF;
  IF pPL20=0.9480 AND pTEMPER=90 THEN
    RETURN 0.9049;
  END IF;
  IF pPL20=0.8220 AND pTEMPER=45 THEN
    RETURN 0.8049;
  END IF;


  --1. Определение базовой температуры - приведение к 0.5
  sg:=SIGN(pTEMPER);
  vTT:=FLOOR(2*ABS(pTEMPER)+0.5)/2*sg; -- базовая температура

  --2. Определение базовой плотности: Для KLS_GOST_390085.TEMPER=TT находим наибольшее
  -- значение плотности KLS_GOST_390085.PL20 для которого
  -- ABS(KLS_GOST_390085.KOEF-pPL20) минимально
  vBASA:=0; -- базовая плотность
  BEGIN
    SELECT MAX(PL20) INTO vBASA
	  FROM KLS_GOST_390085
	 WHERE TEMPER=vTT
   	   AND KOEF=pPL20+SIGN(KOEF-pPL20)*(SELECT MIN(ABS(KOEF-pPL20)) FROM KLS_GOST_390085 WHERE TEMPER=vTT);
	vBASA:=NVL(vBASA,0);
  EXCEPTION
    WHEN OTHERS THEN
	  RETURN 0;
  END;

  IF vBASA=0 THEN
    RETURN 0;
  END IF;

  -- 3. Находим значение значение коэффициента для базовых плотности и температуры
  vKOEF:=0;
  BEGIN
    SELECT KOEF INTO vKOEF
	  FROM KLS_GOST_390085
	 WHERE TEMPER=vTT
	   AND PL20=vBASA;
	vKOEF:=NVL(vKOEF,0);
  EXCEPTION
    WHEN OTHERS THEN
	  RETURN 0;
  END;
  IF vKOEF=0 THEN
    RETURN 0;
  END IF;

  -- 4. Интерполяция значения коэффициента по температуре

  -- остаток от приведения температуры к 0.5
  vHVOST := pTEMPER -  vTT;
  vO:=0;
  -- значение коэффициента для следующего значения температуры
  BEGIN
    SELECT KOEF INTO vKOEF_NEXT
	  FROM KLS_GOST_390085
	 WHERE TEMPER=vTT+0.5
	   AND PL20=vBASA;
    -- интерполяция коэффициента
    vO:=ROUND((vKOEF_NEXT-vKOEF) / 0.5 * vHVOST,4);
  EXCEPTION
    WHEN OTHERS THEN
	  vO:=0;
  END;

  --5. Рассчет фактической плотности
  vRes:=vBASA - vKOEF + pPL20 - vO;
  RETURN vRes;
END;

/* Расчет факт.плотности по температуре и плотности при температуре <=-25 */
FUNCTION GET_FACT_PL_MOROZ(pTEMPER NUMBER, pPL NUMBER) RETURN NUMBER AS
  s NUMBER;
  sg NUMBER;
  vTT NUMBER;
BEGIN
  IF NVL(pPL,0)<=0 THEN
    RETURN 0;
  END IF;

  -- Приведение температуры к шагу 0.5
  sg:=IIFN(pTEMPER<0,-1,1);
  vTT:=FLOOR(2*ABS(pTEMPER)+0.5)/2*sg; -- базовая температура

  BEGIN
    SELECT KOEF INTO s
	  FROM KLS_GOST_OLD
	 WHERE pPL BETWEEN pl1 and pl2
	   AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
	  RETURN 0;
  END;

  s:=s * 10000 * (vTT-20);
  s:=ROUND(pPL * 10000 - s,0) / 10000;
  RETURN s;
END;

/* Определение коэффициента коррекции объема по ASTM D 1250 */
FUNCTION GET_CTLV_ASTMD1250(pTEMPER NUMBER, pPL15 NUMBER, pPROD_ID_NPR VARCHAR2) RETURN NUMBER AS
  sg NUMBER;
  vTT NUMBER;
  new_PL15 NUMBER;
  vKoef NUMBER;
BEGIN

  IF NVL(pPL15,0)<=0 THEN
    RETURN 0;
  END IF;

  IF NVL(pTEMPER,0)=15 THEN
    RETURN 1;
  END IF;

  -- Приведение температуры к шагу 0.5
  sg:=IIFN(pTEMPER<0,-1,1);
  vTT:=FLOOR(2*ABS(pTEMPER)+0.5)/2*sg; -- базовая температура

  -- Приведение плотности при 15'C к шагу 0.002
  new_PL15:=(FLOOR(pPL15*1000)+MOD(FLOOR(pPL15*1000),2))/1000;

  BEGIN
    IF pPROD_ID_NPR>='90000' THEN
      SELECT KOEF INTO vKoef
	    FROM KLS_GOST_8595_54A
	   WHERE TEMPER=vTT AND PL15=new_PL15;
    ELSE
      SELECT KOEF INTO vKoef
	    FROM KLS_GOST_8595_54B
	   WHERE TEMPER=vTT AND PL15=new_PL15;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
	  RETURN 0;
  END;

  RETURN NVL(vKoef,0);
END;

/* Процедура очистки стека (временная таблица TEMP_VES) */
PROCEDURE EMPTY_TEMP_VES AS
BEGIN
  DELETE TEMP_VES;
END;

/* Процедура сохранения параметра в стек (временная таблица TEMP_VES) */
PROCEDURE SET_PARAM (pTAG VARCHAR2, pVALUE VARCHAR2, pNORMA VARCHAR2 DEFAULT NULL) as
BEGIN
  IF pNORMA||' '<>' ' THEN
    UPDATE TEMP_VES SET VALUE=pVALUE, NORMA=pNORMA WHERE TAG=pTAG;
  ELSE
    UPDATE TEMP_VES SET VALUE=pVALUE WHERE TAG=pTAG;
  END IF;
  IF SQL%NOTFOUND THEN
    INSERT INTO TEMP_VES (TAG,VALUE,NORMA) VALUES (pTAG,pVALUE,pNORMA);
  END IF;
END;

/* Функции считывания параметра из стека (временная таблица TEMP_VES) */
FUNCTION GET_PARAM_AS_CHAR (pTAG VARCHAR2) RETURN VARCHAR2 AS
  vRes TEMP_VES.VALUE%TYPE;
BEGIN
  SELECT VALUE INTO vRes
    FROM TEMP_VES
   WHERE TAG=pTAG;
  RETURN vRes;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

FUNCTION GET_PARAM_AS_NUM (pTAG VARCHAR2) RETURN NUMBER AS
BEGIN
  RETURN ora_char_to_num(GET_PARAM_AS_CHAR(pTAG));
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;

FUNCTION GET_PARAM_NORMA (pTAG VARCHAR2) RETURN NUMBER AS
  vRes TEMP_VES.NORMA%TYPE;
  vNum NUMBER;
BEGIN
  BEGIN
    SELECT NORMA INTO vRes
      FROM TEMP_VES
     WHERE TAG=pTAG;
  EXCEPTION
    WHEN OTHERS THEN
      vRes:='';
  END;
  RETURN ora_char_to_num(vRes);
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;

/* Сохранение показателей паспорта из сведения в стек параметров для процедуры расчета веса */
PROCEDURE SET_PARAM_VALSVED (pSVED_ID VARCHAR2) as
BEGIN
  FOR lcur IN (SELECT DISTINCT NLS_UPPER(KLS_KODIF.FIELD_SVED) as TAG, KLS_VALSVED.QUAL as VALUE, KLS_TABLPOK.NORMTU as NORMA
                 FROM KLS_VALSVED, SVED, KLS_TABLPOK, KLS_KODIF
                WHERE KLS_VALSVED.SVED_ID=pSVED_ID
                  AND KLS_VALSVED.SVED_ID=SVED.ID
                  AND KLS_VALSVED.KODIF_ID=KLS_KODIF.ID
                  AND SVED.PROD_ID_NPR=KLS_TABLPOK.PROD_ID_NPR
                  AND KLS_VALSVED.KODIF_ID=KLS_TABLPOK.KODIF_ID)
  LOOP
    SET_PARAM(lcur.TAG,lcur.VALUE,lcur.NORMA);
  END LOOP;
END;

/* Определение текущего ГОСТа */
FUNCTION GET_DEFAULT_GOST (pLOAD_TYPE_ID NUMBER, pDATE_CALC DATE, pPROD_ID_NPR VARCHAR2,
                           pTEMPER VARCHAR2, pPL15 NUMBER, pPL20 NUMBER, vSLIV NUMBER) RETURN NUMBER AS
  vGOST NUMBER;
BEGIN
  IF pDATE_CALC>=G_NEW_GOST THEN
    vGOST:=1; -- ГОСТ 8.595-2004
  ELSE
    vGOST:=0; -- ГОСТ 3900-85
  END IF;
--  IF vGOST=1 AND vSLIV=9 AND pPROD_ID_NPR<>'90002' THEN
--    -- слив НЕФТИ кроме усинской - ГОСТ 3900-85
--    vGOST:=0;
--  END IF;
  IF vGOST=1 AND vSLIV=9 AND pPROD_ID_NPR>='90000' AND (pPL15<0.83 OR pPL15>0.87 OR pTEMPER<-18 OR pTEMPER>150) THEN
    -- слив НЕФТИ, нет данных в таблицах - ГОСТ 3900-85
    vGOST:=0;
  END IF;
  IF vGOST=1 AND vSLIV<>9 AND pPROD_ID_NPR>='90000' AND (pPL15<0.83 OR pPL15>0.87 OR pTEMPER<-18 OR pTEMPER>150) THEN
    -- отгрузка НЕФТИ, нет данных в таблицах - ГОСТ 3900-85
    vGOST:=0;
  END IF;
  IF vGOST=1 AND pPROD_ID_NPR<'90000' AND (pPL15<0.654 OR pPL15>1.074 OR pTEMPER<-18 OR pTEMPER>150) THEN
    -- отгрузка НЕФТЕПРОДУКТОВ, нет данных в таблицах - ГОСТ 3900-85
    vGOST:=0;
  END IF;
  IF vGOST=0 AND (pPL20<0.5 OR pPL20>1.09 OR pTEMPER<-25 OR pTEMPER>125) THEN
    -- совсем старый ГОСТ
    vGOST:=-1; 
  END IF;
  RETURN vGost;
END;

/* Расчет объема при 15'C по фактическому объему */
FUNCTION GET_VOLUME15_BY_VOLUME (pDATE_CALC DATE, vVOLUME NUMBER, vTEMPER NUMBER, vCTLV NUMBER, vSLIV NUMBER) RETURN NUMBER AS
  vVOLUME15 NUMBER;
BEGIN
  IF pDATE_CALC>=TO_DATE('01.11.2005','dd.mm.yyyy') THEN
	vVOLUME15:=(vVOLUME*((1+(2*12.5/1000000+23/1000000)*(vTEMPER-20))*vCTLV));
  ELSE
	vVOLUME15:=(vVOLUME*((1+(2*11.3/1000000+23/1000000)*(vTEMPER-20))*vCTLV));
  END IF;
  IF vSLIV<>9 THEN
    -- для отгрузки нефти и нефтепродуктов
	vVOLUME15:=ROUND(vVOLUME15,0);
  ELSE
    -- для слива нефти
	vVOLUME15:=ROUND(vVOLUME15,4);
  END IF;		
  RETURN vVOLUME15;
END;

/* Расчет фактического объема по объему при 15'C */
FUNCTION GET_VOLUME_BY_VOLUME15 (pDATE_CALC DATE, vVOLUME15 NUMBER, vTEMPER NUMBER, vCTLV NUMBER) RETURN NUMBER AS
  vVOLUME NUMBER;
BEGIN
  IF vCTLV<>0 THEN
    IF pDATE_CALC>=TO_DATE('01.11.2005','dd.mm.yyyy') THEN
	  vVOLUME:=ROUND(vVOLUME15/((1+(2*12.5/1000000+23/1000000)*(vTEMPER-20))*vCTLV),0);
    ELSE
	  vVOLUME:=ROUND(vVOLUME15/((1+(2*11.3/1000000+23/1000000)*(vTEMPER-20))*vCTLV),0);
    END IF;
  ELSE
    vVOLUME:=0;
  END IF;
  RETURN vVOLUME;
END;

/* Расчет веса:
	pDATE_CALC - дата расчета
	pLOAD_TYPE_ID - тип транспортировки (ж/д, самовывоз и т.п.)
	pMESTO_ID - место отгрузки
	pDEFI_MASS_ID - метод замера массы (1 - метр/шток, 2 - весы)
	vFAS:
		0 - налив: расчет чистого веса груза по известным весам брутто, тары
		1 - фасовка: расчет чистого веса груза по известным весам брутто, тары, упаковки
		2 - фасовка: расчет веса упаковки по известным весам брутто, чистого веса груза, тары
		3 - фасовка: расчет веса тары по известным весам брутто, чистого веса груза, упаковки
		4 - фасовка: расчет веса брутто по известным весам тары, чистого веса груза, упаковки
	vKOL:
		0 - налив
		1 - вычисление веса 1 единицы груза по весу груза (для FAS<>0)
		2 - вычисление веса груза по значению веса 1 ед.груза (для FAS<>0 AND FAS<>2)
		3 - вычисление кол-ва ед-ц груза по весу 1 единицы
	vUPAK:
		0 - налив
		1 - вычисление веса упаковки 1 единицы груза по весу всей упаковки (для FAS<>0)
		2 - вычисление веса всей упаковки по значению веса упаковки 1 ед.груза (для FAS<>0 AND FAS<>2)
	vGOST - только для наливных грузов (FAS=0) - ГОСТ, по которому необходимо произвести расчет либо веса,
	       либо объема - ВНИМАНИЕ!!! Гост может измениться внутри процедуры расчета. Гост по которому
		   действительно был произведен расчет возвращается через временную таблицу TEMP_VES.
		   Первоначальное значение GOST можно определить вызвав FOR_VES.GET_GOST
	vSLIV - признак слива
		1 - отгрузка
		9 - слив нефти
 */
FUNCTION CALC_VES(pDATE_CALC DATE, pLOAD_TYPE_ID NUMBER, pVAGONTYPE_ID NUMBER, pMESTO_ID NUMBER,
   pDEFI_MASS_ID NUMBER) RETURN NUMBER AS
  vPROD_ID_NPR KLS_PROD.ID_NPR%TYPE;
  vPLAT_ID NUMBER;
  vKALIBR_ID KLS_KALIBR.ID%TYPE;
  vMG_VOD NUMBER;
  vP_VOD NUMBER;
  vMG_SOL NUMBER;
  vP_SOL NUMBER;
  vP_DIRT NUMBER;
  vPL15 NUMBER;
  vPL20 NUMBER;
  vTEMPER NUMBER;
  vCTLV NUMBER;
  vGOST NUMBER;
  vVOLUME NUMBER;
  vVOLUME15 NUMBER;
  vUPAK_VES NUMBER;
  vUPAK_VES_ED NUMBER;
  vKOL_ED NUMBER;
  vVES_ED NUMBER;
  vPODDONS NUMBER;
  vPODDON_VES NUMBER;
  vSHIELDS NUMBER;
  vSHIELD_VES NUMBER;
  vVES_ALL NUMBER;
  vVES_CIST NUMBER;
  vVES NUMBER;
  vKOL_NET NUMBER;
  vVZLIV NUMBER;
  vFACT_PL NUMBER;
  vVED_ED NUMBER;
  vFAS NUMBER;
  vKOL NUMBER;
  vUPAK NUMBER;
  vSLIV NUMBER;
BEGIN
  -- Входные параметры для расчета
  IF pDEFI_MASS_ID=1 THEN
    vFAS:=0;
	vKOL:=0;
	vUPAK:=0;
  ELSE
    IF pVAGONTYPE_ID IN (1,6) THEN
	  vFAS:=1;
	  vKOL:=0;
	  vUPAK:=0;
	ELSE
	  vFAS:=2;
	  vKOL:=1;
	  vUPAK:=1;
  	END IF;
  END IF;
  vPROD_ID_NPR:=GET_PARAM_AS_CHAR('PROD_ID_NPR'); --продукт
  vPLAT_ID:=GET_PARAM_AS_NUM('PLAT_ID'); --плательщик по договору (для ЛУКОЙЛ-СНП вычитаем воду)
  vKALIBR_ID:=GET_PARAM_AS_CHAR('KALIBR_ID'); -- тип вагона
  vMG_VOD:=GET_PARAM_AS_NUM('MG_VOD'); -- содержание воды мг/л
  vP_VOD:=GET_PARAM_AS_NUM('P_VOD'); -- содержание воды %
  IF vP_VOD<0 THEN 
    vP_VOD:=0;
  END IF;	
  vMG_SOL:=GET_PARAM_AS_NUM('MG_SOL'); -- содержание солей мг/дм3
  vP_SOL:=GET_PARAM_AS_NUM('P_SOL'); -- содержание солей %
  IF vP_SOL<0 THEN 
    vP_SOL:=0;
  END IF;	
  vP_DIRT:=GET_PARAM_AS_NUM('P_DIRT'); -- содержание мех.примеесй, %
  IF vP_DIRT<0 THEN 
    vP_DIRT:=0;
  END IF;	
  vPL15:=GET_PARAM_AS_NUM('PL15'); -- плотность при 15'C
  vPL20:=GET_PARAM_AS_NUM('PL20'); -- плотность при 20'C
  vTEMPER:=GET_PARAM_AS_NUM('TEMPER'); -- температура
  vCTLV:=0; -- коэффициент коррекции объема
  vVZLIV:=GET_PARAM_AS_NUM('VZLIV'); -- взлив
  vVOLUME:=GET_PARAM_AS_NUM('VOLUME'); -- объем по калибровочной таблице
  vVOLUME15:=0; -- объем при 15'C
  vFACT_PL:=0; -- факт.плотность по ГОСТ 3900-85
  vUPAK_VES:=GET_PARAM_AS_NUM('UPAK_VES'); -- вес упаковки, тн
  vUPAK_VES_ED:=GET_PARAM_AS_NUM('UPAK_VES_ED'); -- вес 1 ед-цы упаковки, кг
  vKOL_ED:=GET_PARAM_AS_NUM('KOL_ED'); -- кол-во ед-ц
  vVES_ED:=GET_PARAM_AS_NUM('VES_ED'); -- вес 1 ед-цы, тн
  vPODDONS:=GET_PARAM_AS_NUM('PODDONS'); -- кол-во поддонов
  vPODDON_VES:=GET_PARAM_AS_NUM('PODDON_VES'); -- вес 1 поддона, кг
  IF vPODDON_VES=0 THEN
    vPODDON_VES:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','PODDON_VES',FOR_INIT.GetCurrUser);
  END IF;
  vSHIELDS:=GET_PARAM_AS_NUM('SHIELDS'); -- кол-в щитов
  vSHIELD_VES:=GET_PARAM_AS_NUM('SHIELD_VES'); -- вес 1 щита,кг
  IF vSHIELD_VES=0 THEN
    vSHIELD_VES:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','SHIELD_VES',FOR_INIT.GetCurrUser);
  END IF;
  vVES_ALL:=GET_PARAM_AS_NUM('VES_ALL'); -- вес груза, упаковки, вагона
  vVES_CIST:=GET_PARAM_AS_NUM('VES_CIST'); -- вес вагона
  vVES:=GET_PARAM_AS_NUM('VES'); -- вес груза
  vKOL_NET:=0; -- вес НЕТТО нефти (без баласта)
  vSLIV:=NVL(GET_PARAM_AS_NUM('SLIV'),0); -- v
  vGOST:=GET_DEFAULT_GOST(pLOAD_TYPE_ID,pDATE_CALC,vPROD_ID_NPR,vTEMPER,vPL15,vPL20,vSLIV);

  -- Расчет % солей
  IF vP_SOL=0 AND vMG_SOL<>0 THEN
    IF vGOST=1 AND vPL15<>0 THEN
	  vP_SOL:=ROUND(vMG_SOL/vPL15/10000,4);
	END IF;
    IF vGOST<>1 AND vPL20<>0 THEN
	  vP_SOL:=ROUND(vMG_SOL/vPL20/10000,4);
	END IF;
  END IF;

  -- Расчет % воды
  IF vP_VOD=0 AND vMG_VOD<>0 THEN
    vP_VOD:=ROUND(vMG_VOD / 10000,4);
  END IF;

  -- Расчет плотностей и/или коэффициента объема
  vCTLV:=GET_CTLV_ASTMD1250(vTEMPER, vPL15, vPROD_ID_NPR);
  IF vGOST<>-1 THEN
    vFACT_PL:=GET_FACT_PL_390085(vTEMPER, vPL20);
  END IF;
  IF vFACT_PL=0 OR vGOST=-1 THEN
    vFACT_PL:=GET_FACT_PL_MOROZ(vTEMPER, vPL20);
	IF vGOST=0 THEN
  	  vGOST:=-1;
	END IF;
  END IF;

  -- расчет кол-ва ед-ц груза
  IF vKOL=3 AND vVES_ED<>0 THEN
    vKOL_ED:=FLOOR(vVES / vVES_ED);
  END IF;

  -- расчет веса груза (в ТН)
  IF vKOL=2 THEN
    vVES:=ROUND((vKOL_ED*vVES_ED)/1000,3);
  END IF;

  -- расчет веса упаковки (в ТН)
  IF pDEFI_MASS_ID=1 OR vFAS=0 THEN
	vUPAK_VES:=0;
  ELSE
    IF vUPAK=2 AND vFAS<>2 AND vKOL_ED<>0 AND vUPAK_VES_ED<>0 THEN
      vUPAK_VES:=ROUND((vKOL_ED*vUPAK_VES_ED+vSHIELDS*vSHIELD_VES+vPODDONS*vPODDON_VES)/1000,3);
	END IF;
  END IF;

  -- расчет веса
  IF pDEFI_MASS_ID=1 THEN
    -- ЗАМЕР МЕТР-ШТОКОМ
    -- Определяем фактический объем
    IF pLOAD_TYPE_ID=1 AND NVL(vVOLUME,0)=0 THEN
      vVOLUME:=FOR_CIST.GET_VOLUME(vKALIBR_ID, vVZLIV, pLOAD_TYPE_ID, pVAGONTYPE_ID);
    END IF;
    -- Определяем объем при 15'C по фактическому объему
    vVOLUME15:=GET_VOLUME15_BY_VOLUME(pDATE_CALC,vVOLUME,vTEMPER,vCTLV,vSLIV);
	-- Определяем вес
	IF vGOST=1 THEN
      vVES:=vPL15 * vVOLUME15;
	ELSE
      vVES:=vFACT_PL * vVOLUME;
	END IF;
	IF vSLIV=9 THEN
	  vVES:=ROUND(vVES,4)/1000;
	ELSE
	  vVES:=ROUND(vVES,0)/1000;
    END IF;	  
    vVES_ALL:=vVES+vVES_CIST+vUPAK_VES;
  ELSE
    -- Взвешивание: pDEFI_MASS_ID<>1
	IF vFAS=0 OR vFAS=1 THEN
	  -- Взвешивание наливных и фасованных продуктов: Расчет веса
	  vVES:=vVES_ALL-vVES_CIST-vUPAK_VES;
	ELSIF vFAS=2 THEN
	  -- Взвешивание фасованных продуктов: Расчет упаковки
	  vUPAK_VES:=vVES_ALL-vVES_CIST-vVES;
	ELSIF vFAS=3 THEN
	  -- Взвешивание фасованных продуктов: Расчет тары
	  vVES_CIST:=vVES_ALL-vVES-vUPAK_VES;
	ELSIF vFAS=4 THEN
	  -- Взвешивание фасованных продуктов: Расчет брутто
      vVES_ALL:=vVES+vVES_CIST+vUPAK_VES;
	END IF;
    -- расчет фактического объема и объема при 15'C
	IF vGOST=1 THEN
	  IF vPL15<>0 THEN
        -- Определяем объем при 15'C
        vVOLUME15:=ROUND(vVES/vPL15,0);
        -- Определяем фактический объем
        vVOLUME:=GET_VOLUME_BY_VOLUME15(pDATE_CALC,vVOLUME15,vTEMPER,vCTLV);
	  ELSIF vFACT_PL<>0 THEN
        -- Определяем фактический объем
        vVOLUME:=ROUND(vVES/vFACT_PL,0);
        -- Определяем объем при 15'C
        vVOLUME15:=GET_VOLUME15_BY_VOLUME(pDATE_CALC,vVOLUME,vTEMPER,vCTLV,vSLIV);
	  END IF;
	ELSE -- vGOST<>1
	  IF vFACT_PL<>0 THEN
        -- Определяем фактический объем
        vVOLUME:=ROUND(vVES/vFACT_PL,0);
        -- Определяем объем при 15'C
        vVOLUME15:=GET_VOLUME15_BY_VOLUME(pDATE_CALC,vVOLUME,vTEMPER,vCTLV,vSLIV);
	  ELSIF vPL15<>0 THEN
        -- Определяем объем при 15'C
        vVOLUME15:=ROUND(vVES/vPL15,0);
        -- Определяем фактический объем
        vVOLUME:=GET_VOLUME_BY_VOLUME15(pDATE_CALC,vVOLUME15,vTEMPER,vCTLV);
	  END IF;
    END IF;
  END IF;

  -- расчет кол-ва ед-ц груза
  IF vKOL=3 AND vVES_ED<>0 THEN
    vKOL_ED:=FLOOR(vVES / vVES_ED);
  END IF;

  -- расчет веса 1 единицы груза (в КГ)
  IF vKOL=1 AND vKOL_ED<>0 THEN
    vVES_ED:=ROUND(vVES * 1000 / vKOL_ED,2);
  END IF;

  -- расчет веса упаковки 1 единицы груза (в КГ)
  IF pDEFI_MASS_ID=1 OR vFAS=0 THEN
      vUPAK_VES_ED:=0;
  ELSE
    IF vUPAK=1 AND vKOL_ED<>0 AND vUPAK_VES<>0 THEN
      vUPAK_VES_ED:=ROUND((vUPAK_VES*1000-vSHIELDS*vSHIELD_VES-vPODDONS*vPODDON_VES)/vKOL_ED,2);
	END IF;
  END IF;

  -- расчет веса упаковки (в ТН)
  IF pDEFI_MASS_ID=1 OR vFAS=0 THEN
	vUPAK_VES:=0;
  ELSE
    IF vUPAK=2 AND vFAS<>2 AND vKOL_ED<>0 AND vUPAK_VES_ED<>0 THEN
      vUPAK_VES:=ROUND((vKOL_ED*vUPAK_VES_ED+vSHIELDS*vSHIELD_VES+vPODDONS*vPODDON_VES)/1000,3);
	END IF;
  END IF;

  -- расчет веса НЕТТО нефти
  IF vPROD_ID_NPR>='90000' THEN
    vKOL_NET:=(vVES*(1-vP_SOL/100-vP_DIRT/100-vP_VOD/100));
  ELSE
    vKOL_NET:=0;
  END IF;
  IF vSLIV=9 THEN
	vKOL_NET:=ROUND(vKOL_NET,7);
  ELSE
	vKOL_NET:=ROUND(vKOL_NET,3);
  END IF;	  

  IF vSLIV<>9 AND (pDEFI_MASS_ID=1 OR vFAS=0 OR vFAS=1) THEN
	-- Коррекция веса на воду (ж/д, СНП)
	IF pLOAD_TYPE_ID=1 AND vPLAT_ID=2641 THEN
	  IF vMG_VOD<>0 AND vMG_VOD>GET_PARAM_NORMA('MG_VOD') THEN
	    -- сожержание воды в мг/кг превышает норму
	    vVES:=vVES - ROUND(vVES * vMG_VOD / 1000000,3);
	  END IF;
	END IF;
  END IF;
  
  IF vVES<0 THEN
    vVES:=0;
  END IF;	

  -- Сохраняем результаты
  SET_PARAM('GOST',vGOST);
  SET_PARAM('P_VOD',ora_num_to_char(vP_VOD,'999.9999'));
  SET_PARAM('P_SOL',ora_num_to_char(vP_SOL,'999.9999'));
  SET_PARAM('FACT_PL',ora_num_to_char(vFACT_PL,'9.9999'));
  SET_PARAM('CTLV',ora_num_to_char(vCTLV,'9.9999'));
  SET_PARAM('VOLUME',ora_num_to_char(vVOLUME));
  SET_PARAM('VOLUME15',ora_num_to_char(vVOLUME15));
  SET_PARAM('UPAK_VES',ora_num_to_char(vUPAK_VES,'999.999'));
  SET_PARAM('UPAK_VES_ED',ora_num_to_char(vUPAK_VES_ED,'999.999'));
  SET_PARAM('KOL_ED',ora_num_to_char(vKOL_ED));
  SET_PARAM('VES_ED',ora_num_to_char(vVES_ED,'999.999'));
  SET_PARAM('PODDON_VES',ora_num_to_char(vPODDON_VES));
  SET_PARAM('SHIELD_VES',ora_num_to_char(vSHIELD_VES));
  SET_PARAM('VES_ALL',ora_num_to_char(vVES_ALL,'999.999'));
  SET_PARAM('VES_CIST',ora_num_to_char(vVES_CIST,'999.999'));
  SET_PARAM('VES',ora_num_to_char(vVES/*,'999.9999999'*/));
  SET_PARAM('KOL_NET',ora_num_to_char(vKOL_NET/*,'999.999'*/));
  COMMIT;
  RETURN vVES;
END;

END; 
/

