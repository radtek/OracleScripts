/*  Нагрузка (чтение\запись) по файлам данных */

select f.NAME, s.READTIM, s.WRITETIM from v$datafile f, v$filestat s
  where f.file# = s.file#
    order by s.READTIM desc

select SUBSTR(f.name,1,1) as disk, SUM(s.READTIM) as readtim, SUM(s.PHYRDS) as PHYRDS, SUM(s.WRITETIM) as writetim, SUM(s.PHYWRTS) as PHYWRTS 
from v$datafile f, v$filestat s
  where f.file# = s.file#
    group by SUBSTR(f.name,1,1)
	
	
select f.name, SUM(s.READTIM) as readtim, SUM(s.WRITETIM) as writetim, SUM(s.PHYRDS) as PHYRDS, SUM(s.PHYWRTS) as PHYWRTS 
from v$datafile f, v$filestat s
  where f.file# = s.file#
    group by f.name	
