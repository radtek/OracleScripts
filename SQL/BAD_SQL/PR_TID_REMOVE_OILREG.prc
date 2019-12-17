CREATE OR REPLACE procedure PR_TID_REMOVE_OILREG
(
  nRN in number,
  nCOMPANY in number
)
as


begin

for C in
(
select /*+ ORDERED */
R.RN
 from TRANSINVDEPT T, DOCINPT I, DOCLINKS L, DOCOUTPT O, OILINREG R
where T.RN=nRN and I.DOCUMENT=nRN and I.UNITCODE='GoodsTransInvoicesToDepts'
and I.RN=L.IN_DOC and O.RN=L.OUT_DOC
and O.UNITCODE='OilIncomeRegistry' and O.DOCUMENT=R.RN
)
loop

P_LINKSALL_REMOVE(nCOMPANY, 'GoodsTransInvoicesToDepts', nRN,  'OilIncomeRegistry',  C.RN);
P_OILINREG_BASE_DELETE(  nCOMPANY,  C.RN);

end loop;


end;
/

