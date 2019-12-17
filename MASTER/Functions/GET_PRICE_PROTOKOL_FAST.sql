--
-- GET_PRICE_PROTOKOL_FAST  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Price_Protokol_Fast
 (nom_dok# NUMBER, kod_npr# VARCHAR2, date_kvit# DATE, dog_id# NUMBER, usl_number# NUMBER, date_vyp_sf# DATE, nom_sf# NUMBER, old_nom_sf# NUMBER)
RETURN VARCHAR2
AS
  val# VARCHAR2(50);
  cat_cen# NUMBER;
  date_cena# DATE;
  begin_date# DATE;
BEGIN
  SELECT USL_DOG.CAT_CEN_ID INTO cat_cen# FROM USL_DOG
    WHERE DOG_ID#=USL_DOG.dog_id AND USL_NUMBER#=USL_DOG.USL_NUMBER;

  -- Определяем дату
  IF NVL(old_nom_sf#,0)<>0 AND NVL(old_nom_sf#,0)<>NVL(nom_sf#,0) THEN
    -- Если счет корректирует другой счет (но не минусовой) - по дате счета
    date_cena#:=date_vyp_sf#;
  ELSE
    -- Если счет оригинальный или минусовой - по дате квитанции
    date_cena#:=date_kvit#;
  END IF;		

  BEGIN  
    SELECT MAX(begin_date) 
	  INTO begin_date# 
	  FROM NPR_PRICES b 
     WHERE b.cat_cen_id=cat_cen# 
       AND b.prod_id_npr=kod_npr# 
  	   AND b.begin_date<=date_cena# 
	   AND b.is_original=1;
	   
    SELECT MAX(DECODE(a.PROTOKOL_NUM,NULL,'',a.PROTOKOL_NUM || ' от ' || TO_CHAR(a.PROTOKOL_DATE,'dd.mm.yy') || 'г.')) 
      INTO val# FROM NPR_PRICES a
     WHERE a.begin_date=begin_date# 
       AND a.cat_cen_id=cat_cen# 
	   AND a.prod_id_npr=kod_npr# 
	   AND a.is_original=1;
	   
    RETURN val#;
  EXCEPTION
    WHEN OTHERS THEN
	  RETURN '';		 
  END;
END Get_Price_Protokol_Fast;

/

