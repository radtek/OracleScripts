-- 
-- Non Foreign Key Constraints for Table OIL_TRACE 
-- 
ALTER TABLE MASTER.OIL_TRACE ADD (
  CONSTRAINT OIL_TRACE_PK
  PRIMARY KEY
  (KOD)
  USING INDEX MASTER.OIL_TRACE_PK
  ENABLE VALIDATE);
