select a.*, a.rowid from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'

select a.*, a.rowid from SHIFT_REPORT_MIS a where DOC_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')


select a.*, a.rowid from doc_line a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select a.*, a.rowid from check_return a where report_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select a.*, a.rowid from check_return_i a where doc_id in (select doc_id from check_return a where report_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'))

select a.*, a.rowid from doc_line a where doc_id in (select doc_id from check_return a where report_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'))

select a.*, a.rowid from shift_report_inv a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')


select a.*, a.rowid from ACCEPT_REPORT_SPEC a where master_id in (select line_id from doc_line a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'))
 
select a.*, a.rowid from shift_report_sale_raw a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select a.*, a.rowid from z_report a where report_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')


select a.*, a.rowid from doc_line a where doc_id in (select doc_id from z_report a where report_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'))

select a.*, a.rowid from shift_report_turn a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select a.*, a.rowid from shift_report a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')


select a.*, a.rowid from CARD_GDS_STOR_FLOW a where line_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select line_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%'

select a.*, a.rowid from shift_report_sale a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')

select a.*, a.rowid from ACCEPT_REPORT_SPEC a where master_id in (select line_id from doc_line a where line_id in (select line_id from shift_report_sale a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')))

select a.*, a.rowid from CARD_GDS_STOR_FLOW a where line_id in (select line_id from doc_line a where line_id in (select line_id from shift_report_sale a where doc_id in (select doc_id from SHIFT_REPORT a where DOC_NUMBER like '%ÀÇÑ11Àðõ' and doc_id like '43500000%')))