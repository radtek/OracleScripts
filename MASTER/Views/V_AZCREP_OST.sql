--
-- V_AZCREP_OST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AZCREP_OST
(END_DATE, ID, ID_NPR, OST)
AS 
SELECT A.END_DATE,B.ID, C.ID_NPR, (FOR_AZC.GET_AZC_OST_VOL(B.ID, C.ID_NPR, 1, A.END_DATE)) as OST FROM V_MASTER_REPORTS A,ORG_STRUCTURE B, KLS_PROD C
WHERE C.AZC_PR_GRP_ID is NOT NULL;

