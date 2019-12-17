--
-- ZADREP  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.ZadRep AS

procedure PR_ZAD_END_PER
          (date1 varchar2, date2 varchar2,res IN OUT curstype)
-- Œ“◊≈“ œŒ œ–Œ—–Œ◊≈ÕÕŒ… «¿ƒŒÀ∆≈ÕÕŒ—“» Õ¿  ŒÕ≈÷ œ≈–»Œƒ¿ (KVS)
  IS
  datex Date;
  BEGIN
  datex:= to_date(date2,'dd.mm.yyyy');
    open res for
      select g.dog_grp as dog_group, g.nom_do as nom_dog, g.pred_nam as pred_name,
             sum(decode(sign(oplata-mon1),-1,mon1-oplata,0)) as m1,
             sum(decode(sign(oplata-mon3),-1,mon3-oplata,0)) as m3,
             sum(decode(sign(oplata-mon4),-1,mon4-oplata,0)) as m4,
             sum(decode(sign(oplata-mon6),-1,mon6-oplata,0)) as m6,
             sum(decode(sign(oplata-day5),-1,day5-oplata,0)) as d5,
             sum(decode(sign(oplata-cur),-1,cur-oplata,0)) as c0,
			 sum(kol_dn) as kol_dn, date2 as enddat
        from (  -- Œ“√–”« ¿
             select g.name as dog_grp, c.dogovor_num as nom_do, f.name as pred_nam,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',add_months(datex,-1),to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as mon1,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',add_months(datex,-3),to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as mon3,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',add_months(datex,-4),to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as mon4,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',add_months(datex,-6),to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as mon6,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',datex-5,to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as day5,
             sum(decode(IIFD(b.check_date+b.days_number,'<=',datex,to_date('01.01.1990','dd.mm.yyyy'),to_date('01.01.2000','dd.mm.yyyy')),to_date('01.01.2000','dd.mm.yyyy'),0,b.BILL_TOTAL_SUM)) as cur,
             avg(b.days_number) as kol_dn
             from komitu.lo_bill b,
			      komitu.lo_contract c,
				  komitu.lo_factory f,
				  komitu.lo_dogovor_groups g,
				  komitu.lo_dogovor d
			where b.is_deleted=0 and c.is_deleted=0 and f.is_deleted=0 and b.contract_id=c.id and g.is_deleted=0
			      and g.is_deleted=0 and d.is_deleted=0 and b.dogovor_id=d.id and d.dogovor_group_id=g.id
			      and b.contract_payer_id=f.id
		    group by g.name, c.dogovor_num, f.name
             ) g,
             (  -- ŒœÀ¿“¿
             select g.name as dog_grp, c.dogovor_num as nom_do, f.name as pred_nam, sum(e.summa) as oplata, datex as enddat
             from komitu.lo_extract e,
			      komitu.lo_contract c,
			      komitu.lo_factory f,
			      komitu.lo_dogovor_groups g,
		          komitu.lo_dogovor d
             where e.extract_date<=datex and e.is_deleted=0 and c.is_deleted=0 and f.is_deleted=0
			       and e.contract_id=c.id and e.contract_payer_id=f.id
                   and g.is_deleted=0 and d.is_deleted=0 and e.dogovor_id=d.id and d.dogovor_group_id=g.id
             group by g.name, c.dogovor_num, f.name
             ) o
       where g.nom_do=o.nom_do and
-- ƒÀﬂ Œ“—≈»¬¿Õ»ﬂ ¬—≈’ Õ”À≈¬€’ «¿ƒŒÀ∆≈ÕÕŒ—“≈…
             (decode(sign(oplata-mon1),-1,mon1-oplata,0)<>0 or
             decode(sign(oplata-mon3),-1,mon3-oplata,0)<>0 or
             decode(sign(oplata-mon4),-1,mon4-oplata,0)<>0 or
             decode(sign(oplata-mon6),-1,mon6-oplata,0)<>0 or
             decode(sign(oplata-day5),-1,day5-oplata,0)<>0 or
             decode(sign(oplata-cur),-1,cur-oplata,0)<>0)
	   group by g.dog_grp, g.nom_do, g.pred_nam
       order by nom_dog, pred_name;

  END PR_ZAD_END_PER;

---------------------------------------------------------------------------------------

procedure DEB_KRED_ZAD
          (date1 varchar2, date2 varchar2,res IN OUT curstype)
-- Œ“◊≈“ œŒ ƒ≈¡≈“Œ–— Œ- –≈ƒ»“Œ–— Œ… «¿ƒŒÀ∆≈ÕÕŒ—“» (KVS)
  IS
  datex1 Date;
  datex2 Date;
  BEGIN
  datex1:= to_date(date1,'dd.mm.yyyy');
  datex2:= to_date(date2,'dd.mm.yyyy');
    open res for  --- general select from "union all"'s
select dog_group, nom_dog, pred_name,kol_dn,
       decode(sign(nvl(opl_nach,0)-nvl(otgr_nach,0)),-1,nvl(otgr_nach,0)-nvl(opl_nach,0),0) as deb_sald_nach,
	   decode(sign(nvl(otgr_nach,0)-nvl(opl_nach,0)),-1,nvl(opl_nach,0)-nvl(otgr_nach,0),0) as kred_sald_nach,
	   otgr_per, opl_per,
       decode(sign(nvl(opl_kon,0)-nvl(otgr_kon,0)),-1,nvl(otgr_kon,0)-nvl(opl_kon,0),0) as deb_sald_kon,
	   decode(sign(nvl(otgr_kon,0)-nvl(opl_kon,0)),-1,nvl(opl_kon,0)-nvl(otgr_kon,0),0) as kred_sald_kon,
	   decode(sign(nvl(pr_kred,0)-nvl(pr_deb,0)),-1,nvl(pr_deb,0)-nvl(pr_kred,0),0) as prosr_zad,
	   date1 as start_date, date2 as end_date
  from
	  (
      select dog_grp as dog_group, nom_do as nom_dog, pred_nam as pred_name,  --- ‚ÒÂ „ÛÔÔËÛÂÏ [1]
	         sum(otgr_nach) as otgr_nach, sum(otgr_per) as otgr_per,
			 sum(otgr_kon) as otgr_kon, sum(pr_deb) as pr_deb, sum(kol_dn) as kol_dn,
			 sum(opl_nach) as opl_nach, sum(opl_per) as opl_per, sum(opl_kon) as opl_kon, sum(pr_kred) as pr_kred
		from
			 (
			 select g.name as dog_grp, c.dogovor_num as nom_do, f.name as pred_nam, ---ÓÚ„ÛÁÍ‡
                    sum(decode(IIFDate(b.CHECK_DATE,'<',datex1),1,b.BILL_TOTAL_SUM,0)) as otgr_nach,
					sum(decode(IIFDate(b.CHECK_DATE,'>=',datex1),1,b.BILL_TOTAL_SUM,0)) as otgr_per,
					sum(b.BILL_TOTAL_SUM) as otgr_kon,
					sum(decode(IIFDate(b.check_date+b.days_number,'<=',datex2),1,b.BILL_TOTAL_SUM,0)) as pr_deb, -- ‰Îˇ ÔÓÒÓ˜ÍË
                    avg(b.days_number) as kol_dn, 0 as opl_nach, 0 as opl_per,0 as opl_kon, 0 as pr_kred
               from komitu.lo_bill b,
			        komitu.lo_contract c,
				    komitu.lo_factory f,
			  	    komitu.lo_dogovor_groups g,
				    komitu.lo_dogovor d
			  where b.is_deleted=0 and c.is_deleted=0 and f.is_deleted=0 and b.contract_id=c.id and g.is_deleted=0
			        and g.is_deleted=0 and d.is_deleted=0 and b.dogovor_id=d.id and d.dogovor_group_id=g.id
			        and b.contract_payer_id=f.id and b.CHECK_DATE<=datex2
   		      group by g.name, c.dogovor_num, f.name
              UNION ALL  --- Ó·˙Â‰ËÌËÏ
             select g.name as dog_grp, c.dogovor_num as nom_do, f.name as pred_nam, --- ÓÔÎ‡Ú‡
			        0 as otgr_nach, 0 as otgr_per, 0 as otgr_kon, 0 as pr_deb,0 as kol_dn,
					sum(decode(IIFDate(e.extract_date,'<=',datex1),1,e.SUMMA,0)) as opl_nach,
					sum(decode(IIFDate(e.extract_date,'>=',datex1),1,e.SUMMA,0)) as opl_per,
					sum(e.SUMMA) as opl_kon,
					sum(decode(IIFDate(e.extract_date,'<=',datex2),1,e.SUMMA,0)) as pr_kred -- ‰Îˇ ÔÓÒÓ˜ÍË
               from komitu.lo_extract e,
		   	        komitu.lo_contract c,
			        komitu.lo_factory f,
			        komitu.lo_dogovor_groups g,
		            komitu.lo_dogovor d
              where e.extract_date<=datex2 and e.is_deleted=0 and c.is_deleted=0 and f.is_deleted=0
			        and e.contract_id=c.id and e.contract_payer_id=f.id
                    and g.is_deleted=0 and d.is_deleted=0 and e.dogovor_id=d.id and d.dogovor_group_id=g.id
              group by g.name, c.dogovor_num, f.name
			  )
		group by dog_grp, nom_do, pred_nam  ---[1] end
		)
WHERE  decode(sign(nvl(opl_nach,0)-nvl(otgr_nach,0)),-1,nvl(otgr_nach,0)-nvl(opl_nach,0),0)<>0 or
	   decode(sign(nvl(otgr_nach,0)-nvl(opl_nach,0)),-1,nvl(opl_nach,0)-nvl(otgr_nach,0),0)<>0 or
	   otgr_per<>0 or opl_per<>0 or
       decode(sign(nvl(opl_kon,0)-nvl(otgr_kon,0)),-1,nvl(otgr_kon,0)-nvl(opl_kon,0),0)<>0 or
	   decode(sign(nvl(otgr_kon,0)-nvl(opl_kon,0)),-1,nvl(opl_kon,0)-nvl(otgr_kon,0),0)<>0 or
	   decode(sign(nvl(pr_kred,0)-nvl(pr_deb,0)),-1,nvl(pr_deb,0)-nvl(pr_kred,0),0)<>0
order by dog_group, nom_dog;
--- ÍÓÌÂˆ ÒÂÎÂÍÚ‡Ï
------------------------------------------------------------------------
END DEB_KRED_ZAD;

END ZadRep;

/

