--
-- ISU_VIEW_DOCS_EXIST_PACK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.ISU_VIEW_DOCS_EXIST_PACK
("Номер документа", "Дата документа")
AS 
select DOC_NUM as "Номер документа",
        DOC_DATE as "Дата документа"  
        from ISU_TAX_EXIST 
            JOIN ISU_TAX_DOCS ON ISU_TAX_EXIST.DOC_ID=ISU_TAX_DOCS.ID AND ISU_TAX_DOCS.PACKAGE_ID IS NOT NULL;


