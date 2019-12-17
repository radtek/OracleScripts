-------------------------------------------------------------------------------
--
-- Script:	kgl_bucket_count.sql
-- Purpose:	to set the _kgl_bucket_count parameter
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	The query counts the number of named objects in the library
--		cache, and suggests an index into the bucket count array for
--		the initial sizing of the library cache hash table at instance
--		startup. This value should be set using the _kgl_bucket_count
--		parameter. This prevents the hash table from growing
--		dynamically, and thus prevents the performance problems
--		associated with hash table growth.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  least(8, ceil(log(2, ceil(count(*) / 509))))  "INDEX"
from
  sys.x_$kglob  o
where
  o.inst_id = userenv('Instance') and
  o.kglhdadr = o.kglhdpar
/

@restore_sqlplus_settings
