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
/* ��������� ����� ����� � �������� ��� ���*/
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
/* ���������� ������ �� */
P_SALESRPTMAIN_EXISTS( nCOMPANY,nRN,nCRN,nJUR_PERS );
/* ����� ��� ������������ ����������: ����������� */
nIDENT := PKG_INHIER.CONSTRUCTOR( nCOMPANY );
for i in tLINK_TYPES.FIRST..tLINK_TYPES.LAST loop
/* ���������� � ������� ��������� */
PKG_INHIER.PREP_LINK( nIDENT );
/* ����������� �������� �������/��������� */
PKG_INHIER.SET_IN_UNIT( nIDENT,0,'TradeReports',tLINK_TYPES(i).LINK_TYPE,tLINK_TYPES(i).ACTION,'SALESREPORTMAIN' );
PKG_INHIER.SET_IN_DOC_EX( nIDENT,0,nRN,nCRN,nJUR_PERS );
PKG_INHIER.SET_IN_UNIT( nIDENT,1,'TradeReportsSp' );
/* ����������� ��������� ������� */
PKG_INHIER.SET_OUT_UNIT( nIDENT,0,'EconomicOperations','P_ECONOPRS_BASE_DELETE' );
PKG_INHIER.SET_OUT_UNIT( nIDENT,1,'EconomicOperationsSpecs' );
/* ������� �������� � ��������� ���������� ����� ��������������� */
PKG_INHIER.DROP_LINKS( nIDENT );
end loop;
/* ����� ��� ������������ ����������: ���������� */
PKG_INHIER.DESTRUCTOR( nIDENT );
/* ��������� ��������� �� */
begin
/* ���������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReports' );
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReportsSp' );
/* ��������� ������� � �������� ��� ������ ����������� */
--PKG_UPDATELIST.DROP_REGISTER( 'SALESREPORTMAIN','U' );
/* ��������� ������� */
update SALESREPORTMAIN
set WORK_STATE     = nvl(nWORK_STATE,WORK_STATE)         ,
WORK_DATE      = decode(nWORK_STATE,0,null,WORK_DATE),
WORK_STATE_TAX = nvl(nWORK_STATE_TAX,WORK_STATE_TAX) ,
WORK_DATE_TAX  = decode(nWORK_STATE_TAX,0,null,WORK_DATE_TAX)
where RN = nRN;
/* �������������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* ��������� ������� � �������� ��� ������������� ����������� */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
exception
when OTHERS then
/* �������������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* ��������� ������� � �������� ��� ������������� ����������� */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
raise;
end;
end;
/




CREATE OR REPLACE procedure P_SALESRPTMAIN_REPLACE
(
nCOMPANY        in number,
nIDENT          in number,
nFLAG_LINK      in number         -- �� �����������
)
as
nCOUNT_FULL     PKG_STD.TREF;
nCOUNT_PROC     PKG_STD.TREF;
begin
/* ����������� �� ������ � ���������� �� ������ � ���� */
P_ECOPRBUF_BASE_REPLACE( nCOMPANY,nIDENT,1,0 );
/* ��������� ��������� �� */
begin
/* ���������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReports' );
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET( 'TradeReportsSp' );
/* ��������� ������� � �������� ��� ������ ����������� */
--PKG_UPDATELIST.DROP_REGISTER( 'SALESREPORTMAIN','U' );
/* ��������� �������� ��������� */
for rec in
(
select B.IN_DOCUMENT0 DOCUMENT
from INHIERBUFF B
where B.IDENT = nIDENT and B.COMPANY = nCOMPANY
group by B.IN_DOCUMENT0
) loop
/* ��������� ��������� ��������� � ����� ��������� ������. */
P_SALESRPTMAIN_REFRESH_STATE( nCOMPANY, rec.DOCUMENT );
end loop;
/* �������������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* ��������� ������� � �������� ��� ������������� ����������� */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
exception
when OTHERS then
/* �������������� ������ �� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
/* ��������� ������� � �������� ��� ������������� ����������� */
PKG_UPDATELIST.SET_REGISTER( 'SALESREPORTMAIN','U' );
raise;
end;
/* ������� ������ ��������� */
P_ECOPRBUF_PACK_BY_IDENT( nCOMPANY,nIDENT );
end;
/




CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTDET_BDELETE before delete on SALESREPORTDETAIL
for each row
begin

IF USER<>'SNP_REPL' THEN
  -- PSV 22.09.2004 ��������� �������� ����� ��� ����������
  /* �������� ����� ������ ������� */
  P_LINKSALL_CHECK( :old.PRN, :old.COMPANY, 'TradeReports' );
  /* �������� ����� */
  P_LINKSALL_CHECK( :old.RN, :old.COMPANY, 'TradeReportsSp' );
END IF;
  
/* ����������� ������� */
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
  -- PSV 22.09.2004 ��������� �������� ����� ��� ����������
  /* �������� ����� ������ ������� */
  P_LINKSALL_CHECK( :new.PRN, :new.COMPANY, 'TradeReports' );
END IF;
  
/* ����������� ������� */
P_SALESREPORTDETAIL_IUD_EVENT(:new.RN, 'I', :new.COMPANY, :new.PRN, :new.OPER_DATE, :new.OPER_CODE,
:new.BALUNIT, :new.AGENT, :new.NOMENCLATURE, :new.NOMMODIF, :new.NOMNMODIFPACK, :new.SUBDIV);
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTDET_BUPDATE
before update on SALESREPORTDETAIL for each row
begin
if (:old.RN != :new.RN ) then
P_EXCEPTION ( 0, '�� ��������� ����������� ���� RN.' );
end if;
if (:old.COMPANY != :new.COMPANY ) then
P_EXCEPTION ( 0, '�� ��������� ����������� ���� COMPANY.');
end if;
if (:old.PRN != :new.PRN ) then
P_EXCEPTION ( 0, '�� ��������� ����������� ���� PRN.');
end if;
if ( :new.CRN = :old.CRN ) then

  IF USER<>'SNP_REPL' THEN
    -- PSV 22.09.2004 ��������� �������� ����� ��� ����������
    /* �������� ����� */
    P_LINKSALL_CHECK( :new.RN, :new.COMPANY, 'TradeReportsSp' );
    /* �������� ����� ������ ������� */
    P_LINKSALL_CHECK( :new.PRN, :new.COMPANY, 'TradeReports' );
  END IF;  

end if;
/* ����������� ������� */
P_SALESREPORTDETAIL_IUD_EVENT(:new.RN, 'U', :new.COMPANY, :new.PRN, :new.OPER_DATE, :new.OPER_CODE,
:new.BALUNIT, :new.AGENT, :new.NOMENCLATURE, :new.NOMMODIF, :new.NOMNMODIFPACK, :new.SUBDIV);
end;
/





CREATE OR REPLACE TRIGGER "PARUS".T_SALESRPTMAIN_BUPDATE
before update on SALESREPORTMAIN for each row
begin
/* �������� ������������ ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� �������� ���� RN ������� SALESREPORTMAIN �����������.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� �������� ���� COMPANY ������� SALESREPORTMAIN �����������.' );
end if;
/* ������������� �������� � ������ */
:new.RPT_PREFIX := TRIMNUMB( :new.RPT_PREFIX,10 );
:new.RPT_NUMBER := TRIMNUMB( :new.RPT_NUMBER,10 );
/* ��������� ����� ������������ */
if ( not( :new.CRN = :old.CRN ) ) then
update SALESREPORTDETAIL
set CRN = :new.CRN
where PRN = :new.RN;
else

  IF USER<>'SNP_REPL' THEN
    -- PSV 22.09.2004 ��������� �������� ����� ��� ����������
    /* �������� ����� ��������� � ������� */
    P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'TradeReports' );
  END IF;  

end if;
/* ����������� ������� */
P_UPDATELIST_EVENT( 'SALESREPORTMAIN',:new.RN,'U',:new.COMPANY,null,null,null,:new.RPT_PREFIX || '; ' || :new.RPT_NUMBER );
end;
/
