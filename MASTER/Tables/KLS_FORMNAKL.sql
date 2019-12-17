--
-- KLS_FORMNAKL  (Table) 
--
CREATE TABLE MASTER.KLS_FORMNAKL
(
  ID            NUMBER(2)                       NOT NULL,
  FLG_DOSTUP    NUMBER(1),
  FORM_NAME     VARCHAR2(30 BYTE),
  FLG_GROUP     NUMBER(1),
  IS_RUS        NUMBER(1)                       DEFAULT 0,
  LOAD_TYPE_ID  NUMBER(10)                      DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.KLS_FORMNAKL.IS_RUS IS '1-российские накладные';



