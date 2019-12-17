CREATE OR REPLACE procedure P_DICACCFO_AZS_CREATE_COPY
(
nCOMPANY         in number,
sDELIM           in varchar2,
sBLANK           in varchar2,
sCATALOG_NAME    in varchar2,
dFROM_DATE       in date,
dTO_DATE         in date,
sSTORE_OPER      in varchar2,
sCODE_RECEIVER   in varchar2,
sCODE_SENDER     in varchar2,
sBANK_SENDER     in varchar2,
sSTORE_SENDER    in varchar2,
nFORM_JOURNAL    in number,
dACC_DATE        in date,
sPREFIX          in varchar2,
sTAX_GROUP_CODE  in varchar2,
sTAX_GROUP_SERV  in varchar2,
sSERVE_CODE      in varchar2,
sFACEACC         in varchar2,
nUSECLOSEFACEACC in number,
nRESULT        out number
)
as
nCRN              number( 17 );
nSTORE_OPER       number( 17 );
nTYPE             number( 17 );
nSECTION          number( 17 );
nKEEP_SIGN        number( 17 );
nCODE_SENDER      number( 17 );
nBANK_SENDER      number( 17 );
nSTORE_SENDER     number( 17 );
nCS_BANK_CODE     number( 17 );
nCS_RECEIVER_CODE number( 17 );
nTAX_GROUP_CODE   number( 17 );
nTAX_GROUP_SERV   number( 17 );
nSERVE_CODE       number( 17 );
nSAVE_RN          number( 17 );
nSAVE_PRN         number( 17 );
nSAVE_AGENT       number( 17 )   := null;
nSAVE_FACEACC     number( 17 )   := null;
nSAVE_NOMEN       number( 17 );
nSAVE_MUNIT       number( 17 );
nSAVE_PRICE       number( 17,2 ) := 0;
nFIRST_ROW        number( 17 )   := 0;
nLAST_ROW         number( 17 )   := 0;
nLAST_ROW_SLAVE   number( 17 )   := 0;
nLAST_MUNIT       number( 17 );
nLAST_NOMEN       number( 17 );
nLAST_PRICE       number( 17,2 ) := 0;
sREG_NUMB         varchar2( 10 );
nAG_BLANK         number( 17 );
sAG_MIN           varchar2( 20 );
sAG_MAX           varchar2( 20 );
nFAC_BLANK        varchar2( 20 );
sFAC_MIN          varchar2( 20 );
sFAC_MAX          varchar2( 20 );
nRN_M             number( 17 ) := null;
nRN_S             number( 17 ) := null;
nONE_PRICE        number( 17,2 ) := 0;
nSUM_PRICE        number( 17,2 ) := 0;
nRATE_NDS         number( 17,2 ) := 0;
nONE_SUM_NDS      number( 17,2 ) := 0;
nSUM_NDS          number( 17,2 ) := 0;
nONE_GSM_TAX      number( 17,2 ) := 0;
nONE_GSM_TAX_SUM  number( 17,2 ) := 0;
nSUM_GSM          number( 17,2 ) := 0;
nONE_EXCISE       number( 17,2 ) := 0;
nONE_EXCISE_SUM   number( 17,2 ) := 0;
nEXCISE           number( 17,2 ) := 0;
nONE_WOUT_SUM     number( 17,2 ) := 0;
nSUM_WOUT         number( 17,2 ) := 0;
nONE_SUM_TOTAL    number( 17,2 ) := 0;
nONE_NSP          number( 17,5 ) := 0;
nNSP              number( 17,5 ) := 0;
nONE_NSP_SUM      number( 17,5 ) := 0;
nTYPE_NDS         number( 17 )    := 0;
nP_VALUE_NDS      number( 17, 2 ) := 0;
nA_SUMMER_NDS     number( 17, 2 ) := 0;
nTYPE_GSM         number( 17 )    := 0;
nP_VALUE_GSM      number( 17, 2 ) := 0;
nA_SUMMER_GSM     number( 17, 2 ) := 0;
nTYPE_EXC         number( 17 )    := 0;
nP_VALUE_EXC      number( 17, 2 ) := 0;
nA_SUMMER_EXC     number( 17, 2 ) := 0;
nTYPE_NDS1        number( 17 )    := 0;
nP_VALUE_NDS1     number( 17, 2 ) := 0;
nA_SUMMER_NDS1    number( 17, 2 ) := 0;
nTYPE_GSM1        number( 17 )    := 0;
nP_VALUE_GSM1     number( 17, 2 ) := 0;
nA_SUMMER_GSM1    number( 17, 2 ) := 0;
nTYPE_EXC1        number( 17 )    := 0;
nP_VALUE_EXC1     number( 17, 2 ) := 0;
nA_SUMMER_EXC1    number( 17, 2 ) := 0;
vRESULT           number( 17 )    := 0;
vQUANT            number( 17, 5 ) := 0;
sCODE_TMP         varchar2( 20 );
sNAME_TMP         varchar2( 160 );
nMEAS_SERV        number( 17 );
nAMEAS_TMP        number( 17 );
nEQUAL_TMP        number( 17,5 );
nOLD_TAX_GROUP    number( 17 ) := null;
dBASE_DATE		date;
nBASE_TYPE		number(17,0);
sBASE_NUMB		varchar(20);
sJUR_PERS     JURPERSONS.CODE%Type;
nJUR_PERS     JURPERSONS.RN%Type;


/* Формирование списка спецификаций сменных отчетов АЗС */
cursor MainCursor is
select /*+ RULE */
FC.AGENT, FC.RN as FACEACC, FC.NUMB, FC.FACT_CLOSE_DATE, AG.AGNABBR, O.NOMEN, O.MUNIT MAIN_MEAS, D.UMEAS_MAIN REAL_MEAS, O.RN, O.PRN,
NVL( O.PRICE, 0 ) PRICE, NVL( O.VOLUME, 0 ) VOLUME, NVL( O.MASSA, 0 ) MASSA, NVL( O.SUMM, 0 ) SUMM
from
AZSSREPORTMAIN  M,
AZSREPOUT       O,
AGNLIST         AG,
FACEACC         FC,
DICNOMNS        D,
AZSGSMWAYSTYPES G
where M.COMPANY      = nCOMPANY
and trunc ( M.DATE_SMENA ) between dFROM_DATE and dTO_DATE
and O.PRN          = M.RN
and O.OUTTYPE      = nSTORE_OPER
and O.OUTTYPE      = G.RN
and G.GSMWAYS_TYPE = 0
and O.NOMEN        = D.RN
and O.FACEACC      = FC.RN
and ( sFAC_MIN is null and sFAC_MAX is null and nFAC_BLANK = 0 and FC.AGENT is not null or
O.FACEACC in ( select FAC.RN from FACEACC FAC
where sFACEACC like FAC.NUMB or
( sFAC_MIN is null or FAC.NUMB >= sFAC_MIN and
sFAC_MAX is null or FAC.NUMB <= sFAC_MAX and
strinlike( FAC.NUMB, sFACEACC, sDELIM, sBLANK ) = 1 )))
and FC.AGENT       = AG.RN
and ( sAG_MIN is null and sAG_MAX is null and nAG_BLANK = 0 and FC.AGENT is not null or
FC.AGENT in ( select AG.RN from AGNLIST AG
where sCODE_RECEIVER like AG.AGNABBR or
( sAG_MIN is null or AG.AGNABBR >= sAG_MIN and
sAG_MAX is null or AG.AGNABBR <= sAG_MAX and
strinlike( AG.AGNABBR, sCODE_RECEIVER, sDELIM, sBLANK ) = 1 )))
and
not exists( select /*+ ORDERED */ * from DOCINPT in_link, DOCLINKS link, DOCOUTPT out_link
where in_link.DOCUMENT = O.RN and
in_link.UNITCODE = 'AZSREPOUT' and
in_link.RN = link.IN_DOC and
link.OUT_DOC = out_link.RN and
out_link.UNITCODE = 'AccountFactOutputSlave' )
order by FC.AGENT, FC.RN, O.NOMEN, O.MUNIT, O.PRICE;
index_link      integer := 0;
index_linkall   integer := 0;
index_faceacc   integer := 0;
cur_index       integer := 0;
-- Использование динамических таблиц
TYPE LinkRecord IS RECORD( RN_IN        number  ( 15 ),
PRN_IN       number  ( 15 ),
UNITCODE_IN  varchar2( 40 ),
RN_OUT       number  ( 15 ),
PRN_OUT      number  ( 15 ),
UNITCODE_OUT varchar2( 40 )
);
TYPE LinkTableType IS TABLE OF LinkRecord INDEX BY BINARY_INTEGER;
TYPE LinkColumnType IS TABLE OF number( 15 ) INDEX BY BINARY_INTEGER;
LINKTABLE LinkTableType;
LINKFACEACC LinkColumnType;
LINK_MASTER LinkColumnType;
LINK_SLAVE  LinkColumnType;
function NotEqual ( A in number, B in number ) return Boolean
is
begin
Return ( A is null and B is not null) or (A is not null and B is null)
or (A is not null and B is not null and A != B );
end;
/* Установка связей через DOCLINKS */
procedure FormLinks is
begin
if vRESULT = 0 then return; end if;
cur_index := LINKTABLE.first;
while cur_index is not null loop
P_LINKSALL_LINK_DIRECT_SMART(
nCOMPANY, LINKTABLE( cur_index ).UNITCODE_IN, LINKTABLE( cur_index ).RN_IN,
LINKTABLE( cur_index ).PRN_IN, SYSDATE, 0, LINKTABLE( cur_index ).UNITCODE_OUT,
LINKTABLE( cur_index ).RN_OUT, LINKTABLE( cur_index ).PRN_OUT, SYSDATE, 0, 1 );
cur_index := LINKTABLE.next( cur_index );
end loop;
commit;
LINKTABLE.delete;
index_link := 0;
end;
/* Процедура добавления спецификации СЧФК по номенклатуре */
procedure AddNomenSpec is
begin
if vRESULT = 0 or vQUANT = 0 then return; end if;
/* пересчет сумм */
P_DICLACFO_CALCDATA(
nCOMPANY, nSAVE_PRICE * vQUANT, vQUANT,
nTAX_GROUP_CODE, dACC_DATE,
nONE_PRICE, nSUM_PRICE, nRATE_NDS, nONE_SUM_NDS, nSUM_NDS,
nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM, nONE_EXCISE, nONE_EXCISE_SUM,
nEXCISE, nONE_WOUT_SUM, nSUM_WOUT, nONE_SUM_TOTAL, nONE_NSP, nNSP, nONE_NSP_SUM );
/* базовое добавление */
P_DICLACFO_BASE_INSERT(
nCOMPANY, nRN_M, null, nSAVE_NOMEN, null, null,
null, null, vQUANT, nSAVE_MUNIT, nTAX_GROUP_CODE,
nONE_PRICE, nSUM_PRICE, nONE_EXCISE, nONE_EXCISE_SUM,
nEXCISE, nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM,
nONE_WOUT_SUM, nSUM_WOUT, nRATE_NDS, 0, 0, nONE_SUM_NDS,
nSUM_NDS, nONE_SUM_TOTAL, nONE_NSP, nNSP, nONE_NSP_SUM,
nSAVE_PRICE * vQUANT, 0, 0, 0, null, 0,
null, null, /* COUNTRY, GTD */
nRN_S );
/* заполняем контейнер связей */
cur_index := LINK_MASTER.first;
while cur_index is not null loop
index_link                           := index_link + 1;
LINKTABLE( index_link ).RN_IN        := LINK_MASTER( cur_index );
LINKTABLE( index_link ).PRN_IN       := null;
LINKTABLE( index_link ).UNITCODE_IN  := 'AZSREPORTLST';
LINKTABLE( index_link ).RN_OUT       := nRN_M;
LINKTABLE( index_link ).PRN_OUT      := null;
LINKTABLE( index_link ).UNITCODE_OUT := 'AccountFactOutput';
index_link                           := index_link + 1;
LINKTABLE( index_link ).RN_IN        := LINK_SLAVE( cur_index );
LINKTABLE( index_link ).PRN_IN       := LINK_MASTER( cur_index );
LINKTABLE( index_link ).UNITCODE_IN  := 'AZSREPOUT';
LINKTABLE( index_link ).RN_OUT       := nRN_S;
LINKTABLE( index_link ).PRN_OUT      := nRN_M;
LINKTABLE( index_link ).UNITCODE_OUT := 'AccountFactOutputSlave';
cur_index                            := LINK_MASTER.next( cur_index );
end loop;
LINK_MASTER.delete;
LINK_SLAVE.delete;
index_linkall := 0;
vQUANT        := 0;
end;
/* Процедура добавления спецификации СЧФК по услугам */
procedure AddServSpec is
I  binary_integer;
nSUM_FACEACC number( 17,2 ) := 0;
/* Курсор поиска начислений за услуги для л\с FA */
cursor ServCh is
select /*+ ORDERED INDEX(S I_SERVCHARGES_DATEFCAC) INDEX(F)  */
S.SUMWITHNDS SER_SUMM, S.RN, S.TAX_GROUP
from FACEACC     F,
SERVCHARGES S
where F.RN      = nSAVE_FACEACC
and S.FACEACC = F.RN
and trunc ( S.OPER_DATE ) between dFROM_DATE and dTO_DATE
and S.STOREOPER = nSTORE_OPER
and not exists
( select /*+ ORDERED */ link.RN
from DOCINPT  in_link,
DOCLINKS link,
DOCOUTPT out_link
where in_link.DOCUMENT  = S.RN
and in_link.UNITCODE  = 'ServiceCharges'
and in_link.RN        = link.IN_DOC
and link.OUT_DOC      = out_link.RN
and out_link.UNITCODE = 'AccountFactOutput' )
order by S.TAX_GROUP ;
begin
if vRESULT = 0 then return; end if;
/* считываем сумму для услуги */
nSUM_FACEACC := 0;
for ser_rec in ServCh loop
if nOLD_TAX_GROUP is null then
nOLD_TAX_GROUP := ser_rec.TAX_GROUP;
end if;
if nOLD_TAX_GROUP != ser_rec.TAX_GROUP then
if nSUM_FACEACC <> 0 then
/* пересчет сумм */
P_DICLACFO_CALCDATA(
nCOMPANY, nSUM_FACEACC, 1, nOLD_TAX_GROUP, dACC_DATE,
nONE_PRICE, nSUM_PRICE, nRATE_NDS, nONE_SUM_NDS, nSUM_NDS,
nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM, nONE_EXCISE,
nONE_EXCISE_SUM, nEXCISE, nONE_WOUT_SUM, nSUM_WOUT, nONE_SUM_TOTAL,
nONE_NSP, nNSP, nONE_NSP_SUM );
/* генерация последней спецификации для услуги */
P_DICLACFO_BASE_INSERT(
nCOMPANY, nRN_M, null, nSERVE_CODE, null, null, null, null, 1,
nMEAS_SERV, nOLD_TAX_GROUP, nONE_PRICE, nSUM_PRICE, nONE_EXCISE,
nONE_EXCISE_SUM, nEXCISE, nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM,
nONE_WOUT_SUM, nSUM_WOUT, nRATE_NDS, 0, 0, nONE_SUM_NDS,
nSUM_NDS, nONE_SUM_TOTAL, nONE_NSP, nNSP, nONE_NSP_SUM,
nSUM_FACEACC, 0, 0, 0, null, 0,
null, null, /* COUNTRY, GTD */
nRN_S );
end if;
nSUM_FACEACC   := 0;
nOLD_TAX_GROUP := ser_rec.TAX_GROUP;
end if;
nSUM_FACEACC  := nSUM_FACEACC + ser_rec.SER_SUMM;
index_faceacc := index_faceacc + 1;
LINKFACEACC( index_faceacc ) := ser_rec.RN;
end loop;
if nSUM_FACEACC <> 0 then
/* пересчет сумм */
P_DICLACFO_CALCDATA(
nCOMPANY, nSUM_FACEACC, 1, nOLD_TAX_GROUP, dACC_DATE,
nONE_PRICE, nSUM_PRICE, nRATE_NDS, nONE_SUM_NDS, nSUM_NDS,
nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM, nONE_EXCISE,
nONE_EXCISE_SUM, nEXCISE, nONE_WOUT_SUM, nSUM_WOUT, nONE_SUM_TOTAL,
nONE_NSP, nNSP, nONE_NSP_SUM );
/* генерация последней спецификации для услуги */
P_DICLACFO_BASE_INSERT(
nCOMPANY, nRN_M, null, nSERVE_CODE, null, null, null, null, 1,
nMEAS_SERV, nOLD_TAX_GROUP, nONE_PRICE, nSUM_PRICE, nONE_EXCISE,
nONE_EXCISE_SUM, nEXCISE, nONE_GSM_TAX, nONE_GSM_TAX_SUM, nSUM_GSM,
nONE_WOUT_SUM, nSUM_WOUT, nRATE_NDS, 0, 0, nONE_SUM_NDS,
nSUM_NDS, nONE_SUM_TOTAL, nONE_NSP, nNSP, nONE_NSP_SUM,
nSUM_FACEACC, 0, 0, 0, null, 0,
null, null, /* COUNTRY, GTD */
nRN_S );
end if;
/* заполняем контейнер связей */
cur_index := LINKFACEACC.first;
while cur_index is not null loop
index_link                           := index_link + 1;
LINKTABLE( index_link ).RN_IN        := LINKFACEACC( cur_index );
LINKTABLE( index_link ).PRN_IN       := null;
LINKTABLE( index_link ).UNITCODE_IN  := 'ServiceCharges';
LINKTABLE( index_link ).RN_OUT       := nRN_M;
LINKTABLE( index_link ).PRN_OUT      := null;
LINKTABLE( index_link ).UNITCODE_OUT := 'AccountFactOutput';
index_link                           := index_link + 1;
LINKTABLE( index_link ).RN_IN        := LINKFACEACC( cur_index );
LINKTABLE( index_link ).PRN_IN       := null;
LINKTABLE( index_link ).UNITCODE_IN  := 'ServiceCharges';
LINKTABLE( index_link ).RN_OUT       := nRN_S;
LINKTABLE( index_link ).PRN_OUT      := nRN_M;
LINKTABLE( index_link ).UNITCODE_OUT := 'AccountFactOutputSlave';
cur_index                            := LINKFACEACC.next( cur_index );
end loop;
end;
/* Получение реквизитов будущего СЧФК */
procedure PrepareParams( nAgent number, sAgent varchar2 ) is
begin
/* Генерируем номер счета-фактуры */
P_DICACCFO_GETNEXTNUMB( nCOMPANY, sPREFIX, sREG_NUMB );
/* получаем код банковских реквизитов получателя */
nCS_BANK_CODE := null;
for rec_bank in ( select RN from AGNACC where AGNRN = nAgent  order by RN desc )
loop
nCS_BANK_CODE := rec_bank.RN;
exit;
end loop;
/* вставляем новый реквизит банка получателя */
if nCS_BANK_CODE is null then
P_AGNACC_MODIFY( null, nAgent, '000001', null, sAgent,
null, null, null, null, null,
null, null,null, null, null,
null, null, null, null, null,
null, nCS_BANK_CODE );
end if;
/* получаем код грузополучателя */
nCS_RECEIVER_CODE := null;
for rec_fifo in ( select RN from AGNFIFO where PRN = nAgent order by RN desc )
loop
nCS_RECEIVER_CODE := rec_fifo.RN;
exit;
end loop;
/* вставляем новый реквизит грузополучателя */
if nCS_RECEIVER_CODE is null then
P_AGNFIFO_BASE_INSERT( nCOMPANY, nAgent, sAgent, sAgent, null, 1, 1, null, nCS_RECEIVER_CODE );
end if;
end;
procedure PrepareCommonParams is
begin
/* поиск каталога для счетов-фактур */
FIND_ACATALOG_NAME( 0, nCOMPANY, null, 'AccountFactOutput', sCATALOG_NAME, nCRN );
/* поиск типа складской операции */
FIND_DICSTOPR_TYPE_EX( nCOMPANY, sSTORE_OPER, nSTORE_OPER, nTYPE, nSECTION, nKEEP_SIGN );
/* поиск грузоотправителя */
FIND_AGENT_BY_MNEMO( nCOMPANY, sCODE_SENDER, nCODE_SENDER );
FIND_AGNACC_BY_CODE( nCOMPANY, sCODE_SENDER, sBANK_SENDER, nBANK_SENDER );
if sSTORE_SENDER is not null
then FIND_DICSTORE_NUMB( 0, nCOMPANY, sSTORE_SENDER, nSTORE_SENDER );
else nSTORE_SENDER := null;
end if;
/* поиск налоговой группы */
FIND_DICTAXGR_CODE( 0, nCOMPANY, sTAX_GROUP_CODE, nTAX_GROUP_CODE );
/* вычисление налогов */
FIND_DICTAXIS_ALL( nCOMPANY, 1, nTAX_GROUP_CODE, null, dACC_DATE,
nTYPE_NDS, nP_VALUE_NDS, nA_SUMMER_NDS,
nTYPE_GSM, nP_VALUE_GSM, nA_SUMMER_GSM,
nTYPE_EXC, nP_VALUE_EXC, nA_SUMMER_EXC );
/* поиск кода услуги */
FIND_DICNOMNS_BY_CODE( 0, nCOMPANY, sSERVE_CODE, nSERVE_CODE );
/* поиск единицы измерения для услуги */
FIND_DICNOMNS_BY_RN( nCOMPANY, nSERVE_CODE, sCODE_TMP, sNAME_TMP, nMEAS_SERV, nAMEAS_TMP, nEQUAL_TMP );
/* поиск налоговой группы для услуги */
FIND_DICTAXGR_CODE( 0, nCOMPANY, sTAX_GROUP_SERV, nTAX_GROUP_SERV );
/* вычисление налогов для услуги */
FIND_DICTAXIS_ALL( nCOMPANY, 1, nTAX_GROUP_SERV, null, dACC_DATE,
nTYPE_NDS1, nP_VALUE_NDS1, nA_SUMMER_NDS1,
nTYPE_GSM1, nP_VALUE_GSM1, nA_SUMMER_GSM1,
nTYPE_EXC1, nP_VALUE_EXC1, nA_SUMMER_EXC1 );
/* вычисляем параметры */
P_USERFUNC_PARMPREP( sDELIM, sBLANK, sCODE_RECEIVER, 20, nAG_BLANK, sAG_MIN, sAG_MAX );
/* вычисляем параметры */
P_USERFUNC_PARMPREP( sDELIM, sBLANK, sFACEACC, 20, nFAC_BLANK, sFAC_MIN, sFAC_MAX );
end;
/*######################### ТЕЛО ГЛАВНОЙ ПРОЦЕДУРЫ ##############################*/
begin
PrepareCommonParams;
for rec in MainCursor
loop
if ( rec.FACT_CLOSE_DATE is not null ) and ( nUSECLOSEFACEACC = 0 ) then
P_EXCEPTION ( 0, 'Невозможно сформировать счета-фактуры по закрытому лицевому счету "'||rec.NUMB||'".' );
end if;
/* при смене контрагента */
if NotEqual( nSAVE_AGENT, rec.AGENT ) or NotEqual( nSAVE_FACEACC, rec.FACEACC ) then
/* завершаем формирование СЧФК по старому контрагенту */
AddNomenSpec;
AddServSpec;
FormLinks;
/* формируем начисления за услуги по новому контрагенту */
if nFORM_JOURNAL = 1 then
P_SERVCHARGES_BASE_FORM(  NCOMPANY, 1, null, rec.AGENT, dTO_DATE,
nSTORE_OPER, nKEEP_SIGN, dFROM_DATE, dTO_DATE, nTAX_GROUP_SERV, nUSECLOSEFACEACC );
end if;
/* генерация заголовка счета фактуры */
PrepareParams( rec.AGENT, rec.AGNABBR );
/* Достаем документ-основание, если есть */
begin
	select c.doc_type, c.doc_pref||c.doc_numb, c.doc_date 
	into nBASE_TYPE, sBASE_NUMB, dBASE_DATE
	from contracts c, stages, faceacc where stages.prn = c.rn
		and stages.faceacc = faceacc.rn
		and faceacc.rn = rec.faceacc;
exception
	when NO_DATA_FOUND then
		nBASE_TYPE :=null;
		dBASE_DATE :=null;
		sBASE_NUMB :=null;
end;

FIND_JURPERSONS_MAIN (1 , nCOMPANY, sJUR_PERS, nJUR_PERS);

P_DICACCFO_BASE_INSERT( nCOMPANY, nCRN, nJUR_PERS, sPREFIX, sREG_NUMB, dACC_DATE,
nCODE_SENDER, nBANK_SENDER, nSTORE_SENDER,
rec.AGENT, nCS_BANK_CODE, nCS_RECEIVER_CODE,
nBASE_TYPE, sBASE_NUMB, dBASE_DATE, null, null, null, null,
0, 1, nRN_M );
vRESULT := vRESULT + 1;
end if;
/* при смене номенклатуры, цены или единиц измерения - создаем новую строку спецификации СЧФК */
if ( ( nSAVE_AGENT = rec.AGENT ) or ( nSAVE_FACEACC = rec.FACEACC ) ) and
( NotEqual( nSAVE_NOMEN, rec.NOMEN ) or
NotEqual( nSAVE_MUNIT, rec.MAIN_MEAS ) or
NotEqual( nSAVE_PRICE, rec.PRICE ) )
then
AddNomenSpec;
/*Не надо добавлять запись об услугах для каждой строки спецификации*/
--      AddServSpec;
end if;
/* суммируем количество для одинаковых позиций номенклатуры, цены и единиц измерения */
if rec.MAIN_MEAS = rec.REAL_MEAS
then vQUANT := vQUANT + rec.VOLUME;
else vQUANT := vQUANT + rec.MASSA;
end if;
nSAVE_NOMEN := rec.NOMEN;
nSAVE_MUNIT := rec.MAIN_MEAS;
nSAVE_PRICE := rec.PRICE;
/* Увеличили индекс массива записей RN для последующей связи */
index_linkall := index_linkall + 1;
/* запоминаем RN заголовка сменного отчета АЗС */
LINK_MASTER( index_linkall ) := rec.PRN;
/* запоминаем RN спецификации сменного отчета АЗС */
LINK_SLAVE( index_linkall ) := rec.RN;
/* запоминаем значение контрагента */
nSAVE_AGENT   := rec.AGENT;
nSAVE_FACEACC := rec.FACEACC;
end loop;
AddNomenSpec;
AddServSpec;
FormLinks;
nRESULT := vRESULT;
end;
/

