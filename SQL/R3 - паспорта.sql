select r3_kvit2sap.ID_SAP as r3_num_post,--Номер поставки SAP 
r3_kvit2sap.ID_SAP_PSN as r3_post_pos,--Номер позиции поставки
kls_pasp.PASP_NUM as CQ_NUM,--N сертификата качества
'ЛУКОЙЛ-УНП' as CQ_INSP_NAME,--Наименование инспектора kls_kodif
kls_pasp.PASP_DATE as CQ_DATE_INSP,--Дата инспекции
for_pasp.GET_PASP_VALUE_BY_TAG(kvit.PASP_ID, 'PL20') as Z0000001,--Плотность при 20 оС ( г/см3)
for_pasp.GET_PASP_VALUE_BY_TAG(kvit.PASP_ID, 'p_vod') as Z0000011,--Массовая доля воды
for_pasp.GET_PASP_VALUE_BY_TAG(kvit.PASP_ID, 'p_ser') as Z0000018,--Массовая доля серы (%)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000028') as Z0000028,--Кислотность (мгКОН/100см3)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000059') as Z0000059,--Содержание масла (%масс.)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000078') as Z0000078,--Вязк.усл.при 80оС
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000079') as Z0000079,--Пред.тем.фильтруемости (оС)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000229') as Z0000229,--Зольность (% масс.)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000219') as Z0000219,--Содержание свинца
for_pasp.GET_PASP_VALUE_BY_TAG(kvit.PASP_ID, 't_vsp') as Z0000005,--Тем.всп.в закр.тигле (оС)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000006') as Z0000006,--Температура застывания (оС)
for_pasp.GET_PASP_VALUE_BY_TAG(kvit.PASP_ID, 'p_dirt') as Z0000007,--Мас.доля механ. примесей (%)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000008') as Z0000008,--Содержание никеля мг/кг (ppm)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000012') as Z0000012,--Содержание железа мг/кг (ppm)
for_pasp.GET_PASP_VALUE_BY_R3(kvit.PASP_ID, 'Z0000013') as Z0000013--Содержание натрия мг/кг (ppm)
from kls_pasp,kvit,r3_kvit2sap
where kvit.PASP_ID=kls_pasp.ID
	  and kvit.ID=r3_kvit2sap.KVIT_ID
	  and kvit.DATE_KVIT>=:BegDate--выбираем только квитанции за период
	  and kvit.DATE_KVIT<=:EndDate
      and kvit.NUM_CIST LIKE '%'



select * from
(
select /*+ RULE */ r3_kvit2sap.ID_SAP, r3_kvit2sap.ID_SAP_PSN,'CQ_NUM' as QQ_NAME,kls_pasp.PASP_NUM as QQ_VALUE from kls_pasp,r3_kvit2sap,kvit
where kvit.PASP_ID=kls_pasp.ID
	  and kvit.ID=r3_kvit2sap.KVIT_ID
	  and kvit.DATE_KVIT>=:BegDate--выбираем только квитанции за период
	  and kvit.DATE_KVIT<=:EndDate
    and kvit.NUM_CIST LIKE '%'
union all
select r3_kvit2sap.ID_SAP as r3_num_post, r3_kvit2sap.ID_SAP_PSN as r3_post_pos,'CQ_INSP_NAME','ЛУКОЙЛ-УНП' from kls_pasp,kvit,r3_kvit2sap
where kvit.PASP_ID=kls_pasp.ID
	  and kvit.ID=r3_kvit2sap.KVIT_ID
	  and kvit.DATE_KVIT>=:BegDate--выбираем только квитанции за период
	  and kvit.DATE_KVIT<=:EndDate
    and kvit.NUM_CIST LIKE '%'
union all
select r3_kvit2sap.ID_SAP as r3_num_post, r3_kvit2sap.ID_SAP_PSN as r3_post_pos,'CQ_DATE_INSP',to_char(kls_pasp.PASP_DATE,'dd.mm.yyyy')
from kls_pasp,r3_kvit2sap,kvit
where kvit.PASP_ID=kls_pasp.ID
	  and kvit.ID=r3_kvit2sap.KVIT_ID
	  and kvit.DATE_KVIT>=:BegDate--выбираем только квитанции за период
	  and kvit.DATE_KVIT<=:EndDate
    and kvit.NUM_CIST LIKE '%'
union all


select distinct
kls_kodif.ID_R3,
kls_kodif.NAME,
kls_kodif.id
from kls_pasp,kls_valpasp,kls_kodif,kvit,month
where kls_pasp.ID=kls_valpasp.PASP_ID
	  and kls_valpasp.KODIF_ID=kls_kodif.ID
	  and kvit.PASP_ID=kls_pasp.ID
	  and kvit.DATE_KVIT>=:BegDate--выбираем только квитанции за период
	  and kvit.DATE_KVIT<=:EndDate
	  and kvit.nom_zd=month.nom_zd
	  and month.is_exp+0=1

)
order by id_sap,id_sap_psn




kls_kodif