--
-- FOR_CRYSTAL_TEL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_Crystal_Tel AS

PROCEDURE CR_INSIDENUM(TIP_DATE VARCHAR2, DATE_BEG VARCHAR2, DATE_END VARCHAR2,
  INSIDE_NUM VARCHAR2, CRS IN OUT CURSTYPE) IS
--- Отчет по переговорам в разрезе внутренних телефонов (VEV) 25.12.2002г.
  DATE1 DATE;
  DATE2 DATE;
  NUM   VARCHAR2(20);
BEGIN
  
  DATE1:=TO_DATE(DATE_BEG,'dd.mm.yyyy hh24:mi');
  DATE2:=TO_DATE(DATE_END,'dd.mm.yyyy hh24:mi');

  IF (INSIDE_NUM='*') OR (INSIDE_NUM IS NULL) THEN
    NUM:='%';
  ELSE
    NUM:=INSIDE_NUM;
  END IF;	
  
  OPEN CRS FOR
  SELECT 
    atslog.calltime, 
    atslog.calllength, 
    atslog.fromnumber, 
    atslog.tonumber,
    atslog.inbound, 
    atslog.dest_id, 
    atslog.summa AS summa_approx, 
    gatslog.summa AS summa_exact, 
    kls_phones.fio,
    kls_gtsdestination.destination_name
    FROM tel.atslog, tel.gatslog, tel.kls_phones, tel.kls_gtsdestination
   WHERE ((gatslog.ID(+) = atslog.gatslog_id) AND 
          (atslog.fromnumber = kls_phones.inside_number(+)) AND 
	  	  (SUBSTR(atslog.tonumber,1,4) = kls_gtsdestination.code(+)) AND
		  (atslog.inbound IS NULL) AND (SUBSTR(atslog.tonumber,1,1)='8') AND
		  (atslog.FROMNUMBER BETWEEN '6100' AND '6299' OR 
		   atslog.FROMNUMBER BETWEEN '6500' AND '6699' OR
		   atslog.FROMNUMBER BETWEEN '703'  AND '703') AND
		   atslog.CALLLENGTH>=1 AND not atslog.FROMNUMBER in ('6101','6201') and
		  (atslog.calltime BETWEEN date1 AND date2) AND (atslog.fromnumber LIKE num));
END;
END;

/

