--
-- TEMP_NAR_LINE  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE MASTER.TEMP_NAR_LINE
(
  NOM_ZD        VARCHAR2(12 BYTE)               NOT NULL,
  KOL           NUMBER(5)                       DEFAULT 0,
  VES           NUMBER(14,3)                    DEFAULT 0,
  FACT_KOL      NUMBER(5)                       DEFAULT 0                     NOT NULL,
  FACT_VES      NUMBER(14,3)                    DEFAULT 0                     NOT NULL,
  MON_KOL       NUMBER(5)                       DEFAULT 0                     NOT NULL,
  MON_VES       NUMBER(14,3)                    DEFAULT 0                     NOT NULL,
  MON_FACT_KOL  NUMBER(5)                       DEFAULT 0                     NOT NULL,
  MON_FACT_VES  NUMBER(14,3)                    DEFAULT 0                     NOT NULL,
  STAN_NAME     VARCHAR2(50 BYTE),
  PROD_NAME     VARCHAR2(20 BYTE),
  POLUCH_NAME   VARCHAR2(30 BYTE),
  TONN_REE      NUMBER(14,3)                    DEFAULT 0                     NOT NULL,
  NORMOTGR      NUMBER(4,1)                     DEFAULT 0                     NOT NULL,
  LOAD_TYPE_ID  NUMBER(10)
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE MASTER.TEMP_NAR_LINE IS 'Временная таблица для заполнения разрешения на отгрузку';



