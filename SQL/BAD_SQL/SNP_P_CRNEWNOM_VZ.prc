CREATE OR REPLACE PROCEDURE       Snp_P_Crnewnom_Vz
/*
situation: ввод "новой" номенклатуры из определенного каталога
с правильной группой ТМЦ, которая определяется счетом из остатков
ТМЦ
warning: группы прописаны непосредственно в процедуре, по счету 10/6
группа ТМЦ не меняется  - генерируется только новая номенклатура
*/
(
v_crn_into IN VARCHAR2, --каталог куда будет вкачиваться номенклатура
v_schet IN VARCHAR2
)
AS
v_crn_into_num NUMBER; -- № каталог куда будет вкачиваться номенклатура
nRN1 NUMBER; -- № новой номенклатуры
new_rn_nom NUMBER;
flag_exist NUMBER;
ntmp NUMBER;
i NUMBER;
BEGIN
SELECT rn INTO v_crn_into_num
FROM ACATALOG
WHERE NAME =v_crn_into
AND docname ='Nomenclator';
i:=0;
FOR  mas IN (
SELECT A.accname,A.nomcode,A.NOMNAME, B.UMEAS_MAIN, B.UMEAS_ALT,B.EQUAL,   B.SIGN_ACNT, B.SIGN_DOCS, B.sGROUP_CODE,B.sTAX_GROUP,B.sNALTAX_GROUP,
B.SIGN_UMEAS, B.NOMEN_TYPE, B.SIGN_SERIAL,B.SIGN_MODIF,	 B.SIGN_PARTY, B.nCNTRNDM,B.nMTDRNDM, B.NSIGN_SET, B.nSIGN_SET_DIVIDE,
B.nWIDTH,B.nHEIGHT, B.nLENGTH, B.nWEIGHT, B.nMU_SIZE, B.nMU_WEIGHT,B.nCOMMON_PR_SIGN , B.nTEMP_TO , B.nTEMP_FROM,
B.nHUMID_FROM, B.nHUMID_TO,DECODE(TRIM(A.accname),'10/9','ИНВЕНТАРЬ','10/92','СПЕЦОДЕЖДА','10/5','АВТОЗАПЧАСТИ','НЕТ') AS my_group
FROM V_VALREMNS A, v_dicnomns B
WHERE remn_date = TO_DATE ('01.01.2004','dd.mm.yyyy')
AND A.NOMCODE = B.NOMEN_CODE
AND trim(A.accname) = v_schet
GROUP BY
A.accname,A.nomcode,A.NOMNAME, B.UMEAS_MAIN, B.UMEAS_ALT,B.EQUAL,   B.SIGN_ACNT, B.SIGN_DOCS, B.sGROUP_CODE,B.sTAX_GROUP,B.sNALTAX_GROUP,
B.SIGN_UMEAS, B.NOMEN_TYPE, B.SIGN_SERIAL,B.SIGN_MODIF,	 B.SIGN_PARTY, B.nCNTRNDM,B.nMTDRNDM, B.NSIGN_SET, B.nSIGN_SET_DIVIDE,
B.nWIDTH,B.nHEIGHT, B.nLENGTH, B.nWEIGHT, B.nMU_SIZE, B.nMU_WEIGHT,B.nCOMMON_PR_SIGN , B.nTEMP_TO , B.nTEMP_FROM,
B.nHUMID_FROM, B.nHUMID_TO
)
LOOP

i:= i+1;
IF i=10 THEN
i:=0;
END IF;

SELECT COUNT(*) INTO flag_exist FROM v_dicnomns
WHERE
NOMEN_NAME = mas.NOMNAME || '_';
IF flag_exist = 0 THEN
SELECT COUNT(*) INTO flag_exist FROM v_dicnomns
WHERE
NOMEN_CODE  =  SUBSTR('.' || mas.NOMCODE,1,LENGTH('.' || mas.NOMCODE)-2)||TO_CHAR(i);
END IF;

IF flag_exist=0 THEN
IF trim(mas.accname) = '10/6'  THEN
  P_DICNOMNS_INSERT(
  nCOMPANY => 2,
  nCRN   => v_crn_into_num,
  sNOMEN_CODE  => SUBSTR('.' || mas.NOMCODE,1,LENGTH('.' || mas.NOMCODE)-2)||TO_CHAR(i),
  sNOMEN_NAME => mas.NOMNAME || '_',
  sUMEAS_MAIN => mas.UMEAS_MAIN,
  sUMEAS_ALT  =>  mas.UMEAS_ALT,
  nEQUAL   => mas.EQUAL,
  nSIGN_ACNT => mas.SIGN_ACNT,
  nSIGN_DOCS => mas.SIGN_DOCS,
  sGROUP_CODE => mas.sGROUP_CODE,
  sTAX_GROUP => mas.sTAX_GROUP,
  sNALTAX_GROUP => mas.sNALTAX_GROUP,
  nSIGN_UMEAS => mas.SIGN_UMEAS,
  nNOMEN_TYPE => mas.NOMEN_TYPE,
  nSIGN_SERIAL => mas.SIGN_SERIAL,
  nSIGN_MODIF => mas.SIGN_MODIF,
  nSIGN_PARTY => mas.SIGN_PARTY,
  nCNTRNDM => mas.nCNTRNDM,
  nMTDRNDM => mas.nMTDRNDM,
  nCNTRNDS => NULL,
  nMTDRNDS => NULL,
  sOKDP	 => NULL,
  nSIGN_SET => mas.nSIGN_SET,
  nSIGN_SET_DIVIDE => mas.nSIGN_SET_DIVIDE,
  nRN_DUP => NULL,
  nWIDTH => mas.nWIDTH,
  nHEIGHT => mas.nHEIGHT,
  nLENGTH => mas.nLENGTH,
  nWEIGHT => mas.nWEIGHT,
  nMU_SIZE => mas.nMU_SIZE,
  nMU_WEIGHT => mas.nMU_WEIGHT,
  nTEMP_FROM => mas.nTEMP_FROM,
  nTEMP_TO => mas.nTEMP_TO,
  nHUMID_FROM => mas.nHUMID_FROM,
  nHUMID_TO => mas.nHUMID_TO,
  nCOMMON_PR_SIGN => mas.nCOMMON_PR_SIGN,
  nSTORAGE_TIME => NULL,
  sUMEAS_STORAGE => NULL,
  NEWRN => nRN1
  );
 ELSE
  P_DICNOMNS_INSERT (
  nCOMPANY => 2,
  nCRN => v_crn_into_num,
  sNOMEN_CODE  => SUBSTR('.' || mas.NOMCODE,1,LENGTH('.' || mas.NOMCODE)-2)||TO_CHAR(i),
  sNOMEN_NAME  => mas.NOMNAME || '_',
  sUMEAS_MAIN => mas.UMEAS_MAIN,
  sUMEAS_ALT  =>  mas.UMEAS_ALT,
  nEQUAL => mas.EQUAL,
  nSIGN_ACNT => mas.SIGN_ACNT,
  nSIGN_DOCS => mas.SIGN_DOCS,
  sGROUP_CODE => trim(mas.my_group),
  sTAX_GROUP => mas.sTAX_GROUP,
  sNALTAX_GROUP => mas.sNALTAX_GROUP,
  nSIGN_UMEAS  => mas.SIGN_UMEAS,
  nNOMEN_TYPE => mas.NOMEN_TYPE,
  nSIGN_SERIAL => mas.SIGN_SERIAL,
  nSIGN_MODIF => mas.SIGN_MODIF,
  nSIGN_PARTY => mas.SIGN_PARTY,
  nCNTRNDM => mas.nCNTRNDM,
  nMTDRNDM => mas.nMTDRNDM,
  nCNTRNDS => NULL,
  nMTDRNDS => NULL,
  sOKDP	 => NULL,
  nSIGN_SET => mas.nSIGN_SET,
  nSIGN_SET_DIVIDE => mas.nSIGN_SET_DIVIDE,
  nRN_DUP => NULL,
  nWIDTH => mas.nWIDTH,
  nHEIGHT => mas.nHEIGHT,
  nLENGTH => mas.nLENGTH,
  nWEIGHT => mas.nWEIGHT,
  nMU_SIZE => mas.nMU_SIZE,
  nMU_WEIGHT => mas.nMU_WEIGHT,
  nTEMP_FROM => mas.nTEMP_FROM,
  nTEMP_TO => mas.nTEMP_TO,
  nHUMID_FROM => mas.nHUMID_FROM,
  nHUMID_TO => mas.nHUMID_TO,
  nCOMMON_PR_SIGN => mas.nCOMMON_PR_SIGN,
  nSTORAGE_TIME => NULL,
  sUMEAS_STORAGE => NULL,
  NEWRN => nRN1
  );
END IF;

P_Nommodif_Insert(2,nRN1,SUBSTR('.' || mas.NOMCODE,1,LENGTH('.' || mas.NOMCODE)-2)||TO_CHAR(i), mas.NOMNAME || '_',NULL,NULL,NULL,NULL,
mas.nwidth,mas.nheight,mas.nLENGTH,mas.nweight,mas.nmu_size,mas.nmu_weight,mas.ntemp_from,
mas.ntemp_to,mas.nhumid_from,mas.nhumid_to,mas.ncommon_pr_sign,NULL,NULL,NULL, ntmp);
END IF;
END LOOP;
END;
/

