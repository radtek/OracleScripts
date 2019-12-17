--
-- KLS_NAR_LINE  (Table) 
--
CREATE TABLE MASTER.KLS_NAR_LINE
(
  ID         NUMBER(10)                         NOT NULL,
  NARIAD_ID  NUMBER(10),
  NOM_ZD     VARCHAR2(12 BYTE),
  IS_LOADED  NUMBER(1)                          DEFAULT 0,
  VES        NUMBER(14,3)                       DEFAULT 0,
  KOL        NUMBER(5)                          DEFAULT 0,
  FACT_VES   NUMBER(14,3)                       DEFAULT 0,
  FACT_KOL   NUMBER(5)                          DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_NAR_LINE IS 'Позиции наряда / разрешения на отгрузку';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.NARIAD_ID IS 'ID наряда';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.NOM_ZD IS '№ задания';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.VES IS 'Вес к отгрузке, тн';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.KOL IS 'Кол-во к отгрузке';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.FACT_VES IS 'Фактически отгружено, тн';

COMMENT ON COLUMN MASTER.KLS_NAR_LINE.FACT_KOL IS 'Фактически отгружено, кол-во';



