connect internal/sys
startup NOMOUNT PFILE=C:\DB_ORCL\initorcl.ora

alter database mount;

alter database rename file 'j:\db_orcl\paridx_2.ORA' to 'g:\db_orcl\paridx_2.ORA';
alter database rename file 'j:\db_orcl\paridx_4.ORA' to 'g:\db_orcl\paridx_4.ORA';
alter database rename file 'j:\db_orcl\parus_idx2.ORA' to 'g:\db_orcl\parus_idx2.ORA';
alter database rename file 'j:\db_orcl\parusidx_2.ORA' to 'g:\db_orcl\parusidx_2.ORA';
alter database rename file 'j:\db_orcl\parusidx_4.ORA' to 'g:\db_orcl\parusidx_4.ORA';
alter database rename file 'j:\db_orcl\parusidx2.ORA' to 'g:\db_orcl\parusidx2.ORA';
alter database rename file 'j:\db_orcl\replidx2.ORA' to 'g:\db_orcl\replidx2.ORA';
alter database rename file 'j:\db_orcl\repl_idx2.ORA' to 'g:\db_orcl\repl_idx2.ORA';



alter database rename file 'd:\db_orcl\LOG32.ORA' to 'c:\db_orcl\LOG32.ORA';
alter database rename file 'd:\db_orcl\LOG52.ORA' to 'c:\db_orcl\LOG52.ORA';
alter database rename file 'd:\db_orcl\parus01.ORA' to 'c:\db_orcl\parus01.ORA';

#alter database rename file 'e:\db_orcl\LOG21.ORA' to 'e:\db_orcl\LOG21.ORA';
#alter database rename file 'e:\db_orcl\LOG41.ORA' to 'e:\db_orcl\LOG41.ORA';
#alter database rename file 'e:\db_orcl\LOG61.ORA' to 'e:\db_orcl\LOG61.ORA';
#alter database rename file 'e:\db_orcl\prsrlb1.ORA' to 'e:\db_orcl\prsrlb1.ORA';

alter database rename file 'f:\db_orcl\parus03.ORA' to 'c:\db_orcl\parus03.ORA';
alter database rename file 'f:\db_orcl\parus04.ORA' to 'e:\db_orcl\parus04.ORA';

alter database rename file 'g:\db_orcl\system1.ORA' to 'c:\db_orcl\system1.ORA';
alter database rename file 'g:\db_orcl\temp1.ORA' to 'c:\db_orcl\temp1.ORA';
alter database rename file 'g:\db_orcl\tools1.ORA' to 'c:\db_orcl\tools1.ORA';

alter database rename file 'h:\db_orcl\paridx00.ORA' to 'd:\db_orcl\paridx00.ORA';
alter database rename file 'h:\db_orcl\paridx02.ORA' to 'e:\db_orcl\paridx02.ORA';
alter database rename file 'h:\db_orcl\paridx05.ORA' to 'd:\db_orcl\paridx05.ORA';
alter database rename file 'h:\db_orcl\paridx06.ORA' to 'd:\db_orcl\paridx06.ORA';
alter database rename file 'h:\db_orcl\paridx07.ORA' to 'd:\db_orcl\paridx07.ORA';
alter database rename file 'h:\db_orcl\paridx08_2.ORA' to 'd:\db_orcl\paridx08_2.ORA';

alter database rename file 'i:\db_orcl\temp2.ORA' to 'c:\db_orcl\temp2.ORA';

alter database rename file 'j:\db_orcl\paridx01.ORA' to 'd:\db_orcl\paridx01.ORA';
alter database rename file 'j:\db_orcl\paridx03.ORA' to 'd:\db_orcl\paridx03.ORA';
alter database rename file 'j:\db_orcl\paridx04.ORA' to 'd:\db_orcl\paridx04.ORA';
alter database rename file 'j:\db_orcl\paridx08_1.ORA' to 'd:\db_orcl\paridx08_1.ORA';

alter database rename file 'k:\db_orcl\LOG22.ORA' to 'e:\db_orcl\LOG22.ORA';
alter database rename file 'k:\db_orcl\LOG42.ORA' to 'e:\db_orcl\LOG42.ORA';
alter database rename file 'k:\db_orcl\LOG62.ORA' to 'e:\db_orcl\LOG62.ORA';
alter database rename file 'k:\db_orcl\parus07.ORA' to 'e:\db_orcl\parus07.ORA';
alter database rename file 'k:\db_orcl\parus08.ORA' to 'e:\db_orcl\parus08.ORA';

alter database rename file 'l:\db_orcl\parus02.ORA' to 'e:\db_orcl\parus02.ORA';
alter database rename file 'l:\db_orcl\parus05.ORA' to 'e:\db_orcl\parus05.ORA';
alter database rename file 'l:\db_orcl\parus06.ORA' to 'e:\db_orcl\parus06.ORA';
alter database rename file 'l:\db_orcl\parus_inst.ORA' to 'e:\db_orcl\parus_inst.ORA';

alter database rename file 'm:\db_orcl\LOG11.ORA' to 'c:\db_orcl\LOG11.ORA';
alter database rename file 'm:\db_orcl\LOG31.ORA' to 'c:\db_orcl\LOG31.ORA';
alter database rename file 'm:\db_orcl\LOG51.ORA' to 'c:\db_orcl\LOG51.ORA';
alter database rename file 'm:\db_orcl\prsrlb2.ORA' to 'e:\db_orcl\prsrlb2.ORA';

alter database rename file 'n:\db_orcl\parus00.ORA' to 'e:\db_orcl\parus00.ORA';

alter database noarchivelog;

alter database open;

alter user parus identified by "parad";

drop tablespace temp;

CREATE TEMPORARY TABLESPACE TEMP TEMPFILE 
  'C:\DB_ORCL\TEMP1.ORA' SIZE 717664K REUSE AUTOEXTEND ON NEXT 100M MAXSIZE 5000M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 808K;


