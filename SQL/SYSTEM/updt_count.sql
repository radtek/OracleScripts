select count(*) from updatelist 
where modifdate > TO_DATE('May 16, 2003, 7:00 A.M.','Month dd, YYYY, HH:MI A.M.')
and modifdate < TO_DATE('May 20, 2003, 6:00 A.M.','Month dd, YYYY, HH:MI A.M.')