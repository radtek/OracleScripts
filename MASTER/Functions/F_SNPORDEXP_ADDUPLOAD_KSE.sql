--
-- F_SNPORDEXP_ADDUPLOAD_KSE  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.F_SNPORDEXP_ADDUPLOAD_KSE(
  sUserName varchar2
) return number as
  pragma AUTONOMOUS_TRANSACTION;

  nUploadId T_SNPORDEXP_UPLOAD_KSE.UPLOADID%type;
begin
insert into T_SNPORDEXP_UPLOAD_KSE(UPLOADID, DATETIME, USERNAME)
values ((select nvl(max(UPLOADID), 0)+1 from T_SNPORDEXP_UPLOAD_KSE),
        sysdate, sUserName)
returning UPLOADID into nUploadId;
commit;

return nUploadId;
end F_SNPORDEXP_ADDUPLOAD_KSE;

/

