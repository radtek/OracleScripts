--
-- REESTR_RAIL  (Table) 
--
CREATE TABLE MASTER.REESTR_RAIL
(
  NUM_PER         VARCHAR2(10 BYTE),
  DATA_PER        DATE,
  DATE_OTGR       DATE,
  NUM_KVIT        NUMBER,
  TARIF           NUMBER                        DEFAULT 0,
  TARNDS          NUMBER                        DEFAULT 0,
  NOM_ZD          VARCHAR2(12 BYTE),
  GUARD           NUMBER                        DEFAULT 0,
  GUARDNDS        NUMBER                        DEFAULT 0,
  REESTR_RAIL_ID  NUMBER
)
TABLESPACE USERS2
NOCOMPRESS ;


