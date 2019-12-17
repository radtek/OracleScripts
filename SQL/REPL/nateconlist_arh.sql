CREATE OR REPLACE TRIGGER "PARUS".T_NATECONLIST_BINSERT
before insert on NATECONLIST for each row
declare
nRECOUNT          PKG_STD.TREF;
begin
IF USER<>'SNP_REPL' THEN
  /* ���뢠��� ��ࠬ��஢ master-����� */
  select VERSION, CRN
  into :new.VERSION,:new.CRN
  from AGNLIST
  where RN = :new.PRN;
  if :new.PRIMARY_SIGN <> 1 then -- �᫨ � ⥪�饩 ����� �ਧ��� "�᭮����" ��⠭�����
  /* �஢�ਬ ����稥 ����ᥩ � �ਧ����� "�᭮����"*/
  begin
    select 1
    into nRECOUNT
    from  NATECONLIST T
    where (T.PRN = :new.PRN)
    and (T.PRIMARY_SIGN = 1);
  exception
  when NO_DATA_FOUND then
    nRECOUNT := 0;
  when TOO_MANY_ROWS then
    nRECOUNT := 2;
  end;
  if nRECOUNT = 0 then
    :new.PRIMARY_SIGN := 1;
  end if;
  end if;
  /* ॣ������ ᮡ��� */
  P_NATECONLIST_IUD( :new.RN, 'I', :new.VERSION, :new.PRN, :new.OKONH );
end if;  
end;
/



alter table parus.agnlist drop constraint c_agnlist_natecon_fk;
/