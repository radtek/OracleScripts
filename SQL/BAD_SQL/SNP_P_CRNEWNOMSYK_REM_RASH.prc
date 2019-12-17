CREATE OR REPLACE PROCEDURE       Snp_P_Crnewnomsyk_rem_rash
--замена номенклатуры на другую номенклатуру
(
v_crn_into IN VARCHAR2, --каталог откуда берется номенклатура
v_n_prih IN NUMBER --номер расходника
)
AS
NRN1 NUMBER;
ntmp NUMBER;
flag_group BOOLEAN;
cnt_nom NUMBER;
v_crn_into_num NUMBER; -- № каталог куда будет вкачиваться номенклатура
q_msg varchar2(200);
v_modif_code VARCHAR2(20);
BEGIN



--определяем каталог, куда будет вкачиваться номенклатура
SELECT rn INTO v_crn_into_num
FROM acatalog
WHERE NAME =v_crn_into
AND docname ='Nomenclator';
----------------------------
--проверка номенклатуры на наличие старой группы - ввод новой номенклатуры, замена старой
FOR mas IN (
SELECT  A.*
FROM V_TRANSINVDEPTSPECS A, v_dicnomns B
WHERE A.nprn = v_n_prih
AND A.SNOMEN = B.NOMEN_CODE
)
LOOP

	FOR mas_2 IN
	(SELECT /*+rule*/ * FROM zhukov.SNP_SYKT)
	LOOP

	IF mas.snomen = mas_2.code_ex THEN
	SELECT smodif_code INTO  v_modif_code FROM V_NOMMODIF
	WHERE snomen_code = mas_2.code_new;

P_TRANSINVDEPTSPECS_UPDATE
(
 nRN => mas.nrn,
 nCOMPANY => 2,
  nPRN => v_n_prih,
sNOMEN => mas_2.code_new,
sSERNUMB => mas.sSERNUMB,
sCOUNTRY => mas.sCOUNTRY,
sGTD => mas.sGTD,
sNOMMODIF => v_modif_code,
sNOMNMODIFPACK  => NULL,
sARTICLE => mas.SARTICLE,
sCELL => mas.sCELL,
sGOODSPARTY => mas.SGOODSPARTY,
nPRICE => mas.nprice,
nQUANT => mas.nquant,
nQUANTALT => mas.nQUANTALT,
nPRICEMEAS => mas.nPRICEMEAS,
nSUMMWITHNDS => mas.nSUMMWITHNDS,
dBEGINDATE  => mas.dBEGINDATE,
dENDDATE => mas.dENDDATE,
sNOTE => mas.sNOTE,
sMSG => q_msg
);
END IF;
END LOOP;
END LOOP;
END;
/

