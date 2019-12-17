--
-- ZADREP  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.ZadRep AS

       TYPE curstype IS REF CURSOR;

procedure PR_ZAD_END_PER
          (date1 varchar2, date2 varchar2, res IN OUT curstype);

procedure DEB_KRED_ZAD
          (date1 varchar2, date2 varchar2,res IN OUT curstype);

END ZadRep;

/

