--
-- V_ISU_PACKAGE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ISU_PACKAGE
(ID, PACK_NUM, PACK_DATE, DOCCOUNT)
AS 
Select A.ID,A.PACK_NUM,A.PACK_DATE,count(B.ID) as DOCCOUNT  
    from isu_tax_package A 
         JOIN isu_tax_docs B ON A.ID=B.PACKAGE_ID
        group by A.ID,A.PACK_NUM,A.PACK_DATE;


