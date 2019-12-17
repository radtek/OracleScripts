CREATE OR REPLACE procedure pr_snp_TICcheckSDCstatus_osv
(
 nCompany_ number,
 nRn       number
)
is
 nRn_        transinvcust.rn%type;
 dWork_date_ transinvcust.work_date%type;
 nCount_     number(1) :=0;
 nCrn_       sheepdirscust.crn%type;
 nStatus_    sheepdirscust.status%type;
begin
 
 /* ���� ��������� ��� SDC �� TIC */
 begin
  select  /*+ RULE */
   i.document
  into
   nRn_ 
  from
   DOCINPT  I,
   DOCLINKS L,
   DOCOUTPT O
  where
   O.document=nRn
   and I.UNITCODE = 'SheepDirectToConsumers'
   and L.IN_DOC   = I.RN
   and L.OUT_DOC  = O.RN
   and O.UNITCODE = 'GoodsTransInvoicesToConsumers';
  exception
  when no_data_found then 
   /* ���������� ���� ��� ����� 
      ��������������. � ����.����.����.*/
   return;
 end; 
  /* ������� ��������������� SDC */
 begin
  select  /*+ RULE */
   sdc.crn,
   sdc.status
  into
   nCrn_,
   nStatus_
  from
   sheepdirscust SDC
  where
   sdc.rn=nRn_;
  exception
  when no_data_found then 
   return;
 end;
 if nStatus_=2
 then
  /* ���� ����������� �� ������ �������
     SDC � �������                      */
  begin
   select  /*+ RULE */ 
   count(*)
   into
    nCOUNT_
   from 
    extra_dicts ed,
    extra_dicts_values edv
   where 
    edv.prn     = ed.rn
    and ed.code     = '�� ���������'
    and trim(edv.note)=trim(to_char(nCRN_));
   exception
    when NO_DATA_FOUND 
    then 
     nCOUNT_ := 0;
  end;
  /* ���� �� ������ 
     �� ��������� �� �������� SDC */
  if nCount_=0
  then
   /* ��������� ����� User �� �������� SDC */
   begin
    select  /*+ RULE */ 
    count(*)
    into
     nCOUNT_
    from
     v_roleunitfunc RUF,
     v_userroles UR
    where
     ur.sauthid=user
     and ruf.roleid=ur.nroleid
     and ruf.catalog=nCrn_ -- �������
     and ruf.unitcode='SheepDirectToConsumers'
     and ruf.func='SHEEPDIRSCUST_CLOSE';
    exception
    when NO_DATA_FOUND 
    then 
     nCOUNT_ := 0;
   end ;
   if nCount_=0    
   then
    p_exception(0,--chr(13)||
               '������ ����� ��������� � "��������� ��������� �� ������ ������������" '
               ||' �.�. "������������ �� �������� ������������" ��������� � ������� "������"'
              )
    ;
   end if; 
  end if;
 end if; 
end ;
/

