--
-- DISP_AZS_MANUAL  (Table) 
--
CREATE TABLE MASTER.DISP_AZS_MANUAL
(
  ID           NUMBER(10)                       NOT NULL,
  OSUSER       VARCHAR2(50 BYTE),
  TERMINAL     VARCHAR2(50 BYTE),
  BEG_DATE     DATE,
  END_DATE     DATE,
  ORG_STRU_ID  NUMBER(10),
  PROD_ID_NPR  VARCHAR2(5 BYTE),
  IN_O_VOL     NUMBER(20,3)                     DEFAULT 0,
  IN_O_MAS     NUMBER(20,3)                     DEFAULT 0,
  OUT_O_VOL    NUMBER(20,3)                     DEFAULT 0,
  OUT_O_MAS    NUMBER(20,3)                     DEFAULT 0,
  END_VOLUME   NUMBER(20,3)                     DEFAULT 0,
  END_MASSA    NUMBER(20,3)                     DEFAULT 0,
  OUT_O_1_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_1_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_2_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_2_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_3_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_3_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_4_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_4_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_5_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_5_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_6_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_6_MAS  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_7_VOL  NUMBER(20,3)                     DEFAULT 0,
  OUT_O_7_MAS  NUMBER(20,3)                     DEFAULT 0,
  LAST_DAY     DATE
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.DISP_AZS_MANUAL IS 'Временная таблица для отчета disp_azs (НЕ автоматизированные АЗС)';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.ID IS 'ID';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.OSUSER IS 'Пользователь';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.TERMINAL IS 'Терминал';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.ORG_STRU_ID IS 'Склад (АЗС)';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.PROD_ID_NPR IS 'Продукт';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.OUT_O_VOL IS 'Реализовано (л) с начала месяца';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.OUT_O_MAS IS 'Реализовано (т) с начала месяца';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.END_VOLUME IS 'Остаток (л)';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.END_MASSA IS 'Остаток (т)';

COMMENT ON COLUMN MASTER.DISP_AZS_MANUAL.LAST_DAY IS 'На конец дня';



