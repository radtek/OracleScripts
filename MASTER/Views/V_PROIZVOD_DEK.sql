--
-- V_PROIZVOD_DEK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PROIZVOD_DEK
(PROD, MES, DEKADA, TRIADA, PLAN_PROIZV)
AS 
SELECT /* + RULE*/ d.PROD,
to_char(DATA,'mm') as mes,
CASE 
	  WHEN trunc((to_number(to_char(d.DATA,'dd'))-1)/10) = 0 then 1
	  WHEN trunc((to_number(to_char(d.DATA,'dd'))-1)/10) = 1 then 2
	  ELSE 3
end as DEKADA,
CASE 
	  WHEN to_number(to_char(d.DATA,'dd')) in (1,2,3) then 1
	  WHEN to_number(to_char(d.DATA,'dd')) in (4,5,6) then 2
	  WHEN to_number(to_char(d.DATA,'dd')) in (7,8,9,10) then 3
	  WHEN to_number(to_char(d.DATA,'dd')) in (11,12,13) then 1
	  WHEN to_number(to_char(d.DATA,'dd')) in (14,15,16) then 2
	  WHEN to_number(to_char(d.DATA,'dd')) in (17,18,19,20) then 3
	  WHEN to_number(to_char(d.DATA,'dd')) in (21,22,23) then 1
	  WHEN to_number(to_char(d.DATA,'dd')) in (24,25,26) then 2
	  ELSE 3
END as TRIADA,
sum(case EXTRACT(DAY FROM d.DATA) 
		          WHEN 1 THEN d.plan_nar 
				  ELSE (select d.plan_nar-B.plan_nar from Dayly_Fact b where b.prod=d.prod AND d.DATA=b.DATA+1)
       		  end
) as PLAN_PROIZV 
from dayly_fact d
WHERE to_char(d.DATA,'mm.yyyy')=to_char(FOR_TEMP.GET_AS_DATE('DBEG_PLAN','MASTER','GU12'),'mm.yyyy')
group by
	  d.PROD,
	  to_char(DATA,'mm'),
	  CASE 
	  	   WHEN trunc((to_number(to_char(d.DATA,'dd'))-1)/10) = 0 then 1
	  	   WHEN trunc((to_number(to_char(d.DATA,'dd'))-1)/10) = 1 then 2
	  	   ELSE 3
	  END,
	  CASE 
		 WHEN to_number(to_char(d.DATA,'dd')) in (1,2,3) then 1
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (4,5,6) then 2
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (7,8,9,10) then 3
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (11,12,13) then 1
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (14,15,16) then 2
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (17,18,19,20) then 3
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (21,22,23) then 1
	  	 WHEN to_number(to_char(d.DATA,'dd')) in (24,25,26) then 2
	  	 ELSE 3
	  END;


