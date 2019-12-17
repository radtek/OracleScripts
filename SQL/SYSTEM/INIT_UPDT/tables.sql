
DROP TABLE PARUS.UPDATELIST_ARC CASCADE CONSTRAINTS;

--
-- UPDATELIST_ARC  (Table) 
--
CREATE TABLE PARUS.UPDATELIST_ARC
(
  RN         NUMBER(17)                         NOT NULL,
  TABLENAME  VARCHAR2(32)                       NOT NULL,
  COMPANY    NUMBER(17),
  VERSION    NUMBER(17),
  TABLERN    NUMBER(17)                         NOT NULL,
  AUTHID     VARCHAR2(30)                       NOT NULL,
  MODIFDATE  DATE                               NOT NULL,
  ARCDATE    DATE                               NOT NULL,
  OPERATION  VARCHAR2(1)                        NOT NULL,
  NOTE       VARCHAR2(2000)                     NOT NULL
)
TABLESPACE PARUS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          553080K
            NEXT             256M
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;



