--
-- GU12_BR  (Table) 
--
CREATE TABLE MASTER.GU12_BR
(
  ID             NUMBER,
  ID_B           NUMBER,
  DATE_R         DATE,
  KOL_VAG        NUMBER(8)                      DEFAULT 0,
  VES            NUMBER(8)                      DEFAULT 0,
  ID_NPR         VARCHAR2(5 BYTE),
  METKA          NUMBER(1),
  ZAKAZ_HIST_ID  NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.GU12_BR.ZAKAZ_HIST_ID IS 'Позиция заказа клиента';



