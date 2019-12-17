select
 tic.dPeriod,
 tic.sPeriod as sPeriod,
 al.agnname                    sAgent,
 dn.nomen_name                 sNomen,
 pt.gsmpayments_mnemo          sPayType,
 tic.nQuant/1000 as nQuant,
 round(parus.f_get_regprice_osv
 (
  2,
  gs.rn,
  gp.nommodif,
  null,
  2,
  (add_months(to_date('01'||tic.sPeriod,'ddmmyyyy'),1)-1) -- цена на последний день месяца
 )*1000,2) as nRegPrice,-- учетная цена округленная до 2 знаков
 tic.nPrice*1000 as nPrice,
 tic.nSumm
from
 (
  select
   tic.agent,
   nm.prn nomen,
   tics.goodsparty,
   tic.paytype,
   trunc(tic.docdate,'month') as dPeriod,
   to_char(tic.docdate,'month yyyy') sPeriod,
   sum(tics.quantalt)            nQuant,
   round(tics.price,2)           nPrice,
   sum(round(tics.summwithnds,2)) nSumm
  from
   transinvcust tic,
   transinvcustspecs tics,
   nommodif nm
  where
   tic.docdate>=to_date('01012003','ddmmyyyy')
   and tic.store    = 57483834 --'Автоналив'
   and tics.prn     = tic.rn
   and tics.nommodif = nm.rn
  group by
   trunc(tic.docdate,'month'),
   to_char(tic.docdate,'month yyyy'),
   tic.agent,
   nm.prn,
   tics.goodsparty,
   tic.paytype,
   round(tics.price,2)
 ) tic,
 agnlist al,
 azsgsmpaymentstypes pt,
 parus.goodssupply gs,
 goodsparties gp,
 dicnomns dn
where
 tic.agent    = al.rn
 and tic.paytype  = pt.rn
 and tic.nomen    = dn.rn
 and tic.goodsparty = gp.rn(+)
 and gs.prn         = gp.rn
 and gs.store       = 57483834 --'Автоналив'
order by
 tic.dPeriod,
 tic.sPeriod,
 al.agnname,
 dn.nomen_name,
 gp.rn,
 pt.gsmpayments_mnemo
 
 
begin 
   Dbms_Session.SET_NLS('NLS_DATE_FORMAT','''dd.mm.yyyy hh24:mi''');
  Dbms_Session.SET_NLS('NLS_LANGUAGE','''RUSSIAN''');
end;  
