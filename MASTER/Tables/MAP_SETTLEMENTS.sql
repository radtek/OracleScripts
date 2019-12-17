--
-- MAP_SETTLEMENTS  (Table) 
--
CREATE TABLE MASTER.MAP_SETTLEMENTS
(
  ID             NUMBER(10),
  X              NUMBER(10),
  Y              NUMBER(10),
  NAME           CHAR(255 BYTE),
  SYSTEMID       NUMBER(10)                     DEFAULT 0,
  SIZE1          NUMBER(10),
  SIZE2          NUMBER(10),
  UNDER_LINE     NUMBER(2),
  CAPTION_PLACE  NUMBER(2)
)
TABLESPACE USERS2
NOCOMPRESS ;


