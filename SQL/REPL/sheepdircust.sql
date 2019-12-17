CREATE OR REPLACE TRIGGER T_SHEEPDIRSCUST_BDELETE before delete on SHEEPDIRSCUST
for each row
declare
nCNT              PKG_STD.TLNUMBER;
nRN               PKG_STD.TLNUMBER;
nWARNING          PKG_STD.TLNUMBER;
sMSG              varchar2 (300);
begin
if :old.STATUS = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION ( 0, '�������� �ᯮ�殮��� �� ���㧪� � ���ﭨ� "��ࠡ�⠭" �������⨬�.' );
end if;
if :old.STATUS = 2 AND USER<>'SNP_REPL' then
P_EXCEPTION ( 0, '�������� �ᯮ�殮��� �� ���㧪� � ���ﭨ� "������" �������⨬�.' );
end if;
/* ������ 㤠����� ���㬥�� �� ��室��� ⠡����. */
P_LINKSALL_DELETE_FULL_OUT (:old.COMPANY, 'SheepDirectToConsumers', :old.RN);
/* ॣ������ ᮡ��� */
P_SHEEPDIRSCUST_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.DOCTYPE,:old.PREF,:old.NUMB);
end;
/
