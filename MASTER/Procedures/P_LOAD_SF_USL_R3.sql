--
-- P_LOAD_SF_USL_R3  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.P_Load_Sf_Usl_R3(vDATE DATE) IS
  vPrevDok NUMBER;
  vPrevProd VARCHAR2(5);
  vBillPosId NUMBER;
  vNomSf NUMBER;
  vNumAkt NUMBER;
/******************************************************************************
   NAME:       P_LOAD_SF_USL_R3
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05.02.2007          1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     P_LOAD_SF_USL_R3
      Sysdate:         05.02.2007
      Date and Time:   05.02.2007, 16:43:36, and 05.02.2007 16:43:36
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
vBillPosId:=1;

--Удаляем все фактуры по услугам за сутки
DELETE FROM BILL_POS WHERE NOM_DOK IN (SELECT NOM_DOK FROM BILLS WHERE DATE_KVIT=vDATE 
   AND PROD_ID_NPR>='10000' AND PROD_ID_NPR<='10100' AND PROD_ID_NPR<>'10080');
DELETE FROM BILLS WHERE DATE_KVIT=vDATE AND PROD_ID_NPR>='10000' AND PROD_ID_NPR<='10100' AND PROD_ID_NPR<>'10080';
   
--цикл по заголовкам
FOR REC3 IN (SELECT /*+ ORDERED */ DISTINCT 
	 	 		IB.NOM_SF AS ISU_NOM_SF
				,IBP.ISU_KOD_POS
		 		,IB.DATE_VYP_SF
		 		,IB.ISU_KOD
		 		,vDate AS DATE_KVIT
				,For_Init.GetCurrUser AS FIO_ISPOL
				,TO_NUMBER(SUBSTR(IB.USL_PLAT,3)) AS KOL_DN
				,IB.ISU_KOD_OLD
				,'?' AS NOM_ZD
				,8 AS OWNER_ID
				,D.ID AS DOG_ID
				,1 AS USL_NUMBER
				,P.ID_NPR AS PROD_ID_NPR
				,vDate AS DATE_MOS
				,D.IS_AGENT
				,(CASE
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 1 AND 5 THEN 1
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 6 AND 10 THEN 2
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 11 AND 15 THEN 3
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 16 AND 20 THEN 4
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 20 AND 25 THEN 5
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD'))>25 THEN 6
					   ELSE 0
				  END) AS NUM_5_DAY
				,NULL AS NAZN_OTG_ID
				,vDate+TO_NUMBER(SUBSTR(IB.USL_PLAT,3)) AS DATE_PLAT
				,1-NVL(IBP.IS_AKCIZ,0) AS NO_AKCIZ
				,vDate AS DATE_BUXG
				,NVL(IB.STATUS,0) AS STATUS
        		,IBP.PRICE AS CENA
        		,IBP.PRICE_WITH_NDS AS CENA_OTP
        		,IBP.SUMMA_BN AS SUM_PROD
        		,0 AS SUM_AKCIZ
        		,IBP.SUMMA_NDS AS SUM_PROD_NDS
        		,IBP.TARIF_NDS AS TARIF_NDS 
        		,IBP.TARIF_GUARD_NDS AS TARIF_GUARD_NDS 
        		,IBP.SUMMA_VOZN_BN AS SUM_VOZN11
        		,ROUND(IBP.SUMMA_VOZN_BN*0.18,2) AS SUM_VOZN11_NDS  
        		,IBP.SUMMA_RAZN_BN AS SUM_VOZN12
        		,ROUND(IBP.SUMMA_RAZN_BN*0.18,2) AS SUM_VOZN12_NDS
		 FROM ISU_BILLS IB
			  ,ISU_BILL_POS IBP
			  ,KLS_DOG D
			  ,KLS_PROD P
		 WHERE IB.DATE_KVIT=vDATE
		   AND IB.ISU_KOD=SUBSTR(IBP.ISU_KOD_POS,1,10)
		   AND SUBSTR(IB.ISU_KOD_DOG,1,10)=SUBSTR(D.ISU_KOD_DOG_USLUG,1,10)
		   AND IBP.Material_KSSS=P.ID_NPR
		   AND NVL(IB.STATUS,0) IN (0,3)
		   AND IB.LATENT||' '<>'X'
		   AND P.ID_NPR<>'10003'
			   )
LOOP

		vNumAkt:=0;
		--заполняем заголовок
		INSERT INTO BILLS (ISU_NOM_SF
			   		  ,NOM_SF /* PSV - номер нового счета =0 */
    		          ,DATE_VYP_SF
					  ,ISU_KOD
					  ,NOM_DOK
					  ,DATE_KVIT
					  ,FIO_ISPOL
					  ,KOL_DN
					  ,OLD_NOM_DOK
					  ,NOM_ZD
					  ,OWNER_ID
					  ,DOG_ID
					  ,USL_NUMBER
					  ,PROD_ID_NPR
					  ,DATE_MOS
					  ,IS_AGENT
					  ,NUM_5_DAY
					  ,KORR_5_DAY
					  ,NAZN_OTG_ID
					  ,DATE_PLAT
					  ,NO_AKCIZ
					  ,DATE_BUXG
					  ,SUMMA_DOK
     	              ,NDS_DOK
     				  ,PROD_SUM
     				  ,PROD_NDS
     				  ,LUK_SUMMA_DOK
     				  ,LUK_NDS_DOK
					  )
          VALUES (REC3.ISU_NOM_SF
		  		 ,REC3.ISU_NOM_SF --,vNomSF с 01.01.2007 берем номер из r3
		         ,REC3.DATE_VYP_SF
				 ,REC3.ISU_KOD
				 ,TO_NUMBER(REC3.ISU_KOD)
				 ,REC3.DATE_KVIT
				 ,REC3.FIO_ISPOL
				 ,REC3.KOL_DN
				 ,REC3.ISU_KOD_OLD
				 ,REC3.NOM_ZD
				 ,REC3.OWNER_ID
				 ,REC3.DOG_ID
				 ,REC3.USL_NUMBER
				 ,REC3.PROD_ID_NPR
				 ,REC3.DATE_MOS
				 ,REC3.IS_AGENT
				 ,REC3.NUM_5_DAY
				 ,REC3.NUM_5_DAY
				 ,REC3.NAZN_OTG_ID
				 ,REC3.DATE_PLAT
				 ,REC3.NO_AKCIZ
				 ,REC3.DATE_BUXG
				 ,REC3.SUM_PROD
     	         ,REC3.SUM_PROD_NDS
				 ,REC3.SUM_PROD
     	         ,REC3.SUM_PROD_NDS
				 ,REC3.SUM_PROD
     	         ,REC3.SUM_PROD_NDS
				 );
		 INSERT INTO BILL_POS (
		   					  BILL_POS_ID
							 ,NOM_DOK
		   					 ,VES
							 ,CENA_BN
							 ,SUMMA_BN
							 ,SUMMA_AKCIZ
							 ,SUMMA_NDS20
							 ,SUMMA
							 ,PROD_ID_NPR
							 ,IS_AGENT
							 ,NO_AKCIZ
							 ,OWNERSHIP_ID
							 ,IS_LUK
							 ,PROTO_NUM
							 ,PROTO_DATE
							 ,DATE_REALIZ
							 ,NUM_AKT
							 )
		              VALUES(
							  1
							 ,REC3.ISU_KOD
		   					 ,0
							 ,REC3.CENA
							 ,REC3.SUM_PROD
							 ,REC3.SUM_AKCIZ
							 ,REC3.SUM_PROD_NDS
							 ,REC3.SUM_PROD
							 ,REC3.PROD_ID_NPR
							 ,REC3.IS_AGENT
							 ,REC3.NO_AKCIZ
							 ,1
							 ,1
							 ,NULL
							 ,NULL
							 ,vDate
							 ,0
							 );	
			 
END LOOP;

FOR REC3 IN (SELECT /*+ ORDERED */ DISTINCT 
	 	 		IB.NOM_SF AS ISU_NOM_SF
		 		,IB.DATE_VYP_SF
		 		,IB.ISU_KOD
		 		,vDate AS DATE_KVIT
				,For_Init.GetCurrUser AS FIO_ISPOL
				,TO_NUMBER(SUBSTR(IB.USL_PLAT,3)) AS KOL_DN
				,IB.ISU_KOD_OLD
				,'?' AS NOM_ZD
				,8 AS OWNER_ID
				,D.ID AS DOG_ID
				,1 AS USL_NUMBER
				,P.ID_NPR AS PROD_ID_NPR
				,vDate AS DATE_MOS
				,D.IS_AGENT
				,(CASE
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 1 AND 5 THEN 1
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 6 AND 10 THEN 2
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 11 AND 15 THEN 3
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 16 AND 20 THEN 4
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD')) BETWEEN 20 AND 25 THEN 5
				  	   WHEN TO_NUMBER(TO_CHAR(vDate,'DD'))>25 THEN 6
					   ELSE 0
				  END) AS NUM_5_DAY
				,NULL AS NAZN_OTG_ID
				,vDate+TO_NUMBER(SUBSTR(IB.USL_PLAT,3)) AS DATE_PLAT
				,1-NVL(IBP.IS_AKCIZ,0) AS NO_AKCIZ
				,vDate AS DATE_BUXG
				,NVL(IB.STATUS,0) AS STATUS
        		,IBP.PRICE AS CENA
        		,IBP.PRICE_WITH_NDS AS CENA_OTP
				,IBP.SUMMA
				,IBP.SUMMA_BN
        		,0 AS SUM_AKCIZ
        		,IBP.SUMMA_NDS AS SUM_PROD_NDS
        		,IBP.TARIF_NDS AS TARIF_NDS 
        		,IBP.TARIF_GUARD_NDS AS TARIF_GUARD_NDS 
        		,IBP.SUMMA_VOZN_BN AS SUM_VOZN11
        		,ROUND(IBP.SUMMA_VOZN_BN*0.18,2) AS SUM_VOZN11_NDS  
        		,IBP.SUMMA_RAZN_BN AS SUM_VOZN12
        		,ROUND(IBP.SUMMA_RAZN_BN*0.18,2) AS SUM_VOZN12_NDS
		 FROM ISU_BILLS IB
			  ,ISU_BILL_POS IBP
			  ,KLS_DOG D
			  ,KLS_PROD P
		 WHERE IB.DATE_KVIT=vDate
		   AND IB.ISU_KOD=SUBSTR(IBP.ISU_KOD_POS,1,10)
		   AND SUBSTR(IB.ISU_KOD_DOG,1,10)=SUBSTR(D.ISU_KOD_DOG,1,10)
		   AND IBP.Material_KSSS=P.ID_NPR
		   AND NVL(IB.STATUS,0) IN (0,3)
		   AND IB.LATENT||' '<>'X'
		   AND P.ID_NPR='10003'
			   )
LOOP

		vNumAkt:=0;
		--заполняем заголовок
		INSERT INTO BILLS (ISU_NOM_SF
			   		  ,NOM_SF /* PSV - номер нового счета =0 */
    		          ,DATE_VYP_SF
					  ,ISU_KOD
					  ,NOM_DOK
					  ,DATE_KVIT
					  ,FIO_ISPOL
					  ,KOL_DN
					  ,OLD_NOM_DOK
					  ,NOM_ZD
					  ,OWNER_ID
					  ,DOG_ID
					  ,USL_NUMBER
					  ,PROD_ID_NPR
					  ,DATE_MOS
					  ,IS_AGENT
					  ,NUM_5_DAY
					  ,KORR_5_DAY
					  ,NAZN_OTG_ID
					  ,DATE_PLAT
					  ,NO_AKCIZ
					  ,DATE_BUXG
					  ,SUMMA_DOK
     	              ,NDS_DOK
     				  ,PROD_SUM
     				  ,PROD_NDS
     				  ,LUK_SUMMA_DOK
     				  ,LUK_NDS_DOK
					  )
          VALUES (REC3.ISU_NOM_SF
		  		 ,REC3.ISU_NOM_SF --,vNomSF с 01.01.2007 берем номер из r3
		         ,REC3.DATE_VYP_SF
				 ,REC3.ISU_KOD
				 ,TO_NUMBER(REC3.ISU_KOD)
				 ,REC3.DATE_KVIT
				 ,REC3.FIO_ISPOL
				 ,REC3.KOL_DN
				 ,REC3.ISU_KOD_OLD
				 ,REC3.NOM_ZD
				 ,REC3.OWNER_ID
				 ,REC3.DOG_ID
				 ,REC3.USL_NUMBER
				 ,REC3.PROD_ID_NPR
				 ,REC3.DATE_MOS
				 ,REC3.IS_AGENT
				 ,REC3.NUM_5_DAY
				 ,REC3.NUM_5_DAY
				 ,REC3.NAZN_OTG_ID
				 ,REC3.DATE_PLAT
				 ,REC3.NO_AKCIZ
				 ,REC3.DATE_BUXG
				 ,REC3.SUMMA
     	         ,REC3.SUM_PROD_NDS
				 ,REC3.SUMMA
     	         ,REC3.SUM_PROD_NDS
				 ,REC3.SUMMA
     	         ,REC3.SUM_PROD_NDS
				 );
		 INSERT INTO BILL_POS (
		   					  BILL_POS_ID
							 ,NOM_DOK
		   					 ,VES
							 ,CENA_BN
							 ,SUMMA_BN
							 ,SUMMA_AKCIZ
							 ,SUMMA_NDS20
							 ,SUMMA
							 ,PROD_ID_NPR
							 ,IS_AGENT
							 ,NO_AKCIZ
							 ,OWNERSHIP_ID
							 ,IS_LUK
							 ,PROTO_NUM
							 ,PROTO_DATE
							 ,DATE_REALIZ
							 ,NUM_AKT
							 )
		              VALUES(
							  1
							 ,REC3.ISU_KOD
		   					 ,0
							 ,REC3.CENA
							 ,REC3.SUMMA_BN
							 ,REC3.SUM_AKCIZ
							 ,REC3.SUM_PROD_NDS
							 ,REC3.SUMMA
							 ,REC3.PROD_ID_NPR
							 ,REC3.IS_AGENT
							 ,REC3.NO_AKCIZ
							 ,1
							 ,1
							 ,NULL
							 ,NULL
							 ,vDate
							 ,0
							 );	
			 
END LOOP;
COMMIT;

END P_Load_Sf_Usl_R3;

/

