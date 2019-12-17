--
-- FOR_INIT  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Init AS
  
--- Инициализация приложения MASTER 
PROCEDURE Init_MASTER;

-- Текущий пользователь
FUNCTION GetCurrUser RETURN VARCHAR2;

-- Текущая машина
FUNCTION GetCurrTerm RETURN VARCHAR2;

-- Текущая машина
FUNCTION GetCurrSessionId RETURN NUMBER;

-- Текущий пользователь приложения
FUNCTION AppUserId RETURN NUMBER;
FUNCTION AppUserName RETURN VARCHAR2;
FUNCTION AppUserPost RETURN VARCHAR2;
FUNCTION AppUserUNP RETURN NUMBER;
FUNCTION AppUserSNP RETURN NUMBER;
FUNCTION AppUserMNOS RETURN NUMBER;

-- Сбор статистики
PROCEDURE UPDATE_STAT;
    
END; 
/

