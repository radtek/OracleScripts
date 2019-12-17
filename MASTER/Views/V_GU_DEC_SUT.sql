--
-- V_GU_DEC_SUT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GU_DEC_SUT
(COLUMN_A, COLUMN_B, COLUMN_C, COLUMN_D, COLUMN_E, 
 COLUMN_F, COLUMN_G, COLUMN_H, COLUMN_I, COLUMN_J)
AS 
select /*+ rule */ 
     -- Отгрузка по графику (4, F) 
      -- Жд 
       T1.DATE_R      as COLUMN_A,  -- Дата 
       0                          as COLUMN_B,  -- Возможность отгрузки по эстакадам 
       T3.NAME_NPR                as COLUMN_C,  -- Продукт 
       T4.PREDPR_NAME || ' (ж/д)' as COLUMN_D,  -- Покупатель 
       0                          as COLUMN_E,  -- Заказ на месяц, тн 
       Sum(T1.VES)                as COLUMN_F,  -- Отгрузка по графику, тн 
       0                          as COLUMN_G,  -- Задание на сутки, тн 
       0                          as COLUMN_H,  -- Отклонение от графика, тн 
       0                          as COLUMN_I,  -- Факт за сутки, тн 
       0                          as COLUMN_J   -- Отклонение от задания на сутки, тн 
from V_MASTER_REPORTS V1, GU12_BR T1 
join GU12_B T2 on (T1.ID_B = T2.ID) 
join KLS_PROD T3 on (T1.ID_NPR = T3.ID_NPR) 
join KLS_PREDPR T4 on (T2.PLAT_ID = T4.ID) 
where (T1.DATE_R between V1.BEGIN_DATE and V1.END_DATE) and 
      (Nls_Upper(V1.REPORT_FILE) = 'GU_DEC.XLS') 
group by T1.DATE_R, T3.NAME_NPR, T4.PREDPR_NAME 
union all 
-- Самовывоз 
select T4.VALUE                             as COLUMN_A,  -- Дата 
       0                                    as COLUMN_B,  -- Возможность отгрузки по эстакадам 
       T2.NAME_NPR                          as COLUMN_C,  -- Продукт 
       T3.PREDPR_NAME || ' (а/н)'           as COLUMN_D,  -- Покупатель 
       0                                    as COLUMN_E,  -- Заказ на месяц, тн 
       Sum(round(T1.VES/(Last_Day(T1.BEGIN_DATE)- 
	       T1.BEGIN_DATE+1),3))                as COLUMN_F,  -- Отгрузка по графику, тн 
       0                                    as COLUMN_G,  -- Задание на сутки, тн 
       0                                    as COLUMN_H,  -- Отклонение от графика, тн 
       0                                    as COLUMN_I,  -- Факт за сутки, тн 
       0                                    as COLUMN_J   -- Отклонение от задания на сутки, тн 
from V_MASTER_REPORTS V1, ZAKAZ T1 
join KLS_PROD T2 on (T1.PROD_ID_NPR = T2.ID_NPR) 
join KLS_PREDPR T3 on (T1.PLAT_ID = T3.ID), KLS_DATES T4 
where (T1.IS_AGENT = 1) and 
      (T1.BEGIN_DATE between V1.BEGIN_DATE and V1.END_DATE) and 
      (T4.VALUE between V1.BEGIN_DATE and V1.END_DATE) and 
      (T1.BEGIN_DATE <= T4.VALUE) and (T4.VALUE <= Last_Day(T1.BEGIN_DATE)) and 
      (T1.LOAD_ABBR = 'САМ') and 
	  (T1.IS_ACCEPT = 1) and 
      (Nls_Upper(V1.REPORT_FILE) = 'GU_DEC.XLS') 
group by T4.VALUE, T2.NAME_NPR, T3.PREDPR_NAME 
union all 
-- Факт за сутки (7, I) 
select /*+ rule */ T1.DATE_OTGR           as COLUMN_A,  -- Дата 
       0                                  as COLUMN_B,  -- Возможность отгрузки по эстакадам 
       T2.NAME_NPR                        as COLUMN_C,  -- Продукт 
       (case T3.LOAD_ABBR when 'САМ' 
		  then T5.PREDPR_NAME || ' (а/н)' 
	      else T5.PREDPR_NAME || ' (ж/д)' 
        end)                              as COLUMN_D,  -- Покупатель 
       0                                  as COLUMN_E,  -- Заказ на месяц, тн 
       0                                  as COLUMN_F,  -- Отгрузка по графику, тн 
       0                                  as COLUMN_G,  -- Задание на сутки, тн 
       0                                  as COLUMN_H,  -- Отклонение от графика, тн 
       Sum(T1.VES)                        as COLUMN_I,  -- Факт за сутки, тн 
       0                                  as COLUMN_J   -- Отклонение от задания на сутки, тн 
from V_MASTER_REPORTS V1, KVIT T1 
join KLS_PROD T2 on (T1.PROD_ID_NPR = T2.ID_NPR) 
join MONTH T3 on (T1.NOM_ZD = T3.NOM_ZD) 
join KLS_DOG T4 on (T3.DOG_ID = T4.ID) 
join KLS_PREDPR T5 on (T4.PREDPR_ID = T5.ID) 
where (T1.DATE_OTGR between V1.BEGIN_DATE and V1.END_DATE) and 
      (Nls_Upper(V1.REPORT_FILE) = 'GU_DEC.XLS') 
group by T1.DATE_OTGR, T2.NAME_NPR, (case T3.LOAD_ABBR when 'САМ' then T5.PREDPR_NAME || ' (а/н)' else T5.PREDPR_NAME || ' (ж/д)' end) 
--order by COLUMN_A, COLUMN_D, COLUMN_C
;


