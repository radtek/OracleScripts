--
-- MONTH_REE  (Table) 
--
CREATE TABLE MASTER.MONTH_REE
(
  DATE_REE  DATE                                NOT NULL,
  DOP_REE   NUMBER(1)                           NOT NULL,
  NOM_ZD    VARCHAR2(12 BYTE)                   NOT NULL,
  VES       NUMBER(14,3)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.MONTH_REE IS '"Старый" суточный реестр заданий';



