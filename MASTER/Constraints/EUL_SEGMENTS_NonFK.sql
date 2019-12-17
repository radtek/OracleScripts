-- 
-- Non Foreign Key Constraints for Table EUL_SEGMENTS 
-- 
ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CONSTRAINT EUL_OSS_CHECK_1
  CHECK ( (oss_obj_id is null or oss_seg_type in (1, 2)) and (oss_sumo_id is null or oss_seg_type = 3) and (oss_bq_id is null or oss_seg_type = 4) and (oss_cuo_id is null or oss_seg_type = 5) and (oss_exp_id is null or oss_seg_type = 6) )
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CONSTRAINT EUL_OSS_CHECK_2
  CHECK ( oss_obj_id is not null or oss_sumo_id is not null or oss_bq_id is not null or oss_cuo_id is not null or oss_exp_id is not null )
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CONSTRAINT EUL_OSS_CHECK_3
  CHECK ( oss_seg_type IN (1, 2, 3, 4, 5, 6, 0 ) )
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CHECK ("OSS_SEG_TYPE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CHECK ("OSS_SEQUENCE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CONSTRAINT EUL_OSS_PK
  PRIMARY KEY
  (OSS_ID)
  USING INDEX MASTER.EUL_OSS_PK
  ENABLE VALIDATE);

ALTER TABLE MASTER.EUL_SEGMENTS ADD (
  CONSTRAINT EUL_OSS_OSS2_UK
  UNIQUE (OSS_SUMO_ID, OSS_SEG_TYPE, OSS_SEQUENCE, OSS_OBJ_ID, OSS_CUO_ID, OSS_BQ_ID, OSS_EXP_ID)
  USING INDEX MASTER.EUL_OSS_OSS2_UK
  ENABLE VALIDATE);

