--
-- V_SVED_P_VOD  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SVED_P_VOD
(SVED_ID, P_VOD)
AS 
SELECT /*+ ordered use_nl(KLS_VALSVED,KLS_KODIF) index(KLS_VALSVED VALSVED_SVED_FK_I)*/ KLS_VALSVED.SVED_ID, NVL(KLS_VALSVED.QUAL,0) AS U_VES
FROM KLS_VALSVED,KLS_KODIF
WHERE KLS_VALSVED.KODIF_ID = KLS_KODIF.ID AND NLS_UPPER(KLS_KODIF.FIELD_SVED) = 'P_VOD';

