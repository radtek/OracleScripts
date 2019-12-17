BEGIN
  DBMS_STATS.DELETE_DATABASE_STATS(statown => 'SYS',stattab => 'P5_SAVESTATS_DATABASE') ;
  DBMS_STATS.GATHER_DATABASE_STATS(cascade => true, statown => 'SYS', stattab => 'P5_SAVESTATS_DATABASE',gather_sys => FALSE) ;
END;


BEGIN
DBMS_STATS.GATHER_SYSTEM_STATS(
             gathering_mode => 'interval',
             interval => 600,
             stattab => 'P5_SAVESTATS_SYSTEM',
             statid => 'OLTP',
			 statown => 'SYS');
END;


BEGIN
DBMS_STATS.GATHER_SYSTEM_STATS(
             gathering_mode => 'interval',
             interval => 720,
             stattab => 'P5_SAVESTATS_SYSTEM',
             statid => 'OLAP',
			 statown => 'SYS');
END;

BEGIN
DBMS_STATS.IMPORT_SYSTEM_STATS(
             stattab => 'P5_SAVESTATS_SYSTEM',
             statid => 'OLTP',
			 statown => 'SYS');
END;

EXECUTE DBMS_STATS.GATHER_SYSTEM_STATS ('START');
EXECUTE DBMS_STATS.GATHER_SYSTEM_STATS ('STOP');

