--
-- MON_VISIR_UNIQ  (Index) 
--
CREATE UNIQUE INDEX MASTER.MON_VISIR_UNIQ ON MASTER.MONTH_VISIR
(DATE_REE, DOP_REE, NOM_ZD)
TABLESPACE USERSINDX;


