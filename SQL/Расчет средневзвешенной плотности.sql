/* 1 */
update kls_prod_plan P set (avg_fact_pl)=
(select 
  SUM(FAKT_PL*VES_BRUTTO)/SUM(VES_BRUTTO) as AVG_PL
 from kvit A,KLS_PROD C, KLS_PROD_PLAN D
 WHERE A.PROD_ID_NPR=C.ID_NPR
   AND C.PROD_PLAN_ID=D.ID
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
   AND D.ID=P.ID
 )
where exists   
(select 
  NULL
 from kvit A,KLS_PROD C, KLS_PROD_PLAN D
 WHERE A.PROD_ID_NPR=C.ID_NPR
   AND C.PROD_PLAN_ID=D.ID
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
   AND D.ID=P.ID
 )

/* 2 */ 
update kls_prod P set (avg_fact_pl)=
(
select 
  SUM(FAKT_PL*VES_BRUTTO)/SUM(VES_BRUTTO) as AVG_PL
 from kvit A, kls_prod B
 WHERE A.PROD_ID_NPR=B.ID_NPR
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
   AND B.ID_GROUP_NPR=P.ID_NPR
 )
where exists   
(
select 
  NULL
 from kvit A, kls_prod B
 WHERE A.PROD_ID_NPR=B.ID_NPR
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
   AND B.ID_GROUP_NPR=P.ID_NPR
 )
 
 
 /* 3 */ 
update kls_prod P set (avg_fact_pl)=
(
select 
  SUM(FAKT_PL*VES_BRUTTO)/SUM(VES_BRUTTO) as AVG_PL
 from kvit A
 WHERE A.PROD_ID_NPR=P.ID_NPR
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
 )
where exists   
(
 select 
  NULL
 from kvit A
 WHERE A.PROD_ID_NPR=P.ID_NPR
   AND A.FAKT_PL>0 AND VES_BRUTTO>0
 )

