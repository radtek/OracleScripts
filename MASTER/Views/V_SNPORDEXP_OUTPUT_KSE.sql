--
-- V_SNPORDEXP_OUTPUT_KSE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SNPORDEXP_OUTPUT_KSE
(CONTRACT1NUM, ORDROWCODE, ORDDATE, ORDNUM, DELIVDATE, 
 CUSTCODE, PAYERCODE, CONSIGNEECODE, USERCODE, CONTRACT2NUM, 
 CONTRACT2DATE, PRICECAT, PRODCODE, WEIGHT, VOLUME, 
 PRICENOTAX, UNIT, SHIPTYPE, DISPSTAN, ENDSTAN, 
 UNLOADTERM, CONTRACT3NUM_SUBA, CONTRACT3DATE_SUBA, SUPPLIERCODE_SUBA, PAYERCODE_SUBA, 
 SALEPRICENOTAX_SUBA, UNIT_SUBA, NOTE, SPECNOTE, LETTERNUM, 
 LETTERDATE, UNLOADTERM2, "orderid")
AS 
select luk_dog.isu_kod_dog as contract1num,
         zakaz_hist.id as ordrowcode, zakaz_hist.input_date as orddate,
         zakaz_hist.client_number/* ||'/'|| zakaz_hist.input_number*/ as ordnum,
         last_day(zakaz.date_plan) as delivdate,
         969 as custcode, payerpr.ksss_predpr_id as payercode,
         consignpr.ksss_predpr_id as consigneecode, userpr.ksss_predpr_id as usercode,
         ''/*kls_dog.isu_kod_dog*/ as contract2num, ''/*kls_dog.dog_date*/ as contract2date,
         '' as pricecat, kls_prod.ksss_prod_id as prodcode,
         zakaz_hist.load_ves as weight, 0 as volume,
         0 as pricenotax, 'Т' as unit,
         case kls_load_type.id
            when 1 then 3 when 6 then 3
            when 2 then 1
            when 3 then 5
            when 4 then 6
            else 0
         end as shiptype,
         case nvl(kls_stan.ksss_stan_id, 0)
           when 0 then null
           else 'RR11229'/*'2520'*/
         end as dispstan,
         kls_stan.isu_kod/*ksss_stan_id*/ as endstan, kls_vetka.vetka_name as unloadterm,
         '' as contract3num_suba, '' as contract3date_suba,
         0 as suppliercode_suba, 969/*payerpr.ksss_predpr_id*/ as payercode_suba,
         0 as salepricenotax_suba, '' as unit_suba,
         '' as note, '' as specnote, '' as letternum,
         '' as letterdate, '' as unloadterm2,
         zakaz_hist.id as orderid -- это поле всегда последнее, нужно для регистрации выгрузки
  from zakaz
       left join kls_dog luk_dog on luk_dog.id=zakaz.lukdog_id
       join zakaz_hist on zakaz_hist.zakaz_id=zakaz.id
       left join t_snpordexp_uploadord_kse uo on uo.orderid=zakaz_hist.id
       join kls_predpr payerpr on payerpr.id=zakaz.plat_id
       left join kls_predpr consignpr on consignpr.id=zakaz.poluch_id
       left join kls_predpr userpr on userpr.id=zakaz.potreb_id
       left join kls_dog on kls_dog.id=zakaz.dog_id
       join kls_prod on kls_prod.id_npr=zakaz.prod_id_npr
       join kls_vid_otgr on kls_vid_otgr.load_abbr=zakaz.load_abbr
       join kls_load_type on kls_load_type.id=kls_vid_otgr.load_type_id
       left join kls_stan on kls_stan.id=zakaz.stan_id
       left join kls_vetka on kls_vetka.id=zakaz.vetka_id
  where zakaz.is_agent=2 and zakaz_hist.status_zakaz_id=20 and
        uo.orderid is null;

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONTRACT1NUM IS 'Номер договора';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.ORDROWCODE IS 'Код строки разнарядки';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.ORDDATE IS 'Дата разнарядки';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.ORDNUM IS 'Номер разнарядки';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.DELIVDATE IS 'Период действия разнарядки. Дата начала действия разнарядки';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CUSTCODE IS 'Код КССС заказчика';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.PAYERCODE IS 'Код КССС плательщика по агентской схеме';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONSIGNEECODE IS 'Код КССС грузополучателя';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.USERCODE IS 'Код КССС потребителя';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONTRACT2NUM IS 'Юридический номер стороннего договора';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONTRACT2DATE IS 'Дата стороннего договора';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.PRICECAT IS 'Категория цены. Номер позиции ссылочного заказа на поставку — количество вагонов';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.PRODCODE IS 'Код КССС продукта';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.WEIGHT IS 'Общий вес заказа в кг';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.VOLUME IS 'Запланированный объём заказа в штуках (для фасовки)';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.PRICENOTAX IS 'Цена нетто без налогов, руб.';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.UNIT IS 'Продажная ЕИ: Т — тонна, КГ — килограмм, ШТ — штука, Л — литр';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.SHIPTYPE IS 'Вид отгрузки: 1 — автомобильный транс., 2 — МНПП, 3 — ж/д транс., 5 — водный транс., 6 — трубопроводный транс.';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.DISPSTAN IS 'Код станции, порта или терминала (для отгрузки по трубе) отправления в кодировке ЖД';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.ENDSTAN IS 'Код станции, порта или терминала (для отгрузки по трубе) назначения в кодировке ЖД';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.UNLOADTERM IS 'Пункт выгрузки. Примечание к разнарядке, если есть условия по подводу состава на определённую ветку';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONTRACT3NUM_SUBA IS 'Номер договора при реализации по субагентской схеме';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.CONTRACT3DATE_SUBA IS 'Дата договора, указанного в поле CONTRACT3NUM_SUBA';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.SUPPLIERCODE_SUBA IS 'Код КССС поставщика товара конечному клиенту';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.PAYERCODE_SUBA IS 'Плательщик по субагентской схеме. Код КССС клиента';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.SALEPRICENOTAX_SUBA IS 'Цена продажи по субагентской схеме без учёта налогов, руб.';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.UNIT_SUBA IS 'Продажная ЕИ по субагентской схеме: Т — тонна, КГ — килограмм, ШТ — штука, Л — литр';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.NOTE IS 'Примечание в заголовке, тексты';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.SPECNOTE IS 'Особые отметки в заголовке, тексты';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.LETTERNUM IS 'Номер письма в данных заказа на поставку';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.LETTERDATE IS 'Дата письма в данных заказа на поставку';

COMMENT ON COLUMN MASTER.V_SNPORDEXP_OUTPUT_KSE.UNLOADTERM2 IS 'Пункт выгрузки в доп. данных Б.';



