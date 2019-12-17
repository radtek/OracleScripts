--
-- V_TAX_NOPACKAGE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TAX_NOPACKAGE
(DOC_ID, PARENT_DOC_ID, DOC_NUM, DOC_DATE, REL_NAME)
AS 
select to_char(docs.doc_num)||to_char(docs.doc_date)||to_char(docs.doc_rel_id) as doc_id, 
       to_char(docs.parent_doc_num)||to_char(docs.parent_doc_date)||to_char(docs.parent_doc_rel_id) as parent_doc_id,     
       docs.doc_num, 
       docs.doc_date,
       rel.rel_name
from isu_tax_docs docs join isu_tax_rel rel on docs.doc_rel_id=rel.id 
where docs.package_id is null;


