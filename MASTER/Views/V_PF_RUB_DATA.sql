--
-- V_PF_RUB_DATA  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PF_RUB_DATA
(PLANSTRU_ID, PLAN_VES, PLAN_SUM, PLANOBR_VES, FACT_VES, 
 FACT_SUM)
AS 
select PLANSTRU_ID,
        sum(PLAN_VES) as PLAN_VES,
        sum(PLAN_SUM) as PLAN_SUM,
        sum(PLANOBR_VES) as PLANOBR_VES,
        sum(FACT_VES) as FACT_VES,
        sum(FACT_SUM) as FACT_SUM
 from (
       -- Факт
       select /*+ RULE*/ 
              T2.PLANSTRU_ID,
              0 as PLAN_VES,
              0 as PLAN_SUM,
              0 as PLANOBR_VES,
              sum(T1.VES_BRUTTO) as FACT_VES,
              round(sum(decode(nvl(T1.SUM_PROD,0),0,
                   nvl((select max(T3.CENA)
                                    from V_NPR_PRICES T3
                                    where (T3.CAT_CEN_ID = T4.CAT_CEN_ID)   and
                                          (T3.PROD_ID_NPR = T1.PROD_ID_NPR) and
                                  (T1.DATE_KVIT between T3.BEGIN_DATE and T3.END_DATE)),0)*T1.VES_BRUTTO,
                T1.SUM_PROD)),2) as FACT_SUM
       from V_MASTER_REPORTS R, KVIT T1, MONTH T2, USL_DOG T4
       where (nls_upper(R.REPORT_FILE) = 'PF_RUB.XLS') and
             (T1.DATE_KVIT between R.BEGIN_DATE and R.END_DATE) and
             (T1.NOM_ZD = T2.NOM_ZD) and
             (T2.DOG_ID = T4.DOG_ID) and
             (T2.USL_NUMBER = T4.USL_NUMBER)
       group by T2.PLANSTRU_ID
       
    union all

       -- Первоначальный план
       select  /*+ RULE*/ 
              T1.PLANSTRU_ID,
              sum(T1.PLAN_VES) as PLAN_VES,
              round(sum(nvl((select max(T3.CENA)
                             from V_NPR_PRICES T3, KLS_CAT_CEN CC
                       where (T3.CAT_CEN_ID = CC.ID) and 
                         (decode(nvl(CC.PREDPR_ID,0),0,2,CC.PREDPR_ID) = D.PREDPR_ID) and
                             (T3.PROD_ID_NPR = T1.PROD_ID_NPR) and
                       (T2.BEGIN_DATE between T3.BEGIN_DATE and T3.END_DATE)),
           0)*T1.PLAN_VES),2) as PLAN_SUM_SUM,
              0 as PLANOBR_VES,
              0 as FACT_VES,
              0 as FACT_SUM
       from V_MASTER_REPORTS R, PLAN_POST T1, PLAN_PERIODS T2, KLS_DOG D
       where (nls_upper(r.REPORT_FILE) = 'PF_RUB.XLS') and
             (T1.PLAN_PER_ID = T2.ID) and
            (T1.DOG_ID = D.ID) and
             (T1.PLAN_ID = 2) and
             (T2.END_DATE >= R.BEGIN_DATE) and
          (T2.BEGIN_DATE <= R.END_DATE)
       group by T1.PLANSTRU_ID
       
    union all

       -- План с ОБР
       select  /*+ RULE*/ 
               T1.PLANSTRU_ID,
               0 as PLAN_VES,
               0 as PLAN_SUM,
               sum(T1.PLAN_VES) as PLANOBR_VES,
               0 as FACT_VES,
               0 as FACT_SUM
       from V_MASTER_REPORTS R, PLAN_POST T1, PLAN_PERIODS T2
       where (nls_upper(R.REPORT_FILE) = 'PF_RUB.XLS') and
             (T1.PLAN_PER_ID = T2.ID) and
             (T1.PLAN_ID in (2,3)) and
             (T2.END_DATE >= R.BEGIN_DATE)   and
           (T2.BEGIN_DATE <= R.END_DATE)
       group by T1.PLANSTRU_ID)
 group by PLANSTRU_ID;


