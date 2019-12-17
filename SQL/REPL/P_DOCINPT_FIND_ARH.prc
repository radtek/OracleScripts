CREATE OR REPLACE procedure P_DOCINPT_FIND
(
nFLAG_SMART    in number,
nCOMPANY       in number,
sUNITCODE      in varchar2,
nDOCUMENT      in number,
nRESULT       out number,
nCHECK_BREAKUP in number default 0
)
as
nRN_FIND      number( 17 );
nBREAKUP_KIND number( 1 );
nTEMP_FLAG    number( 1 ) :=NVL(nFLAG_SMART, 0);
begin
/* инициализация */
nRN_FIND := null;
/* поиск записи */
begin
select /*+ INDEX(DOCINPT C_DOCINPT_UK) */ RN, BREAKUP_KIND
into nRN_FIND, nBREAKUP_KIND
from DOCINPT
where UNITCODE = sUNITCODE
and DOCUMENT = nDOCUMENT;
exception
when NO_DATA_FOUND then nRN_FIND := null;
end;
if ( nRN_FIND is not null ) then
/* если необходимо снять контроль и запись имеет на это разрешение,
то сменить режим с предупредительного на информационный */
if nCHECK_BREAKUP =1 and nBREAKUP_KIND =1 and nTEMP_FLAG = 0 then
nTEMP_FLAG :=1;
end if;
/* PSV 13.09.2004 связи проверям только по документам,
  созданным в Архангельске */
IF nDOCUMENT>=90000000000000 THEN 
  P_DOCLINKS_FINDERR( nTEMP_FLAG, 0, sUNITCODE, nDOCUMENT );
END IF;  
end if;
/* установка результата */
nRESULT := nRN_FIND;
end;
/
