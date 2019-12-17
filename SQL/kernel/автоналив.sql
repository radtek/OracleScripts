BEGIN
  EXECUTE IMMEDIATE 'alter session set global_names=false';
END;  

Commit;  // даже если был только select

alter session close database link NALIV;

BEGIN
  EXECUTE IMMEDIATE 'alter session set global_names=true';
END;  

declare
  res NUMBER;
begin
  UHT_PCK_AUTONALIV_UNP.start_dblink;
  res:=UHT_PCK_AUTONALIV_UNP.send_request(1,'АИ-95','К 317 РУ-11',1,10000,'ПРОКУШЕВ С.В.',SYSDATE);
  dbms_output.put_line(to_char(res));
  UHT_PCK_AUTONALIV_UNP.finish_dblink;
end;  

update sh30_temp@autonalivsql set "defi_mass"=1 where "id"=1;

select a.*,"xpl","ves"*1000/"vzliv" from sh30@naliv a where "vzliv"<>0 order by "np_data_o" desc, "id";

select * from sh30_temp@autonalivsql order by "np_data_o" desc, "id";

rollback; 




declare
  res NUMBER;
  ves NUMBER;
  volume NUMBER;
  pl NUMBER;
  temper NUMBER;
begin
  UHT_PCK_AUTONALIV_UNP.start_dblink;
  res:=UHT_PCK_AUTONALIV_UNP.get_value(1,ves,volume,pl,temper);
  dbms_output.put_line(to_char(res)||' '||to_char(ves)||' '||to_char(volume)||' '||to_char(pl)||' '||to_char(temper));
  UHT_PCK_AUTONALIV_UNP.finish_dblink;
end;

declare
  res NUMBER;
begin
  UHT_PCK_AUTONALIV_UNP.start_dblink;
  res:=UHT_PCK_AUTONALIV_UNP.set_waybill_printed(1);
  dbms_output.put_line(to_char(res));
  UHT_PCK_AUTONALIV_UNP.finish_dblink;
end;



select value
from NLS_DATABASE_PARAMETERS
where PARAMETER = 'NLS_CHARACTERSET';




select a.* from sh30@naliv a where "np_data_o">=SYSDATE-1 order by "np_data_o" desc, "id";

rollback

alter session close database link NALIV;


select a.*,b."num_otgr" as asutp_num_otgr, b."prod_abbr2" as asutp_prod_name, round(b."ves",3) as asutp_ves, b."vzliv" as asutp_vzliv, DECODE(b."vzliv",0,0,round(round(b."ves",3)*1000/b."vzliv",4)) as asutp_pl from SH30_ZPOSTAV_PSV a, sh30@naliv b where a.postav_id=b."id"(+) and a.nakl_volume<>0