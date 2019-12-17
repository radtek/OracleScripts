--
-- KLS_PROD_AKCIZ  (Table) 
--
CREATE TABLE MASTER.KLS_PROD_AKCIZ
(
  FROM_DATE       DATE                          NOT NULL,
  TO_DATE         DATE                          NOT NULL,
  PROD_GROUPS_ID  NUMBER(10)                    NOT NULL,
  VALUE           NUMBER(15,6)                  DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_PROD_AKCIZ IS 'Ставки акциза';



