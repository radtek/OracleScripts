CREATE OR REPLACE PROCEDURE       Snp_P_Crnewnom_group
--меняет группу у номенклатуры в спецификации
(v_nrn IN NUMBER, --номер, спецификации
 v_sgroup IN VARCHAR2 -- новая ггруппа номенкалтуры
)
AS
v_sgroup_ NUMBER;
BEGIN

FOR mas IN
(
SELECT /*+Rule*/   A.NCOMPANY, B.*  FROM v_inorderspecs A, v_dicnomns B
WHERE
a.nrn =  v_nrn
AND A.SNOMEN = B.NOMEN_CODE
)

LOOP
P_DICNOMNS_UPDATE
(
nCOMPANY => mas.NCOMPANY,
nRN  => mas.rn,
sNM_CODE => mas.NOMEN_CODE,
sNM_NAME => mas.NOMEN_NAME,
sMEAS_MAIN => mas.UMEAS_MAIN,
sMEAS_ALT => mas.UMEAS_ALT,
nEQUAL => mas.EQUAL,
nSIGN_ACNT => mas.SIGN_ACNT,
nSIGN_DOCS => mas.SIGN_DOCS,
sGROUP_CODE =>  v_sgroup,
sTAX_GROUP => mas.STAX_GROUP,
sNALTAX_GROUP => mas.SNALTAX_GROUP,
nSIGN_UMEAS => mas.SIGN_UMEAS,
nNOMEN_TYPE => mas.NOMEN_TYPE,
nSIGN_SERIAL => mas.SIGN_SERIAL,
nSIGN_MODIF => mas.SIGN_MODIF,
nSIGN_PARTY => mas.SIGN_PARTY,
nCNTRNDM => mas.nCNTRNDM,
nMTDRNDM => mas.nMTDRNDM,
nCNTRNDS => mas.nCNTRNDS,
nMTDRNDS => mas.nMTDRNDS,
sOKDP => mas.OKDP,
nSIGN_SET => mas.nSIGN_SET,
nSIGN_SET_DIVIDE => mas.NSIGN_SET_DIVIDE,
nWIDTH => mas.NWIDTH,
nHEIGHT => mas.NHEIGHT,
nLENGTH => mas.NLENGTH,
nWEIGHT => mas.NWEIGHT,
nMU_SIZE => mas.NMU_SIZE,
nMU_WEIGHT => mas.NMU_WEIGHT,
nTEMP_FROM => mas.NTEMP_FROM,
nTEMP_TO => mas.NTEMP_TO,
nHUMID_FROM => mas.NHUMID_FROM,
nHUMID_TO => mas.nHUMID_TO,
nCOMMON_PR_SIGN => mas.NCOMMON_PR_SIGN
);
END LOOP;
END;
/

