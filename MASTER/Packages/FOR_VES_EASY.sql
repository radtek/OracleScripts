--
-- FOR_VES_EASY  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_VES_EASY AS

/* Расчет факт.плотности по температуре и плотности при температуре <=-25 */
FUNCTION GET_FACT_PL_MOROZ(pTEMPER NUMBER, pPL NUMBER) RETURN NUMBER;

/* Расчет факт.плотности по температуре и плотности при 20'C по ГОСТ 3900-85 */
FUNCTION GET_FACT_PL_390085(pTEMPER NUMBER, pPL20 NUMBER) RETURN NUMBER;

/* Определение коэффициента коррекции объема по ASTM D 1250 */
FUNCTION GET_CTLV_ASTMD1250(pTEMPER NUMBER, pPL15 NUMBER) RETURN NUMBER;

/* Определение текущего ГОСТа */
FUNCTION GET_DEFAULT_GOST (pLOAD_TYPE_ID NUMBER, pDATE_CALC DATE,
                           pTEMPER VARCHAR2, pPL15 NUMBER, pPL20 NUMBER) RETURN NUMBER;

/* Расчет объема при 15'C по фактическому объему */
FUNCTION GET_VOLUME15_BY_VOLUME (pDATE_CALC DATE, vVOLUME NUMBER, vTEMPER NUMBER, vCTLV NUMBER) RETURN NUMBER;

/* Расчет фактического объема по объему при 15'C */
FUNCTION GET_VOLUME_BY_VOLUME15 (pDATE_CALC DATE, vVOLUME15 NUMBER, vTEMPER NUMBER, vCTLV NUMBER) RETURN NUMBER;

/* Перерасчет весовых показателей */
FUNCTION CALC_VES(pLOAD_TYPE_ID NUMBER, pDATE_CALC DATE) RETURN NUMBER;

END;
/

