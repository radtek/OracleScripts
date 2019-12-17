--
-- GET_PRICE_PROTOKOL  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Price_Protokol
 (nom_dok# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(50);
  kod_npr# VARCHAR2(5);
  cat_cen# NUMBER;
  date_kvit# DATE;
  date_vyp_sf# DATE;
  date_cena# DATE;
  old_nom_sf# NUMBER;
  nom_sf# NUMBER;
  proto_num# VARCHAR2(15);
  proto_date# DATE;
--  propis# varchar2(4000);
BEGIN
  -- Реквизиты счета
  SELECT /*+ rule */ v_bills.PROD_ID_NPR,USL_DOG.CAT_CEN_ID,v_bills.DATE_KVIT,v_bills.DATE_VYP_SF,v_bills.NOM_SF,v_bills.OLD_NOM_SF,v_bills.PROTO_NUM,v_bills.PROTO_DATE 
    INTO kod_npr#,cat_cen#,date_kvit#,date_vyp_sf#,nom_sf#,old_nom_sf#,proto_num#,proto_date#  
	FROM v_bills,USL_DOG,BILLS
    WHERE BILLS.DOG_ID=USL_DOG.dog_id AND BILLS.USL_NUMBER=USL_DOG.USL_NUMBER AND v_bills.NOM_DOK=nom_dok# AND BILLS.nom_dok=v_bills.nom_dok;
 
  IF proto_num# IS NULL OR LTRIM(RTRIM(proto_num#))||' '=' ' THEN  
    -- Определяем дату
    IF old_nom_sf# IS NOT NULL AND old_nom_sf#<>nom_sf# THEN
      -- Если счет корректирует другой счет (но не минусовой) - по дате счета
      date_cena#:=date_vyp_sf#;
    ELSE
      -- Если счет оригинальный или минусовой - по дате квитанции
      date_cena#:=date_kvit#;
    END IF;		
	
    SELECT MAX(a.PROTOKOL_NUM || ' от ' || TO_CHAR(a.PROTOKOL_DATE,'dd.mm.yy') || 'г.') INTO val# FROM NPR_PRICES a
    WHERE 
     (a.begin_date=(SELECT MAX(begin_date) FROM NPR_PRICES b 
         WHERE b.cat_cen_id=cat_cen# AND b.prod_id_npr=kod_npr# AND b.begin_date<=date_cena# AND b.is_original=1)) AND
	  (a.cat_cen_id=cat_cen# AND a.prod_id_npr=kod_npr# AND a.begin_date<=date_cena# AND a.is_original=1);
  ELSE
    val#:=proto_num# || ' от ' || TO_CHAR(proto_date#,'dd.mm.yy') || 'г.';
  END IF;
  RETURN val#;
END Get_Price_Protokol;

/

