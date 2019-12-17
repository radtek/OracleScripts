CREATE OR REPLACE PROCEDURE pr_oco_rash2 (
ncompany      IN   NUMBER,
ddate         IN   DATE,
scstore       IN   VARCHAR2,
prm_account   IN   VARCHAR2
--   prm_agent     IN   VARCHAR2
)
AS
ngroup_ident       NUMBER;
nident             NUMBER;
nPart              NUMBER;
scgroup_code       VARCHAR2 (20);
scnomen_code       VARCHAR2 (20);
scmodif_code       VARCHAR2 (20);
scpack             VARCHAR2 (20);
scparty            VARCHAR2 (20);
scnom_cat          VARCHAR2 (160);
scstore_cat        VARCHAR2 (160);
company            NUMBER;
ident              NUMBER;
blank              VARCHAR2 (20);
delimiter          VARCHAR2 (20);
date_from          DATE;
date_to            DATE;
prm_balunit        VARCHAR2 (20);
PRM_JUR_PERS       VARCHAR2 (20);
prm_currency       VARCHAR2 (20);
prm_agn_crn        VARCHAR2 (20);

prm_nomn_crn       VARCHAR2 (20);
prm_nomenclature   VARCHAR2 (20);
prm_partno         VARCHAR2 (20);
prm_indate         NUMBER;
prm_findate        DATE;
prm_tindate        DATE;
prm_balelemn       VARCHAR2 (20)  := NULL;
prm_with_specs     NUMBER         := 0;
result             NUMBER;
prm_agent          agnlist.agnabbr%type;
prm_accountc       VARCHAR2 (200);
scstorec       VARCHAR2 (200);
scstorecm       VARCHAR2 (200);

BEGIN
-- заменяем в стоке счета * на %
prm_accountc := replace(prm_account,'*','%');
scstorec := replace(scstore,'-','?');
If instr(scstore,'*')>0 then
scstorec := replace(scstorec,'*','');
scstorec := scstorec || ';' || scstorec || 'Ф';
end if;
If instr(scstore,';')>1 then
scstorecm := substr(scstore,1,instr(scstore,';')-1);
else
scstorecm := replace(scstore,'*','');
end if;
-- Вытаскиваем МОЛ склада
begin
select agn.agnabbr into prm_agent from azsazslistmt st, agnlist agn
where st.azs_agent = agn.rn and azs_number = scstorecm;
exception when NO_DATA_FOUND then
p_exception(0, 'Для склада "'||scstorecm||'" не определено МОЛ');
end;

-- Чистим ведомость остатков
DELETE
FROM stroperjrn_d
WHERE authid = USER;
commit;

p_stroperjrn_d (ncompany,
ddate,
ngroup_ident,
nident,
scgroup_code,
scnomen_code,
scmodif_code,
scpack,
scparty,
scnom_cat,
scstore_cat,
scstorec
);
commit;
-- Проверяем тип счета

select count(*) into nPart
from ACCTFORM a , DICACCS b
where a.numb = b.acc_form and a.IS_MaterialsPart = 1 and b.acc_number = 
prm_account;
-- Обнуляем партии, если счет не партионный
/*
IF nPart = 0
THEN
UPDATE stroperjrn_d SET party=NULL  WHERE authid = USER;
END IF;
*/
IF NOT prm_account IS NULL
THEN
DELETE
FROM valturns
WHERE authid = USER;
commit;
-- Создаем оборотку по ТМЦ
date_from := ddate;
date_to := ddate;
ident := nident;
blank := '()';
delimiter := ';';
prm_balunit := '';
PRM_JUR_PERS:='';
prm_currency := '';
prm_agn_crn := NULL;
prm_nomn_crn := NULL;
prm_nomenclature := '';
prm_partno := '';
prm_indate := 1;
prm_findate := NULL;
prm_tindate := NULL;
result := NULL;
p_valturns_create (ncompany,
ident,
blank,
delimiter,
date_from,
date_to,
prm_accountc,
prm_balunit,
PRM_JUR_PERS,
prm_currency,
prm_agn_crn,
prm_agent,
prm_nomn_crn,
prm_nomenclature,
prm_partno,
prm_indate,
prm_findate,
prm_tindate,
prm_balelemn,
prm_with_specs,
result
);
commit;
END IF;
END;
/

