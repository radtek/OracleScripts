select * from bills_luk A where not exists (select B.nom_dok from bills_luk1 B 
where a.nom_dok=b.nom_dok) 
and date_mos>=to_date('01.04.2002','dd.mm.yyyy')

select * from bills_luk1 A 
where not exists (select B.nom_dok from bills_luk B 
where a.nom_dok=b.nom_dok) 

select A.npo_sf,B.npo_sf from bills_luk A, bills_luk1 B 
where a.nom_dok=b.nom_dok
and (a.NOM_SF<>b.NOM_SF 
--  or upper(a.NPO_SF)<>upper(b.NPO_SF)      
  or a.DATE_VYP_SF<>b.DATE_VYP_SF 
  or a.DATE_KVIT<>b.DATE_KVIT   
  or a.DATE_BUXG<>b.DATE_BUXG   
  or a.DATE_MOS<>b.DATE_MOS    
  or a.SUMMA_DOK<>b.SUMMA_DOK   
  or a.NDS_DOK<>b.NDS_DOK      
  or a.GSM_DOK<>b.GSM_DOK     
  or a.AKCIZ_DOK<>b.AKCIZ_DOK   
  or a.PRIM<>b.PRIM        
  or a.FIO_ISPOL<>b.FIO_ISPOL   
  or a.KOL_DN<>b.KOL_DN      
  or a.OLD_NOM_DOK<>b.OLD_NOM_DOK  
  or a.NOM_ZD<>b.NOM_ZD        
  or a.OWNER_ID<>b.OWNER_ID     
  or a.DOG_ID<>b.DOG_ID        
  or a.USL_NUMBER<>b.USL_NUMBER   
  or a.PROD_ID_NPR<>b.PROD_ID_NPR  
  or a.SNPDOG_ID<>b.SNPDOG_ID    
  or a.SNPUSL_NUMBER<>b.SNPUSL_NUMBER  
  or a.SNPSUMMA_DOK<>b.SNPSUMMA_DOK   
  or a.SNPNDS_DOK<>b.SNPNDS_DOK     
  or a.SNPGSM_DOK<>b.SNPGSM_DOK     
  or a.SNPAKCIZ_DOK<>b.SNPAKCIZ_DOK    
  or a.OLD_NOM_SF<>b.OLD_NOM_SF     
)


select * from bill_pos_luk A where not exists (select B.nom_dok from bill_pos_luk1 B 
where a.nom_dok=b.nom_dok and a.BILL_POS_ID=b.BILL_POS_ID)
and date_realiz >= to_date('01.04.2002','dd.mm.yyyy')

select * from bill_pos_luk1 A where not exists (select B.nom_dok from bill_pos_luk B 
where a.nom_dok=b.nom_dok and a.BILL_POS_ID=b.BILL_POS_ID) 

select A.* from bill_pos_luk A, bill_pos_luk1 B 
where a.nom_dok=b.nom_dok and a.BILL_POS_ID=b.BILL_POS_ID
and 
(  a.VES<>b.VES               
or a.CENA_BN<>b.CENA_BN           
or a.CENA<>b.CENA              
or a.SUMMA_BN<>b.SUMMA_BN          
or a.SUMMA_AKCIZ<>b.SUMMA_AKCIZ       
or a.SUMMA_NDS20<>b.SUMMA_NDS20       
or a.SUMMA_GSM25<>b.SUMMA_GSM25       
or a.SUMMA<>b.SUMMA             
or a.CENA_POKUP<>b.CENA_POKUP        
or a.SUMMA_BN_POKUP<>b.SUMMA_BN_POKUP    
or a.SUMMA_NDS20_POKUP<>b.SUMMA_NDS20_POKUP 
or a.SUMMA_GSM25_POKUP<>b.SUMMA_GSM25_POKUP 
or a.DATE_REALIZ<>b.DATE_REALIZ       
or a.ID_OLD<>b.ID_OLD            
or a.PROD_ID_NPR<>b.PROD_ID_NPR       
or a.OWNERSHIP_ID<>b.OWNERSHIP_ID      
or a.ANALIT_ID<>b.ANALIT_ID         
) 



select count(*) from bill_pos_luk A

select count(*) from bill_pos_luk1 A  
