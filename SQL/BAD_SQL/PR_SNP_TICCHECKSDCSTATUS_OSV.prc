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
 
 /* ищем параметры для SDC из TIC */
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
   /* отваливаем если нет связи 
      РНнаОтпускПотр. с Расп.Отгр.Потр.*/
   return;
 end; 
  /* Каталог местонахождения SDC */
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
  /* ищем проверяется ли данный каталог
     SDC в системе                      */
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
    and ed.code     = 'НЕ ПРОВЕРЯТЬ'
    and trim(edv.note)=trim(to_char(nCRN_));
   exception
    when NO_DATA_FOUND 
    then 
     nCOUNT_ := 0;
  end;
  /* если не найден 
     то указаывем на закрытие SDC */
  if nCount_=0
  then
   /* проверяем права User на закрытие SDC */
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
     and ruf.catalog=nCrn_ -- каталог
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
               'Нельзя снять отработку с "Расходные накладные на отпуск потребителям" '
               ||' т.к. "Распоряжение на отгрузку потребителям" находится в статусе "Закрыт"'
              )
    ;
   end if; 
  end if;
 end if; 
end ;
/

