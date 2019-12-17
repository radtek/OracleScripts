CREATE OR REPLACE procedure PVZ_AZSREPOUT_IMP_INSERT
(
nCOMPANY	in	number,
nPRN	in	number,
sTIME	in	varchar2,
sNOMEN	in	varchar2,
sOUTTYPE	in	varchar2,
sPAYTYPE	in	varchar2,
sSHIPTYPE	in	varchar2,
sMUNIT	in	varchar2,
sAGENT	in	varchar2,
sCARD	in	varchar2,
sMECH	in	varchar2,
nTEMPERATURE	in	number,
nPL	in	number,
nVOLUME	in	number,
nMASSA	in	number,
nPRICE	in	number,
nRN	out	number
)
as
RID	rowid;
vCRN	number( 17 );
nCHECKED	number( 17 );
nHASERRORS	number( 17 );
nQUANT	number( 17, 3 );
nOUT_RN	number( 17 );
nNOMEN	number( 17 );
nOUTTYPE	number( 17 );
nPAYTYPE	number( 17 );
nSHIPTYPE	number( 17 );
nMUNIT	number( 17 );
nQUANT_SIGN	number( 17 );
nFUND_FLAG	number( 17 );
aPRICE	number( 17, 5 );
nSUMM	number( 17, 2 )                 := 0;
nTYPE	number( 17 );
nSECTION	number( 17 );
nKEEP_SIGN	number( 17 );
nFC_SUM	number( 17, 2 )                 := 0;
nFC_RN	number( 17 )                    := null;
nFC_CREDIT	number( 17, 3 );
sFC_NUMB	varchar2( 20 );
nFC_AGENT	number( 17 );
nFC_CLASS	number( 17 );
nFOUNDED	number( 17 );
nFirstClass	number( 17 );
nSecClass	number( 17 );
nAGENT	number( 17 );
nFACEACC	number( 17 )                    := null;
nCARD_RN	number( 17 )                    := null;
nMECH	number( 17 );
nVERSION	number( 17 );
vMUNIT	number( 17 );
nMEAS_MAIN	number( 17 );
nMEAS_ALT	number( 17 );
nCURRENCY	number( 17 );
dDATE_SMENA	date;
nRP_RN	number( 17 );
nCARD_SUM	number( 17, 2 );
nCARD_NORM	number( 17, 3 );
nTRANSIT	number( 17 )                    := null;
nPRICE_FOUNDED	number( 17 );
nSTORE	number( 17 );
sTAX_GROUP	varchar2( 20 );
lMUNIT	varchar2( 10 );
ssCARD	varchar2( 20 );
NCARD_STATE	number( 17 );
DREC_DATE	date                            := null;
nSHIFT	number( 17 );
SSM_BEGIN	varchar2( 5 );
SSM_END	varchar2( 5 );
D1	date;
D2	date;
D3	date;
vREMNS	PKG_FACEACCTRADE.TFACEACC_REMNS;
nOPER_TYPE	number                          := 1;
nSUMMREZ	number;
isCREDCARD	boolean                         := false;
sAGENT_CR	AGNLIST.AGNABBR%type;
sFACEACC_CR	FACEACC.NUMB%type;
sTARIF	varchar2(20):='�����-���';
nTARIF	number(17);
nPRICEMEAS	number;
nDISCOUNT	number;
nDISCTYPE	number;
nTAXGROUP	number;
nCATEGORY	number(17);
procedure GET_AGENT_FACEACC(
nAGENT	in	number,
nFACEACC	in	number,
sAGENT	out	varchar2,
sFACEACC	out	varchar2
)
is
begin
begin
select AGNABBR
into sAGENT
from AGNLIST
where RN = nAGENT;
exception
when no_data_found then
sAGENT := '<null>';
end;
begin
select NUMB
into sFACEACC
from FACEACC
where RN = nFACEACC;
exception
when no_data_found then
sFACEACC := '<null>';
end;
end GET_AGENT_FACEACC;
begin
/* ���������� ���������� �������� ������ */
begin
select RN, rowid, CRN, DATE_SMENA, CHECKED, HAVE_ERRORS, AZS_NUMBER,
AZS_SMENA
into nRP_RN, RID, vCRN, dDATE_SMENA, nCHECKED, nHASERRORS, nSTORE,
nSHIFT
from AZSSREPORTMAIN
where RN = nPRN
and COMPANY = nCOMPANY;
exception
when no_data_found then
P_EXCEPTION( 0, '������� ����� �� ������.' ); end;
/* �������� ���� ������� */
P_USERPRIV_CTLG_FUNCACCESS( nCOMPANY, 'AZSREPORTLST', vCRN,
'AZSRpOut_INSERT'
);
/* �������� ���� �������� ������ */
P_AZSREPORT_CHECK_DATE( nSHIFT, dDATE_SMENA, sTIME, dREC_DATE );
/* ����� ��������� �������� */
FIND_DICSTOPR_TYPE_EX( nCOMPANY, sOUTTYPE, nOUTTYPE, nTYPE, nSECTION, nKEEP_SIGN
);
--   FIND_DICTARIF_CODE(0,  nCOMPANY,sTARIF,  nTARIF);
if nTYPE <> 0 then
P_EXCEPTION( 0, 'C�������� �������� (��� �������) "' || sOUTTYPE ||
'" ������ ����� ��� "������".'
);
end if;
/* ����� �� ��������� ����� */
if rtrim( sCARD ) is not null then
ssCARD := rtrim( sCARD );
/* ���������� ���������� ��������� ����� */
begin
select RN, AGENT, FACEACC, FUND_FLAG, CURRENT_SUM, ISSUE_RATE,
TRANSIT, STATE
into nCARD_RN, nAGENT, nFACEACC, nFUND_FLAG, nCARD_SUM, nCARD_NORM,
nTRANSIT, NCARD_STATE
from CREDCARD
where NUMB = ssCARD
and COMPANY = nCOMPANY;
exception
when no_data_found then
P_EXCEPTION( 0, '��������� ����� "' || sCARD || '" �� ����������.' ); end;
if nFACEACC is null then
P_EXCEPTION( 0, '��� ��������� ����� "' || sCARD ||
'" �� ��������� ������� ����.'
);
end if;
isCREDCARD := true;
/* ����� �� ����������� */
elsif sAGENT is not null then
/* ����������� ������ ����������� */
FIND_VERSION_BY_COMPANY( nCOMPANY, 'AGNLIST', nVERSION );
/* ���������� �����������, ����������� �������� ��� */
begin
select AG.RN
into nAGENT
from AGNLIST AG
where AG.AGNABBR = sAGENT
and AG.VERSION = nVERSION
and exists(select CL.AGENT
from AZSCLIENTS CL
where CL.AGENT = AG.RN
and CL.COMPANY = nCOMPANY );
exception
when no_data_found then
P_EXCEPTION( 0, '���������� "' || sAGENT ||
'" �� �������� �������� ���.'
);
end;
else
P_EXCEPTION( 0,
'��� ������ ������� ������ ���� ����� ���������� ��� ����� ��������� �����.' );
end if;
/* ���� �������� ������������� */
if nKEEP_SIGN = 1 then
/* ������� ���� ��� ������������� */
P_AZSREPOUT_IMP_FIND( nCOMPANY, nAGENT, nFACEACC, 2, nFOUNDED, nFC_RN, sFC_NUMB, nFC_SUM, nFC_CREDIT, nFC_CLASS
);
if nFOUNDED = 0 then
if isCREDCARD then
GET_AGENT_FACEACC( nAGENT, nFACEACC, sAGENT_CR, sFACEACC_CR );
P_EXCEPTION( 0, '���������� "' || sAGENT_CR ||
'" � ������� ������ (�������������) "' ||
sFACEACC_CR ||
'" ��������� ����� "' ||
ssCARD ||
'" �� ��������������� ��� ������ ���.'
);
else
P_EXCEPTION( 0,
'��� ����������� (������� ���) "' || sAGENT ||
'" �� ��������� ������� ���� ���� "�������������".'
);
end if;
end if;
else
/* ���������� ���������� ������������ �/� �� �������� */
if nvl( to_number( GET_OPTIONS_STR( 'FaceAccPriority', nCOMPANY )), 0 ) =
1 then nFirstClass := 0;                                       -- �� ������ nSecClass := 1;                                 -- �� ��������������
else
nFirstClass := 1;	-- �� ��������������
nSecClass := 0;	-- �� ������
end if;
/* ����� �/� �� ���������� �� ������������ (1 ���������) */
P_AZSREPOUT_IMP_FIND( nCOMPANY, nAGENT, nFACEACC, nFirstClass, nFOUNDED, nFC_RN, sFC_NUMB, nFC_SUM, nFC_CREDIT, nFC_CLASS
);
/* ����� �/� �� ���������� �� ������������ (2 ���������) */
if nFOUNDED = 0 then
P_AZSREPOUT_IMP_FIND( nCOMPANY, nAGENT, nFACEACC, nSecClass, nFOUNDED, nFC_RN, sFC_NUMB, nFC_SUM, nFC_CREDIT, nFC_CLASS
);
end if;
/* ���� �� ����� �� �� ������, �� �� �������������� ���� ���������� �/� */
if nFOUNDED = 0 then
P_AZSREPOUT_IMP_FIND( nCOMPANY, nAGENT, nFACEACC, 3, nFOUNDED, nFC_RN, sFC_NUMB, nFC_SUM, nFC_CREDIT, nFC_CLASS
);
end if;
if nFOUNDED = 0 then
if isCREDCARD then
GET_AGENT_FACEACC( nAGENT, nFACEACC, sAGENT_CR, sFACEACC_CR );
P_EXCEPTION( 0,
'���������� "' || sAGENT_CR ||
'" � ������� ������ (�� ������, �������������� ��� ����������) "' ||
sFACEACC_CR ||
'" ��������� ����� "' ||
ssCARD ||
'" �� ��������������� ��� ������ ���.'
);
else
P_EXCEPTION( 0,
'��� ����������� (������� ���) "' || sAGENT ||
'" �� ��������� ������� ���� �� ������, �������������� ��� ����������.'
);
end if;
end if;
end if;
nFACEACC := nFC_RN;
/* ����������� ������ */
FIND_VERSION_BY_COMPANY( NCOMPANY, 'Nomenclator', nVERSION );
if nFACEACC is not null then
select TARIF into nTARIF from FACEACC where RN=nFACEACC;
if nTARIF is null then P_EXCEPTION(0,'�� ��������� ����� � �/� '||sFC_NUMB);  end if;
end if;
/* ����� ������������ */
begin
select N.RN, N.UMEAS_MAIN, N.UMEAS_ALT, M.CATEGORY
into nNOMEN, nMEAS_MAIN, nMEAS_ALT, nCATEGORY
from DICNOMNS N, DICMUNTS M
where N.VERSION = nVERSION
and N.NOMEN_CODE = sNOMEN and N.UMEAS_MAIN=M.RN;
exception
when no_data_found then
P_EXCEPTION( 0, '������������ "' || sNOMEN || '" �� ����������.' ); end;
FIND_MEASUNIT_BY_MNEMO( nCOMPANY, sMUNIT, vMUNIT ); nMUNIT := vMUNIT;
if vMUNIT = nMEAS_MAIN then
nQUANT_SIGN := 0;
elsif	( nMEAS_ALT is not null )
and ( vMUNIT = nMEAS_ALT ) then
nQUANT_SIGN := 1;
else
P_EXCEPTION( 0, '������� ������� ��������� "' || sMUNIT ||
'" �� ������������� �������� ��������� ������������.'
);
end if;
FIND_DICPAYVW_CODE( 0, nCOMPANY, sPAYTYPE, nPAYTYPE );
FIND_DICSHPVW_CODE( 0, nCOMPANY, sSHIPTYPE, nSHIPTYPE );
if	sMECH is not null
and rtrim( sMECH ) is not null then
FIND_TRK_BY_AZS(0,0, nSTORE, sMECH, nMECH ); else
nMECH := null;
end if;
/* ���������, ��� �������, ���� */
aPRICE := 0;
nPRICE_FOUNDED := 0;
FIND_CURRENCY_BASE( nCOMPANY, nCURRENCY );
/*   P_OILOUTPR_FIND_PRICE_BASE( nCOMPANY, 1, dREC_DATE, nNOMEN, nSTORE,
nOUTTYPE, nPAYTYPE, nSHIPTYPE, nMUNIT, nCURRENCY, null, nPRICE_FOUNDED,
sTAX_GROUP, lMUNIT, aPRICE
);
*/
if nPRICE is null or nPRICE=0 then
P_RLPRICES_GETPRICE_BASE( nCOMPANY, dREC_DATE, null, null, null, null, nTARIF, nSTORE, nSHIPTYPE, nPAYTYPE, nNOMEN,
null,  null,  null,  nCURRENCY,1,1,
aPRICE,  nPRICEMEAS,  nDISCOUNT,  nDISCTYPE,  nTAXGROUP);
	if aPRICE is not null then
if ( nPRICEMEAS=0 and nCATEGORY!=1 ) or ( nPRICEMEAS=1 and nCATEGORY=1 )  then
nSUMM := aPRICE * nVOLUME;
		else
			nSUMM := aPRICE * nMASSA;
end if;
end if;
elsif nPRICE>0 then
	 	aPRICE :=nPRICE;
		nSUMM :=aPRICE * nVOLUME;
else
	 	aPRICE :=0;
		nSUMM :=0;
end if;
	/*
if	nPRICE is not null and nPRICE <> aPRICE then
	insert
	into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD )
		values (GEN_ID, nRP_RN,
'���������� ���� ���������� ��� "' || sNOMEN || '" ('|| nPRICE ||') �� ������������� ���� �� ����������� ('|| aPRICE ||').', nFACEACC, nCARD_RN
				);
			p_exception( 0, '���������� ���� ���������� ��� "' || sNOMEN || '" (' ||
		nPRICE ||
							') �� ������������� ���� �� ����������� (' ||
							aPRICE ||
							').'
							);
		end if; */
	/*   else
	insert
		into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD )
		values (GEN_ID, nRP_RN,
		'�� ������ ���� ���������� ��� : "' || sNOMEN || '", "' || sOUTTYPE ||
				'", "' || sPAYTYPE || '", "' || sSHIPTYPE ||'", "' || sMUNIT || '".', nFACEACC, nCARD_RN
				);
	p_exception( 0,
	'�� ������ ���� ���������� ��� : "' || sNOMEN || '", "' || sOUTTYPE ||
		'", "' ||
			sPAYTYPE ||
			'", "' ||
			sSHIPTYPE ||
			'", "' ||
sMUNIT ||
'".'
); */
if nSUMM <> 0 then
/*
if nFC_CLASS <> 3 then
if (nFC_SUM + NVL(nFC_CREDIT,0)) - nSUMM < 0 then
insert
into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD )
values (GEN_ID, nRP_RN,
'��������� ������� �������� ����� �������� �����.', nFACEACC, null
);
end if;
end if;
*/
/* �������������� �������� ����� */
nSUMMREZ := -nSUMM;
if nSUMMREZ >= 0 then
vREMNS.nPLAN_INCOME := nSUMMREZ;
vREMNS.nFACT_INCOME := nSUMMREZ;
else
vREMNS.nPLAN_SHIP := nSUMMREZ;
vREMNS.nFACT_SHIP := nSUMMREZ;
end if;
P_FACEACC_CORRECT_ACCOUNT( nCOMPANY, nFACEACC, null, null, vREMNS, nOPER_TYPE, null, null
);
/* ������������� ������� ��������� ����� ���� ��� ������������� �� �� ����� ������� */
if	( nCARD_RN is not null )
and ( nFUND_FLAG = 1 ) then
nCARD_SUM := nCARD_SUM - nSUMM;
update CREDCARD
set CURRENT_SUM = nCARD_SUM
where RN = NCARD_RN;
/*
if nCARD_SUM < 0 then
insert
into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC,CARD )
values (GEN_ID, nRP_RN,
'��������� ����� ��������� �����.', nFACEACC, nCARD_RN
);
end if;
if nVOLUME > nCARD_NORM then
insert
into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD)
values (GEN_ID, nRP_RN,
'��������� ����� ��������� ����� ������� � ����.', nFACEACC, nCARD_RN
);
end if;
*/
end if;
/*
if (nCARD_RN is not null) and (NCARD_STATE <> 0) then
if nCARD_STATE = 1 then
insert
into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD)
values (GEN_ID, nRP_RN,
'���������� ������ �� ��������� �����, ������� ��������� "������".', nFACEACC, nCARD_RN
);
elsif NCARD_STATE = 2 then
insert
into AZSIMPEVENTS (RN, PRN, EVENT, FACEACC, CARD)
values (GEN_ID, nRP_RN,
'���������� ������ �� ��������� �����, ������� ��������� "�����".',  nFACEACC, nCARD_RN
);
end if;
end if;
*/
end if;
if nKEEP_SIGN = 1 then
P_KEEPREMN_BASE_MODIFY( nCOMPANY, nFACEACC, nSTORE, nNOMEN, -nVOLUME,
-nMASSA, 1
);
end if;
/* ����� �������� */
if	nCHECKED = 1
and nHASERRORS = 0 then
update AZSSREPORTMAIN
set CHECKED = 0
where rowid = RID;
end if;
P_AZSREPOUT_BASE_INSERT( nCOMPANY, vCRN, nPRN, DREC_DATE, nNOMEN, nOUTTYPE, nPAYTYPE, nSHIPTYPE, nMUNIT, nFACEACC, nCARD_RN, nTEMPERATURE, nPL, nVOLUME, nMASSA, aPRICE, nSUMM, nOUT_RN
);
nRN := nOUT_RN;
end;
/

