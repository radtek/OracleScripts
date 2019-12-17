CREATE OR REPLACE procedure       P_TRANSINVCUST_INSERT_IO
(
nCOMPANY     in number,
nCRN         in number,
sJUR_PERS    in varchar2,
sDOCTYPE     in varchar2,
sPREF        in varchar2,
sNUMB        in varchar2,
dDOCDATE     in date,
dSALEDATE    in date,
sACCDOC      in varchar2,
sACCNUMB     in varchar2,
dACCDATE     in date,
sDIRDOC      in varchar2,
sDIRNUMB     in varchar2,
dDIRDATE     in date,
sSTOPER      in varchar2,
sFACEACC     in varchar2,
sGRAPHPOINT  in varchar2,
sAGENT       in varchar2,
sTARIF       in varchar2,
nSERVACT_SIGN  in number,
sSTORE       in varchar2,
sMOL         in varchar2,
sSHEEPVIEW   in varchar2,
sPAYTYPE     in varchar2,
nDISCOUNT    in number,
sCURRENCY    in varchar2,
nCURCOURS    in number,
nCURBASE     in number,
nFA_COURS    in number,
nFA_BASECOURS  in number,
nSUMM        in number,
nSUMMWITHNDS in number,
sRECIPDOC    in varchar2,
sRECIPNUMB   in varchar2,
dRECIPDATE   in date,
sFERRYMAN    in varchar2,
sAGNFIFO     in varchar2,
sFORWARDER   in varchar2,
sWAYBLADENUMB  in varchar2,
sDRIVER      in varchar2,
sCAR         in varchar2,
sROUTE       in varchar2,
sTRAILER1    in varchar2,
sTRAILER2    in varchar2,
sCOMMENTS    in varchar2,
sACC_AGENT   in varchar2,
sSUBDIV      in varchar2,
nRN         out number,
sBARCODE    out varchar2,
sMSG        out varchar2
)
as
newRN        number( 17 );
nDOCTYPE     number( 17 );
nACCDOC      number( 17 );
nDIRDOC      number( 17 );
nSTOPER      number( 17 );
nFACEACC     number( 17 );
nGRAPHPOINT  number( 17 );
nAGENT       number( 17 );
nTARIF       number( 17 );
nSTORE       number( 17 );
nMOL         number( 17 );
nSHEEPVIEW   number( 17 );
nPAYTYPE     number( 17 );
nCURRENCY    number( 17 );
nRECIPDOC    number( 17 );
nFERRYMAN    number( 17 );
nAGNFIFO     number( 17 );
nDRIVER      number( 17 );
nCAR         number( 17 );
nROUTE       number( 17 );
nTRAILER1    number( 17 );
nTRAILER2    number( 17 );
nFORWARDER   number( 17 );
nACC_AGENT   number (17);
nSUBDIV      number (17);
nJUR_PERS    number (17);
nNeedReserv  number( 1 );
nCODE        number;
nRESULT      number;
begin
nRN := null;
/* фиксация начала выполнения действия */
PKG_ENV.PROLOGUE( nCOMPANY,null,nCRN,'GoodsTransInvoicesToConsumers','TRANSINVCUST_INSERT_IO','TRANSINVCUST' );
/* проверим необходимость резервирования */
-- Разрешено резервировать только при наличии настройки и отсутствии признака акта приемки работ/услуг
nNeedReserv := NVL(GET_OPTIONS_NUM('Realiz_InvCust_AutoReserv', nCOMPANY),0) * (1-nSERVACT_SIGN);
if (nNeedReserv = 1) then
/* фиксация начала выполнения действия */
PKG_ENV.SMART_ACCESS( nCOMPANY,null,nCRN,'GoodsTransInvoicesToConsumers','TRANSINVCUST_RESERV',nRESULT );
if nRESULT=0 then
P_EXCEPTION(0,'У вас нет прав на резервирование товара. Обратитесь к администратору.');
end if;
/* очиска буфера сообщений */
PKG_GOODS_CHECK.P_CLEAR_ERRORS;
end if;
/* разрешение ссылок */
P_TRANSINVCUST_JOINS( nCOMPANY, sJUR_PERS, nJUR_PERS, sDOCTYPE, nDOCTYPE, sACCDOC, nACCDOC, sDIRDOC, nDIRDOC, sSTOPER, nSTOPER,
sFACEACC, nFACEACC, sGRAPHPOINT, nGRAPHPOINT, sAGENT, nAGENT, sTARIF, nTARIF,
sSTORE, nSTORE, sMOL, nMOL, sSHEEPVIEW, nSHEEPVIEW, sPAYTYPE, nPAYTYPE, sCURRENCY, nCURRENCY,
sRECIPDOC, nRECIPDOC, sFERRYMAN, nFERRYMAN, sAGNFIFO, nAGNFIFO, sDRIVER, nDRIVER, sCAR, nCAR,
sROUTE, nROUTE, sTRAILER1, nTRAILER1, sTRAILER2, nTRAILER2, sFORWARDER, nFORWARDER,
sACC_AGENT, nACC_AGENT, sSUBDIV, nSUBDIV );
/* базовое добавление */
P_TRANSINVCUST_BASE_INSERT( nCOMPANY, nCRN, nJUR_PERS, nDOCTYPE, sPREF, sNUMB, dDOCDATE, dSALEDATE, nACCDOC, sACCNUMB, dACCDATE,
nDIRDOC, sDIRNUMB, dDIRDATE, nSTOPER, nFACEACC, nGRAPHPOINT, nAGENT, nTARIF, nSERVACT_SIGN, nSTORE, nMOL,
nSHEEPVIEW, nPAYTYPE, nDISCOUNT, nCURRENCY, nCURCOURS, nCURBASE, nFA_COURS, nFA_BASECOURS,
nSUMM, nSUMMWITHNDS, nRECIPDOC, sRECIPNUMB, dRECIPDATE, nFERRYMAN, nAGNFIFO, nFORWARDER,
sWAYBLADENUMB, nDRIVER, nCAR, nROUTE, nTRAILER1, nTRAILER2, sCOMMENTS, 1, nACC_AGENT, nSUBDIV, newRN );
/* установка выходного регистрационного номера */
nRN := newRN;
/* считывание штрих-кода */
select BARCODE into sBARCODE from TRANSINVCUST where RN = newRN;
/* установка значения предупреждения для пользователя */
if (nNeedReserv = 1) then
sMSG := null;
if (PKG_GOODS_CHECK.P_GET_ERRORS_COUNT <> 0) then
PKG_GOODS_CHECK.P_CHECK_RIGHTS ( 0, nCOMPANY, nCRN );
nCODE := PKG_GOODS_CHECK.P_GET_FIRST_ERROR_CODE;
sMSG  := PKG_GOODS_CHECK.P_GET_WARNING_TEXT;
end if;
end if;
/* фиксация окончания выполнения действия */
PKG_ENV.EPILOGUE( nCOMPANY,null,nCRN,'GoodsTransInvoicesToConsumers','TRANSINVCUST_INSERT_IO','TRANSINVCUST',newRN );
end;
/

