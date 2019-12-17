--
-- ISU_VIEW_DOCS_EXIST_NOPACK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.ISU_VIEW_DOCS_EXIST_NOPACK
("Номер документа", "Дата документа", "ПРИЧИНА", "Имя файла", "ПОЗИЦИЯ")
AS 
select ISU_TAX_DOCS.DOC_NUM as "Номер документа",
       ISU_TAX_DOCS.DOC_DATE as "Дата документа",
       ISU_TAX_REASON.reason as "Причина",
       ISU_TAX_FILES.file_name as "Имя файла",
       ISU_TAX_EXIST.file_pos_num as "Позиция"
       from ISU_TAX_EXIST 
            JOIN ISU_TAX_DOCS ON ISU_TAX_EXIST.DOC_ID=ISU_TAX_DOCS.ID AND ISU_TAX_DOCS.PACKAGE_ID IS NULL 
            JOIN ISU_TAX_REASON ON ISU_TAX_EXIST.reason_id=ISU_TAX_REASON.id
            JOIN ISU_TAX_FILES ON ISU_TAX_EXIST.file_id=ISU_TAX_FILES.id;


