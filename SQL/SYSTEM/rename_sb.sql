/* "��������������" ������ ��� Standby Database */

connect internal/sys
STARTUP NOMOUNT PFILE= G:\db_orcl\initorcl.ora
ALTER DATABASE MOUNT STANDBY DATABASE;

ALTER DATABASE RENAME FILE 'J:\TOOLS1.ORA' to 'C:\DB_ORCL\TOOLS1.ORA';

ALTER DATABASE RENAME FILE 'K:\DB_ORCL\PRSRLB1.ORA' to 'C:\DB_ORCL\PRSRLB1.ORA';
ALTER DATABASE RENAME FILE 'K:\DB_ORCL\LOG21.ORA' to 'C:\DB_ORCL\LOG21.ORA';
ALTER DATABASE RENAME FILE 'K:\DB_ORCL\LOG41.ORA' to 'C:\DB_ORCL\LOG41.ORA';
ALTER DATABASE RENAME FILE 'K:\DB_ORCL\LOG61.ORA' to 'C:\DB_ORCL\LOG61.ORA';

ALTER DATABASE RENAME FILE 'L:\DB_ORCL\PARUS3.ORA' to 'F:\DB_ORCL\PARUS3.ORA';

ALTER DATABASE RENAME FILE 'M:\DB_ORCL\PRSRLB2.ORA' to 'H:\DB_ORCL\PRSRLB2.ORA';
ALTER DATABASE RENAME FILE 'M:\DB_ORCL\LOG11.ORA' to 'H:\DB_ORCL\LOG11.ORA';
ALTER DATABASE RENAME FILE 'M:\DB_ORCL\LOG31.ORA' to 'H:\DB_ORCL\LOG31.ORA';
ALTER DATABASE RENAME FILE 'M:\DB_ORCL\LOG51.ORA' to 'H:\DB_ORCL\LOG51.ORA';


