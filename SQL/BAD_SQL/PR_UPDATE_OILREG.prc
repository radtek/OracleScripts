CREATE OR REPLACE procedure PR_UPDATE_OILREG
(
  nRN         in number,
  nCOMPANY    in number,
  SAZS_NUMBER in varchar2,    -- Номер склада
  SSM_NUMBER  in varchar2,    -- Номер смены
  SREZ_NUMBER in varchar2,    -- Номер резервуара
  SAGENT      in varchar2,    -- Поставщик
  SFACE_ACC   in varchar2,    -- Лицевой счет поставщика
  dDATA_PR        date,       -- Дата отработки прихода
  sTIME_PR      in varchar2,  -- Время отработки прихода
  sTRANS_TYPE   in varchar2,  -- Тип транспортного средства
  sTRANS_NUMBER in varchar2   -- Номер транспортного средства
)
as

nRN_AZS number(17);
nRN_SM number(17);
nRN_REZ number(17);
nRN_AGN number(17);
nRN_FCC number(17);
nRN_TR  number(17);

begin

FIND_DICSTORE_NUMB(0,nCOMPANY,sAZS_NUMBER,nRN_AZS);
FIND_AZSSMENA_BY_NUMBER(nRN_AZS,sSM_NUMBER,nRN_SM);
FIND_AZS_REZERVUAR_BY_NUMB(sREZ_NUMBER,nRN_AZS,nRN_REZ);
FIND_AGNLIST_BY_MNEMO(0,nCOMPANY,sAGENT,nRN_AGN);
FIND_FACEACC_BY_NUMB(nCOMPANY,sFACE_ACC,nRN_FCC);
FIND_DICCMRKS_BY_CODE(1,1,nCOMPANY,sTRANS_TYPE,nRN_TR);


Update OILINREG set  
       AZS_NUMBER = nRN_AZS,
       SM_NUMBER  = nRN_SM,
       REZ_NUMBER = nRN_REZ,
       AGENT      = nRN_AGN,
       FACE_ACC   = nRN_FCC,
       DATE_TIME  = s2dt(d2s(dDATA_PR) || ' ' || sTIME_PR),
       TRANS_TYPE = nRN_TR,
       TRANS_NUMBER= sTRANS_NUMBER
  
Where   RN = nRN and
        COMPANY = nCOMPANY;
end;
/

