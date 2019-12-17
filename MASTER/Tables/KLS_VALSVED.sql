--
-- KLS_VALSVED  (Table) 
--
CREATE TABLE MASTER.KLS_VALSVED
(
  SVED_ID            VARCHAR2(9 BYTE)           NOT NULL,
  KODIF_ID           NUMBER(5)                  NOT NULL,
  QUAL               VARCHAR2(12 BYTE),
  DATEUPLOAD         DATE                       DEFAULT SYSDATE,
  FROM_DBF           NUMBER(1)                  DEFAULT 0,
  SVED_FLG_OPERDATA  NUMBER(1)                  DEFAULT 1                     NOT NULL
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON COLUMN MASTER.KLS_VALSVED.FROM_DBF IS 'Признак загрузки из DBF';

COMMENT ON COLUMN MASTER.KLS_VALSVED.SVED_FLG_OPERDATA IS '1-оперативная, 0-документированная';



