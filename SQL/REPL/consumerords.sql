
CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BDELETE
before delete on CONSUMERORD for each row
begin
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if :old.BLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
/* �஢�ਬ ���ﭨ� ������ */
if ( :old.ORD_STATE <> 0 )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'�������� ������ ���ॡ�⥫� � ���ﭨ� �⫨筮� �� "�� �⢥ত��" �������⨬�.' );
end if;
/* ॣ������ ᮡ��� */
P_UPDATELIST_EVENT( 'CONSUMERORD',:old.RN,'D',:old.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :old.COMPANY,:old.ORD_DOCTYPE,null,:old.ORD_PREF,:old.ORD_NUMB,:old.ORD_DATE ));
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BINSERT
before insert on CONSUMERORD for each row
begin
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if :new.BLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
/* ���४�஢�� ����� */
:new.ORD_NUMB := strright( strtrim( :new.ORD_NUMB ),10 );
:new.ORD_PREF := strright( strtrim( :new.ORD_PREF ),10 );
-- ������� ᫥���饣� �����
if GET_OPTIONS_NUM('Realiz_Auto_Generate_Next_Number', :new.COMPANY) = 1 then
P_DOC_GETNEXTNUMB(:new.COMPANY, 'CONSUMERORD', 'ORD_DOCTYPE', 'ORD_PREF', 'ORD_NUMB',
'CONSUMERORDBUF', 'ORD_DOCTYPE', 'ORD_PREF', 'ORD_NUMB', :new.ORD_DOCTYPE, :new.ORD_PREF, :new.ORD_NUMB);
end if;
/* ॣ������ ᮡ��� */
P_UPDATELIST_EVENT( 'CONSUMERORD',:new.RN,'I',:new.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :new.COMPANY,:new.ORD_DOCTYPE,null,:new.ORD_PREF,:new.ORD_NUMB,:new.ORD_DATE ) );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BUPDATE
before update on CONSUMERORD for each row
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� CONSUMERORD �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� CONSUMERORD �������⨬�.' );
end if;
/* ���४�஢�� ����� */
:new.ORD_NUMB := strright( strtrim( :new.ORD_NUMB ),10 );
:new.ORD_PREF := strright( strtrim( :new.ORD_PREF ),10 );
/* ��⠭���� ��ࠬ��஢ detail-����ᥩ */
if not( :new.CRN = :old.CRN ) then -- ᬥ�� ��⠫���
update CONSUMERORDS
set CRN = :new.CRN
where PRN = :new.RN;
update CONSUMERORDP
set CRN = :new.CRN
where PRN = :new.RN;
else -- ��������� � ������
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if (:old.BLOCKED = :new.BLOCKED) and (:old.BLOCKED = 1) and USER<>'SNP_REPL'           -- �ਧ��� �६����� �����஢�� �� ������� � ��⠭����� � 1
then
if (:old.RESERVDATE is not null and :new.RESERVDATE is null)  -- ����⪠ ���� ��१�ࢨ஢����
or (:old.NOTE is null and :new.NOTE is not null)            -- ����⪠ ��ࠢ��� �������਩
or (:old.NOTE is not null and :new.NOTE is null)            -- ����⪠ ��ࠢ��� �������਩
or (:old.NOTE <> :new.NOTE)                                 -- ����⪠ ��ࠢ��� �������਩
--
-- ��������� �᫮���, �� ������ ࠧ�襭� UPDATE �� ��⠭�������� �ਧ���� "�६����� �����஢��" �����
--
then
null;
else
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
end if;
if ( :new.ORD_STATE <> :old.ORD_STATE ) then -- �᫨ �� �� ᬥ�� ���ﭨ�, �஢��塞 ᮮ�. ��࠭�祭��.
if (:new.ORD_STATE = 1) and (:new.FACEACC is null) then
P_EXCEPTION( 0,'��⠭���� ���ﭨ� "�⢥ত��" ��� ������� ��楢��� ��� �������⨬�.');
end if;
end if;/**/
end if;
/* ॣ������ ᮡ��� */
P_UPDATELIST_EVENT( 'CONSUMERORD',:new.RN,'U',:new.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :new.COMPANY,:new.ORD_DOCTYPE,null,:new.ORD_PREF,:new.ORD_NUMB,:new.ORD_DATE ) );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDP_BINSERT
before insert on CONSUMERORDP for each row
declare
nBLOCKED                      number(1);      -- �ਧ��� �६����� �����஢��
begin
/* ���뢠��� ��ࠬ��஢ master-����� */
select COMPANY, CRN, BLOCKED
into :new.COMPANY, :new.CRN, nBLOCKED
from CONSUMERORD
where RN = :new.PRN;
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
/* ॣ������ ᮡ��� */
P_CONSUMERORDP_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF_NUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDP_BUPDATE
before update on CONSUMERORDP for each row
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� CONSUMERORDP �������⨬�.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� PRN ⠡���� CONSUMERORDP �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� CONSUMERORDP �������⨬�.' );
end if;
if :old.CRN = :new.CRN then          -- ��⠫�� ���������, => ���������� ��㣨� ����
if not F_CNSMRRDP_UPDBLCK_ENABLE
(
:old.RN, :new.RN
,:old.PRN, :new.PRN
,:old.COMPANY, :new.COMPANY
,:old.CRN, :new.CRN
,:old.PERF_NUMB, :new.PERF_NUMB
,:old.PERF_DATE, :new.PERF_DATE
,:old.PSUMWTAX, :new.PSUMWTAX
,:old.PSUMWOTAX, :new.PSUMWOTAX
,:old.SUPP_PLAN_SUM, :new.SUPP_PLAN_SUM
,:old.SUPP_FACT_SUM, :new.SUPP_FACT_SUM
,:old.PAY_PLAN_SUM, :new.PAY_PLAN_SUM
,:old.PAY_FACT_SUM, :new.PAY_FACT_SUM
,:old.ACC_QUANT, :new.ACC_QUANT
,:old.ACC_SUM, :new.ACC_SUM
) AND USER<>'SNP_REPL'
then -- ���������� ����, ����� ����� ������ �� ��⠭�������� �ਧ���� "�६.�����஢��"
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� (���� BLOCKED) */
P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :new.PRN);
end if;
end if;
/* ॣ������ ᮡ��� */
P_CONSUMERORDP_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.PERF_NUMB );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BDELETE
before delete on CONSUMERORDPS for each row
declare
nBLOCKED                     number(1);       -- �ਧ��� �६����� �����஢�� ������
TABLE_MUTATING               exception;
pragma exception_init(
TABLE_MUTATING, -04091);
begin
begin
/* �롨ࠥ� �ਧ��� �६����� �����஢�� �� ��������� ������ */
select M.BLOCKED into nBLOCKED
from
CONSUMERORD  M,
CONSUMERORDS S
where S.RN = :old.PRN
and M.RN = S.PRN;
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
exception
when TABLE_MUTATING then
null; -- ������㥬 ᮡ���, ��뢠��� ����⢨ﬨ ��� master-⠡��楩. ����� master ᠬ ����஫���� �� �����⨬����
end;
/* ॣ������ ᮡ��� */
P_CONSUMERORDPS_IUD( :old.RN,'D',:old.COMPANY,:old.PRN,:old.PERF );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BINSERT
before insert on CONSUMERORDPS for each row
declare
nORD_STATE     CONSUMERORD.ORD_STATE%TYPE;    -- ���ﭨ� ������ (0-�����⢥ত��, 1-���⢥ত��, 2-ᮣ��ᮢ����, 3-������, 4-���㫨஢��)
nORD_PERIOD    CONSUMERORD.ORD_PERIOD%TYPE;   -- ��ਮ���᪨� ����� (0-ࠧ���, 1-��ਮ���᪨�)
nPERIOD_CORR   CONSUMERORD.PERIOD_CORR%TYPE;  -- ���४�� �� ��ਮ��� (0-���, 1-��)
nPERIOD_QUANT  CONSUMERORD.PERIOD_QUANT%TYPE; -- �᫮ ��ਮ���
nPRODUCT       PKG_STD.tREF;                  -- �������
nPRAQUANT      RLARTICLES.QUANT%TYPE;         -- ���-�� ������� � ���
nBLOCKED       CONSUMERORD.BLOCKED%TYPE;      -- �ਧ��� �६����� �����஢�� ������
nCONSOLIDATED  CONSUMERORD.CONSOLIDATED%TYPE; -- �ਧ��� ���᮫���樨
begin
/* ���뢠��� ��ࠬ��஢ master-����� */
select COMPANY, CRN
into :new.COMPANY, :new.CRN
from CONSUMERORDS
where RN = :new.PRN;
/* ��⠥� ���ﭨ� ������ */
select /*+ ORDERED*/
M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR, M.PERIOD_QUANT, S.PRODUCT,
M.BLOCKED, M.CONSOLIDATED
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR, nPERIOD_QUANT, nPRODUCT,
nBLOCKED, nCONSOLIDATED
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
if (nCONSOLIDATED < 2) then -- ��� �����᮫���஢����� �������
/* �஢�ਬ �����⨬���� ��⠭����������� ���ﭨ� */
/* ��࠭�祭��: ������ ���������� ⮫쪮 � ���ﭨ�� '�� ᮣ��ᮢ���' */
if ( :new.PERFS_STATE <> 0 ) and USER<>'SNP_REPL' then -- ���ﭨ� �. ���� ⮫쪮 '�� ᮣ��ᮢ���'
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �⫨筮�� �� "�� ᮣ��ᮢ���" �� ���������� ����� �ᯮ������ ����樨 ᯥ�䨪�樨 ������ �������⨬�.' );
else -- �᫨ ���ﭨ� ��ଠ�쭮�, � �஢�ਬ ���������
if (nORD_STATE <> 0) and USER<>'SNP_REPL' then -- ��������� �. ���� � ���ﭨ� '�����⢥ত��'
P_EXCEPTION( 0,'���������� ����� �ᯮ������ ����樨 ᯥ�䨪�樨 ������ �� ���ﭨ� ��������� �⫨筮� �� "�� �⢥ত��" �������⨬�.' );
end if;
end if;
end if;
/* �᫨ �।����� �஢��� ��諨, � ��⠫��� �஢���� ⮫쪮 �� ��࠭�祭�� ��ࠬ��஢ ����� */
/* ᮢ������� ���-� � ���-���� � ������� */
if (nPRODUCT is not null) AND USER<>'SNP_REPL' then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �᭮���� �� �⫨筮� �� 1 �������⨬�.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �������⥫쭮� �� �⫨筮� �� 㪠������� � ������� �������⨬�.' );
end if;
end if;
/* ������ �㬬 � �ᯮ������ ������ */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX + :new.ACTSWTAX
where RN = :new.PERF;  /* ॣ������ ᮡ��� */
P_CONSUMERORDPS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BUPDATE
before update on CONSUMERORDPS for each row
declare
nORD_STATE      CONSUMERORD.ORD_STATE%TYPE;    -- ���ﭨ� ������ (0-�����⢥ত��, 1-���⢥ত��, 2-ᮣ��ᮢ����, 3-������, 4-���㫨஢��)
nORD_PERIOD     CONSUMERORD.ORD_PERIOD%TYPE;   -- ��ਮ���᪨� ����� (0-ࠧ���, 1-��ਮ���᪨�)
nPERIOD_CORR    CONSUMERORD.PERIOD_CORR%TYPE;  -- ���४�� �� ��ਮ��� (0-���, 1-��)
nPERIOD_QUANT   CONSUMERORD.PERIOD_QUANT%TYPE; -- �᫮ ��ਮ���
nATSAMETIME     CONSUMERORD.ATSAMETIME%TYPE;   -- �����६����� �ᯮ������ (0-���, 1-��)
nBLOCKED        CONSUMERORD.BLOCKED%TYPE;      -- �ਧ��� �६����� �����஢�� ������ (0, 1)
nSUMWTAX        PKG_STD.tSUMM;                 -- ��室��� �㬬� � �������
nSUMWOTAX       PKG_STD.tSUMM;                 -- ��室��� �㬬� ��� ������
nMAIN_QUANT     PKG_STD.tQUANT;                -- ��室��� ���-�� � ��. ��
nALT_QUANT      PKG_STD.tQUANT;                -- ��室��� ���-�� � ���. ��
nPRODUCT        PKG_STD.tREF;                  -- �������
nPRAQUANT       PKG_STD.tQUANT;                -- ���-�� ������� � ���
nTMP            PKG_STD.tREF;                  -- �६�����.
nSAVE_EXEC_CUST number(1);                     -- ����ன�� "���࠭��� �।������� �ᯮ���⥫� � �����稪�"
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� CONSUMERORDPS �������⨬�.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� PRN ⠡���� CONSUMERORDPS �������⨬�.' );
end if;
if ( not( :new.PERF = :old.PERF ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� PERF ⠡���� CONSUMERORDPS �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� CONSUMERORDPS �������⨬�.' );
end if;
/* �� �஢�ન ⮫쪮 �᫨ �� �� ᬥ�� ��⠫��� */
if ( :new.CRN = :old.CRN ) then
/* ��⠥� ���ﭨ� ������ */
select M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR,M.PERIOD_QUANT,M.ATSAMETIME,M.BLOCKED,
S.SUMWTAX,S.SUMWOTAX,S.MAIN_QUANT,S.ALT_QUANT,S.PRODUCT
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR,nPERIOD_QUANT,nATSAMETIME,nBLOCKED,
nSUMWTAX,nSUMWOTAX,nMAIN_QUANT,nALT_QUANT,nPRODUCT
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if ( nBLOCKED = 1 and not F_CNSMRRDPS_UPDBLCK_ENABLE( :old.RN, :new.RN, :old.PRN, :new.PRN, :old.COMPANY, :new.COMPANY,
:old.CRN, :new.CRN, :old.PERF, :new.PERF, :old.PERFS_STATE, :new.PERFS_STATE,
:old.CS_DATE, :new.CS_DATE,:old.PERF_DATE, :new.PERF_DATE,
:old.ACTPF_DATE, :new.ACTPF_DATE,:old.CUST_DATE, :new.CUST_DATE,
:old.EXEC_DATE, :new.EXEC_DATE, :old.ACTM_QUANT, :new.ACTM_QUANT,
:old.ACTA_QUANT, :new.ACTA_QUANT, :old.EXECM_QUANT, :new.EXECM_QUANT,
:old.EXECA_QUANT, :new.EXECA_QUANT, :old.CUSTM_QUANT, :new.CUSTM_QUANT,
:old.CUSTA_QUANT, :new.CUSTA_QUANT,:old.ACTSWTAX, :new.ACTSWTAX,
:old.ACTSWOTAX, :new.ACTSWOTAX, :old.EXECSWTAX, :new.EXECSWTAX,
:old.EXECSWOTAX, :new.EXECSWOTAX, :old.CUSTSWTAX, :new.CUSTSWTAX,
:old.CUSTSWOTAX, :new.CUSTSWOTAX, :old.ACCM_QUANT, :new.ACCM_QUANT,
:old.ACCA_QUANT, :new.ACCA_QUANT, :old.ACC_SUM, :new.ACC_SUM,
:old.P_PLANM_QUANT, :new.P_PLANM_QUANT,
:old.P_PLANA_QUANT, :new.P_PLANA_QUANT,
:old.P_FACTM_QUANT, :new.P_FACTM_QUANT,
:old.P_FACTA_QUANT, :new.P_FACTA_QUANT,
:old.P_PLAN_SUM, :new.P_PLAN_SUM,:old.P_FACT_SUM, :new.P_FACT_SUM,
:old.RESERVM_QUANT, :new.RESERVM_QUANT,:old.RESERVA_QUANT, :new.RESERVA_QUANT )) AND USER<>'SNP_REPL'
then
P_EXCEPTION( 0,'������ ����饭�. ���㬥�� �६���� �����஢��.' );
end if;
/* ��ࠡ�⪠ ᬥ�� ���ﭨ� */
if ( :new.PERFS_STATE <> :old.PERFS_STATE ) then
/* �஢�ਬ �����⨬���� ��⠭����������� ���ﭨ� (���� ���� �஢�ન - � ��楤�� P_CONSUMERORD_SET_STATE) */
if (nORD_STATE = 1 and nORD_PERIOD = 1 and :new.PERFS_STATE in (1,2)) then
/* �᫨ �� ��ਮ���᪨� ����� � � ���ﭨ� '�⢥ত��', �஢�ਬ �����⨬���� ᬥ�� ���ﭨ� ᯥ�䨪�樥� */
if ( PKG_DOCLINKS_SMART.CHECK_IN( 'ConsumersOrdersPerform' ) = 0 ) then -- �஢�ઠ ��室��� ���㬥�⮢
P_DOCINPT_FIND_EXACT( 0,:old.COMPANY,'ConsumersOrdersPerform',:old.PERF,nTMP );
end if;
end if;
/* �஢�ਬ �����⨬���� ��⠭����������� ���ﭨ� */
if ( :new.PERFS_STATE = 0 and not (nORD_STATE = 0) ) AND USER<>'SNP_REPL' then -- �� ᮣ��ᮢ���
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �ᯮ������ ����樨 ᯥ�䨪�樨 "�� ᮣ��ᮢ���"'||
' �� ���ﭨ� ������ �⫨筮� �� "�� �⢥ত��" �������⨬�.' );
end if;
/* �।������� �����稪� */
if ( :new.PERFS_STATE = 1 and not (nORD_STATE = 2 or (nORD_STATE = 1 and nORD_PERIOD = 1 and nPERIOD_CORR = 1)) )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �ᯮ������ ����樨 ᯥ�䨪�樨 "�।������� �����稪�"'||
' �� ���ﭨ� ������ �⫨筮� �� "�����ᮢ����" ��� "�⢥ত��" �������⨬�.' );
end if;
/* �।������� �ᯮ���⥫� */
if ( :new.PERFS_STATE = 2 and not (nORD_STATE = 2 or (nORD_STATE = 1 and nORD_PERIOD = 1 and nPERIOD_CORR = 1)) )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �ᯮ������ ����樨 ᯥ�䨪�樨 "�।������� �ᯮ���⥫�"'||
' �� ���ﭨ� ������ �⫨筮� �� "�����ᮢ����" ��� "�⢥ত��" �������⨬�.' );
end if;
/* ᮣ��ᮢ��� */
if ( :new.PERFS_STATE = 3 and not (nORD_STATE in (1,2)) ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �ᯮ������ ����樨 ᯥ�䨪�樨 "�����ᮢ���"'||
' �� ���ﭨ� ������ �⫨筮� �� "�����ᮢ����" ��� "�⢥ত��" �������⨬�.' );
end if;
/* ��⠥� ����ன�� "���࠭��� �।������� �ᯮ���⥫� � �����稪�" */
nSAVE_EXEC_CUST := GET_OPTIONS_NUM('Realiz_ConsumerOrd_Save_Exec_Cust_Vals', :new.COMPANY);
/*!!!�஢��塞 ᮢ������� ������!!!*/
if ( :new.PERFS_STATE = 3 and not (:new.EXECM_QUANT = :new.CUSTM_QUANT and
:new.EXECA_QUANT = :new.CUSTA_QUANT and
:new.EXECSWTAX   = :new.CUSTSWTAX   and
:new.EXECSWOTAX  = :new.CUSTSWOTAX  and
:new.EXEC_DATE   = :new.CUST_DATE) ) then
if (:old.PERFS_STATE = 1) then
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
:new.ACTPF_DATE  := :new.CUST_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.EXECM_QUANT := :new.CUSTM_QUANT;
:new.EXECA_QUANT := :new.CUSTA_QUANT;
:new.EXECSWTAX   := :new.CUSTSWTAX;
:new.EXECSWOTAX  := :new.CUSTSWOTAX;
:new.EXEC_DATE   := :new.CUST_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 402 );
elsif (:old.PERFS_STATE = 2) then
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
:new.ACTPF_DATE  := :new.EXEC_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.CUSTM_QUANT := :new.EXECM_QUANT;
:new.CUSTA_QUANT := :new.EXECA_QUANT;
:new.CUSTSWTAX   := :new.EXECSWTAX;
:new.CUSTSWOTAX  := :new.EXECSWOTAX;
:new.CUST_DATE   := :new.EXEC_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 403 );
end if;
/* ��ࠢ�� ���� � � ��������� �ᯮ������ �� ��ਮ�� */
if (nATSAMETIME = 1) then -- �᫨ �ᯮ������ �����६�����
update CONSUMERORDP
set PERF_DATE = :new.ACTPF_DATE
where RN = :new.PERF
and PERF_DATE <> :new.ACTPF_DATE;
end if;
end if;
/* ������ */
if ( :new.PERFS_STATE = 4 and not (nORD_STATE in (3,4)) ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �ᯮ������ ����樨 ᯥ�䨪�樨 "������"'||
' �� ���ﭨ� ������ �⫨筮� �� "������" ��� "���㫨஢��" �������⨬�.' );
end if;
/*!!!�஢��塞 ᮢ������� ������!!!*/
if ( :new.PERFS_STATE = 4 and not (:new.EXECM_QUANT = :new.CUSTM_QUANT and
:new.EXECA_QUANT = :new.CUSTA_QUANT and
:new.EXECSWTAX   = :new.CUSTSWTAX   and
:new.EXECSWOTAX  = :new.CUSTSWOTAX  and
:new.EXEC_DATE   = :new.CUST_DATE) ) then
/* �᫨, ��ࠬ���� ��ᮣ��ᮢ��� - ᮣ���㥬 ��� �� �⢥ত���� */
if (:old.PERFS_STATE = 1) then
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
:new.ACTPF_DATE  := :new.CUST_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.EXECM_QUANT := :new.CUSTM_QUANT;
:new.EXECA_QUANT := :new.CUSTA_QUANT;
:new.EXECSWTAX   := :new.CUSTSWTAX;
:new.EXECSWOTAX  := :new.CUSTSWOTAX;
:new.EXEC_DATE   := :new.CUST_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 402 );
elsif (:old.PERFS_STATE = 2) then
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
:new.ACTPF_DATE  := :new.EXEC_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.CUSTM_QUANT := :new.EXECM_QUANT;
:new.CUSTA_QUANT := :new.EXECA_QUANT;
:new.CUSTSWTAX   := :new.EXECSWTAX;
:new.CUSTSWOTAX  := :new.EXECSWOTAX;
:new.CUST_DATE   := :new.EXEC_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 403 );
end if;
/* ��ࠢ�� ���� � � ��������� �ᯮ������ �� ��ਮ�� */
if (nATSAMETIME = 1) then -- �᫨ �ᯮ������ �����६�����
update CONSUMERORDP
set PERF_DATE = :new.ACTPF_DATE
where RN = :new.PERF
and PERF_DATE <> :new.ACTPF_DATE;
end if;
end if;
/* ��।����� */
else -- ���ﭨ� �� ����������
if ((:new.P_PLANM_QUANT = :old.P_PLANM_QUANT) and
(:new.P_PLANA_QUANT = :old.P_PLANA_QUANT) and
(:new.P_FACTM_QUANT = :old.P_FACTM_QUANT) and
(:new.P_FACTA_QUANT = :old.P_FACTA_QUANT) and
(:new.P_PLAN_SUM    = :old.P_PLAN_SUM)    and
(:new.P_FACT_SUM    = :old.P_FACT_SUM))   then -- �᫨ �� �� �ᯮ������
if ( PKG_DOCLINKS_SMART.CHECK_IN( 'ConsumersOrdersPerform' ) = 0 ) AND USER<>'SNP_REPL' then -- �஢�ઠ ��室��� ���㬥�⮢
P_DOCINPT_FIND_EXACT( 0,:old.COMPANY,'ConsumersOrdersPerform',:old.PERF,nTMP );
end if;
/* �஢�ਬ �����⨬���� ��������� ������ � ��⠭������� ���ﭨ�, ⮫쪮 �᫨ ��� ᯥ�. 䫠��!!! */
if ( :old.PERFS_STATE = 3 or :old.PERFS_STATE = 4) and (PKG_FLAG.RESET_FLAG = 0) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'��������� ����� �ᯮ������ ����樨 ᯥ�䨪�樨 � ���ﭨ� "������" ��� "�����ᮢ���" �������⨬�.' );
end if;
else -- ��ࠢ�塞 �㬬� �ᯮ������ � ��������� ��ਮ��
update CONSUMERORDP
set SUPP_PLAN_SUM = SUPP_PLAN_SUM - :old.P_PLAN_SUM + :new.P_PLAN_SUM,
SUPP_FACT_SUM = SUPP_FACT_SUM - :old.P_FACT_SUM + :new.P_FACT_SUM
where RN = :new.PERF;
end if;
end if;
/* ��ࠢ�塞 �㬬�, ���-�� � ���� � ����ᬮ�� �� ���ﭨ� */
if ( :new.PERFS_STATE = 0) and (PKG_FLAG.RESET_FLAG = 0) then -- � ���. �� ᮣ��ᮢ��� (��६ ���. �����), ⮫쪮 �᫨ ��� ᯥ�. 䫠��!!!
/* ������⢠ */
:new.ACTM_QUANT  := nMAIN_QUANT;
:new.ACTA_QUANT  := nALT_QUANT;
:new.CUSTM_QUANT := nMAIN_QUANT;
:new.CUSTA_QUANT := nALT_QUANT;
:new.EXECM_QUANT := nMAIN_QUANT;
:new.EXECA_QUANT := nALT_QUANT;
/* �㬬� */
:new.ACTSWTAX    := nSUMWTAX;
:new.ACTSWOTAX   := nSUMWOTAX;
:new.CUSTSWTAX   := nSUMWTAX;
:new.CUSTSWOTAX  := nSUMWOTAX;
:new.EXECSWTAX   := nSUMWTAX;
:new.EXECSWOTAX  := nSUMWOTAX;
/* ���� */
if ( :new.PERFS_STATE <> :old.PERFS_STATE ) then -- ��室���.
:new.ACTPF_DATE  := :new.PERF_DATE;
:new.CUST_DATE   := :new.PERF_DATE;
:new.EXEC_DATE   := :new.PERF_DATE;
else -- ᮣ��ᮢ�����.
:new.PERF_DATE  := :new.ACTPF_DATE;
:new.CUST_DATE  := :new.ACTPF_DATE;
:new.EXEC_DATE  := :new.ACTPF_DATE;
end if;
elsif ( :new.PERFS_STATE = 1) then -- � ���. �।������� �����稪�
/* ������⢠ (����� �������� � �ᯮ���⥫�) */
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
/* �㬬� */
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
/* ���� */
:new.ACTPF_DATE  := :new.EXEC_DATE;
elsif ( :new.PERFS_STATE = 2) then -- � ���. �।������� �ᯮ���⥫�.
/* ������⢠ (����� �������� � �����稪�) */
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
/* �㬬� */
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
/* ���� */
:new.ACTPF_DATE  := :new.CUST_DATE;
end if;
/* ������ �㬬 � ��ਮ�� �ᯮ������ ������ */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX - :old.ACTSWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX - :old.ACTSWTAX + :new.ACTSWTAX
where RN = :new.PERF;
/* �஢�ਬ ��࠭�祭�� */
/* ᮢ������� ���-� � ���-�� � ������� */
if (nPRODUCT is not null) then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �᭮���� �� �⫨筮� �� 1 �������⨬�.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �������⥫쭮� �� �⫨筮� �� 㪠������� � ������� �������⨬�.' );
end if;
end if;
end if;
/* ॣ������ ᮡ��� */
P_CONSUMERORDPS_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.PERF );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BDELETE
before delete on CONSUMERORDS for each row
begin
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� (���� BLOCKED) */
IF USER<>'SNP_REPL' THEN
  P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :old.PRN);
END IF;  
/* ॣ������ ᮡ��� */
P_CONSUMERORDS_IUD( :old.RN,'D',:old.COMPANY,:old.PRN,:old.NOMEN,:old.NOM_PACK,:old.NOM_MODIF,:old.NOMMOD_PACK,:old.PRODUCT,:old.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BINSERT
before insert on CONSUMERORDS for each row
declare
nORD_PERIOD           CONSUMERORD.ORD_PERIOD%TYPE;   -- ��ਮ���᪨� ����� (0-ࠧ���, 1-��ਮ���᪨�)
nORD_STATE            CONSUMERORD.ORD_STATE%TYPE;    -- ���ﭨ� ������ (0-�� �⢥ত��, 1-�⢥ত��, 2-ᮣ��ᮢ����, 3-������, 4-���㫨஢��)
nSIGN_SERIAL          DICNOMNS.SIGN_SERIAL%TYPE;     -- �ਧ��� ������� ��� �� �਩�� ����ࠬ (0 - ���, 1 - ��)
nPRNMOD               PKG_STD.tREF;                  -- ����䨪��� ������������ �������.
nNOMEN_TYPE           DICNOMNS.NOMEN_TYPE%TYPE;      -- ⨯ ����ફ����� (1 - ⮢��, 2 - ��㣠, 3 - ��)
IsUseNomenSerial      boolean;                       -- ����ன�� "�ந������� � ��⮬ �਩��� ����஢"
nBLOCKED              CONSUMERORD.BLOCKED%TYPE;      -- �ਧ��� �६����� �����஢��
nCONSOLIDATED         CONSUMERORD.CONSOLIDATED%TYPE; -- �ਧ��� ���᮫���樨
begin
/* ���뢠��� ��ࠬ��஢ master-����� */
select COMPANY, CRN, ORD_PERIOD, ORD_STATE, BLOCKED, CONSOLIDATED
into :new.COMPANY, :new.CRN, nORD_PERIOD, nORD_STATE, nBLOCKED, nCONSOLIDATED
from CONSUMERORD
where RN = :new.PRN;
/* �஢�ઠ �����⨬��� ���������� */
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
/* �஢�ઠ ⥪�饣� ���ﭨ� master-����� */
if (nORD_STATE <> 0) and (nCONSOLIDATED < 2) and USER<>'SNP_REPL' then
P_EXCEPTION( 0,'���������� ����� ����樨 ᯥ�䨪�樨 ������ � ���ﭨ� �⫨筮� �� "�� �⢥ত��" �������⨬�.' );
end if;
/* �஢�ઠ ���४⭮�� ������塞�� ������ */
if (:new.PRODUCT is not null and nORD_PERIOD <> 0) then -- ������� ����㯭� ⮫쪮 ��� ࠧ����� ������
P_EXCEPTION( 0,'��� ��ਮ���᪮�� ������ ���� "�������" ������㯭�.' );
end if;
/* ᮢ������� ������������, ����䨪�樨 � �������� */
if ( :new.NOMEN is not null ) then
/* ��⠥� ��ࠬ���� ������������ */
select SIGN_SERIAL,NOMEN_TYPE
into nSIGN_SERIAL,nNOMEN_TYPE
from DICNOMNS where RN = :new.NOMEN;
/* �஢�ਬ �� ⨯ ��㣠 */
if (nNOMEN_TYPE <> 2) and ((:new.BEGIN_DATE is not null) or (:new.END_DATE is not null)) then
P_EXCEPTION( 0,'������� ��� ��ਮ�� �।��⠢����� ���, ��� ᯥ�䨪�樨 � ����������ன �� ��饩�� ��㣮� �������⨬�.' );
end if;
if (nNOMEN_TYPE = 2) and (:new.BEGIN_DATE is null) then
P_EXCEPTION( 0,'����室��� ������ ���� ��砫� ��ਮ�� �।��⠢����� ���.' );
end if;
IsUseNomenSerial := GET_OPTIONS_NUM('Realiz_Nomen_With_Ser_Num', :new.COMPANY) = 1;
if IsUseNomenSerial then
if (:new.PRODUCT is not null) then
if (nSIGN_SERIAL = 0) then
P_EXCEPTION( 0,'��� ������������ ��� �ਧ���� ������� ��� �� �਩�� ����ࠬ 㪠����� ������� �������⨬�.' );
end if;
select NOMMODIF into nPRNMOD from RLARTICLES where RN = :new.PRODUCT;
if (:new.NOM_MODIF <> nPRNMOD) then
P_EXCEPTION( 0,'����䨪��� ������������ ������� � ᯥ�䨪�樨 ������ �� ᮢ������.' );
end if;
else
if nSIGN_SERIAL = 1 then
P_EXCEPTION ( 0, '��� ������������, ����饩 �ਧ��� "��� �� �਩�� ����ࠬ", ��易⥫쭮 㪠����� �������.' );
end if;
end if;
end if;
end if;
/* ॣ������ ᮡ��� */
P_CONSUMERORDS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.NOMEN,:new.NOM_PACK,:new.NOM_MODIF,:new.NOMMOD_PACK,:new.PRODUCT,:new.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BUPDATE
before update on CONSUMERORDS for each row
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� CONSUMERORDS �������⨬�.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� PRN ⠡���� CONSUMERORDS �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� CONSUMERORDS �������⨬�.' );
end if;
/* ��⠭���� ��ࠬ��஢ detail-����ᥩ */
if not( :new.CRN = :old.CRN ) then     -- ᬥ�� ��⠫��� => ��⠫�� ���� �� ��������
update CONSUMERORDPS
set CRN = :new.CRN
where PRN = :new.RN;
else
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� (���� BLOCKED) */
IF USER<>'SNP_REPL' THEN
  P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :new.PRN);
END IF;  
end if;
/* ॣ������ ᮡ��� */
P_CONSUMERORDS_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.NOMEN,:new.NOM_PACK,:new.NOM_MODIF,:new.NOMMOD_PACK,:new.PRODUCT,:new.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BINSERT
before insert on CONSUMERORDPS for each row
declare
nORD_STATE     CONSUMERORD.ORD_STATE%TYPE;    -- ���ﭨ� ������ (0-�����⢥ত��, 1-���⢥ত��, 2-ᮣ��ᮢ����, 3-������, 4-���㫨஢��)
nORD_PERIOD    CONSUMERORD.ORD_PERIOD%TYPE;   -- ��ਮ���᪨� ����� (0-ࠧ���, 1-��ਮ���᪨�)
nPERIOD_CORR   CONSUMERORD.PERIOD_CORR%TYPE;  -- ���४�� �� ��ਮ��� (0-���, 1-��)
nPERIOD_QUANT  CONSUMERORD.PERIOD_QUANT%TYPE; -- �᫮ ��ਮ���
nPRODUCT       PKG_STD.tREF;                  -- �������
nPRAQUANT      RLARTICLES.QUANT%TYPE;         -- ���-�� ������� � ���
nBLOCKED       CONSUMERORD.BLOCKED%TYPE;      -- �ਧ��� �६����� �����஢�� ������
nCONSOLIDATED  CONSUMERORD.CONSOLIDATED%TYPE; -- �ਧ��� ���᮫���樨
begin
/* ���뢠��� ��ࠬ��஢ master-����� */
select COMPANY, CRN
into :new.COMPANY, :new.CRN
from CONSUMERORDS
where RN = :new.PRN;
/* ��⠥� ���ﭨ� ������ */
select /*+ ORDERED*/
M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR, M.PERIOD_QUANT, S.PRODUCT,
M.BLOCKED, M.CONSOLIDATED
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR, nPERIOD_QUANT, nPRODUCT,
nBLOCKED, nCONSOLIDATED
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* �஢��塞 ����稥 �६����� �����஢�� ���㬥�� */
if nBLOCKED = 1 then
P_EXCEPTION(0, '������ ����饭�. ���㬥�� �६���� �����஢��.');
end if;
if (nCONSOLIDATED < 2) then -- ��� �����᮫���஢����� �������
/* �஢�ਬ �����⨬���� ��⠭����������� ���ﭨ� */
/* ��࠭�祭��: ������ ���������� ⮫쪮 � ���ﭨ�� '�� ᮣ��ᮢ���' */
if ( :new.PERFS_STATE <> 0 ) and USER<>'SNP_REPL' then -- ���ﭨ� �. ���� ⮫쪮 '�� ᮣ��ᮢ���'
P_EXCEPTION( 0,'��⠭���� ���ﭨ� �⫨筮�� �� "�� ᮣ��ᮢ���" �� ���������� ����� �ᯮ������ ����樨 ᯥ�䨪�樨 ������ �������⨬�.' );
else -- �᫨ ���ﭨ� ��ଠ�쭮�, � �஢�ਬ ���������
if (nORD_STATE <> 0) and USER<>'SNP_REPL' then -- ��������� �. ���� � ���ﭨ� '�����⢥ত��'
P_EXCEPTION( 0,'���������� ����� �ᯮ������ ����樨 ᯥ�䨪�樨 ������ �� ���ﭨ� ��������� �⫨筮� �� "�� �⢥ত��" �������⨬�.' );
end if;
end if;
end if;
/* �᫨ �।����� �஢��� ��諨, � ��⠫��� �஢���� ⮫쪮 �� ��࠭�祭�� ��ࠬ��஢ ����� */
/* ᮢ������� ���-� � ���-���� � ������� */
if (nPRODUCT is not null) then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �᭮���� �� �⫨筮� �� 1 �������⨬�.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) then
P_EXCEPTION( 0,'�� �������� �������, ������⢮ � �������⥫쭮� �� �⫨筮� �� 㪠������� � ������� �������⨬�.' );
end if;
end if;
/* ������ �㬬 � �ᯮ������ ������ */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX + :new.ACTSWTAX
where RN = :new.PERF;  /* ॣ������ ᮡ��� */
P_CONSUMERORDPS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF );
end;
/
