--
-- V_TAX_NOPARENT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TAX_NOPARENT
(DOC_NUM, DOC_DATE)
AS 
select doc_num, doc_date
    from isu_tax_docs docs
  where not exists (select id from isu_tax_docs where doc_num=docs.parent_doc_num
  and doc_date=docs.parent_doc_date)
        and not (select pid from isu_tax_rel where id=docs.doc_rel_id) is null;


