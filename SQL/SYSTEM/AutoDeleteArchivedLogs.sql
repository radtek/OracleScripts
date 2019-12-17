connect sys/YOUR_SYS_PASSWORD 

grant select on v_$archived_log to YOUR_USER; 
grant execute on dbms_backup_restore to YOUR_USER; 

connect YOUR_USER/USER_PASSWORD 

create or replace directory ARCHIVEDIR as 
  'd:\ora8i\orant\oradata\archive'; 

create or replace function proc_nom_fich(P_chain IN Varchar2) 
 return varchar2 IS 
  l_posi       number; 
  l_nom_fich   varchar2(100); 

begin 
 l_posi := length(P_chain); 
 loop 
   if substr(P_chain,l_posi,1)  in ('/','\') then 
     l_nom_fich := substr(P_chain,l_posi + 1); 
     exit; 
   else 
     l_posi := l_posi - 1; 
     if  l_posi < 0 then 
       exit; 
     end if; 
   end if; 
  end loop; 

  return(l_nom_fich); 
end; 
/ 

create or replace procedure proc_dele_arch_log is 
  arch_file        bfile; 
  arch_exis        boolean; 
  arch_file_name   varchar2(100); 

  cursor sel_archive is 
    select name 
      from v$archived_log 
     where completion_time < sysdate - 30; 

begin 
  for list in sel_archive loop 
    arch_exis := FALSE; 
    arch_file_name := proc_nom_fich(list.name); 
    arch_file := bfilename('ARCHIVEDIR',arch_file_name); 
    arch_exis := dbms_lob.fileexists(arch_file) = 1; 

    if arch_exis then 
      sys.dbms_backup_restore.deleteFile(list.name); 
    end if; 
  end loop; 
end; 
/ 

declare 
  l_job_nb    number; 
  l_inst_nb   number; 
begin 
  select sys.jobseq.nextval into l_job_nb from dual; 
  dbms_job.submit(l_job_nb, 'proc_dele_arch_log;', 
    to_date(sysdate,'DD-MON-YYYY HH24:MI'), 'sysdate + 7'); 
  commit; 
end; 
/ 
