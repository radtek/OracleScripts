drop index PARUS.I_BILLASSACT_COMPANY_FK; 

CREATE INDEX PARUS.I_BILLASSACT_COMPANY_FK ON PARUS.BILLASSACT
(COMPANY,REG_DATE)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP INDEX PARUS.I_BILLCARD_COMPANY_FK;

CREATE INDEX PARUS.I_BILLCARD_COMPANY_FK ON PARUS.BILLCARD
(COMPANY,REG_DATE)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;




drop  INDEX PARUS.I_BILLRECPACT_COMPANY_FK;

CREATE INDEX PARUS.I_BILLRECPACT_COMPANY_FK ON PARUS.BILLRECPACT
(COMPANY,REG_DATE)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;




CREATE OR REPLACE TRIGGER "PARUS".T_BILLASSACT_BDELETE
before delete on BILLASSACT for each row
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �裡 � ���㬥�⠬� */
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BillAssignmentActs' );
END IF;  
/* ॣ������ ᮡ��� */
P_BILLASSACT_IUD( :old.RN,'D',:old.COMPANY,:old.ACT_TYPE,:old.ACT_PREF,:old.ACT_NUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_BILLASSACT_BUPDATE
before update on BILLASSACT for each row
declare
nH_SL  number( 1 );
nTMP   number;
sTMP   varchar2( 20 );
dTMP   date;
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� BILLASSACT �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� BILLASSACT �������⨬�.' );
end if;
if  ((:new.ACT_TYPE <> :old.ACT_TYPE)
or (:new.ACT_PREF <> :old.ACT_PREF)
or (:new.ACT_NUMB <> :old.ACT_NUMB)
or (:new.REG_DATE <> :old.REG_DATE)
or (:new.AGENT_FROM <> :old.AGENT_FROM)
or (:new.FACEACC <> :old.FACEACC)
or (:new.AGENT_ACT_NUMB <> :old.AGENT_ACT_NUMB)
or (:new.ACT_DATE <> :old.ACT_DATE)
or (:new.VDOC_TYPE <> :old.VDOC_TYPE)
or (:new.VDOC_NUMB <> :old.VDOC_NUMB)
or (:new.VDOC_DATE <> :old.VDOC_DATE)
or (:new.CURRENCY <> :old.CURRENCY)
or (:new.NOM_SUM <> :old.NOM_SUM)
or (:new.PRICE_SUM <> :old.PRICE_SUM)
or (:new.DISC_SUM <> :old.DISC_SUM)
or (:new.NOM_SUM_BASE <> :old.NOM_SUM_BASE)
or (:new.PRICE_SUM_BASE <> :old.PRICE_SUM_BASE)
or (:new.DISC_SUM_BASE <> :old.DISC_SUM_BASE)
or (:new.DEST_SUM <> :old.DEST_SUM)
or (:new.DEST_SUM_BASE <> :old.DEST_SUM_BASE)
or (:new.ACC_STATE <> :old.ACC_STATE)) AND USER<>'SNP_REPL' then
/* �஢�ઠ �裡 � ���㬥�⠬� */
P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BillAssignmentActs' );
end if;
/* ����  slave ����ᥩ */
if (not( :new.AGENT_FROM = :old.AGENT_FROM ) or
not( :new.CURRENCY   = :old.CURRENCY ))  then
P_BILLASSACT_GET_SLAVE( 1, 0, :new.COMPANY, :new.RN, null, null, null, nH_SL,
nTMP,dTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,
nTMP,sTMP,nTMP,sTMP,nTMP,sTMP,sTMP,dTMP,nTMP,sTMP,
nTMP,sTMP,nTMP,nTMP );
if (nH_SL <> 0) AND USER<>'SNP_REPL' then -- �ਭ���稥 slave, �� ���� ������ �����.
P_EXCEPTION( 0,'��������� ����ࠣ��� �/��� ������ ��� ��।��, �� ����稨 ᯥ�䨪�権, �������⨬�.' );
end if;
end if;
/* ���४�� ����� */
:new.ACT_PREF := strright( strtrim( :new.ACT_PREF ), 10 );
:new.ACT_NUMB := strright( strtrim( :new.ACT_NUMB ), 10 );
/* ��⠭���� ��ࠬ��஢ detail-����ᥩ */
if not( :new.CRN = :old.CRN ) then
update BILLASSACTDOC
set CRN = :new.CRN
where PRN = :new.RN;
update BILLASSACTASS
set CRN = :new.CRN
where PRN = :new.RN;
end if;
/* ॣ������ ᮡ��� */
P_BILLASSACT_IUD( :new.RN,'U',:new.COMPANY,:new.ACT_TYPE,:new.ACT_PREF,:new.ACT_NUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_BILLRECPACT_BDELETE
before delete on BILLRECPACT for each row
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �裡 � ���㬥�⠬� */
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BillReceptionActs' );
END IF;  
/* ॣ������ ᮡ��� */
P_BILLRECPACT_IUD(:old.RN,'D',:old.COMPANY,:old.ACT_TYPE,:old.ACT_PREF,:old.ACT_NUMB );
end;
/




CREATE OR REPLACE TRIGGER "PARUS".T_BILLRECPACT_BUPDATE
before update on BILLRECPACT for each row
declare
nH_SL  number( 1 );
nTMP   number;
sTMP   varchar2( 20 );
dTMP   date;
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� BILLRECPACT �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� BILLRECPACT �������⨬�.' );
end if;
if   ((:new.ACT_TYPE <> :old.ACT_TYPE)
or (:new.ACT_PREF <> :old.ACT_PREF)
or (:new.ACT_NUMB <> :old.ACT_NUMB)
or (:new.REG_DATE <> :old.REG_DATE)
or (:new.AGENT_FROM <> :old.AGENT_FROM)
or (:new.FACEACC <> :old.FACEACC)
or (:new.AGENT_ACT_NUMB <> :old.AGENT_ACT_NUMB)
or (:new.ACT_DATE <> :old.ACT_DATE)
or (:new.VDOC_TYPE <> :old.VDOC_TYPE)
or (:new.VDOC_NUMB <> :old.VDOC_NUMB)
or (:new.VDOC_DATE <> :old.VDOC_DATE)
or (:new.CURRENCY <> :old.CURRENCY)
or (:new.NOM_SUM <> :old.NOM_SUM)
or (:new.PRICE_SUM <> :old.PRICE_SUM)
or (:new.DISC_SUM <> :old.DISC_SUM)
or (:new.NOM_SUM_BASE <> :old.NOM_SUM_BASE)
or (:new.PRICE_SUM_BASE <> :old.PRICE_SUM_BASE)
or (:new.DISC_SUM_BASE <> :old.DISC_SUM_BASE)
or (:new.DEST_SUM <> :old.DEST_SUM)
or (:new.DEST_SUM_BASE <> :old.DEST_SUM_BASE)
or (:new.ACC_STATE <> :old.ACC_STATE)) AND USER<>'SNP_REPL' then
/* �஢�ઠ �裡 � ���㬥�⠬� */
P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BillReceptionActs' );
end if;
/* ����  slave ����ᥩ */
if (not( :new.AGENT_FROM = :old.AGENT_FROM ) or
not( :new.CURRENCY   = :old.CURRENCY ))  then
P_BILLRECPACT_GET_SLAVE( 1, 0, :new.COMPANY, :new.RN, null, null, null, nH_SL,
nTMP,dTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,nTMP,
nTMP,sTMP,nTMP,sTMP,nTMP,sTMP,sTMP,dTMP,nTMP,sTMP,
nTMP,sTMP,nTMP,nTMP );
if (nH_SL <> 0) AND USER<>'SNP_REPL' then -- �ਭ���稥 slave, �� ���� ������ �����.
P_EXCEPTION( 0,'��������� ����ࠣ��� �/��� ������ ��� �ਥ�� �� ����稨 ᯥ�䨪�権 �������⨬�.' );
end if;
end if;
/* ���४�� ����� */
:new.ACT_PREF := strright( strtrim( :new.ACT_PREF ), 10 );
:new.ACT_NUMB := strright( strtrim( :new.ACT_NUMB ), 10 );
/* ��⠭���� ��ࠬ��஢ detail-����ᥩ */
if not( :new.CRN = :old.CRN ) then
update BILLRECPACTDOC
set CRN = :new.CRN
where PRN = :new.RN;
update BILLRECPACTASS
set CRN = :new.CRN
where PRN = :new.RN;
end if;
/* ॣ������ ᮡ��� */
P_BILLRECPACT_IUD( :new.RN,'U',:new.COMPANY,:new.ACT_TYPE,:new.ACT_PREF,:new.ACT_NUMB );
end;
/




CREATE OR REPLACE TRIGGER "PARUS".T_BILLMOVEMENT_BUPDATE
before update on BILLMOVEMENT for each row
declare
nPACKAGE_SIGN  BILLCARD.PACKAGE_SIGN%TYPE;
nDIFF_SIGN     number(1) := 0;    -- ���� ��������� ������⢠
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if :new.RN <> :old.RN then
P_EXCEPTION(0, '��������� ���祭�� ���� RN ⠡���� BILLMOVEMENT �������⨬�.');
end if;
if :new.PRN <> :old.PRN then
P_EXCEPTION(0, '��������� ���祭�� ���� PRN ⠡���� BILLMOVEMENT �������⨬�.');
end if;
if :new.COMPANY <> :old.COMPANY then
P_EXCEPTION(0, '��������� ���祭�� ���� COMPANY ⠡���� BILLMOVEMENT �������⨬�.');
end if;
if :new.OPER_TYPE <> :old.OPER_TYPE then
P_EXCEPTION(0, '��������� ���祭�� ���� OPER_TYPE ⠡���� BILLMOVEMENT �������⨬�.');
end if;
if :new.CRN = :old.CRN then -- �᫨ ⥪�騩 update - �� ��६�饭�� �� ��⠫��� � ��⠫��
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �裡 � ���㬥�⠬� */
  P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BillCardsMovement' );
  P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BillReceptionActsMovement' );
  P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BillAssignmentActsMovement' );
END IF;  
/* ���뢠��� ��ࠬ��஢ master-����� */
select  PACKAGE_SIGN
into nPACKAGE_SIGN
from BILLCARD
where RN = :new.PRN;
if (nPACKAGE_SIGN = 1) and (:old.AMOUNT != :new.AMOUNT) then -- ����� (��������� ������⢠ � master-����� )
/* ��।������ ����� ������⢠ */
if :new.OPER_TYPE in (2,9,10,13) then       -- 㢥��祭�� ������⢠
nDIFF_SIGN := 1;
elsif :new.OPER_TYPE in (3,5,8,11) then     -- 㬥��襭�� ������⢠
nDIFF_SIGN := -1;
end if;
/* ���������� ������⢠ � ����� 業��� �㬠� */
update BILLCARD
set AMOUNT = AMOUNT + nDIFF_SIGN * (:new.AMOUNT - :old.AMOUNT)
where RN = :new.PRN;
end if;
end if;
/* ॣ������ ᮡ��� */
P_BILLMOVEMENT_IUD(:new.RN, 'U', :new.COMPANY, :new.PRN, :new.OPER_TYPE, :new.AGENT);
end;
/





CREATE OR REPLACE TRIGGER "PARUS".T_BILLMOVEMENT_BDELETE
before delete on BILLMOVEMENT for each row
declare
nPACKAGE_SIGN  BILLCARD.PACKAGE_SIGN%TYPE;
nDIFF_SIGN     number(1) := 0;  -- ���� ��������� ������⢠
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �裡 � ���㬥�⠬� */
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BillCardsMovement' );
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BillReceptionActsMovement' );
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BillAssignmentActsMovement' );
END IF;  
/* ���뢠��� ��ࠬ��஢ master-����� */
select  PACKAGE_SIGN
into nPACKAGE_SIGN
from BILLCARD
where RN = :old.PRN;
if nPACKAGE_SIGN = 1 then   -- ����� (��������� ������⢠ � master-����� )
/* ��।������ ����� ������⢠ */
if :old.OPER_TYPE in (2,9,10,13) then    -- 㢥��祭�� ������⢠
nDIFF_SIGN := 1;
elsif :old.OPER_TYPE in (3,5,8,11) then  -- 㬥��襭�� ������⢠
nDIFF_SIGN := -1;
end if;
/* ���������� ������⢠ � ����� 業��� �㬠� */
update BILLCARD
set AMOUNT = AMOUNT - nDIFF_SIGN * :old.AMOUNT
where RN = :old.PRN;
end if;
/* ॣ������ ᮡ��� */
P_BILLMOVEMENT_IUD(:old.RN, 'D', :old.COMPANY, :old.PRN, :old.OPER_TYPE, :old.AGENT);
end;
/
