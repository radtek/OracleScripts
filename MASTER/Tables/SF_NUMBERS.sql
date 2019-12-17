--
-- SF_NUMBERS  (Table) 
--
CREATE TABLE MASTER.SF_NUMBERS
(
  FROM_DATE  DATE,
  TO_DATE    DATE,
  START_NUM  NUMBER                             DEFAULT 0,
  CURR_NUM   NUMBER                             DEFAULT 0,
  RANGE      NUMBER                             DEFAULT 0
)
TABLESPACE USERS2
NOCOMPRESS ;


