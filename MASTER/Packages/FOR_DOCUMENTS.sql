--
-- FOR_DOCUMENTS  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Documents AS

-- Найти документ по реквизитам (ID<>pDocId)
-- Возвращаемое значение:
-- 				>0 - Номер найденного документа
--				0 - не существует
-- 				<0 - Ошибка
FUNCTION CHECK_EXIST(pDocType NUMBER, pMestoId NUMBER, pDocId VARCHAR2, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE) RETURN NUMBER;

-- Проверить номер документа в списках на резервирование других пользователей
-- Возвращаемое значение:
-- 				1 - уже существует
--				0 - не существует
-- 				<0 - Ошибка
FUNCTION CHECK_RESERV(pDocType NUMBER, pMestoId NUMBER, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE) RETURN NUMBER;

-- Очистить список зарезервированных номеров для данного типа документа
-- текущего пользователя
PROCEDURE CLEAR_RESERV (pDocType NUMBER, pMestoId NUMBER);

-- Определить следующий номер документа
-- Возвращаемое значение - номер документа
FUNCTION GET_NEXT_NUM(pDocType NUMBER, pMestoId NUMBER, pDocPrefix VARCHAR2, pDocDate DATE) RETURN NUMBER;

-- Сохранить номер документа
PROCEDURE SET_NUM(pDocType NUMBER, pMestoId NUMBER, pDocId VARCHAR2, pDocPrefix VARCHAR2, pDocNum NUMBER, pDocDate DATE);

END;

/

