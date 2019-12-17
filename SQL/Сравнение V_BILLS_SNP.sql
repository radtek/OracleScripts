select * from bills_snp A where not exists (select B.nom_dok from bills_snp1 B 
where a.nom_dok=b.nom_dok)

AND DATE_kvit >= TO_DATE('01.01.2002','dd.mm.yyyy')

select * from bills_snp1 A 
where not exists (select B.nom_dok from bills_snp B 
where a.nom_dok=b.nom_dok) 


select A.*,B.* from bills_snp A, bills_snp1 B 
where a.nom_dok=b.nom_dok
and (a.NOM_SF<>b.NOM_SF
--  or upper(a.NPO_SF)<>upper(b.NPO_SF)      
  or a.DATE_VYP_SF<>b.DATE_VYP_SF 
  or a.DATE_KVIT<>b.DATE_KVIT   
  or a.DATE_BUXG<>b.DATE_BUXG   
  or a.PRIM<>b.PRIM        
  or a.FIO_ISPOL<>b.FIO_ISPOL   
  or a.KOL_DN<>b.NPOKOL_DN      
  or a.OLD_NOM_DOK<>b.OLD_NOM_DOK  
  or a.NOM_ZD<>b.NOM_ZD        
  or a.OWNER_ID<>b.OWNER_ID     
  or a.DOG_ID<>b.NPODOG_ID        
--  or a.USL_NUMBER<>b.NPOUSL_NUMBER   
  or a.PROD_ID_NPR<>b.PROD_ID_NPR  
  or a.SUMMA_DOK<>b.SUMMA_DOK   
  or a.NDS_DOK<>b.NDS_DOK      
  or a.GSM_DOK<>b.GSM_DOK     
  or a.AKCIZ_DOK<>b.AKCIZ_DOK   
)

select * from bill_pos_snp A where not exists (select B.nom_dok from bill_pos_snp1 B 
where a.nom_dok=b.nom_dok and a.BILL_POS_SNP_ID=b.bill_pos_id)  
AND DATE_otgr >= TO_DATE('01.01.2002','dd.mm.yyyy')

select * from bill_pos_snp1 A where not exists (select B.nom_dok from bill_pos_snp B 
where a.nom_dok=b.nom_dok and a.BILL_POS_ID=b.BILL_POS_SNP_ID) 

select b.kvit_ves,A.* from bill_pos_snp A, bill_pos_snp1 B 
where a.nom_dok=b.nom_dok and a.BILL_POS_snp_ID=b.BILL_POS_ID
AND a.DATE_otgr >= TO_DATE('01.03.2002','dd.mm.yyyy')
and 
(  a.VES<>b.VES
or a.KVIT_VES<>b.KVIT_VES               
or a.SVED_NUM<>b.SVED_NUM               
or a.DATE_OTGR<>b.DATE_OTGR               
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
or a.NPR_PRICES_ID<>b.NPR_PRICES_ID         
)



select count(*) from v_bill_pos A

select count(*) from v_bill_pos_old A  
