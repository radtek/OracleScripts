alter table PARUS.INCOMDOC drop constraint C_INCOMDOC_CODE_UK;
 
CREATE INDEX PARUS.C_INCOMDOC_CODE_UK ON PARUS.INCOMDOC
(CODE, COMPANY)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;




CREATE OR REPLACE procedure P_INCOMDOC_BASE_INSERT
(
nCOMPANY      in number,
nJUR_PERS     in number,
sCODE         in varchar2,
nAGENT        in number,
nSUBDIV       in number,
dENTRY_DATE   in date,
nOUT_PARTY    in number,
nSTOR_SIGN    in number,
nCOMMIS_SIGN  in number,
nRN          out number
)
as
newRN         INCOMDOC.RN%TYPE;
vTmp NUMBER;
begin
/* генерация регистрационного номера */
newRN := gen_id;
/* PSV 16.09.2004 контроль уникальности */
BEGIN
  vTmp:=0;
  SELECT COUNT(*) INTO vTmp FROM INCOMDOC
  WHERE COMPANY=nCOMPANY
    AND CODE=sCODE;
EXCEPTION 
  WHEN OTHERS THEN
    vTmp:=0;
END;		
IF vTmp>0 THEN
  RAISE DUP_VAL_ON_INDEX;
END IF;  	  
/* добавление записи в таблицу */
insert into INCOMDOC ( RN, COMPANY, JUR_PERS, CODE, AGENT, SUBDIV, ENTRY_DATE, OUT_PARTY, STOR_SIGN, COMMIS_SIGN )
values ( newRN, nCOMPANY, nJUR_PERS, sCODE, nAGENT, nSUBDIV, dENTRY_DATE, nOUT_PARTY, nSTOR_SIGN, nCOMMIS_SIGN );
/* установка выходного регистрационного номера */
nRN := newRN;
end;
/






CREATE OR REPLACE procedure P_INCOMDOC_BASE_UPDATE
(
nCOMPANY    in number,
nRN         in number,
nJUR_PERS   in number,
sCODE       in varchar2,
nAGENT      in number,
nSUBDIV     in number,
dENTRY_DATE in date,
nOUT_PARTY  in number
)
as
vTmp NUMBER;
begin
/* PSV 16.09.2004 контроль уникальности */
BEGIN
  vTmp:=0;
  SELECT COUNT(*) INTO vTmp FROM INCOMDOC
  WHERE COMPANY=nCOMPANY
    AND CODE=sCODE
	AND RN<>nRN;
EXCEPTION 
  WHEN OTHERS THEN
    vTmp:=0;
END;		
IF vTmp>0 THEN
  RAISE DUP_VAL_ON_INDEX;
END IF;  	  
--
update INCOMDOC
set CODE       = sCODE,
JUR_PERS   = nJUR_PERS,
AGENT      = nAGENT,
SUBDIV     = nSUBDIV,
ENTRY_DATE = dENTRY_DATE,
OUT_PARTY  = nOUT_PARTY
where RN = nRN
and COMPANY = nCOMPANY;
if SQL%NOTFOUND then
P_EXCEPTION( 0,'Запись партии товара (RN: '||nvl(to_char(nRN),'<null>')||') не найдена.' );
end if;
end;
/
