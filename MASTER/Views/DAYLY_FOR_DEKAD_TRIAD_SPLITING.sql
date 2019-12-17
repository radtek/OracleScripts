--
-- DAYLY_FOR_DEKAD_TRIAD_SPLITING  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.DAYLY_FOR_DEKAD_TRIAD_SPLITING
(DATA, NAME_NPR, XVALUE)
AS 
select A.DATA,KLS_PROD.NAME_NPR,
       case EXTRACT(DAY FROM A.DATA) 
       WHEN 1 THEN A.plan_nar 
       ELSE
        (select A.plan_nar-B.plan_nar from Dayly_Fact b where b.prod=a.prod AND a.DATA=b.DATA+1)
       end as Xvalue
       from Dayly_Fact A 
            LEFT JOIN KLS_PROD ON KLS_PROD.ID_NPR=A.PROD
         order by A.DATA,KLS_PROD.NAME_NPR;


