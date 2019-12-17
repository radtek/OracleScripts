CREATE OR REPLACE PROCEDURE       Snp_P_Crnewnomsyk_Vz2
(
v_crn_into IN VARCHAR2, --каталог куда будет вкачиваться номенклатура
v_group IN VARCHAR2,--номер счета, соответствующий данному приходнику
v_n_prih IN NUMBER --номер приходника
)
AS
NRN1 NUMBER;
ntmp NUMBER;
flag_group BOOLEAN;
cnt_nom NUMBER;
char_ VARCHAR2(2);
v_crn_into_num NUMBER; -- № каталог куда будет вкачиваться номенклатура
i NUMBER;
note_ VARCHAR2(10);
BEGIN


--определяем каталог, куда будет вкачиваться номенклатура
SELECT rn INTO v_crn_into_num
FROM acatalog
WHERE NAME =v_crn_into
AND docname ='Nomenclator';
i:=10;
----------------------------
--проверка номенклатуры на наличие старой группы - ввод новой номенклатуры, замена старой
FOR mas IN (

SELECT /*+Rule*/ a.nrn AS nrn_,a.nPLANQUANT, a.nFACTQUANT, a.nPLANQUANTALT,a.nFACTQUANTALT,
a.nPRICE ,a.nPRICEMEAS ,  a.nPRICE_CALC_RULE, a.nACC_PRICE , a.nACC_PRICEMEAS,
a.dEXPIRY_DATE , a.sCERTIFICATE, a.nPLANSUM, a.nPLANSUMTAX, a.nFACTSUM, a.nFACTSUMTAX,
a.sSERNUMB, a.sBARCODE,a.sCOUNTRY,a.sGTD, B.*
FROM V_INORDERSPECS A, v_dicnomns B
WHERE A.nprn = v_n_prih
AND A.SNOMEN = B.NOMEN_CODE
)
LOOP

    flag_group:=FALSE;
--	char_:=to_char(i);

	IF mas.sgroup_code = v_group THEN
	flag_group := TRUE;
	END IF;


  	SELECT COUNT(*) INTO cnt_nom FROM v_dicnomns
    WHERE nomen_name = mas.NOMEN_NAME ||' .';
	IF  cnt_nom > 0 THEN
	flag_group:=TRUE;
	END IF;


	IF i>=100 THEN
	i:=10;
	END IF;
	char_:=TO_CHAR(i);
  IF flag_group = FALSE THEN
  --добавление номенклатуры
  P_DICNOMNS_MODIFY (
  COMPANYRN => 2,
  RN => NULL,
  CRN => v_crn_into_num,
  NOMEN_CODE => SUBSTR(mas.NOMEN_CODE,1,LENGTH(mas.NOMEN_CODE)-2)||char_,
  NOMEN_NAME => mas.NOMEN_NAME || ' .',
  UMEAS_MAIN => mas.UMEAS_MAIN,
  UMEAS_ALT =>  mas.UMEAS_ALT,
  EQUAL => mas.EQUAL,
  SIGN_ACNT => mas.SIGN_ACNT,
  SIGN_DOCS => mas.SIGN_DOCS,
  sGROUP_CODE => v_group,
  sTAX_GROUP => mas.sTAX_GROUP,
  sNALTAX_GROUP => mas.sNALTAX_GROUP,
  SIGN_UMEAS => mas.SIGN_UMEAS,
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
  NEWRN => nRN1
  );
  -- добавление модификации
P_Nommodif_Insert(2,nRN1, SUBSTR(mas.NOMEN_CODE,1,LENGTH(mas.NOMEN_CODE)-2)||char_, mas.NOMEN_NAME || ' .',NULL,NULL,NULL,NULL,
mas.nwidth,mas.nheight,mas.nLENGTH,mas.nweight,mas.nmu_size,mas.nmu_weight,mas.ntemp_from,
mas.ntemp_to,mas.nhumid_from,mas.nhumid_to,mas.ncommon_pr_sign,NULL,ntmp);
 --
P_INORDERSPECS_UPDATE
(nRN  => mas.nrn_,
nCOMPANY => 2,
nPRN => v_n_prih,
sNOMEN => SUBSTR(mas.NOMEN_CODE,1,LENGTH(mas.NOMEN_CODE)-2)||char_,
sNOMMODIF => SUBSTR(mas.NOMEN_CODE,1,LENGTH(mas.NOMEN_CODE)-2)||char_,
sNOMNMODIFPACK  => NULL,
sARTICLE => NULL,
sCELL => NULL,
sTAXGR => 'НДС 20%',
nPLANQUANT => mas.nPLANQUANT,
nFACTQUANT =>  mas.nFACTQUANT,
nPLANQUANTALT => mas.nPLANQUANTALT,
nFACTQUANTALT => mas.nFACTQUANTALT,
nPRICE    => mas.nPRICE ,
nPRICEMEAS  => mas.nPRICEMEAS,
nPRICE_CALC_RULE => mas.nPRICE_CALC_RULE,
nACC_PRICE => mas.nACC_PRICE ,
nACC_PRICEMEAS => mas.nACC_PRICEMEAS,
dEXPIRY_DATE => mas.dEXPIRY_DATE ,
sCERTIFICATE =>  mas.sCERTIFICATE,
nPLANSUM  => mas.nPLANSUM,
nPLANSUMTAX => mas.nPLANSUMTAX,
nFACTSUM => mas.nFACTSUM ,
nFACTSUMTAX => mas.nFACTSUMTAX,
sNOTE  => NULL,
sSERNUMB => mas.sSERNUMB,
sBARCODE  => mas.sBARCODE,
sCOUNTRY => mas.sCOUNTRY,
sGTD => mas.sGTD,
sPRODUCER => NULL
);
--note_:=SUBSTR(mas.NOMEN_CODE,1,LENGTH(mas.NOMEN_CODE)-1)||char_;

--UPDATE inorderspecs SET NOTE = TRIM(note_)
--WHERE
--rn =mas.nrn_ ;
--COMMIT;

END IF;
i:=i+1;
END LOOP;

END;

--SELECT * FROM dictaxgr
/

