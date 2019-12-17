-- 
-- Non Foreign Key Constraints for Table REESTR_RAIL_SF 
-- 
ALTER TABLE MASTER.REESTR_RAIL_SF ADD (
  CONSTRAINT REESTR_RAIL_SF_PK
  PRIMARY KEY
  (REESTR_RAIL_SF_ID)
  USING INDEX MASTER.REESTR_RAIL_SF_PK
  ENABLE VALIDATE);
