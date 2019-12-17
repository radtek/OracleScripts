--
-- FOR_AZC  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Azc AS

  -- Остаток веса по АЗС, продукту, собственнику на определенную дату
  FUNCTION GET_AZC_OST_VES(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE, FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;
  FUNCTION GET_AZC_OST_VES_ex(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE, FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;

  -- Остаток объема по АЗС, продукту, собственнику на определенную дату
  FUNCTION GET_AZC_OST_VOL(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE,FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;
  FUNCTION GET_AZC_OST_VOL_ex(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE,FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;

  -- Остаток веса на хранении по АЗС, продукту, собственнику на определенную дату
  FUNCTION GET_AZC_HRAN_VES(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE, FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;

  -- Остаток объема на хранении по АЗС, продукту, собственнику на определенную дату
  FUNCTION GET_AZC_HRAN_VOL(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pSOBSTV_ID NUMBER, pDATE_OPER DATE DEFAULT SYSDATE, FIRST_DAY NUMBER DEFAULT 1) RETURN NUMBER;
  -- Остаток объема продукта по объекту по всем собственникам
  FUNCTION GET_AZC_OST_VOL_all(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pDATE_OPER DATE DEFAULT SYSDATE) RETURN NUMBER;
  -- Остаток веса продукта по объекту по всем собственникам
  FUNCTION GET_AZC_OST_VES_all(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pDATE_OPER DATE DEFAULT SYSDATE) RETURN NUMBER;
  -- Остаток весь по продукту и собственнику
  FUNCTION get_azc_ost_allv(pPROD_ID VARCHAR2, pID_KIND_ORG NUMBER, pID_SOBSTV NUMBER, pTYPE VARCHAR2,  pDATE_OPER DATE DEFAULT SYSDATE) RETURN NUMBER;
  -- вывод остатов объетка по продукту 
  FUNCTION get_vol_rez(pID_ORG VARCHAR2, pID_PROD NUMBER, pTYPE VARCHAR2 DEFAULT 'DEAD', pDATE DATE DEFAULT SYSDATE) RETURN NUMBER;
  
  -- функция вывода веса последней записи по собственнику,объекту, продукту
  FUNCTION get_ves_last(pID_SOBSTV NUMBER, pID_ORG NUMBER, pID_PROD NUMBER,pDATE DATE DEFAULT SYSDATE) RETURN NUMBER;
  
  -- процедура проставление остатков на месяц
  -- date_from - дата из меяца остатков , date_to  -  дата из месяца, куда остатки будт проставлены  
  PROCEDURE for_rec_ostatki(DATE_FROM DATE, DATE_TO DATE);
  
  PROCEDURE for_rec_catalog(date_to DATE);


 --Функция возвращает сумму по весу за данный период (АЗС, ПРОДУКТ, ОПЕРАЦИЯ,ДАТА НАЧАЛА, ДАТА КОНЦА) 
  FUNCTION GET_AZC_WEEK_PARUS(pORG_STRU_ID NUMBER, pPROD_ID_NPR VARCHAR2, pID_OPERATION NUMBER,pDateFirst DATE, pDateLast DATE DEFAULT SYSDATE) RETURN NUMBER;
  
 --перенос сумм по операции и продукту 
  PROCEDURE for_week_parus (DATE_FROM VARCHAR2, DATE_TO VARCHAR2);
-- перенос остатков с приведением к общему продукту
   PROCEDURE for_rec_ostatki_rename(DATE_FROM DATE, DATE_TO DATE);
  
    
END;

/

