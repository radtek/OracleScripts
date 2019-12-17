CREATE OR REPLACE procedure       p_snp_AZSRM_ins_osv
(
 nCrn        number,
 nCompany    number,
 sAZS_number varchar2,
 dDate_smena date,
 nRn         out number,
 nBeg_Money  out number
)
as
 sAZS_PBE   varchar2(20);
 sF_MOL     varchar2(20);
 sS_MOL     varchar2(20);
 sT_MOL     varchar2(20);
 sAZS_smena varchar2(20) := '0D';
-- nRn_       number(17);
 nAZS       number(17);
 nChecked   number; 
 nTMP       number;
 sTMP       varchar2(40);
begin

 /* поиск по наименованию
    антрибутов для АЗС */
 find_dicstore_attr
  (
   nFLAG_SMART => 0,
   nFLAG_AZS   => 1,
   nCOMPANY    => nCompany,
   sNUMB       => sAZS_number,
   nRN         => nAZS,
   nMOL        => nTMP,
   sMOL        => sTMP,
   nPBE        => nTMP,
   sPBE        => sAZS_PBE,
   nCURRENCY   => nTMP,
   sCURRENCY   => sTMP
  )
 ;
 /* поиск по RN АЗС и мнемокоду СменыАЗС
    антрибутов для СменыАЗС              */
 find_azssmena_attr
  (
   nPRN       => nAZS,
   sSM_NUMBER => sAZS_smena,
   nRN        => nTMP,
   sSM_BEGIN  => sTMP,
   sSM_END    => sTMP,
   sF_MOL     => sF_MOL,
   sS_MOL     => sF_MOL,
   sT_MOL     => sT_MOL
  )
 ;
 /* вставка */
 p_AZSsReportMain_insert
  (
   nCRN        => nCrn,
   nCOMPANY    => nCompany,
   sAZS_NUMBER => sAZS_number,
   sAZS_SMENA  => sAZS_smena,
   sAZS_PBE    => sAZS_PBE,
   dDATE_SMENA => dDate_smena,
   nCHECKED    => nChecked,
   sF_MOL      => sF_MOL,
   sS_MOL      => sS_MOL,
   sT_MOL      => sT_MOL,
   nRN         => nRn,
   nBEG_MONEY  => nBeg_Money
  )
 ;
end;
/

