--
-- KLS_RS  (Table) 
--
CREATE TABLE MASTER.KLS_RS
(
  ID       NUMBER                               NOT NULL,
  RS       VARCHAR2(20 BYTE),
  RS_NAME  VARCHAR2(50 BYTE)
)
TABLESPACE USERS2
NOCOMPRESS ;

COMMENT ON TABLE MASTER.KLS_RS IS 'Рассчетные счета УНП';



