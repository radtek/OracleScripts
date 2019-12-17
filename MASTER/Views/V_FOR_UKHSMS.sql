--
-- V_FOR_UKHSMS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FOR_UKHSMS
(NETBIOS_NAME, FILENAME)
AS 
select netbios_name,filename from
    (
    select terminal_name as netbios_name, SUBSTR(NLS_UPPER(appl_name),INSTR(NLS_UPPER(appl_name),'\',-1,1)+1,200) as filename from REPL_SESSION 
    where date_start>=TRUNC(add_months(sysdate,-3),'MONTH')
    and descript = 'ON SESSION LOGON'
    and appl_name is not null
    and appl_name <>'?'
    )   
    group by netbios_name,filename;


