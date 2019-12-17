CREATE OR REPLACE procedure PR_CORRSTPLREST (nRN in number,
nONLY in number -- 0 - все 1 осн 2 доп
 )
 is
nSPECRN number(17);nQUANT number(17,3);  nQUANTALT number(17,3); nCELL number(17);
 nDQUANT number(17,3);  nDQUANTALT number(17,3); nSTPL_RN number(17);nNOMMODIF number(17);

begin
-- 0 - расход, 1 - приход
for H in (
select W1.*,A.GSMWAYS_TYPE from WROFFACTS W1,AZSGSMWAYSTYPES A   where W1.rn=NRN and A.Rn=W1.STOPER)
loop
for C in (
select *
from
(select G.RN,G.RESTFACT, G.RESTFACTALT, SUM(SG.QUANT) QUANT, SUM(SG.QUANTALT) QUANTALT
from GOODSSUPPLY G, AZSAZSLISTMT A, STPLGOODSSUPPLY SG
 where G.STORE=A.RN and A.STORE_TYPE=2 and A.RN=H.STORE  and G.RN=SG.GOODSSUPPLY
  group by G.RN,G.RESTFACT, G.RESTFACTALT) M
 where 
 ((nONLY =0 and ((H.GSMWAYS_TYPE=0 and RESTFACT<QUANT and RESTFACTALT<QUANTALT and QUANT>0) 
                 or (H.GSMWAYS_TYPE=1 and RESTFACT>QUANT and RESTFACTALT>QUANTALT  )
                 )
   ) or (nONLY = 1 and ((H.GSMWAYS_TYPE=0 and RESTFACT<QUANT and QUANT>0) 
                  or (H.GSMWAYS_TYPE=1 and RESTFACT>QUANT))
   ) or (nONLY = 2 and ((H.GSMWAYS_TYPE=0 and RESTFACTALT<QUANTALT and QUANTALT>0) 
                  or (H.GSMWAYS_TYPE=1 and RESTFACTALT>QUANTALT))
   )
 )
 and not exists (select * from WROFFACTSPECS W where W.PRN=nRN and W.GOODSSUPPLY=M.RN ))
loop
  select GP.NOMMODIF into nNOMMODIF from GOODSSUPPLY GS, GOODSPARTIES GP where GP.RN=GS.PRN and GS.RN=C.RN;
  
  if H.GSMWAYS_TYPE=0 then
  
    if C.RESTFACT<=0 and nONLY!=2 then nQUANT:=C.QUANT; else nQUANT:=C.QUANT-C.RESTFACT; end if;
    if C.RESTFACTALT<=0 and nONLY!=1 then nQUANTALT:=C.QUANTALT; else nQUANTALT:=C.QUANTALT-C.RESTFACTALT; end if;
  
    P_WROFFACTSPECS_BASE_INSERT(2,nRN,C.RN,  nNOMMODIF,  null,  null,
    nQUANT,  nQUANTALT,
    0,
    0,
    0,
    null,  nSPECRN);
  
    for L in (select * from STPLGOODSSUPPLY where GOODSSUPPLY=C.RN and ((nONLY!=2 and QUANT>0 )
    or (nONLY!=1 and QUANTALT>0)))
        loop 
        if L.QUANT>nQUANT and nONLY!=2  then       nDQUANT:=nQUANT;  else
         nDQUANT:=L.QUANT; nQUANT:=nQUANT-L.QUANT; 
        end if;
        if L.QUANTALT>nQUANTALT and nONLY!=1 then        ndQUANTALT:=nQUANTALT; else
         ndQUANTALT:=L.QUANTALT; nQUANTALT:=nQUANTALT-L.QUANTALT;
        end if;
        if nDQUANT<0 or nDQUANTALT<0 then P_EXCEPTION(0,L.CELL||' '||L.GOODSSUPPLY);end if;
        P_STRPLRESJRNL_BASE_INSERT
        (H.COMPANY,'WriteOffActs','WriteOffActsSpecs',H.RN,nSPECRN,null/*RACK*/,
        L.CELL,      L.GOODSSUPPLY,1, null,H.DOCTYPE, H.DOCDATE,  H.DOCPREF,  H.DOCNUMB,
        sysdate, null,(nDQUANT), (nDQUANTALT), null, nSTPL_RN );
              /* отработка зарезервированного места хранения */
        P_STRPLRESJRNL_PROCESS( H.COMPANY, nSTPL_RN );
        end loop; 
  else

    if  nONLY!=2 then  nQUANT:=C.RESTFACT - C.QUANT; else nQUANT:=0; end if;
    if  nONLY!=1 then nQUANTALT:=C.RESTFACTALT - C.QUANTALT; else nQUANTALT:=0; end if;
  
     
    begin
    select CELL into nCELL from STPLGOODSSUPPLY where GOODSSUPPLY=C.RN and ((nONLY!=2 and QUANT<C.RESTFACT )
    or (nONLY!=1 and QUANTALT<C.RESTFACTALT));
    exception
    when NO_DATA_FOUND then
    nCELL:=null;
    when TOO_MANY_ROWS then
    nCELL:=null;
    end;
    
     if nCELL is not null then
        P_WROFFACTSPECS_BASE_INSERT(2,nRN,C.RN,  nNOMMODIF,  null,  null,
        nQUANT,  nQUANTALT,
        0,
        0,
        0,
        null,  nSPECRN);

        P_STRPLRESJRNL_BASE_INSERT
        (H.COMPANY,'WriteOffActs','WriteOffActsSpecs',H.RN,nSPECRN,null/*RACK*/,
        nCELL, C.RN,0, null,H.DOCTYPE, H.DOCDATE,  H.DOCPREF,  H.DOCNUMB,
        sysdate, null,(nQUANT), (nQUANTALT), null, nSTPL_RN );
              /* отработка зарезервированного места хранения */
        P_STRPLRESJRNL_PROCESS( H.COMPANY, nSTPL_RN );
     end if;
  
  end if;
end loop;
end loop;
end;
/

