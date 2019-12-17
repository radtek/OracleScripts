--
-- TEMPVARI  (Table) 
--
CREATE TABLE MASTER.TEMPVARI
(
  ID             NUMBER                         NOT NULL,
  TERMINAL_NAME  VARCHAR2(30 BYTE),
  OSUSER_NAME    VARCHAR2(30 BYTE),
  APP_NAME       VARCHAR2(30 BYTE),
  UNIT_NAME      VARCHAR2(30 BYTE),
  BEGIN_DATE     DATE,
  END_DATE       DATE,
  VARI_TYPE      VARCHAR2(10 BYTE),
  VARI_NAME      VARCHAR2(50 BYTE),
  NUM1           NUMBER,
  CHAR1          VARCHAR2(250 BYTE),
  DATE1          DATE,
  NUM2           NUMBER,
  CHAR2          VARCHAR2(250 BYTE),
  DATE2          DATE,
  NUM3           NUMBER,
  CHAR3          VARCHAR2(250 BYTE),
  DATE3          DATE,
  NUM4           NUMBER,
  CHAR4          VARCHAR2(250 BYTE),
  DATE4          DATE,
  NUM5           NUMBER,
  CHAR5          VARCHAR2(250 BYTE),
  DATE5          DATE,
  NUM6           NUMBER,
  CHAR6          VARCHAR2(250 BYTE),
  DATE6          DATE,
  NUM7           NUMBER,
  CHAR7          VARCHAR2(250 BYTE),
  DATE7          DATE,
  NUM8           NUMBER,
  CHAR8          VARCHAR2(250 BYTE),
  DATE8          DATE,
  NUM9           NUMBER,
  CHAR9          VARCHAR2(250 BYTE),
  DATE9          DATE,
  NUM10          NUMBER,
  CHAR10         VARCHAR2(250 BYTE),
  DATE10         DATE
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.TEMPVARI.TERMINAL_NAME IS 'Компьютер - заполняется автоматически';

COMMENT ON COLUMN MASTER.TEMPVARI.OSUSER_NAME IS 'Пользователь (Login) - заполняется автоматически';

COMMENT ON COLUMN MASTER.TEMPVARI.APP_NAME IS 'Приложение - заполняется по желанию';

COMMENT ON COLUMN MASTER.TEMPVARI.UNIT_NAME IS 'Модуль - заполняется по желанию';

COMMENT ON COLUMN MASTER.TEMPVARI.BEGIN_DATE IS 'Начало периода действия';

COMMENT ON COLUMN MASTER.TEMPVARI.END_DATE IS 'Окончание периода действия';

COMMENT ON COLUMN MASTER.TEMPVARI.VARI_TYPE IS 'Тип переменной (TABLE - таблица, NUM - число, CHAR - строка, DATE - дата/время)';

COMMENT ON COLUMN MASTER.TEMPVARI.VARI_NAME IS 'Имя переменной';

COMMENT ON COLUMN MASTER.TEMPVARI.NUM1 IS 'Числовое значение переменной';

COMMENT ON COLUMN MASTER.TEMPVARI.CHAR1 IS 'Строковое значение переменной';

COMMENT ON COLUMN MASTER.TEMPVARI.DATE1 IS 'Значение переменной типа Дата';



