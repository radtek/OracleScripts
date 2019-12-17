--
-- KLS_PERTYPE  (Table) 
--
CREATE TABLE MASTER.KLS_PERTYPE
(
  ID            NUMBER(3)                       NOT NULL,
  PERTYPE_NAME  VARCHAR2(50 BYTE),
  BOSS          NUMBER(3),
  SORTBY        NUMBER(10)                      DEFAULT 99
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_PERTYPE IS 'Классификатор предприятий по видам деятельности (ОТРАСЛЬ)';

COMMENT ON COLUMN MASTER.KLS_PERTYPE.SORTBY IS '№ по порядку';



