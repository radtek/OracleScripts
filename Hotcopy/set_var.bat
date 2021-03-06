SET ORACLE_SID=NB
SET ORACLE_HOME=d:\oracle
SET PATH=d:\oracle\bin;%PATH%

SET DIR_ORADATA=d:\oracle\oradata\NB\
SET TEMP_DBFILE='D:\ORACLE\ORADATA\NB\TEMP01.DBF'
SET DIR_PFILE=d:\oracle\ADMIN\NB\PFILE\
SET DIR_BDUMP=d:\oracle\ADMIN\NB\BDUMP\
SET DIR_DATABASE=%ORACLE_HOME%\DATABASE\
SET DIR_ARCHIVE=D:\ARCHIVE\NB\ARCHIVELOG\
SET DIR_AREMOTE_OUT=\\KMISQL1\d$\AREMOTE\AZS\BACKUP_LOG\
SET DIR_BACKUP=D:\ARCHIVE\NB\

SET DIR_HOTCOPY=c:\hotcopy\
SET DIR_CONFIG=c:\hotcopy\config\
SET DIR_TMP=c:\hotcopy\oradata\
SET ORA805_NETA=\ORANT\Net80\Admin\
SET ORA817_NETA=\ORACLE\network\ADMIN\
SET TEMP_BACKUPFILE=%DIR_TMP%HotCopyTmp.rar
SET USB_DRIVE=
SET IS_SERVER=YES
SET SERVER_HOTCOPY=c:\hotcopy\
SET ARGUS_SERVER=%COMPUTERNAME%
SET USE_RMAN=YES
set nls_lang=AMERICAN_AMERICA.CL8MSWIN1251

rem --- ������砥��� � �ᥤ��� ����� (��� ����஢���� �������)
SET IP_ARM0=127.0.0.1\diskc
SET IP_ARM1=0.0.0.0\diskc
SET IP_ARM2=0.0.0.0\diskc
SET USER_ARM0=oracle
SET USER_ARM1=oracle
SET USER_ARM2=oracle
SET PWD_ARM0=master
SET PWD_ARM1=master
SET PWD_ARM2=master

echo y | net use \\%IP_ARM0% %PWD_ARM0% /user:%USER_ARM0%
echo y | net use \\%IP_ARM1% %PWD_ARM1% /user:%USER_ARM1%
echo y | net use \\%IP_ARM2% %PWD_ARM2% /user:%USER_ARM2%

echo y | net use \\%IP_ARM0% 
echo y | net use \\%IP_ARM1% 
echo y | net use \\%IP_ARM2% 


rem --- ������� ����室��� ��⠫��� ---
mkdir c:\temp
mkdir %dir_config%
mkdir %dir_backup%
mkdir %dir_hotcopy%
mkdir %dir_hotcopy%oradata
mkdir %dir_hotcopy%archive
mkdir %dir_hotcopy%backup
mkdir %dir_tmp%
mkdir %dir_tmp%admin
mkdir %dir_tmp%database
mkdir %dir_tmp%archive
mkdir %dir_tmp%config
mkdir %dir_tmp%move

mkdir %DIR_TMP%config
mkdir %DIR_TMP%config\LUKNET
mkdir %DIR_TMP%config%ORA805_NETA%
mkdir %DIR_TMP%config%ORA817_NETA%
mkdir %DIR_TMP%config\PFILE


MONTH.EXE
IF ERRORLEVEL=1 SET NUM_MON=01
IF ERRORLEVEL=2 SET NUM_MON=02
IF ERRORLEVEL=3 SET NUM_MON=03
IF ERRORLEVEL=4 SET NUM_MON=04
IF ERRORLEVEL=5 SET NUM_MON=05
IF ERRORLEVEL=6 SET NUM_MON=06
IF ERRORLEVEL=7 SET NUM_MON=07
IF ERRORLEVEL=8 SET NUM_MON=08
IF ERRORLEVEL=9 SET NUM_MON=09
IF ERRORLEVEL=10 SET NUM_MON=10
IF ERRORLEVEL=11 SET NUM_MON=11
IF ERRORLEVEL=12 SET NUM_MON=12

DAY.EXE
IF ERRORLEVEL=1 SET NUM_DAY=01
IF ERRORLEVEL=2 SET NUM_DAY=02
IF ERRORLEVEL=3 SET NUM_DAY=03
IF ERRORLEVEL=4 SET NUM_DAY=04
IF ERRORLEVEL=5 SET NUM_DAY=05
IF ERRORLEVEL=6 SET NUM_DAY=06
IF ERRORLEVEL=7 SET NUM_DAY=07
IF ERRORLEVEL=8 SET NUM_DAY=08
IF ERRORLEVEL=9 SET NUM_DAY=09
IF ERRORLEVEL=10 SET NUM_DAY=10
IF ERRORLEVEL=11 SET NUM_DAY=11
IF ERRORLEVEL=12 SET NUM_DAY=12
IF ERRORLEVEL=13 SET NUM_DAY=13
IF ERRORLEVEL=14 SET NUM_DAY=14
IF ERRORLEVEL=15 SET NUM_DAY=15
IF ERRORLEVEL=16 SET NUM_DAY=16
IF ERRORLEVEL=17 SET NUM_DAY=17
IF ERRORLEVEL=18 SET NUM_DAY=18
IF ERRORLEVEL=19 SET NUM_DAY=19
IF ERRORLEVEL=20 SET NUM_DAY=20
IF ERRORLEVEL=21 SET NUM_DAY=21
IF ERRORLEVEL=22 SET NUM_DAY=22
IF ERRORLEVEL=23 SET NUM_DAY=23
IF ERRORLEVEL=24 SET NUM_DAY=24
IF ERRORLEVEL=25 SET NUM_DAY=25
IF ERRORLEVEL=26 SET NUM_DAY=26
IF ERRORLEVEL=27 SET NUM_DAY=27
IF ERRORLEVEL=28 SET NUM_DAY=28
IF ERRORLEVEL=29 SET NUM_DAY=29
IF ERRORLEVEL=30 SET NUM_DAY=30
IF ERRORLEVEL=31 SET NUM_DAY=31
