--
-- PAYMENTS  (Table) 
--
CREATE TABLE MASTER.PAYMENTS
(
  ID          NUMBER                            NOT NULL,
  DOG_ID      NUMBER,
  BANK_ID     NUMBER(10),
  RS          VARCHAR2(20 BYTE),
  SUMMA       NUMBER(15,2)                      DEFAULT 0,
  NAZN_PLAT   VARCHAR2(500 BYTE),
  OURBANK_ID  NUMBER(10),
  NUM_PLAT    VARCHAR2(20 BYTE),
  DATE_PLAT   DATE,
  PAYFORM_ID  NUMBER,
  DATE_POST   DATE,
  DEST_ID     NUMBER(10)                        DEFAULT 1,
  RS_ID       NUMBER                            DEFAULT 9
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.PAYMENTS.DATE_POST IS 'Дата попадания платежки в выписку (дата прихода платежа)';

COMMENT ON COLUMN MASTER.PAYMENTS.DEST_ID IS 'Назначение (для процедуры закрытия)';



