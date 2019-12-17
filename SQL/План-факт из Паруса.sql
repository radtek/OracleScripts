-- ��������� ��������� �����������
SELECT /*+ ORDERED */
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn) AS NB_NAME,
  I.DOCUMENT AS ZAYV_RN,
  b.snommodifname AS NOMMODIF_NAME,
  b.nnomen AS DICNOMNS_RN, -- �������
  b.nnommodif AS NOMMODIF_RN, -- �����������
  c.nPRN AS CONTRACTS_RN, -- �������
  c.nRN AS STAGES_RN, -- ���� ��������
  a.nfaceacc AS FACEACC_RN, -- ������� ����
  a.sfaceacc AS FACEACC_CODE,
  a.nsheepview AS TIP_OTGR_RN, -- ��� ���������������
  a.ssheepview AS TIP_OTGR_NAME,
  a.npaytype AS PAYTYPE_RN, -- ����� ������
  a.spaytype AS PAYTYPE_NAME,
  a.nagnfifo AS POLUCH_RN, -- ���������������
  a.sagnfifoname AS POLUCH_NAME,
  SUM(b.nQUANTALT) AS FACT_VES -- ����������� ���
FROM V_TRANSINVCUST a, V_TRANSINVCUSTSPECS b, V_STAGES c,
(SELECT * FROM DOCINPT WHERE UNITCODE = 'ConsumersOrders') I,
DOCLINKS L,
(SELECT * FROM DOCOUTPT WHERE UNITCODE = 'GoodsTransInvoicesToConsumers') O
WHERE b.nPRN = a.nRN
  AND b.nnomen_type=1
  AND a.nFACEACC = c.nFACEACC (+) 
  AND a.ddocdate BETWEEN TO_DATE('01.01.2003','dd.mm.yyyy') AND TO_DATE('31.01.2003','dd.mm.yyyy')
  AND a.sstore NOT IN ('����� ����� ���','���_���','029�')
  AND (a.sstore NOT LIKE '%_��' OR a.sstore='���������_���_��')
  AND a.nRN = O.DOCUMENT (+)
  AND O.RN = L.OUT_DOC (+) 
  AND L.IN_DOC = I.RN (+)  
GROUP BY
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn),
  I.DOCUMENT,
  b.nnomen,
  b.nnommodif,
  b.snommodifname,
  c.nPRN,
  c.nRN,
  a.nfaceacc,
  a.sfaceacc,
  a.nsheepview,
  a.ssheepview,
  a.npaytype,
  a.spaytype,
  a.nagnfifo,
  a.sagnfifoname



SELECT 
FROM
WHERE
  
-- ����� �� ��������
SELECT /*+ ORDERED */
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn) AS NB_NAME, -- ���������
  a.snommodifname AS NOMMODIF_NAME, -- ����������� ��������
  a.nnomen AS DICNOMNS_RN, -- �������
  a.nnommodif AS NOMMODIF_RN, -- �����������
  c.nPRN AS CONTRACTS_RN, -- �������
  c.nRN AS STAGES_RN, -- ���� ��������
  a.nfaceacc AS FACEACC_RN, -- ������� ����
  a.sfaceacc AS FACEACC_CODE,
  SUM(a.nQUANT) AS PLAN_VES -- ���
FROM V_STAGESOUTOPERPLANS a,V_STAGES c
WHERE a.nFACEACC = c.nFACEACC (+)
  AND a.nNOMEN_TYPE=1 
  AND a.dbegin_date BETWEEN TO_DATE('01.01.2003','dd.mm.yyyy') AND TO_DATE('31.01.2003','dd.mm.yyyy')
GROUP BY
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn),
  a.nnomen,
  a.nnommodif,
  a.snommodifname,
  c.nPRN,
  c.nRN,
  a.nfaceacc,
  a.sfaceacc

  
  
-- ������ ������������
SELECT /*+ ORDERED */
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn) AS NB_NAME, -- ���������
  a.NRN AS ZAYV_RN, -- �����
  b.smodif_name AS NOMMODIF_NAME, -- ����������� ��������
  b.nnomen AS DICNOMNS_RN, -- �������
  b.nnom_modif AS NOMMODIF_RN, -- �����������
  c.nPRN AS CONTRACTS_RN, -- �������
  c.nRN AS STAGES_RN, -- ���� ��������
  a.nfaceacc AS FACEACC_RN, -- ������� ����
  a.sfaceacc AS FACEACC_CODE,
  a.ndisp_type AS TIP_OTGR_RN, -- ��� ���������������
  a.sdisp_type AS TIP_OTGR_NAME,
  a.npay_type AS PAYTYPE_RN, -- ����� ������
  a.spay_type AS PAYTYPE_NAME,
  a.nagnfi AS POLUCH_RN, -- ���������������
  a.sagnfiname AS POLUCH_NAME,
  SUM(b.nALT_QUANT) AS ZAYV_VES -- ����������� ���
FROM V_CONSUMERORD a, V_CONSUMERORDS b, V_STAGES c
WHERE b.nPRN = a.nRN
  AND b.nnom_type=1
  AND a.nFACEACC = c.nFACEACC (+) 
  AND a.dord_date BETWEEN TO_DATE('01.01.2003','dd.mm.yyyy') AND TO_DATE('31.01.2003','dd.mm.yyyy')
  AND a.sstore NOT IN ('����� ����� ���','���_���','029�')
  AND (a.sstore NOT LIKE '%_��' OR a.sstore='���������_���_��')
GROUP BY
  GET_NAME_ROOT_CATALOG_PSV(a.nfcacgrcrn),
  a.NRN,
  b.smodif_name,
  b.nnomen,
  b.nnom_modif,
  c.nPRN,
  c.nRN,
  a.nfaceacc,
  a.sfaceacc,
  a.ndisp_type,
  a.sdisp_type,
  a.npay_type,
  a.spay_type,
  a.nagnfi,
  a.sagnfiname

  