--
-- V_AKT_VOZV_TO_EXP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AKT_VOZV_TO_EXP
(STAN_NAME, NUM_NAKL, NUM_CIST, DATE_VOZ, TIME_VOZ, 
 DATE_NALIV, TIME_NALIV, SVED_NUM, NOM_ZD, DATE_OTGR)
AS 
select 
  s1.stan_name, 
--  m1.is_exp,
  v.num_nakl, 
  v.num_cist, 
  v.date_voz, 
  v.time_voz,
  TRUNC(NVL(sv2.BEG_NALIV_TIME,k2.DATE_OFORML)) as date_naliv,
  TO_CHAR(NVL(sv2.BEG_NALIV_TIME,k2.DATE_OFORML),'hh24:mi') as time_naliv,
  sv2.sved_num,
  k2.nom_zd,
  k2.date_otgr
--  m2.is_exp
from (select v.id,v.kvit_id,v.num_nakl,v.num_cist,v.date_voz,v.time_voz,MIN(k2.date_kvit) as date_kvit_next 
        from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='AKT_VOZV_TO_EXP.XLS') r, 
        vozvrat v,kvit k2 
       where k2.num_cist=v.num_cist 
         and k2.date_kvit>=v.date_voz 
   -- Условия 
         and v.date_voz between r.begin_date and r.end_date -- Отчетный период 
   and k2.date_kvit>=r.begin_date -- Отгружено после начала отчетного периода 
       GROUP BY v.id,v.kvit_id,v.num_nakl,v.num_cist,v.date_voz,v.time_voz 
     ) v, 
     kvit k1, month m1, kls_stan s1, kvit k2, month m2, sved sv2
where v.kvit_id=k1.id
  and k1.nom_zd=m1.nom_zd 
  and m1.stan_id=s1.id 
  and v.num_cist=k2.num_cist 
  and v.date_kvit_next=k2.date_kvit 
  and k2.nom_zd=m2.nom_zd
  and k2.sved_id=sv2.id(+) 
  -- Условия 
  and m1.is_exp=0 -- До возврата был отгружен на внутренний рынок 
  and m2.is_exp=1 -- После возврата был отгружен на экспорт 
  and k1.vagowner_id<>3 -- Собственные или арендованные вагоны 
order by v.date_voz,v.num_nakl,v.num_cist;


