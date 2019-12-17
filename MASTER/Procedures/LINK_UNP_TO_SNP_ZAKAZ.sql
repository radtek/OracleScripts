--
-- LINK_UNP_TO_SNP_ZAKAZ  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.link_unp_to_snp_zakaz (pDatePlan DATE, pIdUNPHist number, pNumSNP varchar2) as
  vIDSNP NUMBER;
  vIDSNPHist NUMBER;
  vIDUNP NUMBER;
  vIDUNPHist NUMBER;
  vIdOldSNPHist NUMBER;
begin
  begin
    select b.id,b.zakaz_id into vIdSNPHist,vIDSNP from zakaz a, zakaz_hist b
    where b.zakaz_id=a.id and a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
      and a.lukdog_id=3447
      and a.client_number=pNumSNP and B.STATUS_ZAKAZ_ID=20 and B.LINK_HIST_ID is null
      and rownum=1;
  exception
    when others then
      vIdSNPHist:=null;
      vIDSNP:=null;
  end;
          
  begin
    select b.id,b.zakaz_id into vIdUNPHist,vIDUNP from zakaz a, zakaz_hist b
    where b.zakaz_id=a.id and a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
      and a.plat_id=10 
      and b.id=pIDUNPHist and B.STATUS_ZAKAZ_ID=20; 
  exception
    when others then
      vIdUNPHist:=null;
      vIDUNP:=null;
  end;

  begin
    select b.id into vIdOldSNPHist from zakaz a, zakaz_hist b, zakaz_hist c
    where b.zakaz_id=a.id and a.date_plan=pDatePlan 
      and b.id=c.link_hist_id and c.id=vIdUNPHist
      and rownum=1;
  exception
    when others then
      vIdOldSNPHist:=null;
  end;
     
  if vIDUNPHist is null or vIDUNP is null or vIDSNPHist is null or vIDSNP is null then
    RAISE_APPLICATION_ERROR(22000,'Нет позиции!');
  end if; 

  update zakaz_hist set link_id=null,link_hist_id=null,nom_zd=null where id=vIdOldSNPHist;   
  FOR_ZAKAZ.SETZAKAZLINK(vidUNP,vidSNP, vIdSNPHist);
  FOR_ZAKAZ.SETZAKAZHISTLINK(vidUNPHist,vidSNP, vIdSNPHist);
  FOR_ZAKAZ.SETZAKAZHISTLINK(vidSNPHist,vidUNP, vIdUNPHist);
  FOR_ZAKAZ.FILLFACTTHISMONTH;
  COMMIT;
end; 
/

