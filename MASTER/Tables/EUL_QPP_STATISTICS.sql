--
-- EUL_QPP_STATISTICS  (Table) 
--
CREATE TABLE MASTER.EUL_QPP_STATISTICS
(
  QS_ID              NUMBER(10)                 NOT NULL,
  QS_COST            NUMBER,
  QS_ACT_CPU_TIME    NUMBER,
  QS_ACT_ELAP_TIME   NUMBER,
  QS_EST_ELAP_TIME   NUMBER,
  QS_DATE_STAMP      DATE,
  QS_OBJECT_USE_KEY  VARCHAR2(240 BYTE),
  QS_SUMMARY_FIT     NUMBER(2),
  QS_USERNAME        VARCHAR2(64 BYTE),
  QS_SDO_ID          NUMBER(10),
  QS_DBMP0           RAW(250),
  QS_DBMP1           RAW(250),
  QS_DBMP2           RAW(250),
  QS_DBMP3           RAW(250),
  QS_DBMP4           RAW(250),
  QS_DBMP5           RAW(250),
  QS_DBMP6           RAW(250),
  QS_DBMP7           RAW(250),
  QS_MBMP0           RAW(250),
  QS_MBMP1           RAW(250),
  QS_MBMP2           RAW(250),
  QS_MBMP3           RAW(250),
  QS_MBMP4           RAW(250),
  QS_MBMP5           RAW(250),
  QS_MBMP6           RAW(250),
  QS_MBMP7           RAW(250),
  QS_JBMP0           RAW(250),
  QS_JBMP1           RAW(250),
  QS_JBMP2           RAW(250),
  QS_JBMP3           RAW(250),
  QS_JBMP4           RAW(250),
  QS_JBMP5           RAW(250),
  QS_JBMP6           RAW(250),
  QS_JBMP7           RAW(250)
)
TABLESPACE USERS2
NOCOMPRESS ;


