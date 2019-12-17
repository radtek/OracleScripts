/* ������������� �� */
CREATE OR REPLACE VIEW MASTER.V_UNP_GRAFIK_PRED_SF
AS 
SELECT /*+ RULE */
  b.dog_id,
  b.DATE_KVIT AS date_pred, -- ���� ������������ (���� ���������)
  sum(b.luk_summa_dok) AS summa_pred -- ����� ������������
FROM v_user_bills b, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog
WHERE b.DATE_KVIT BETWEEN r.BEGIN_DATE AND r.END_DATE
  AND b.prod_id_npr=DECODE(r.PROD_ID_NPR,'*',b.prod_id_npr,r.PROD_ID_NPR)
  AND b.dog_id=kls_dog.id
  AND kls_dog.dog_number like r.DOG_NUMBER
GROUP BY
  b.dog_id,
  b.DATE_KVIT

  
/* �������� ������� */
CREATE OR REPLACE VIEW MASTER.V_UNP_GRAFIK_PLAN_PAY
AS 
SELECT /*+ RULE */
  aa.dog_id,
  aa.date_plat,
  SUM(aa.summa_plat) as summa_plat 
FROM
(    
  SELECT /* ��� �� */ 
    b.DOG_ID,
    b.DATE_PLAT AS date_plat, -- ���� ��������� �������� ������� (�������������� ���� �������)
    b.luk_summa_dok AS summa_plat -- ��������� ����� �������
  FROM v_user_bills b, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog
  WHERE b.DATE_PLAT BETWEEN r.BEGIN_DATE AND r.END_DATE
	AND b.DATE_KVIT>=TO_DATE('01.01.2005','dd.mm.yyyy')
    AND b.prod_id_npr=DECODE(r.PROD_ID_NPR,'*',b.prod_id_npr,r.PROD_ID_NPR)
    AND b.dog_id=kls_dog.id
    AND kls_dog.dog_number like r.DOG_NUMBER
  --	
  UNION ALL
  --	 
  SELECT /* ������ (� �������) */
    b.DOG_ID,
    b.DATE_PLAT AS date_plat, -- ���� ��������� �������� ������� (�������������� ���� �������)
    -p.summa AS summa_plat -- ������ (� �������)
  FROM v_user_bills b,payments_on_bills p, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog
  WHERE b.DATE_PLAT BETWEEN r.BEGIN_DATE AND r.END_DATE
	AND b.DATE_KVIT>=TO_DATE('01.01.2005','dd.mm.yyyy')
    AND b.prod_id_npr=DECODE(r.PROD_ID_NPR,'*',b.prod_id_npr,r.PROD_ID_NPR)
    AND b.dog_id=kls_dog.id
    AND kls_dog.dog_number like r.DOG_NUMBER
	AND b.nom_dok=p.nom_dok
  --	
  UNION ALL
  --	 
  SELECT /* ���������� �� */ 
    b.dog_id,
--    c.DATE_POST as date_plat, -- ����������� ���� �������
    b.DATE_PLAT AS date_plat, -- �������������� ���� �������
    a.SUMMA AS summa_plat -- ����������� ����� �������
  FROM v_user_bills b, payments_on_bills a, payments c, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog
  WHERE b.nom_dok=a.NOM_DOK
    AND a.PAYMENTS_ID=c.ID
	AND b.DATE_KVIT>=TO_DATE('01.01.2005','dd.mm.yyyy')
    AND b.DATE_PLAT BETWEEN r.BEGIN_DATE AND r.END_DATE
--    AND c.DATE_POST BETWEEN r.BEGIN_DATE AND r.END_DATE
    AND b.prod_id_npr=DECODE(r.PROD_ID_NPR,'*',b.prod_id_npr,r.PROD_ID_NPR)
    AND b.dog_id=kls_dog.id
    AND kls_dog.dog_number like r.DOG_NUMBER
) aa
GROUP BY
  aa.dog_id,
  aa.date_plat	
	

/* ����������� ������� */
CREATE OR REPLACE VIEW MASTER.V_UNP_GRAFIK_FACT_PAY
AS 
SELECT /*+ RULE */
  aa.dog_id,
  aa.date_plat,
  SUM(aa.summa_plat) as summa_plat 
FROM
(    
  SELECT /* ����������� ������� */ 
    c.dog_id,
    c.DATE_POST as date_plat, -- ����������� ���� �������
    a.SUMMA AS summa_plat -- ����������� ����� �������
  FROM payments c, payments_on_bills a, v_user_bills b, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog 
  WHERE c.DATE_POST BETWEEN r.BEGIN_DATE AND r.END_DATE
    AND c.ID=a.PAYMENTS_ID
    AND a.NOM_DOK=b.nom_dok
    AND b.prod_id_npr=DECODE(r.PROD_ID_NPR,'*',b.prod_id_npr,r.PROD_ID_NPR)
    AND b.dog_id=kls_dog.id
    AND kls_dog.dog_number like r.DOG_NUMBER
  --	
  UNION ALL
  -- 
  SELECT /* �� ����������� ������� */ 
    b.dog_id,
    b.DATE_POST as date_plat, -- ���� �������
    sum(a.summa) as summa_plat -- ����� �������
  FROM payments b,
    (
     SELECT 
       payments.ID,
       payments.SUMMA
     FROM payments
     UNION ALL
     SELECT
       payments_on_bills.PAYMENTS_ID,
       -payments_on_bills.SUMMA
     FROM payments_on_bills
    ) a, V_TEMP_UNP_GARFIK_PARAMS r, kls_dog
  WHERE b.DATE_PLAT BETWEEN r.BEGIN_DATE AND r.END_DATE
    AND r.PROD_ID_NPR='*' -- ����������, ����� ����� �� ���� ���������
    AND a.id=b.id
    AND b.dog_id=kls_dog.id
    AND kls_dog.dog_number like r.DOG_NUMBER
  GROUP BY b.dog_id,b.DATE_POST
  HAVING sum(a.summa)>0
) aa
GROUP BY
  aa.dog_id,
  aa.date_plat	





/* ��������� �������� */
CREATE OR REPLACE VIEW MASTER.V_UNP_GRAFIK
AS 
SELECT
  KLS_PROD.LONG_NAME_NPR as PROD_NAME,
  r.BEGIN_DATE,
  r.END_DATE,
  KLS_PREDPR.SF_NAME as  PREDPR_NAME,
  a.DOG_NUMBER,
  a.DOG_ID,
  GET_KOL_DN(a.DOG_ID,r.BEGIN_DATE,r.END_DATE,r.PROD_ID_NPR) as KOL_DN,
  a.DATE_PLAT,
  a.SUMMA_PRED,
  a.SUMMA_PLAN,
  a.SUMMA_FACT
FROM 
  (  
    SELECT
	  KLS_DOG.PREDPR_ID,
	  KLS_DOG.DOG_NUMBER,
	  a.DOG_ID,
	  DATE_PLAT,
	  SUM(SUMMA_PRED) as SUMMA_PRED,
	  SUM(SUMMA_PLAN) as SUMMA_PLAN,
	  SUM(SUMMA_FACT) as SUMMA_FACT
	FROM  
      (  
       SELECT
         sf.DOG_ID,
         sf.DATE_PRED as DATE_PLAT,
         sf.SUMMA_PRED as SUMMA_PRED,
         0 as SUMMA_PLAN,
         0 as SUMMA_FACT
       FROM MASTER.V_UNP_GRAFIK_PRED_SF sf
       UNION ALL
       SELECT
         plan.DOG_ID,
         plan.DATE_PLAT as DATE_PLAT,
         0 as SUMMA_PRED,
         plan.SUMMA_PLAT as SUMMA_PLAN,
         0 as SUMMA_FACT
       FROM MASTER.V_UNP_GRAFIK_PLAN_PAY plan
       UNION ALL
       SELECT
         fact.DOG_ID,
         fact.DATE_PLAT as DATE_PLAT,
         0 as SUMMA_PRED,
         0 as SUMMA_PLAN,
         fact.SUMMA_PLAT as SUMMA_FACT
       FROM MASTER.V_UNP_GRAFIK_FACT_PAY fact
      ) a, KLS_DOG
	WHERE a.DOG_ID=KLS_DOG.ID
	GROUP BY
	  KLS_DOG.PREDPR_ID,
	  KLS_DOG.DOG_NUMBER,
	  a.DOG_ID,
	  DATE_PLAT
	) a,V_TEMP_UNP_GARFIK_PARAMS r,KLS_PROD,KLS_PREDPR
WHERE r.PROD_ID_NPR=KLS_PROD.ID_NPR(+)
  AND a.PREDPR_ID=KLS_PREDPR.ID
ORDER BY   
  KLS_PREDPR.SF_NAME,
  a.DOG_NUMBER,
  a.DOG_ID,
  a.DATE_PLAT
  	  
  
  
  
  

