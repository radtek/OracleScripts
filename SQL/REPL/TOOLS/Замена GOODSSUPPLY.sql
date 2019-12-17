select a.*,a.rowid from incomefromdepsspec a where supply=900002614098

select a.*,a.rowid from storeoperjourn a where goodssupply=900002614098

select a.*,a.rowid from stplgoodssupply a where goodssupply=900002614098

select a.*,a.rowid from STRPLOPRJRNL a where goodssupply=900002614098

select a.*,a.rowid from STRPLRESJRNL a where goodssupply=900002614098

select a.*,a.rowid from WROFFACTSPECS a where goodssupply=900002614098





select a.*, a.rowid from goodssupply a 
where exists 
(select * from (select prn,store from goodssupply group by prn,store having count(*)>1) b where b.prn=a.prn and b.store=a.store)
order by prn,store




