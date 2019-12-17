--
-- FOR_TEMP  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Temp AS

  /* Объявить временную переменную 
     pVariName - имя переменной
     pVariValue - значение переменной
	 pAppName - приложение (можно не указывать)
	 pUnitName - модуль (можно не указывать)
  */	   
  FUNCTION SET_VARI(pVariName VARCHAR2, PVariValue NUMBER, pAppName VARCHAR2:='', pUnitName VARCHAR2:='', pTime NUMBER := 1) RETURN NUMBER;
  FUNCTION SET_VARI(pVariName VARCHAR2, PVariValue DATE, pAppName VARCHAR2:='', pUnitName VARCHAR2:='', pTime NUMBER := 1) RETURN NUMBER;
  FUNCTION SET_VARI(pVariName VARCHAR2, PVariValue VARCHAR2, pAppName VARCHAR2:='', pUnitName VARCHAR2:='', pTime NUMBER := 1) RETURN NUMBER;

  /* Прочитать значение временной переменной
     pVariName - имя переменной
	 pAppName - приложение (можно не указывать)
	 pUnitName - модуль (можно не указывать)
	 pVariId - ID переменной (указывать если pVariName=NULL)
  */	   
  FUNCTION GET_AS_NUM(pVariName VARCHAR2, pAppName VARCHAR2:='', PUnitName VARCHAR2:='', PVariId NUMBER:=NULL) RETURN NUMBER;
  FUNCTION GET_AS_DATE(pVariName VARCHAR2, pAppName VARCHAR2:='', PUnitName VARCHAR2:='', PVariId NUMBER:=NULL, pFormat VARCHAR2:='dd.mm.yyyy hh24:mi:ss') RETURN DATE;
  FUNCTION GET_AS_CHAR(pVariName VARCHAR2, pAppName VARCHAR2:='', PUnitName VARCHAR2:='', PVariId NUMBER:=NULL, pFormat VARCHAR2:='dd.mm.yyyy hh24:mi:ss') RETURN VARCHAR2;

  /* Подчистка временных переменных */
  PROCEDURE CLEAR_TEMP_VARI;
  
  /* Параметры отчета */
  PROCEDURE SET_REPORT_PARAM_VALUE (pREP_ID NUMBER);

  /* Очистить параметры отчета */
  PROCEDURE EMPTY_REPORT_PARAM_VALUE (pREP_ID NUMBER);
    
END;

/

