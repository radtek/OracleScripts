
drop view master.v_appl_session_now


create or replace view master.v_appl_session_now as
select SID,sysdate as datetime,username,status,NLS_UPPER(osuser) as osuser,NLS_UPPER(terminal) as computer,NLS_UPPER(NVL(program,module)) as module,
(case
    when NLS_LOWER(NVL(program,module)) in  ('pasport.exe','r3csv.exe','repxls.exe','pview.exe','statrep.exe') then 'PASP'
    when NLS_LOWER(NVL(program,module)) in  ('master.exe') then 'MASTER'
    when NLS_LOWER(NVL(program,module)) in  ('dispetcher.exe','repxlsdisp.exe','svodgg.exe','svodpn.exe','gl_name_new.exe','bitum.exe','pro.exe','tsc.exe') then 'DISP_SVOD'
    when NLS_LOWER(NVL(program,module)) in  ('ycet.exe','arxiv.exe','copyfile.exe','impost.exe','impotgr.exe','impper.exe','imptov.exe','reports2.exe','oiluk.exe','repdisp.exe','oilsync.exe','oil.exe') then 'TOV_UCHET'
    when NLS_LOWER(NVL(program,module)) in  ('pretenz.exe') then 'PRETENZ'
    when NLS_LOWER(NVL(program,module)) in  ('azsstop.exe') then 'AZSSTOP'
    else '?'
  end) as program,  
logon_time,last_call_et from sys.v_$session 
where NLS_UPPER(NVL(program,module)) not like 'ORACLE.EXE%'

drop table master.appl_session

create table master.appl_session as 
select * from master.v_appl_session_now

select * from master.appl_session

where program='PASP'

insert into master.appl_session
select * from master.v_appl_session_now

select PROGRAM,OSUSER,COMPUTER,LOGON_TIME,MAX(DATETIME) as LOGOFF_TIME
from  master.appl_session
where PROGRAM='PASP'
group by PROGRAM,OSUSER,COMPUTER,LOGON_TIME
order by PROGRAM,OSUSER,COMPUTER,LOGON_TIME

