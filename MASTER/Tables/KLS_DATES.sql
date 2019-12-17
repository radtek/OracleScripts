--
-- KLS_DATES  (Table) 
--
CREATE TABLE MASTER.KLS_DATES
(
  VALUE        DATE                             NOT NULL,
  DAY_OF_WEEK  NUMBER(2),
  IS_WORK      NUMBER(1)                        DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.KLS_DATES.DAY_OF_WEEK IS 'День недели (1-Понедельник)';

COMMENT ON COLUMN MASTER.KLS_DATES.IS_WORK IS 'Рабочий день';



