CREATE OR REPLACE TRIGGER T_TRANSINVDEPT_BDELETE before delete on TRANSINVDEPT
for each row
declare
nRN       PKG_STD.TLNUMBER;
nWARNING  PKG_STD.TLNUMBER;
sMSG      varchar2 (300);
begin
if :old.STATUS != 0 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '�������� ���㬥�� � ���ﭨ� "��ࠡ�⠭" �������⨬�.');
end if;
/* 㤠����� �痢� */
P_LINKSALL_DELETE_FULL_OUT ( :old.COMPANY, 'GoodsTransInvoicesToDepts', :old.RN );
/* ॣ������ ᮡ��� */
P_TRANSINVDEPT_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.DOCTYPE,:old.PREF,:old.NUMB);
end;
/