--
-- PLAN_STRU_RELATIONS  (Table) 
--
CREATE TABLE MASTER.PLAN_STRU_RELATIONS
(
  PLAN_FROM_ID      NUMBER(2)                   NOT NULL,
  PLANSTRU_FROM_ID  NUMBER(20)                  NOT NULL,
  PLAN_TO_ID        NUMBER(2)                   NOT NULL,
  PLANSTRU_TO_ID    NUMBER(20)                  NOT NULL
)
TABLESPACE USERS2
NOCOMPRESS ;


