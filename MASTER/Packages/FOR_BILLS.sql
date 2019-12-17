--
-- FOR_BILLS  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Bills AS

TYPE CURSTYPE IS REF CURSOR;

-- Возвращает № счета СНП к счету от ЛУКОЙЛа 
FUNCTION NPO_SF$BILLS(AIS_AGENT NUMBER, ADATE_KVIT DATE, ANPO_SF VARCHAR2, ANOM_SF NUMBER) RETURN VARCHAR2;

-- Обновляет BILLS_SNP 
PROCEDURE FIELDS$BILLS_SNP(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='');

-- Обновляет BILL_POS_SNP 
PROCEDURE FIELDS$BILL_POS_SNP(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='');

-- Формирование/обновление счетов на предоплату
PROCEDURE ADD_BILL_PREPAY(ANOM_ZD VARCHAR2, ASVED_NUM NUMBER);

--- Начальное заполнение списка квитанций при выставлении счета
-- PROCEDURE FILL_TEMP_BILL_KVIT (DATE_KVIT# VARCHAR2,NUM_KVIT# VARCHAR2);

--- Определение вознаграждения в зависимости от расстояния
--- pKVIT_ID - ID отгрузки
--- pERR_TXT - пояснение к ошибке;
--- ВОЗВРАЩАЕМОЕ ЗНАЧЕНИЕ:
-- >=0 - сумма вознаграждения (руб/тн)
-- <0 - код ошибки
VR$BAD_RAST CONSTANT NUMBER := -1;
VR$BAD_RAST_TXT CONSTANT VARCHAR2(100) := 'Расстояние до станции равно 0';
VR$OLD_ALGORITM CONSTANT NUMBER := -2;
VR$OLD_ALGORITM_TXT CONSTANT VARCHAR2(100) := 'Вознаграждение считать по старому (как до 01.07.2003)';
VR$VOZN_NOT_FOUND CONSTANT NUMBER := -3;
VR$VOZN_NOT_FOUND_TXT CONSTANT VARCHAR2(100) := 'Не найдено вознаграждение в таблице вознаграждений';
VR$KVIT_NOT_FOUND CONSTANT NUMBER := -4;
VR$KVIT_NOT_FOUND_TXT CONSTANT VARCHAR2(100) := 'Отгрузка не найдена';

VR$OK_0_TXT CONSTANT VARCHAR2(100) := 'Вознаграждение за организацию транспортировки в вагонах МПС';
VR$OK_1_TXT CONSTANT VARCHAR2(100) := 'Вознаграждение за организацию транспортировки в собственных вагонах';
VR$OK_2_TXT CONSTANT VARCHAR2(100) := 'Вознаграждение за организацию транспортировки в арендованных вагонах';
VR$OK_3_TXT CONSTANT VARCHAR2(100) := 'Вознаграждение за организацию транспортировки в вагонах ЛУКОЙЛ''а';

FUNCTION GET_VOZN_RST(pKVIT_ID NUMBER, pERR_TXT OUT VARCHAR2) RETURN NUMBER;

--- Начальное заполнение списка квитанций при выставлении счета
PROCEDURE FILL_TEMP_BILL_KVIT (DATE_KVIT# VARCHAR2,NUM_KVIT# VARCHAR2,NOM_DOK# NUMBER);

--- Расчет сумм в списке квитанций при выставлении счета
PROCEDURE CALC_TEMP_BILL_KVIT (CENA_ID# NUMBER);

--- Определение размера налога НДС на заданную дату в %
FUNCTION GetNDSValue(DATE# DATE) RETURN FLOAT;

--- Определение размера налога НДС на заданную дату в %
FUNCTION GetNDSValueSTR(pDATE VARCHAR2) RETURN FLOAT;

-- Получаем текст о вознаграждении по страрому
FUNCTION GET_VOZN_OLD(pKVIT_ID NUMBER) RETURN VARCHAR2;
-- Определение вознаграждения в вагонах МПС и не МПС 
FUNCTION GET_VOZN_FOR_A_KVIT(pKVIT_ID NUMBER,KINDA_VOZN NUMBER) RETURN NUMBER;

-- Определение страховки
FUNCTION GET_STRH_FOR_A_KVIT(pKVIT_ID NUMBER) RETURN NUMBER;
   
-- Определение страховки на предмет исчисления оной с полной суммы
FUNCTION GET_STRH_KOEF_FOR_A_KVIT(pKVIT_ID NUMBER) RETURN NUMBER;

-- Проставление цены по продукту
PROCEDURE SET_TEMP_BILL_KVIT_PRICE(ID_NPR# VARCHAR2,CENA_ID# NUMBER);

-- Запись нового счета, возвращает NOM_DOK
FUNCTION NEW_BILL(CDATE_VYP_SF# VARCHAR2,CDATE_BUXG# VARCHAR2,NOM_DOK_ED# NUMBER, STORNO# NUMBER) RETURN NUMBER;

-- Удаление счета
FUNCTION DEL_BILL(NOM_DOK# NUMBER) RETURN NUMBER;

-- Добавление квитанции в счет
FUNCTION ADD_KVIT(NUM_KVIT# NUMBER) RETURN NUMBER;

-- Удаление квитанции из счета
FUNCTION DEL_KVIT(NUM_KVIT# NUMBER) RETURN NUMBER;

-- Получить новый номер счет фактуры 
FUNCTION GET_NOM_SF(DATE_VYP_SF# DATE) RETURN NUMBER;

FUNCTION Place_Payments_on_Bills (dog_id# NUMBER, nom_dok# NUMBER, 
  payments_id# NUMBER, realiz_d VARCHAR2)
RETURN VARCHAR2;

FUNCTION Del_Payments_from_Bill
 (nom_dok# NUMBER, payment_id# NUMBER)
RETURN VARCHAR2;

FUNCTION Del_Payments_from_Bill_Period
  (date1# VARCHAR2, date2# VARCHAR2)
RETURN VARCHAR2;

-- Запись счета-фактуры на услуги
FUNCTION NEW_BILL_NO_OTGR(date_vyp_sf# VARCHAR2,dog_id# NUMBER,usl_number# NUMBER,nom_dok_ed# NUMBER, STORNO# NUMBER) RETURN NUMBER; 

-- Очистка TEMP_BILL_POS
PROCEDURE CLEAR_TEMP_BILL_POS(ed_nom_dok# NUMBER);

-- заполнение BILL_POS по определенным алгоритмам
PROCEDURE FILL_TEMP_BILL_POS(date_vyp_sf# VARCHAR2,dog_id# NUMBER,usl_number# NUMBER,ALG_ID# NUMBER); 
   
END;

/

