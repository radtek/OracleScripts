CREATE OR REPLACE procedure P_TRADERPT_DEL_EOPER
(
nCOMPANY         in number,
nRN              in number,
sLINK_TYPE       in varchar2
)
as
nIDENT           PKG_STD.tREF;
nCRN             PKG_STD.tREF;
nJUR_PERS        PKG_STD.tREF;
nWORK_STATE      PKG_STD.tNUMBER;
dWORK_DATE       PKG_STD.tLDATE;
nWORK_STATE_TAX  PKG_STD.tNUMBER;
dWORK_DATE_TAX   PKG_STD.tLDATE;
type tLINK is    record
(
LINK_TYPE      PKG_STD.tNUMBER,
ACTION         PKG_STD.tSTRING
);
type tLINK_TABLE is table of tLINK;
tLINK_TYPES      tLINK_TABLE := tLINK_TABLE();
begin
/* установка типов связи и действий для них*/
if (STRIN('0',sLINK_TYPE,';') = 1) or
(rtrim(sLINK_TYPE) is null) then
tLINK_TYPES.EXTEND;
tLINK_TYPES(tLINK_TYPES.LAST).LINK_TYPE := 0;
tLINK_TYPES(tLINK_TYPES.LAST).ACTION    := 'TRRP_DEL_OPER';
nWORK_STATE := 0;
dWORK_DATE  := null;
end if;
if (STRIN('1',sLINK_TYPE,';') = 1) or
(rtrim(sLINK_TYPE) is null) then
tLINK_TYPES.EXTEND;
tLINK_TYPES(tLINK_TYPES.LAST).LINK_TYPE := 1;
tLINK_TYPES(tLINK_TYPES.LAST).ACTION    := 'TRRP_DEL_OPER_TAX';
nWORK_STATE_TAX := 0;
dWORK_DATE_TAX  := null;
end if;
/* считывание записи ТО */
P_SALESRPTMAIN_EXISTS( nCOMPANY,nRN,nCRN,nJUR_PERS );
/* буфер для наследования документов: конструктор */
nIDENT := PKG_INHIER.CONSTRUCTOR( nCOMPANY );
for i in tLINK_TYPES.FIRST..tLINK_TYPES.LAST loop
/* подготовка к отвязке документа */
PKG_INHIER.PREP_LINK( nIDENT );
/* регистрация входного раздела/документа */
PKG_INHIER.SET_IN_UNIT( nIDENT,0,'TradeReports',tLINK_TYPES(i).LINK_TYPE,tLINK_TYPES(i).ACTION,'SALESREPORTMAIN' );
PKG_INHIER.SET_IN_DOC_EX( nIDENT,0,nRN,nCRN,nJUR_PERS );
PKG_INHIER.SET_IN_UNIT( nIDENT,1,'TradeReportsSp' );
/* регистрация выходного раздела */
PKG_INHIER.SET_OUT_UNIT( nIDENT,0,'EconomicOperations','P_ECONOPRS_BASE_DELETE' );
PKG_INHIER.SET_OUT_UNIT( nIDENT,1,'EconomicOperationsSpecs' );
/* отвязка входного и выходного документов через документооборот */
PKG_INHIER.DROP_LINKS( nIDENT );
end loop;
/* буфер для наследования документов: деструктор */
PKG_INHIER.DESTRUCTOR( nIDENT );
/* установка состояния ТО */
begin
/* ослабление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReports' );
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReportsSp' );
/* установка таблицы и действия для отмены регистрации */
--PKG_UPDATELIST.DROP_REGISTER( 'SALESREPORTMAIN','U' );
/* установка статуса */
update SALESREPORTMAIN
set WORK_STATE     = nvl(nWORK_STATE,WORK_STATE)         ,
WORK_DATE      = decode(nWORK_STATE,0,null,WORK_DATE),
WORK_STATE_TAX = nvl(nWORK_STATE_TAX,WORK_STATE_TAX) ,
WORK_DATE_TAX  = decode(nWORK_STATE_TAX,0,null,WORK_DATE_TAX)
where RN = nRN;
/* восстановление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* установка таблицы и действия для возобновления регистрации */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
exception
when OTHERS then
/* восстановление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* установка таблицы и действия для возобновления регистрации */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
raise;
end;
end;
/




CREATE OR REPLACE procedure P_SALESRPTMAIN_REPLACE
(
nCOMPANY        in number,
nIDENT          in number,
nFLAG_LINK      in number         -- не используетс
)
as
nCOUNT_FULL     PKG_STD.TREF;
nCOUNT_PROC     PKG_STD.TREF;
begin
/* перемещение ХО вместе с проводками из буфера в учет */
P_ECOPRBUF_BASE_REPLACE( nCOMPANY,nIDENT,1,0 );
/* установка состояния ТО */
begin
/* ослабление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReports' );
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReportsSp' );
/* установка таблицы и действия для отмены регистрации */
--PKG_UPDATELIST.DROP_REGISTER( 'SALESREPORTMAIN','U' );
/* установка признака отработки */
for rec in
(
select B.IN_DOCUMENT0 DOCUMENT
from INHIERBUFF B
where B.IDENT = nIDENT and B.COMPANY = nCOMPANY
group by B.IN_DOCUMENT0
) loop
/* Установка состояния отработки в учете товарного отчета. */
P_SALESRPTMAIN_REFRESH_STATE( nCOMPANY, rec.DOCUMENT );
end loop;
/* восстановление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* установка таблицы и действия для возобновления регистрации */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
exception
when OTHERS then
/* восстановление связей ТО */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* установка таблицы и действия для возобновления регистрации */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
raise;
end;
/* очистка буфера отработки */
P_ECOPRBUF_PACK_BY_IDENT( nCOMPANY,nIDENT );
end;
/




CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTDET_BDELETE before delete on SALESREPORTDETAIL
for each row
begin

IF USER<>'SNP_REPL' THEN
  -- PSV 22.09.2004 Отключаем проверку связи для репликации
  /* Проверка связи мастер таблицы */
  P_LINKSALL_CHECK( :old.PRN, :old.COMPANY, 'TradeReports' );
  /* Проверка связи */
  P_LINKSALL_CHECK( :old.RN, :old.COMPANY, 'TradeReportsSp' );
END IF;
  
/* Регистрация события */
P_SALESREPORTDETAIL_IUD_EVENT(:old.RN, 'D', :old.COMPANY, :old.PRN, :old.OPER_DATE, :old.OPER_CODE,
:old.BALUNIT, :old.AGENT, :old.NOMENCLATURE, :old.NOMMODIF, :old.NOMNMODIFPACK, :old.SUBDIV);
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTDET_BINSERT
before insert on SALESREPORTDETAIL for each row
begin
select COMPANY, CRN
into :new.COMPANY, :new.CRN
from SALESREPORTMAIN
where RN = :new.PRN;

IF USER<>'SNP_REPL' THEN
  -- PSV 22.09.2004 Отключаем проверку связи для репликации
  /* Проверка связи мастер таблицы */
  P_LINKSALL_CHECK( :new.PRN, :new.COMPANY, 'TradeReports' );
END IF;
  
/* Регистрация события */
P_SALESREPORTDETAIL_IUD_EVENT(:new.RN, 'I', :new.COMPANY, :new.PRN, :new.OPER_DATE, :new.OPER_CODE,
:new.BALUNIT, :new.AGENT, :new.NOMENCLATURE, :new.NOMMODIF, :new.NOMNMODIFPACK, :new.SUBDIV);
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTDET_BUPDATE
before update on SALESREPORTDETAIL for each row
begin
if (:old.RN != :new.RN ) then
P_EXCEPTION ( 0, 'Не допустима модификация поля RN.' );
end if;
if (:old.COMPANY != :new.COMPANY ) then
P_EXCEPTION ( 0, 'Не допустима модификация поля COMPANY.');
end if;
if (:old.PRN != :new.PRN ) then
P_EXCEPTION ( 0, 'Не допустима модификация поля PRN.');
end if;
if ( :new.CRN = :old.CRN ) then

  IF USER<>'SNP_REPL' THEN
    -- PSV 22.09.2004 Отключаем проверку связи для репликации
    /* Проверка связи */
    P_LINKSALL_CHECK( :new.RN, :new.COMPANY, 'TradeReportsSp' );
    /* Проверка связи мастер таблицы */
    P_LINKSALL_CHECK( :new.PRN, :new.COMPANY, 'TradeReports' );
  END IF;  

end if;
/* Регистрация события */
P_SALESREPORTDETAIL_IUD_EVENT(:new.RN, 'U', :new.COMPANY, :new.PRN, :new.OPER_DATE, :new.OPER_CODE,
:new.BALUNIT, :new.AGENT, :new.NOMENCLATURE, :new.NOMMODIF, :new.NOMNMODIFPACK, :new.SUBDIV);
end;
/





CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTMAIN_BUPDATE
before update on SALESREPORTMAIN for each row
begin
/* проверка неизменности полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы SALESREPORTMAIN недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы SALESREPORTMAIN недопустимо.' );
end if;
/* корректировка префикса и номера */
:new.RPT_PREFIX := TRIMNUMB( :new.RPT_PREFIX,10 );
:new.RPT_NUMBER := TRIMNUMB( :new.RPT_NUMBER,10 );
/* установка полей спецификации */
if ( not( :new.CRN = :old.CRN ) ) then
update SALESREPORTDETAIL
set CRN = :new.CRN
where PRN = :new.RN;
else

  IF USER<>'SNP_REPL' THEN
    -- PSV 22.09.2004 Отключаем проверку связи для репликации
    /* проверка связи документа с другими */
    P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'TradeReports' );
  END IF;  

end if;
/* регистрация события */
P_UPDATELIST_EVENT( 'SALESREPORTMAIN',:new.RN,'U',:new.COMPANY,null,null,null,:new.RPT_PREFIX || '; ' || :new.RPT_NUMBER );
end;
/
