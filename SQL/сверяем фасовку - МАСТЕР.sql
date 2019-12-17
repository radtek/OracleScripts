select /*+ rule */
-- os.filial_name,
 -- os.NAME,os.id,
  --a.date_oper,
  sum(decode(a.prod_id_npr,'80019',a.summa,0)/1000) as sum_s,
  sum(decode(a.prod_id_npr,'80019',0,'10000',0,a.summa)/1000) as sum_f,
  sum(decode(a.prod_id_npr,'10000',a.summa,0)/1000) as sum_u
  --a.prod_id_npr,
  --a.summa/1000 as summa,
  --a.*
from azc_operation a, v_org_structure os
where a.ORG_STRU_ID=os.id
  and a.TYPE_OPER_ID=1
  and a.DATE_OPER between :beg_date and :end_date
 -- and os.filial_id=75
  and a.prod_id_npr in ('10000',/*'80036','80026','80020',*/'80019'/*,'80018'*/)
  --and os.id=9027
--group by os.filial_name--, os.name,os.id-- ,a.date_oper 
--order by os.filial_name, os.name,os.id-- ,a.date_oper
--order by a.date_oper  
  
  azc_type_oper