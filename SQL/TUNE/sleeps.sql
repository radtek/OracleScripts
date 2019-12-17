select max(sleeps) from v$latch_children where name='cache buffers chains'


select 
e.segment_type,
e.owner ||'.'|| e.segment_name ||':'|| e.segment_type segment, 
e.extent_id extent#, 
x.dbablk - e.block_id + 1 block#, 
x.tch, 
l.child#, l.sleeps 
from 
sys.v$latch_children l, 
sys.x$bh x, 
sys.dba_extents e 
where 
l.name = 'cache buffers chains' and 
l.sleeps >= 100 and 
x.hladdr = l.addr and 
e.file_id = x.file# and 
x.dbablk between e.block_id and e.block_id + e.blocks - 1 
order by x.tch desc 
