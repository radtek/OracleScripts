--
-- VALSVED_OPDT_I  (Index) 
--
CREATE INDEX MASTER.VALSVED_OPDT_I ON MASTER.KLS_VALSVED
(SVED_FLG_OPERDATA, FROM_DBF, DATEUPLOAD)
TABLESPACE USERSINDX;


