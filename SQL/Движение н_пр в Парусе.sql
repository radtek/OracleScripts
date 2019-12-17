/* Остатки на конец последней смены на АЗС - по сменным отчетам */
select /*+ RULE INDEX(sm C_AZSAZSSMLIST_PK) INDEX(rr) */ 
  :beg_date as BEG_DATE, -- С даты
  :end_date as END_DATE, -- По дату
  rm.DATE_SMENA as LAST_SMENA, -- Дата последней смены
  rm.AZS_NUMBER as AZS_RN, -- Склад (АЗС) AZSAZSLISTMT
  rr.NOMEN as NOMEN_RN, -- Продукт DICNOMNS
  sm.SM_NUMBER, -- № последней смены
  sm.SM_BEGIN, -- Время начала последней смены
  sm.SM_END, -- Время окончания последней смены 
  SUM(rr.FACT_VOLUME) as END_VOLUME, -- Фактический остаток - Объем
  SUM(rr.FACT_MASS) as END_MASSA, -- Фактический остаток - Масса
  SUM(rr.FACT_FULL) as END_FULL, -- Фактический остаток - Уровень
  SUM(rr.FACT_WATER) as END_WATER -- Фактический остаток - Уровень воды
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

/* Внешний приход на АЗС - по сменным отчетам */
select /*+ RULE */ 
  rm.AZS_NUMBER as AZS_RN, -- Склад (АЗС) AZSAZSLISTMT
  ri.NOMEN as NOMEN_RN, -- Продукт DICNOMNS
  ri.INTYPE as IN_TYPE, -- Вид складской операции AZSGSMWAYSTYPES
  way.GSMWAYS_TYPE as IN_TYPE_TYPE, -- Тип складской операции (1-приход, 0-расход)
  way.SECTION as IN_TYPE_SECTION, -- Тип перемещения (0-внешнее, 1-внутреннее)
  ri.AGENT as IN_AGENT, -- Постащик AGNLIST 
  ri.VOLUME as IN_VOLUME, -- Объем
  ri.MASSA as IN_MASSA -- Масса
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

/* Внешний расход с АЗС - по сменным отчетам */
select /*+ RULE */ 
  rm.AZS_NUMBER as AZS_RN, -- Склад (АЗС) AZSAZSLISTMT
  ro.NOMEN as NOMEN_RN, -- Продукт DICNOMNS
/*  ro.OUTTYPE as OUT_TYPE, -- Вид складской операции AZSGSMWAYSTYPES
  way.GSMWAYS_MNEMO as OUT_TYPE_MNEMO,
  way.GSMWAYS_TYPE as IN_TYPE_TYPE, -- Тип складской операции (1-приход, 0-расход)
  way.SECTION as IN_TYPE_SECTION, -- Тип перемещения (0-внешнее, 1-внутреннее)
  way.KEEP_SIGN, -- Признак ответхранения (0-нет, 1-да)
  ro.PAYTYPE, -- Форма оплаты AZSGSMPAYMENTSTYPES
  pt.GSMPAYMENTS_MNEMO,
  ro.SHIPTYPE, -- Вид отгрузки DICSHPVW
  ro.PRICE, -- Цена */
  SUM(ro.VOLUME) as OUT_VOLUME, -- Объем
  SUM(ro.MASSA) as OUT_MASSA, -- Масса
  SUM(ro.SUMM) as OUT_SUMMA -- Сумма
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
  

  
/* Текущий остаток на складе - по */  


 
/* Приход на склад - по исходящим ТТН на внутреннее перемещение */
SELECT /*+ RULE */ 
  t.IN_STORE as STORE_RN, -- Склад AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- Продукт DICNOMNS
  ts.GOODSPARTY,
  id.AGENT as SUPPLIER_RN,
  gp.PRODUCER,
  way.GSMWAYS_TYPE,
  t.IN_STOPER,
  t.FACEACC,
  DECODE(t.STATUS,0,0,2) as STATUS,
  ts.PRICE,
  SUM(ts.QUANT) as VOLUME, -- Объем
  SUM(ts.QUANTALT) as MASSA, -- Масса
  SUM(ts.SUMMWITHNDS) as SUMMA -- Сумма
FROM
  transinvdeptspecs ts, goodsparties gp, transinvdept t, incomdoc id, NOMMODIF nm, dicnomns dn, DICGNOMN grp, AZSGSMWAYSTYPES way
WHERE t.rn=ts.prn AND ts.NOMMODIF=nm.RN AND nm.prn=dn.RN AND dn.GROUP_CODE=grp.RN AND ts.GOODSPARTY=gp.RN AND gp.INDOC=id.RN AND t.IN_STOPER=way.RN AND way.GSMWAYS_TYPE=1 AND grp.CRN IN (174026631, 168905090)
  and t.DOCDATE>=:beg_date
  and t.DOCDATE<=:end_date 
group by 
  t.IN_STORE, dn.RN, ts.GOODSPARTY, id.AGENT, gp.PRODUCER, way.GSMWAYS_TYPE, t.IN_STOPER, t.FACEACC, DECODE(t.STATUS,0,0,2), ts.PRICE

/* Приход на склад - по входящим приходным ордерам - отработанным как факт */
SELECT /*+ RULE */ 
  io.nSTORE as STORE_RN, -- Склад AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- Продукт DICNOMNS
  io.*
/*  SUM(ios.FACTQUANT) as IN_VOLUME, -- Объем
  SUM(ios.FACTQUANTALT) as IN_MASSA, -- Масса
  SUM(io.nFACTSUMTAX) as IN_SUMMA -- Сумма*/
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
  
/* Расход со склада - по исходящим ТТН на внутреннее перемещение */
SELECT /*+ RULE */ 
  t.STORE as STORE_RN, -- Склад AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- Продукт DICNOMNS
  SUM(ts.QUANT) as OUT_VOLUME, -- Объем
  SUM(ts.QUANTALT) as OUT_MASSA, -- Масса
  SUM(ts.SUMMWITHNDS) as OUT_SUMMA -- Сумма
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


/* Расход со склада - по исходящим ТТН на продажу */
SELECT /*+ RULE */ 
  t.STORE as STORE_RN, -- Склад AZSAZSLISTMT
  dn.RN as NOMEN_RN, -- Продукт DICNOMNS
  SUM(ts.QUANT) as OUT_VOLUME, -- Объем
  SUM(ts.QUANTALT) as OUT_MASSA, -- Масса
  SUM(ts.SUMMWITHNDS) as OUT_SUMMA -- Сумма
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



м_штщквукы