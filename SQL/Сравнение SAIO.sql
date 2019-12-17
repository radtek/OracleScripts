select count(*) from master.bills_luk A where  a.DATE_KVIT>= to_date('01.04.2002','dd.mm.yyyy')

select * from master.bills_luk A where not exists (select B.id from lo_bill B 
where a.nom_dok=b.id and b.database_code=80)
and a.DATE_KVIT>= to_date('01.04.2002','dd.mm.yyyy')
and a.DATE_KVIT<= to_date('10.07.2002','dd.mm.yyyy')



select * from lo_bill A 
where a.database_code=80 
and
not exists (select B.nom_dok from master.bills_luk B 
where a.id=b.nom_dok) 

select count(*),sum(weight) from lo_bill A 
where a.database_code=80
and a.DOGOVOR_ID<>793 and a.DOGOVOR_ID<>787 
and a.CHECK_DATE>= to_date('06.07.2002','dd.mm.yyyy')
and a.CHECK_DATE<= to_date('10.07.2002','dd.mm.yyyy')

select * from lo_bill_purchase_sale A
where 
not exists (select B.id from lo_bill B 
where a.sale_bill_id=b.id and b.database_code=9)

select * from lo_bill A 
where 
not exists (select B.sale_bill_id from lo_bill_purchase_sale B 
where b.sale_bill_id=a.id )
and a.database_code=9



select b.PRODUCT_TOTAL_SUM,UD.CAT_CEN_ID,b.price_category,a.dog_id,a.kol_dn,B.*,A.* from master.bills_luk A, 
--(
--  select c.nom_dok,max(c.ves) ves,max(summa) as summa from master.bill_pos_luk C
-- where c.BILL_POS_ID<10
--  and c.DATE_realiz>= to_date('01.04.2002','dd.mm.yyyy')
-- group by c.nom_dok
-- ) C, 
lo_bill B, master.usl_dog UD 
where a.nom_dok=b.id ---and a.nom_dok=c.nom_dok
and b.database_code=80
and A.DOG_ID=UD.DOG_ID and A.USL_NUMBER=UD.USL_NUMBER
and a.DATE_KVIT>= to_date('01.04.2002','dd.mm.yyyy')
and (a.NOM_SF<>b.BILL_NUM
  or a.DATE_VYP_SF<>b.BILL_DATE 
  or a.DATE_KVIT<>b.CHECK_DATE   
  or a.SUMMA_DOK<>b.BILL_TOTAL_SUM   
  or a.NDS_DOK<>b.BILL_NDS_SUM      
  or a.KOL_DN<>b.days_number      
  or a.DOG_ID<>b.DOGOVOR_ID
--  or c.ves<>b.WEIGHT
--  or UD.ID <> b.contract_id
--  or UD.CAT_CEN_ID <> b.price_category
--  or c.summa <>b.PRODUCT_TOTAL_SUM
)


--  or upper(a.NPO_SF)<>upper(b.NPO_SF)      
  or a.DATE_BUXG<>b.DATE_BUXG   
  or a.DATE_MOS<>b.DATE_MOS    

  or a.GSM_DOK<>b.GSM_DOK     
  or a.AKCIZ_DOK<>b.AKCIZ_DOK   
  or a.PRIM<>b.PRIM        
  or a.FIO_ISPOL<>b.FIO_ISPOL   
  or a.OLD_NOM_DOK<>b.OLD_NOM_DOK  
  or a.NOM_ZD<>b.NOM_ZD        
  or a.OWNER_ID<>b.OWNER_ID     

  or a.SNPDOG_ID<>b.SNPDOG_ID    
  or a.SNPUSL_NUMBER<>b.SNPUSL_NUMBER  
  or a.SNPSUMMA_DOK<>b.SNPSUMMA_DOK   
  or a.SNPNDS_DOK<>b.SNPNDS_DOK     
  or a.SNPGSM_DOK<>b.SNPGSM_DOK     
  or a.SNPAKCIZ_DOK<>b.SNPAKCIZ_DOK    
  or a.OLD_NOM_SF<>b.OLD_NOM_SF     
)


select B.* from lo_check B 
where b.database_code=9

select * from master.kvit A,master.month B,master.kls_dog c where not exists (select B.id from lo_check B 
where a.id=b.id and b.database_code=9)
and a.nom_zd=b.nom_zd and b.dog_id=c.id and c.maindog_id=793
and a.DATE_KVIT>= to_date('01.04.2002','dd.mm.yyyy')
-- and a.DATE_KVIT<= to_date('10.07.2002','dd.mm.yyyy')
and a.bill_id<>0
and a.bill_id is not null
order by a.id

select * from lo_check A 
where 
not exists (select B.id from master.kvit B 
where b.id=a.id )
and a.database_code=80
 
select count(*) from master.kvit B





select count(*),sum(weight)/*,B.DOGOVOR_NUM*/ from lo_check A, lo_dogovor B 
where a.database_code=80
AND B.database_code=80
and a.dogovor_id = B.id
and a.DOGOVOR_ID<>793 and a.DOGOVOR_ID<>787 
and a.CHECK_DATE>= to_date('06.07.2002','dd.mm.yyyy')
and a.CHECK_DATE<= to_date('10.07.2002','dd.mm.yyyy')
and a.BILL_ID is not null

group by B.DOGOVOR_NUM

select A.* from master.kvit A,lo_check B 
where a.id=b.id 
and b.database_code=80
and (a.ves<>b.weight
)

  or a.DATE_VYP_SF<>b.BILL_DATE 
  or a.DATE_KVIT<>b.CHECK_DATE   
  or a.SUMMA_DOK<>b.BILL_TOTAL_SUM   
  or a.NDS_DOK<>b.BILL_NDS_SUM      
--  or a.KOL_DN<>b.days_number      
  or a.DOG_ID<>b.DOGOVOR_ID
--  or c.ves<>b.WEIGHT
--  or UD.ID <> b.contract_id
--  or UD.CAT_CEN_ID <> b.price_category
--  or c.summa <>b.PRODUCT_TOTAL_SUM
)


SELECT *  from lo_check A
where A.DATABASE_CODE=80 and A.BILL_ID=6082187

select * from lo_contract where id=472

select * from lo_dogovor where id=793

--update lo_bill A set note=
--(select B.npo_sf from master.ktu_2_npo_sf B where A.ID=B.nom_dok) 
--where a.database_code=9 and exists (select B.npo_sf from master.ktu_2_npo_sf B where A.ID=B.nom_dok)


select * from lo_bill where database_code=9 


SELECT a.id,b.id,b.dogovor_num,a.CORP_CONTRACT_TYPE_ID,b.CORP_CONTRACT_TYPE_ID from lo_contract A, lo_dogovor B
where A.dogovor_id = B.ID
and a.CORP_CONTRACT_TYPE_ID<>b.CORP_CONTRACT_TYPE_ID
and a.database_code=b.database_code






select count(*),sum(weight),sum(a.BILL_TOTAL_SUM) from lo_bill A 
where a.database_code=80
and DOGOVOR_ID=787 
and a.CHECK_DATE>= to_date('06.07.2002','dd.mm.yyyy')
and a.CHECK_DATE<= to_date('10.07.2002','dd.mm.yyyy')


select count(*),sum(weight)/*,B.DOGOVOR_NUM*/ from lo_check A, lo_dogovor B 
where a.database_code=80
AND B.database_code=80
and a.dogovor_id = B.id
and a.DOGOVOR_ID<>787 and a.DOGOVOR_ID<>793 
and a.CHECK_DATE>= to_date('06.07.2002','dd.mm.yyyy')
and a.CHECK_DATE<= to_date('10.07.2002','dd.mm.yyyy')
and a.BILL_ID is not null


select * from lo_bill where nvl(service_total_sum,0) <> (nvl(service_sum,0) + nvl(service_nds,0) + nvl(service_sp_tax,0))


select * from lo_bill where  database_code=9

--update lo_bill set  service_sp_tax=0, service_total_sum = (nvl(service_sum,0) + nvl(service_nds,0))
--where database_code=9

--update lo_bill set reward_sum=nvl(service_total_sum,0), reward_nds_sum=nvl(service_nds,0)
--where database_code=80

select * from lo_bill where nvl(bill_total_sum,0) <> (nvl(product_total_sum,0) + nvl(service_total_sum,0) + nvl(tariff_total_sum,0)+nvl(insurance,0))


select * from lo_bill where  database_code=80

and
DOGOVOR_ID<>787 and DOGOVOR_ID<>793 
 