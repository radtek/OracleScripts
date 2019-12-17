--
-- SPECIF  (Table) 
--
CREATE TABLE MASTER.SPECIF
(
  ID            NUMBER(10)                      NOT NULL,
  DOG_ID        NUMBER(5),
  PROD_ID_NPR   VARCHAR2(5 BYTE),
  LOAD_ABBR     VARCHAR2(3 BYTE),
  STANOTP_ID    NUMBER(10),
  STAN_ID       NUMBER(10),
  VETKA_ID      NUMBER(4),
  POLUCH_ID     NUMBER(6),
  POTREB_ID     NUMBER(6),
  PRIM          VARCHAR2(100 BYTE)              DEFAULT ' ',
  GR4           VARCHAR2(100 BYTE),
  BEGIN_DATE    DATE,
  END_DATE      DATE,
  M1            NUMBER(15,6)                    DEFAULT 0,
  M2            NUMBER(15,6)                    DEFAULT 0,
  M3            NUMBER(15,6)                    DEFAULT 0,
  M4            NUMBER(15,6)                    DEFAULT 0,
  M5            NUMBER(15,6)                    DEFAULT 0,
  M6            NUMBER(15,6)                    DEFAULT 0,
  M7            NUMBER(15,6)                    DEFAULT 0,
  M8            NUMBER(15,6)                    DEFAULT 0,
  M9            NUMBER(15,6)                    DEFAULT 0,
  M10           NUMBER(15,6)                    DEFAULT 0,
  M11           NUMBER(15,6)                    DEFAULT 0,
  M12           NUMBER(15,6)                    DEFAULT 0,
  KV1           NUMBER(15,6)                    DEFAULT 0,
  KV2           NUMBER(15,6)                    DEFAULT 0,
  KV3           NUMBER(15,6)                    DEFAULT 0,
  KV4           NUMBER(15,6)                    DEFAULT 0,
  VES_ALL       NUMBER(15,6)                    DEFAULT 0,
  APPL_TAG      VARCHAR2(6 BYTE),
  UPDATE_DATE   DATE,
  MONTH_ALL_ID  NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.SPECIF.ID IS 'Портфель заказов';

COMMENT ON COLUMN MASTER.SPECIF.APPL_TAG IS 'Тег приложения';

COMMENT ON COLUMN MASTER.SPECIF.UPDATE_DATE IS 'Дата обновления';

COMMENT ON COLUMN MASTER.SPECIF.MONTH_ALL_ID IS 'Ссылка на заказ потребителя';



