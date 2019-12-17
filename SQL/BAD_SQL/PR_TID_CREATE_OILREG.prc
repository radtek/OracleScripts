CREATE OR REPLACE procedure PR_TID_CREATE_OILREG
(
  nRN in number,
  nCOMPANY in number,
--  SAZS_NUMBER               in varchar2,
  SREZ_NUMBER               in varchar2, -- номер резервуара
  SSM_NUMBER                in varchar2, -- номер смены
--  SAGENT                    in varchar2,
--  SFACE_ACC                 in varchar2,
--  SSTORE_OPER               in varchar2,
  DDATE                     in date,      -- дата
  STIME                     in varchar2,  -- время
--  NDOC_DENSITY              in number,
  NDOC_TEMP                 in number,    -- температура
  NDOC_LEVEL                in number,    -- уровень
  SINVOICE_NUM              in varchar2,  -- номер акта приема
  DINVOICE_DATE             in date,      -- дата акта приема
  STRANS_TYPE               in varchar2,
--  STRANS_NUMBER             in varchar2,
  SCATALOG in varchar2                    -- каталог
)
as

 nCRN        number(17);
 nPARTY      number(17);
 nOILRN      number(17);
 NREZ_NUMBER number(17);
 NSM_NUMBER  number(17);
 nTRANSTYPE  number(17);
 nKOEFF  number(17,5);
  DDATE_TIME                date;

begin


FIND_ACATALOG_NAME(0,nCOMPANY,null,'OilIncomeRegistry',sCATALOG,  nCRN);

if  STRANS_TYPE is not null then
FIND_DICCMRKS_BY_CODE(1,1,nCOMPANY,STRANS_TYPE,nTRANSTYPE);
else
nTRANSTYPE:=null;
end if;

DDATE_TIME := s2dt(d2s(DDATE) || ' ' || STIME);

--P_OILINREG_GETNEXTNUMB(  nCOMPANY,  sPARTY);


for C in
(
select /*+ RULE */
N.RN NOMEN,
strtrim(T.PREF)||strtrim(T.NUMB) sNUMB,
T.DOCDATE,
S.SUMMWITHNDS,
N.TAX_GROUP,
S.PRICE,
DECODE(S.PRICEMEAS,0,S.QUANT,1,S.QUANTALT) nQUANT,
DECODE(S.PRICEMEAS,0,M1.RN,1,M2.RN) nMEAS_UNIT,
DECODE(M1.CATEGORY,1,S.QUANT,S.QUANTALT) nMASS,
DECODE(M1.CATEGORY,3,S.QUANT,S.QUANTALT) nVOLUME,
S.RN,
T.IN_STORE,
T.IN_STOPER,
T.DOCTYPE,
T.MOL,
T.RECIPNUMB
 from TRANSINVDEPT T, TRANSINVDEPTSPECS S, NOMMODIF NM, DICNOMNS N, DICMUNTS M1, DICMUNTS M2
where T.RN=nRN and S.PRN=nRN and N.RN=NM.PRN and NM.RN=S.NOMMODIF
 and UMEAS_MAIN =M1.RN and UMEAS_ALT=M2.RN
)
loop


begin
select /*+ ORDERED */ GP.INDOC into nPARTY from
DOCINPT I, DOCLINKS L, DOCOUTPT O, STOREOPERJOURN R, GOODSSUPPLY GS, GOODSPARTIES GP
where
--T.RN=nRN and
I.DOCUMENT=nRN and I.UNITCODE='GoodsTransInvoicesToDepts'
and I.RN=L.IN_DOC and O.RN=L.OUT_DOC
and O.UNITCODE='StoreOpersJournal' and O.DOCUMENT=R.RN
and R.GOODSSUPPLY=GS.RN and GS.PRN=GP.RN;
exception
when NO_DATA_FOUND then
P_EXCEPTION(0,'Партия не найдена');
when TOO_MANY_ROWS then
P_EXCEPTION(0,'Разбиение по партиям');
end;


FIND_AZS_REZERVUAR_BY_NUMB(  sREZ_NUMBER,  C.IN_STORE,  NREZ_NUMBER);

FIND_AZSSMENA_BY_NUMBER(  C.IN_STORE, sSM_NUMBER,  NSM_NUMBER);

nKOEFF:=C.NMASS/C.NVOLUME;

--P_EXCEPTION(0,nKOEFF);

P_OILINREG_BASE_INSERT
(
  NCRN,
  NCOMPANY,
  C.IN_STORE,
  NREZ_NUMBER,
  NSM_NUMBER,
  C.NOMEN,
  C.MOL,
  NULL,
  C.IN_STOPER,
  DDATE_TIME,
  nKOEFF,
  NDOC_TEMP,
  NDOC_LEVEL,
  C.NVOLUME,
  C.NMASS,
  nKOEFF,
  NDOC_TEMP,
  NDOC_LEVEL,
  C.NVOLUME,
  C.NMASS,
  C.DOCTYPE,
  C.sNUMB,
  C.DOCDATE,
  sINVOICE_NUM,
  DINVOICE_DATE,
  nTRANSTYPE, --NTRANS_TYPE               in number,
  C.RECIPNUMB, --NTRANS_NUMBER             in varchar2,
  C.NQUANT,
  C.nMEAS_UNIT,
  C.PRICE,
  C.TAX_GROUP,
  C.SUMMWITHNDS,
  nPARTY,
  0,
  NOILRN
);
  /* установка связи в DocLinks */
  P_LINKSALL_LINK_DIRECT ( nCOMPANY, 'GoodsTransInvoicesToDepts', nRN, null, sysdate, 0, 'OilIncomeRegistry',  nOILRN, null, sysdate, 0, 1 );

end loop;
end;
/

