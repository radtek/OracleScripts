--
-- REESTR_RAIL_SF  (Table) 
--
CREATE TABLE MASTER.REESTR_RAIL_SF
(
  NUM_PER            VARCHAR2(10 BYTE),
  DATA_PER           DATE,
  TARIF              NUMBER                     DEFAULT 0,
  TARNDS             NUMBER                     DEFAULT 0,
  REESTR_RAIL_SF_ID  NUMBER                     NOT NULL
)
TABLESPACE USERS2
NOCOMPRESS ;


