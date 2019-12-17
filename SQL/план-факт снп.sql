---------- План (Нефтебаза) ---------------
select Sum(T1.VES) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     PLAN_REALIZ T1 
          join ORG_STRUCTURE T2 on (T1.SKLAD_ID = T2.ID) 
          join KLS_ORG_KIND T3 on (T2.ORG_KIND_ID = T3.ID) 
where (T1.DATE_PLAN between r.Begin_Date and r.End_Date)
  and (T1.TIP_REAL_ID = 1)  -- реализация
  and T3.GROUP_KIND_ID = 1  -- нефтебазы

---------- План (АЗС) ---------------
select Sum(T1.VES) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     PLAN_REALIZ T1 
          join ORG_STRUCTURE T2 on (T1.SKLAD_ID = T2.ID) 
          join KLS_ORG_KIND T3 on (T2.ORG_KIND_ID = T3.ID)
where (T1.DATE_PLAN between r.Begin_Date and r.End_Date)
  and (T1.TIP_REAL_ID = 1) -- реализация  
  and T3.GROUP_KIND_ID = 2  -- азс 

---------- План (Транзит) ---------------
select Sum(T1.VES) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     PLAN_REALIZ T1 
          join ORG_STRUCTURE T2 on (T1.SKLAD_ID = T2.ID) 
where (T1.DATE_PLAN between r.Begin_Date and r.End_Date)
  and (T1.TIP_REAL_ID = 2) -- транзит  
  

 
-------- Факт (нефтебазы) ---------
-- BeginDate, EndDate - интервал времени 
select Sum(T1.VES/1000) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     AZC_OPERATION T1 
       join ORG_STRUCTURE T2 on (T1.ORG_STRU_ID = T2.ID) 
       join KLS_ORG_KIND T3 on (T2.ORG_KIND_ID = T3.ID) 
where (T1.DATE_OPER between r.Begin_Date and r.End_Date) 
  and (T1.TYPE_OPER_ID = 1)  
  and (T3.GROUP_KIND_ID = 1)  -- нефтебазы

-------- Факт (нефтебаза) ---------
select Sum(T1.VES/1000) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     AZC_OPERATION T1 
       join ORG_STRUCTURE T2 on (T1.ORG_STRU_ID = T2.ID) 
       join KLS_ORG_KIND T3 on (T2.ORG_KIND_ID = T3.ID) 
where (T1.DATE_OPER between r.Begin_Date and r.End_Date) 
  and (T1.prod_id_npr< '80000' or t1.prod_id_npr in ('80012','80021')) --  без фасовки, но включая газопродукцию 
  and (T1.TYPE_OPER_ID = 1)  
  and (T3.GROUP_KIND_ID = 1)  -- нефтебаза

-------- Факт (АЗС) ---------
select Sum(T1.VES/1000) 
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
     AZC_OPERATION T1 
       join ORG_STRUCTURE T2 on (T1.ORG_STRU_ID = T2.ID) 
       join KLS_ORG_KIND T3 on (T2.ORG_KIND_ID = T3.ID) 
where (T1.DATE_OPER between r.Begin_Date and r.End_Date) 
  and (T1.prod_id_npr< '80000' or t1.prod_id_npr in ('80012','80021')) --  без фасовки, но включая газопродукцию 
  and (T1.TYPE_OPER_ID = 1)  
  and (T3.GROUP_KIND_ID = 2)  -- АЗС

-------- Факт (транзит) ---------
SELECT
   SUM(KVIT.VES_BRUTTO)
  FROM (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='PF_SVOD.XLS') r,
       KVIT,MONTH,V_KLS_PLANSTRU_SNP D,ZAKAZ unp,ZAKAZ snp, KLS_DOG, KLS_DOG ORIG_DOG
 WHERE KVIT.NOM_ZD=MONTH.NOM_ZD AND MONTH.ZAKAZ_ID=unp.ID AND unp.LINK_ID=snp.ID
   AND snp.DOG_ID=KLS_DOG.ID AND MONTH.DOG_ID=ORIG_DOG.ID AND ORIG_DOG.PREDPR_ID=2641 AND KLS_DOG.PREDPR_ID<>2641 -- Транзит
   AND snp.PLANSTRU_ID=D.ID AND D.ID<>97-- План по ЛУКОЙЛ-СНП без отгрузки на хранение
   AND MONTH.DATE_PLAN>=trunc(r.begin_date,'MONTH')
   AND KVIT.DATE_OTGR BETWEEN r.begin_date AND r.end_date
        

