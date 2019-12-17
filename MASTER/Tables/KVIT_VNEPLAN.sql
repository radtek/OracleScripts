--
-- KVIT_VNEPLAN  (Table) 
--
CREATE TABLE MASTER.KVIT_VNEPLAN
(
  NOM_Z       VARCHAR2(15 BYTE)                 NOT NULL,
  NUM_KVIT    NUMBER(15)                        NOT NULL,
  IS_VNEPLAN  NUMBER(1)                         DEFAULT 1                     NOT NULL
)
TABLESPACE USERS
NOCOMPRESS ;


