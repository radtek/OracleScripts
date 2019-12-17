/* Выдает права для нормальной инсталляции Quest Server Agent (для Space Manager) */

grant execute on dbms_pipe to tadm;
grant execute on dbms_sql to tadm;
grant execute on dbms_sys_sql to tadm;
 
grant select on sys.tab$ to tadm;
grant select on sys.tabpart$ to tadm;
grant select on sys.tabsubpart$ to tadm;
grant select on sys.tabcompart$ to tadm;
grant select on sys.cdef$ to tadm;
grant select on sys.user$ to tadm;
grant select on sys.obj$ to tadm;
grant select on sys.col$ to tadm;
grant select on sys.uet$ to tadm;
grant select on sys.file$ to tadm;
grant select on sys.qsa_ktfbue to tadm;
grant select on sys.ind$ to tadm;
grant select on sys.icol$ to tadm;
grant select on sys.x$ktfbue to tadm;
