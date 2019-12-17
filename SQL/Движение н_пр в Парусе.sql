/* ������� �� ����� ��������� ����� �� ��� - �� ������� ������� */
select /*+ RULE INDEX(sm C_AZSAZSSMLIST_PK) INDEX(rr) */ 
  :beg_date as BEG_DATE, -- � ����
  :end_date as END_DATE, -- �� ����
  rm.DATE_SMENA as LAST_SMENA, -- ���� ��������� �����
  rm.AZS_NUMBER as AZS_RN, -- ����� (���) AZSAZSLISTMT
  rr.NOMEN as NOMEN_RN, -- ������� DICNOMNS
  sm.SM_NUMBER, -- � ��������� �����
  sm.SM_BEGIN, -- ����� ������ ��������� �����
  sm.SM_END, -- ����� ��������� ��������� ����� 
  SUM(rr.FACT_VOLUME) as END_VOLUME, -- ����������� ������� - �����
  SUM(rr.FACT_MASS) as END_MASSA, -- ����������� ������� - �����
  SUM(rr.FACT_FULL) as END_FULL, -- ����������� ������� - �������
  SUM(rr.FACT_WATER) as END_WATER -- ����������� ������� - ������� ����
from  
  azssreportrelate rr,
  azssreportmain rm,
  azsazssmlist sm
where rm.rn=rr.prn
  and rm.AZS_SMENA=sm.rn
  and TO_CHAR(rm.DATE_smena,'yyyymmdd')||sm.SM_BEGIN||sm.SM_NUMBER = 
    (SELECT /*+ INDEX(sm_a C_AZSAZSSMLIST_PK)*/ MAX(TO_CHAR(rm_a.DATE_smena,'yyyymmdd')||sm_a.SM_BEGIN||sm_a.SM_NUMBER) 
	   FROM azssreportmain rm_a, azsazssmlist sm_a 
	  WHERE rm_a.AZS_SMENA=sm_a.rn 
        AND rm_a.DATE_smena<=:end_date
		AND rm_a.AZS_NUMBER=rm.AZS_NUMBER)
GROUP BY
  rm.DATE_SMENA, 
  rm.AZS_NUMBER, 
  rr.NOMEN,
  sm.SM_NUMBER,
  sm.SM_BEGIN,
  sm.SM_END 

/* ������� ������ �� ��� - �� ������� ������� */
select /*+ RULE */ 
  rm.AZS_NUMBER as AZS_RN, -- ����� (���) AZSAZSLISTMT
  ri.NOMEN as NOMEN_RN, -- ������� DICNOMNS
  ri.INTYPE as IN_TYPE, -- ��� ��������� �������� AZSGSMWAYSTYPES
  way.GSMWAYS_TYPE as IN_TYPE_TYPE, -- ��� ��������� �������� (1-������, 0-������)
  way.SECTION as IN_TYPE_SECTION, -- ��� ����������� (0-�������, 1-����������)
  ri.AGENT as IN_AGENT, -- �������� AGNLIST 
  ri.VOLUME as IN_VOLUME, -- �����
  ri.MASSA as IN_MASSA -- �����
from  
  azsrepin ri,
  azssreportmain rm,
  AZSGSMWAYSTYPES way
where rm.rn=ri.prn
  and rm.AZS_NUMBER=108382766
  and ri.INTYPE=way.RN
  and way.GSMWAYS_TYPE=1
  and way.SECTION=0
  and rm.DATE_smena>=:beg_date
  and rm.DATE_smena<=:end_date 

group by 
  rm.AZS_NUMBER,
  ri.NOMEN

/* ������� ������ � ��� - �� ������� ������� */
select /*+ RULE */ 
  rm.AZS_NUMBER as AZS_RN, -- ����� (���) AZSAZSLISTMT
  ro.NOMEN as NOMEN_RN, -- ������� DICNOMNS
/*  ro.OUTTYPE as OUT_TYPE, -- ��� ��������� �������� AZSGSMWAYSTYPES
  way.GSMWAYS_MNEMO as OUT_TYPE_MNEMO,
  way.GSMWAYS_TYPE as IN_TYPE_TYPE, -- ��� ��������� �������� (1-������, 0-������)
  way.SECTION as IN_TYPE_SECTION, -- ��� ����������� (0-�������, 1-����������)
  way.KEEP_SIGN, -- ������� ������������� (0-���, 1-��)
  ro.PAYTYPE, -- ����� ������ AZSGSMPAYMENTSTYPES
  pt.GSMPAYMENTS_MNEMO,
  ro.SHIPTYPE, -- ��� �������� DICSHPVW
  ro.PRICE, -- ���� */
  SUM(ro.VOLUME) as OUT_VOLUME, -- �����
  SUM(ro.MASSA) as OUT_MASSA, -- �����
  SUM(ro.SUMM) as OUT_SUMMA -- �����
from  
  azsrepout ro,
  azssreportmain rm,
  AZSGSMWAYSTYPES way,
  AZSGSMPAYMENTSTYPES pt
where rm.rn=ro.prn
  and ro.OUTTYPE=way.RN
  and ro.PAYTYPE=pt.RN
  and way.GSMWAYS_TYPE=0
  and way.SECTION=0
  and rm.DATE_smena>=:beg_date
  and rm.DATE_smena<=:end_date 
group by 
  rm.DATE_SMENA,
  rm.AZS_NUMBER,
  ro.NOMEN
/*  ro.OUTTYPE,
  way.GSMWAYS_MNEMO,
  way.GSMWAYS_NAME,
  way.GSMWAYS_TYPE,
  way.SECTION,
  way.KEEP_SIGN,
  ro.PAYTYPE,
  pt.GSMPAYMENTS_MNEMO,
  pt.GSMPAYMENTS_NAME,
  ro.SHIPTYPE,
  ro.PRICE*/
  

  
/* ������� ������� �� ������ - �� */  


 
/* ������ �� ����� - �� ��������� ��� �� ���������� ����������� */
SELECT /*+ RULE */ 
  t.IN_STORE as STORE_RN, -- ����� AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- ������� DICNOMNS
  ts.GOODSPARTY,
  id.AGENT as SUPPLIER_RN,
  gp.PRODUCER,
  way.GSMWAYS_TYPE,
  t.IN_STOPER,
  t.FACEACC,
  DECODE(t.STATUS,0,0,2) as STATUS,
  ts.PRICE,
  SUM(ts.QUANT) as VOLUME, -- �����
  SUM(ts.QUANTALT) as MASSA, -- �����
  SUM(ts.SUMMWITHNDS) as SUMMA -- �����
FROM
  transinvdeptspecs ts, goodsparties gp, transinvdept t, incomdoc id, NOMMODIF nm, dicnomns dn, DICGNOMN grp, AZSGSMWAYSTYPES way
WHERE t.rn=ts.prn AND ts.NOMMODIF=nm.RN AND nm.prn=dn.RN AND dn.GROUP_CODE=grp.RN AND ts.GOODSPARTY=gp.RN AND gp.INDOC=id.RN AND t.IN_STOPER=way.RN AND way.GSMWAYS_TYPE=1 AND grp.CRN IN (174026631, 168905090)
  and t.DOCDATE>=:beg_date
  and t.DOCDATE<=:end_date 
group by 
  t.IN_STORE, dn.RN, ts.GOODSPARTY, id.AGENT, gp.PRODUCER, way.GSMWAYS_TYPE, t.IN_STOPER, t.FACEACC, DECODE(t.STATUS,0,0,2), ts.PRICE

/* ������ �� ����� - �� �������� ��������� ������� - ������������ ��� ���� */
SELECT /*+ RULE */ 
  io.nSTORE as STORE_RN, -- ����� AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- ������� DICNOMNS
  io.*
/*  SUM(ios.FACTQUANT) as IN_VOLUME, -- �����
  SUM(ios.FACTQUANTALT) as IN_MASSA, -- �����
  SUM(io.nFACTSUMTAX) as IN_SUMMA -- �����*/
FROM
  inorderspecs ios,
  v_inorders io,
  dicnomns dn,
  NOMMODIF nm,
  DICGNOMN grp,
  vaneev.v_dicstore_psv ds
WHERE io.nrn=ios.prn
  AND ios.NOMMODIF=nm.RN
  AND nm.prn=dn.RN
  AND dn.GROUP_CODE=grp.RN
  AND grp.CRN IN (174026631, 168905090)
  AND io.nSTORE=ds.nRN
  AND io.nDOCSTATUS=2 
  and io.dINDOCDATE>=:beg_date
  and io.dINDOCDATE<=:end_date 

group by 
  io.STORE,
  ds.SNAME,
  dn.RN
  
/* ������ �� ������ - �� ��������� ��� �� ���������� ����������� */
SELECT /*+ RULE */ 
  t.STORE as STORE_RN, -- ����� AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- ������� DICNOMNS
  SUM(ts.QUANT) as OUT_VOLUME, -- �����
  SUM(ts.QUANTALT) as OUT_MASSA, -- �����
  SUM(ts.SUMMWITHNDS) as OUT_SUMMA -- �����
FROM
  transinvdeptspecs ts,
  transinvdept t,
  dicnomns dn,
  NOMMODIF nm
WHERE t.rn=ts.prn
  AND ts.NOMMODIF=nm.RN
  AND nm.prn=dn.RN
  and t.DOCDATE>=:beg_date
  and t.DOCDATE<=:end_date 
group by 
  t.STORE,
  dn.RN


/* ������ �� ������ - �� ��������� ��� �� ������� */
SELECT /*+ RULE */ 
  t.STORE as STORE_RN, -- ����� AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- ������� DICNOMNS
  SUM(ts.QUANT) as OUT_VOLUME, -- �����
  SUM(ts.QUANTALT) as OUT_MASSA, -- �����
  SUM(ts.SUMMWITHNDS) as OUT_SUMMA -- �����
FROM
  transinvcustspecs ts,
  transinvcust t,
  dicnomns dn,
  NOMMODIF nm
WHERE t.rn=ts.prn
  AND ts.NOMMODIF=nm.RN
  AND nm.prn=dn.RN
  and t.DOCDATE>=:beg_date
  and t.DOCDATE<=:end_date 
group by 
  t.STORE,
  dn.RN

 

 
STROPERJRN_D



�_��������