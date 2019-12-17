--
-- BILLS_TMP  (Table) 
--
CREATE TABLE MASTER.BILLS_TMP
(
  NOM_DOK         NUMBER(10),
  NOM_SF          NUMBER(7),
  DATE_VYP_SF     DATE,
  DATE_KVIT       DATE,
  DATE_BUXG       DATE,
  SUMMA_DOK       NUMBER(15,2)                  DEFAULT 0,
  NDS_DOK         NUMBER(15,2)                  DEFAULT 0,
  GSM_DOK         NUMBER(15,2)                  DEFAULT 0,
  AKCIZ_DOK       NUMBER(15,2)                  DEFAULT 0,
  PRIM            VARCHAR2(65 BYTE),
  FIO_ISPOL       VARCHAR2(40 BYTE),
  KOL_DN          NUMBER(5)                     DEFAULT 0,
  OLD_NOM_DOK     NUMBER(7),
  NOM_ZD          VARCHAR2(12 BYTE),
  OWNER_ID        NUMBER(6),
  DOG_ID          NUMBER(10),
  USL_NUMBER      NUMBER(3),
  PROD_ID_NPR     VARCHAR2(5 BYTE),
  PROD_SUM        NUMBER(15,2)                  DEFAULT 0,
  PROD_NDS        NUMBER(15,2)                  DEFAULT 0,
  PROD_GSM        NUMBER(15,2)                  DEFAULT 0,
  PROD_AKCIZ      NUMBER(15,2)                  DEFAULT 0,
  DATE_MOS        DATE,
  NPO_SF          VARCHAR2(200 BYTE),
  OLD_NOM_SF      NUMBER(7),
  IS_AGENT        NUMBER(1),
  NUM_5_DAY       NUMBER(1),
  LUK_DOG_ID      NUMBER(10),
  LUK_USL_NUMBER  NUMBER(3),
  LUK_SUMMA_DOK   NUMBER(15,2),
  LUK_NDS_DOK     NUMBER(15,2),
  SNP_DOG_ID      NUMBER(10),
  SNP_USL_NUMBER  NUMBER(3),
  LUK_KOL_DN      NUMBER(5),
  SNP_KOL_DN      NUMBER(5),
  NAZN_OTG_ID     NUMBER(10)                    DEFAULT NULL,
  KORR_5_DAY      NUMBER(1),
  PROTO_NUM       VARCHAR2(15 BYTE),
  PROTO_DATE      DATE,
  NO_AKCIZ        NUMBER(1)                     DEFAULT 0,
  KORR_PROD       NUMBER(1)                     DEFAULT 0,
  DATE_PLAT       DATE,
  IS_KORR         NUMBER(1)                     DEFAULT 0,
  TO_KORR         NUMBER(1)                     DEFAULT 0,
  ISU_KOD         VARCHAR2(10 BYTE),
  ISU_NOM_SF      VARCHAR2(10 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.BILLS_TMP.ISU_NOM_SF IS 'Бухгалтерский № СФ из ИСУ';



