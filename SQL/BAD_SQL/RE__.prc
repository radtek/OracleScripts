CREATE OR REPLACE procedure Re__(
  sCOMPANY   in varchar2,
  sTAX_GROUP in varchar2
)
as
  nCOMPANY      number( 17 );

  nTAX_GRP      number(17);
  nCHARGE_SUM   number( 17, 2);
  nCOUNT        number;

 /* Начисление налогов на сумму по налоговой группе */
  procedure P_ADD_TAX
  (
    nCOMPANY    in number,
    nIN_SUM     in number,
    nTAX_GROUP  in varchar2,
    dDATE   date,
    nOUT_SUM    out number
  )
  is
    nNDS_VALUE      number(17,2) :=0;
    nGSM_VALUE      number(17,2) :=0;
    nROUND_NDS      number(15) :=0;
    nROUND_GSM      number(15) :=0;
    /* Ставка налога */
    cursor Tax_cur( Tax_kind number) is
      select P_VALUE, P_ROUND from DICTAXIS
      where TAX_GROUP = nTAX_GROUP and KIND = Tax_kind and BEG_DATE <= DDATE
      order by BEG_DATE desc;

  begin
    /* Ставка налога НДС */
    for C in Tax_cur( 1 ) loop
      nNDS_VALUE := C.P_VALUE;
      nROUND_NDS := C.P_ROUND;
      exit;
    end loop;
    /* Ставка налога ГСМ */
    for C in Tax_cur( 2 ) loop
      nGSM_VALUE := C.P_VALUE;
      nROUND_GSM := C.P_ROUND;
      exit;
    end loop;
    nNDS_VALUE := nNDS_VALUE / 100;
    nGSM_VALUE := nGSM_VALUE / 100;
    nOUT_SUM := NIN_SUM * (nNDS_VALUE + nGSM_VALUE);  -- только налог
  end;
begin
  FIND_COMPANY_BY_NAME(sCOMPANY, nCOMPANY);
  select count(*)
    into nCOUNT
    from SERVCHARGES
    where COMPANY = nCOMPANY
      and TAX_GROUP is null;

  if nCOUNT = 0 then  -- Ничего не делаем, если нет записей
    return;
  end if;

  FIND_DICTAXGR_CODE(1,nCOMPANY,sTAX_GROUP,nTAX_GRP);
  if nTAX_GRP is null then
    P_DICTAXGR_BASE_INSERT(nCOMPANY,sTAX_GROUP,sTAX_GROUP,nTAX_GRP);
  end if;

  for c in (select * from SERVCHARGES where COMPANY = nCOMPANY)
  loop

     P_ADD_TAX(nCOMPANY,c.SUMM * (c.PERCENT /100), nTAX_GRP, c.OPER_DATE, nCHARGE_SUM);

     P_FACEACC_CORRECT_SERV (c.COMPANY, c.FACEACC, - nCHARGE_SUM );

     update SERVCHARGES
       set TAX_GROUP = nTAX_GRP,
           SUMWITHNDS = c.SUMM * (c.PERCENT /100) + nCHARGE_SUM
     where RN = c.RN;
  end loop;
end;
/

