--
-- FOR_NAKLPRINT  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_NAKLPRINT
AS

FUNCTION rekv_zagr (p_nakl  NUMBER ) RETURN VARCHAR2
AS
  s VARCHAR2(1024);
BEGIN
s:='';
FOR lcur IN (SELECT  
		 		REESTR.VAGONTYPE_ID as RODV,REESTR.FORMNAKL_ID as FORMA,NVL(KLS_FORMSHAB.IS_RUS,0) as IS_RUS,
				SVED.PROD_ID_NPR as KOD_NPR, KLS_UPAK.NAME as BAG_NAME,REESTR.SHIELDS,REESTR.KOL_ED,REESTR.VES_ED,
				REESTR.VZLIV,REESTR.VOLUME15,REESTR.FAKT_PL as XPL,REESTR.GOST_ID as GOST,REESTR.KALIBR_ID as TIP, 
				REESTR.UPAK_ID as BAG_ID,KLS_UPAK.NAME as BAG_GD,SVED.PASP_NUM as NUM_PASP,REESTR.TEMPER,
				FOR_SVED.GET_PASP_VALUE_AS_NUM(SVED.ID,1,NULL) AS PL,
  				FOR_SVED.GET_PASP_VALUE_AS_NUM(SVED.ID,602,NULL) AS PL15
			 FROM REESTR, SVED, MONTH, NAKL, KLS_PROD,
				KLS_CIST,KLS_VAGONTYPE,KLS_FORMSHAB,KLS_UPAK
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
	  			AND SVED.PROD_ID_NPR=KLS_PROD.ID_NPR
	  			AND REESTR.UPAK_ID=KLS_UPAK.ID(+)
	  			AND NAKL.SHABNAKL_ID=KLS_FORMSHAB.ID(+)
	  			AND REESTR.NUM_CIST=KLS_CIST.NUM_CIST(+)
	  			AND KLS_CIST.VAGONTYPE_ID=KLS_VAGONTYPE.ID(+)
	  			AND ROWNUM=1
 	  			AND NAKL.ID=p_nakl)
LOOP

IF lcur.rodv=2 OR lcur.rodv=5 THEN /* КРЫТЫЙ ВАГОН или ПОЛУВАГОН*/
    IF SUBSTR(lcur.kod_npr,1,3)='242' THEN
      s:=s||'НАВАЛОМ'||'       '||'.';
    ELSE 
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/* Одиночная на ЭКСПОРТ*/
        IF lcur.bag_id<>0 THEN 
		   s:=s||lcur.bag_name;
		ELSE
			s:=s||'     '||'.';
		END IF; 
      ELSE
        IF lcur.bag_id<>0 THEN
		   s:=s||lcur.bag_gd;
		ELSE
			s:=s||'     '||'.';
		END IF;	
      END IF;
      s:=s||';'||'       ПАСПОРТ:'||TRIM(lcur.num_pasp);
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/*Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
	  s:=s||';'||'    КОЛ-ВО ЕД.:';
	  IF lcur.kol_ed<>0 THEN
	  	 s:=s||LPAD(TRIM(TO_CHAR(lcur.kol_ed)),7);
	  ELSE 
	  	   s:=s||'     '||'.';
	  END IF;	   
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||' ВЕС 1 ЕД.(КГ):';
	  IF lcur.ves_ed<>0 THEN 
	  	 s:=s||LPAD(TRIM(TO_CHAR(lcur.ves_ed,'9999.999')),7); 
	  ELSE
	  	  s:=s||'     '||'.';
	  END IF;  
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;      
	  s:=s||';'||'  КОЛ-ВО ЩИТОВ:';
	  IF lcur.shields=0 THEN
	  	 s:=s||'     '||'.';
	  ELSE
	  	  s:=s||LPAD(TRIM(TO_CHAR(lcur.shields)),7);
	  END IF;  
    END IF;
END IF;
   IF (lcur.rodv=6 OR lcur.rodv=1) AND (lcur.vzliv IS NULL) THEN/*&& tracks.defi_mass=2     /* Замер ЦИСТЕРН на ВАГОННЫХ ВЕСАХ*/
    IF lcur.is_rus=1 THEN
      IF SUBSTR(lcur.kod_npr,1,3)='242' THEN
        s:=s||'НАВАЛОМ'||'       '||'.';
      ELSE 
        s:=s||'НАЛИВОМ'||'       '||'.';
      END IF;
    END IF;
    IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
      s:=s||';'||'  ТИП ЦИСТЕРНЫ:'||LPAD(TRIM(lcur.tip),7)||';;';
    END IF;
    IF SUBSTR(lcur.kod_npr,1,3)<>'242' THEN
      s:=s||';'||CONCAT('       ПАСПОРТ:',lcur.num_pasp);
    END IF;
    IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
      s:=s||';';
    END IF;
    IF (lcur.pl IS NOT NULL) AND (lcur.gost=0) AND (SUBSTR(lcur.kod_npr,1,3)<>'242') THEN
      s:=s||';'||'ПЛОТН. ПРИ 20''C:'||LPAD(TRIM(TO_CHAR(lcur.pl,'90.9999')),7);
    END IF;
    IF (lcur.pl15 IS NOT NULL) AND (lcur.gost=1) AND (SUBSTR(lcur.kod_npr,1,3)<>'242') THEN
      s:=s||';'||'ПЛОТН. ПРИ 15''C:'||LPAD(TRIM(TO_CHAR(lcur.pl15,'90.9999')),7);
    END IF;
END IF;  
   IF (lcur.rodv=6 OR lcur.rodv=1) AND (lcur.vzliv IS NOT NULL) THEN/*(EMPTY(tracks.defi_mass) OR tracks.defi_mass=1) /* Замер ЦИСТЕРН МЕТР-ШТОКОМ*/
    IF lcur.is_rus=1 THEN 
      IF SUBSTR(lcur.kod_npr,1,3)='242' THEN
        s:=s||'НАВАЛОМ'||'       '||'.';
      ELSE 
        s:=s||'НАЛИВОМ'||'       '||'.';
      END IF;
    END IF;
    IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
      s:=s||';'||'  ТИП ЦИСТЕРНЫ:'||LPAD(TRIM(lcur.tip),7)||';;';
    END IF;
    s:=s||';'||'         ВЗЛИВ:'||LPAD(TRIM(TO_CHAR(lcur.vzliv,'999')),7);
    IF (lcur.pl IS NOT NULL) AND (lcur.gost=0) AND (SUBSTR(lcur.kod_npr,1,3)<>'242') THEN
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||'ПЛОТН. ПРИ 20''C:'||LPAD(TRIM(TO_CHAR(lcur.pl,'90.9999')),7);
    END IF;
    IF (lcur.pl15 IS NOT NULL ) AND (lcur.gost=1) AND (SUBSTR(lcur.kod_npr,1,3)<>'242') THEN
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||'ПЛОТН. ПРИ 15''C:'||LPAD(TRIM(TO_CHAR(lcur.pl15,'90.9999')),7);
    end if;
    IF lcur.gost=1 THEN
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||'   ТЕМПЕРАТУРА:'||LPAD(TRIM(TO_CHAR(lcur.temper,'9999.9'))||'''C',7);
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /*Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||' ОБЪЕМ ПРИ 15''C:'||LPAD(TRIM(TO_CHAR(lcur.volume15)),7);
    END IF;
    IF lcur.gost=0 THEN
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||'   ТЕМПЕРАТУРА:'||LPAD(TRIM(TO_CHAR(lcur.temper,'9999.9'))||'''C',7);
      IF (lcur.forma=5) AND (lcur.is_rus=0) THEN/* Одиночная на ЭКСПОРТ*/
        s:=s||';';
      END IF;
      s:=s||';'||'   ФАКТ. ПЛОТН.:'||LPAD(TRIM(TO_CHAR(lcur.xpl,'90.9999')),7);
    END IF;
	IF (lcur.forma=5) AND (lcur.is_rus=0) THEN /* Одиночная на ЭКСПОРТ*/
       s:=s||';';
    END IF;
    s:=s||';'||'       ПАСПОРТ:'||TRIM(lcur.num_pasp);
END IF;
EXIT;
END LOOP;
RETURN s;	 
END;/*rekv_zagr*/

/*Выбор строки № NN из строкового выражения. Cтроки разделены ;       */
FUNCTION StrokaN (stroka in VARCHAR2,nn in NUMBER,smb in VARCHAR2) RETURN VARCHAR2
AS
  res VARCHAR2(1024);
  str VARCHAR2(1024);
  i INTEGER;
  cur INTEGER;
  prev INTEGER;
  n INTEGER;
  dl VARCHAR2(1);
BEGIN
  if stroka IS NULL THEN
  	 RETURN stroka;
  END IF;	 
  IF (Smb IS NULL) THEN
    dl:=';';
  ELSE
    dl:=Smb;
  END IF;
  if (INSTR(stroka,dl)=0) OR (INSTR(stroka,dl) IS NULL) THEN 
  	 RETURN stroka;
  END IF;	 

  n:=nn;
  str:=TRIM(Stroka)||dl;
  str:=REPLACE(str,dl||dl,dl);
  IF n<=1 THEN
    n:=1;
  END IF;
  cur:=1;
  i:=1;
  WHILE (i<=n) AND (cur<>0)
  LOOP
	  cur:=INSTR(str,dl);
	  IF NOT (cur=0) THEN
	  	 res:=SUBSTR(str,1,cur-1);
		 str:=SUBSTR(str,cur+1);
	  END IF;
	  i:=i+1;	  
  END LOOP;     
  IF cur is null then
  	 return null;
  end if;	 
  RETURN trim(res);

END;/*StrokaN*/

/*Возвращает параметры S1-Отметка таможни/Номер транспорта,S2-Разрешение МПС,S3-Разрешение на продукт,S4-Экспорт*/
FUNCTION Get_S(p_nakl NUMBER, n NUMBER) RETURN VARCHAR2
AS
  s1 VARCHAR2(50);  /*Отметка таможни/Номер транспорта*/
  s2 VARCHAR2(50);  /*Разрешение МПС*/
  s3 VARCHAR2(50);  /*Разрешение на продукт*/
  s4 VARCHAR2(50);  /*Экспорт*/
BEGIN
s1:='';s2:='';s3:='';s4:='';
FOR lcur IN (SELECT  
		 	 MONTH.TRANSPORT as TRANSP,KLS_FORMSHAB.P_RAZR_MPS,KLS_FORMSHAB.IS_RUS,NAKL.FORMNAKL_ID as FORMA,
			 SVED.PROD_ID_NPR as KOD_NPR,KLS_CIST.VAGOWNER_ID as TIPV,GU12_A.NOM_Z as N_PLAN,KLS_VAGOWNER.RAZR_MPS,
			 KLS_PROD.RAZRESH,KLS_SHABEXP.TAM1,KLS_VAGOWNER.ID,KLS_VAGOWNER.VAGOWNER_NAME,KLS_FORMSHAB.IS_OPD	
			 FROM REESTR, SVED, MONTH, NAKL, KLS_PROD,
				KLS_CIST,KLS_VAGONTYPE,KLS_FORMSHAB,GU12_A,KLS_SHABEXP,KLS_VAGOWNER
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
	  			AND SVED.PROD_ID_NPR=KLS_PROD.ID_NPR
				AND MONTH.GU12_A_ID=GU12_A.ID(+)
	  			AND NAKL.SHABNAKL_ID=KLS_FORMSHAB.ID(+)
				AND NAKL.SHABEXP_ID=KLS_SHABEXP.ID(+)
	  			AND REESTR.NUM_CIST=KLS_CIST.NUM_CIST(+)
	  			AND KLS_CIST.VAGONTYPE_ID=KLS_VAGONTYPE.ID(+)
				AND KLS_CIST.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
	  			AND ROWNUM=1
 	  			AND NAKL.ID=p_nakl)
LOOP
      IF NVL(lcur.is_rus,0)=1 AND (lcur.transp IS NOT NULL)then
        s1:='Транспорт '||Trim(lcur.transp);
      END IF;
      IF NOT((lcur.forma=5) OR (lcur.forma=7)) then
        IF lcur.p_razr_mps=1 then
          IF lcur.tipv<>3 OR ((substr(lcur.kod_npr,1,3)='130') OR (substr(lcur.kod_npr,1,3)='131')) then
            /* Печать разрешения МПС*/
            s2:=Trim(lcur.razr_mps);
          end if;
        end if;
      ELSE
        IF NVL(lcur.is_rus,0)=1 then
          s1:='';s4:='';
		  if (NVL(lcur.is_opd,0)<>1) then
			 s1:=TRIM(lcur.tam1);
		  end if;	 
		  if (NVL(lcur.is_opd,0)<>1) then
			 s4:='ЭКСПОРТ';
		  end if;	 
        end if;
      end if;
      
	  IF (lcur.n_plan is null) AND lcur.tipv<>3 then
        s3:=Trim(lcur.razresh);
      end if;
	  EXIT;
END LOOP;
case n
	when 1 then return s1;
	when 2 then return s2;
	when 3 then return s3;
	when 4 then return s4;
end case;		   
END;

/*№ аварийной карты*/
FUNCTION AV_KART(AV_KART NUMBER,KOD VARCHAR2,KOD_GR VARCHAR2,PASP_ID VARCHAR2) RETURN VARCHAR2
AS
  TVsp_61 BOOLEAN;
  t_vsp NUMBER;
BEGIN
  IF kod='90000' then
    RETURN '';
  end if;
  t_vsp:=FOR_PASP.GET_PASP_VALUE_BY_TAG(PASP_ID, 't_vsp');
  TVsp_61:= (t_vsp>61);  
  IF (av_kart is not null) then
    IF av_kart>0 AND Trim(kod_gr)='10400' AND TVsp_61 then
      RETURN 'Ав.карта N 901';
    ELSE  
      IF av_kart<0 then
        RETURN '';
      ELSE
        RETURN 'Ав.карта N '||trim(To_char(av_kart));
      end if;
    end if;
  end if;
  RETURN 'Аварийная карта прилагается';
END;
/*Дополнительная информация под наименованием груза*/
/*По сравнению с фоксом: 1.убран параметро gr0_txt тк. он всегда пустой
                         2.убран перенос на вторую сторону т.к. в накладной все помещается на 1
						 3.вместо reestr_d.np_data_o используется sved.date_oforml*/
FUNCTION Dop_gr_inf(p_nakl NUMBER,cnt NUMBER,KOD_NPR VARCHAR2,KOD_GD VARCHAR2,DATE_OFORML DATE) RETURN VARCHAR2
AS
TYPE LIST_TYPE IS VARRAY (7) of VARCHAR2(60);
final_list LIST_TYPE:=list_type(null,null,null,null,null,null,null);
to_list LIST_TYPE:=list_type(null,null,null,null,null,null,null);
i INTEGER;
j INTEGER;
gr1_txt VARCHAR2(50);gr2_txt VARCHAR2(50);gr3_txt VARCHAR2(50);gr4_txt VARCHAR2(50); 
BEGIN
i:=0;
  gr1_txt:=dop_nakl(p_nakl,'gr1_txt');
  gr2_txt:=dop_nakl(p_nakl,'gr2_txt');
  gr3_txt:=dop_nakl(p_nakl,'gr3_txt');
  gr4_txt:=dop_nakl(p_nakl,'gr4_txt');
  IF substr(kod_npr,1,3)='242' then
    i:=1;  
    to_list(i):='Договор грузоотправителя с СевЖД от 27/12/04 нр 29/Д-8/38'; 
    i:=2;
    to_list(i):='Основание:тел. ОАО РЖД от 02.03.05г. НР СБ-2045'; 
  end if;  
  i:=i+1;
  to_list(i):=Trim(gr1_txt);
  i:=i+1;
  to_list(i):=Trim(gr2_txt);
  i:=i+1;
  to_list(i):=Trim(gr3_txt);
  i:=i+1;
  to_list(i):=Trim(gr4_txt);

  j:=0;
  FOR i  in 1..7
  LOOP
    IF (to_list(i) is not null) then
      j:=j+1;
      final_list(j):=to_list(i);
    end if;  
  end loop;

  IF substr(kod_gd,1,3)='211' then 
    IF date_oforml>=TO_DATE('01.10.2003','dd.mm.yyyy') then
      final_list(j+1):='Ведомственная охрана МПС России';
      final_list(j+2):='Договор N 5/HOP-3/23 от 24.09.2003';
    end if; 
  end if;

  IF cnt>7 then
    RETURN '';
  else
  	IF (final_list(cnt) is null)then
	   final_list(cnt):='';
	end if;  
  	RETURN final_list(cnt);
  end if;

END;

FUNCTION SobsTitle(p_nakl NUMBER,TIP_SOBS NUMBER) RETURN VARCHAR2
AS
  SobsExist BOOLEAN;
  Res VARCHAR2(15);
BEGIN
	SobsExist:=SobsInfo(p_nakl,'SobsExist');
	if SobsExist then
   	   if tip_sobs=2 then
   	   	  return'АРЕНДАТОР';
   	   else 
   	   	  return 'СОБСТВЕННИК';
       end if;
	else
		return '';
	end if;   
END;

/* 
Возвращает признак Единтсвенного собственника или признак существования собственника в зависимости от параметра info.
   info='SobstExist' или info='SobstOne'. 
*/
FUNCTION SobsInfo(p_nakl NUMBER,info VARCHAR2) return BOOLEAN
AS
CURSOR vagons_cur(NaklId NUMBER) IS 
	   		 SELECT  
			 	 KLS_VAGOWNER.VAGOWN_TYP_ID as TIP_SOBS,KLS_VAGOWNER.ID as TIPV
			 FROM REESTR, SVED, MONTH, NAKL, KLS_CIST,KLS_VAGOWNER
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
	  			AND REESTR.NUM_CIST=KLS_CIST.NUM_CIST(+)
				AND KLS_CIST.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
				AND NAKL.ID=NaklId;
vagons_row vagons_cur%ROWTYPE;
SobsExist BOOLEAN;
SobsOne BOOLEAN;
m_tipv NUMBER;
BEGIN
   SobsExist:=false;
   SobsOne:=true;
   OPEN vagons_cur(p_nakl);
/* Необходимо задать начальное значение m_tipv, поэтому первую запись просмотрим вне цикла*/
   FETCH vagons_cur INTO vagons_row;
   if vagons_row.tipv<>3 then
	  	 SobsExist:=true;
   end if;

   m_tipv:=NVL(vagons_row.tipv,0);
   LOOP
   	  FETCH vagons_cur INTO vagons_row;
      EXIT WHEN vagons_cur%NOTFOUND;
	  if NVL(vagons_row.tipv,0)<>3 then
	  	 SobsExist:=true;
	  end if;
	  if NVL(vagons_row.tipv,0)<>m_tipv then 
      	 SobsOne:=false;
      end if;		 	 
   END LOOP;
   CLOSE vagons_cur;
   case 
		when info='SobsExist' then return SobsExist;
		when info='SobsOne' then return SobsOne;
   end case;		   
END;

/*IIF(SobsExist,IIF(SobsOne,types.prn_name,'СМ.ДОП.ЛИСТ К НАКЛАДНОЙ'),'')*/
FUNCTION SobsName(p_nakl NUMBER,VAGOWNER_NAME VARCHAR2) RETURN VARCHAR2
AS
  SobsExist BOOLEAN;
  SobsOne BOOLEAN;
  Res VARCHAR2(15);
BEGIN
	SobsExist:=SobsInfo(p_nakl,'SobsExist');
	SobsOne:=SobsInfo(p_nakl,'SobsOne');

	if SobsExist then
   	   if SobsOne then
   	   	  return Trim(VAGOWNER_NAME);
   	   else 
   	   	  return 'СМ.ДОП.ЛИСТ К НАКЛАДНОЙ';
       end if;
	else
		return '';
	end if;   

END;

/*  Функция возвращает один из пунктов дополнительной информации о грузе или взыск название которго передается через
аргумент ident:vzisk1,vzisk2,vzisk3,vzisk4,gr1_txt,gr2_txt,gr3_txt,gr4_txt.Если накладная экспортная, то в vzisk1,vzisk2
возвращаются их экспортные значения */
FUNCTION Dop_nakl(p_nakl NUMBER, ident VARCHAR2) RETURN VARCHAR2
AS
vzisk1 VARCHAR2(50);vzisk2 VARCHAR2(50);vzisk3 VARCHAR2(50);vzisk4 VARCHAR2(50);
vzisk1_ex VARCHAR2(50);vzisk2_ex VARCHAR2(50);
gr1_txt VARCHAR2(50);gr2_txt VARCHAR2(50);gr3_txt VARCHAR2(50);gr4_txt VARCHAR2(50);
gr1_txt_ex VARCHAR2(50);gr2_txt_ex VARCHAR2(50);
k_tar_txt VARCHAR2(50);
BEGIN
FOR lcur IN (SELECT  
			 /* взыски из разных таблиц*/
			 KLS_VAGOWNER.VZISK1,KLS_VAGOWNER.VZISK2,KLS_VZISKTXT.VZISK1 as VZISK1_TXT,KLS_VZISKTXT.VZISK2 as VZISK2_TXT,
			 KLS_ISKL_TAR.VZISK3,KLS_ISKL_TAR.VZISK4,KLS_VAGOWNER.VZISK1_EX,KLS_VAGOWNER.VZISK2_EX,
			 /* дополнительная информация о грузе*/
			 KLS_VAGOWNER.GR1_TXT,KLS_VAGOWNER.GR2_TXT,KLS_VAGOWNER.GR1_TXT_EX,KLS_VAGOWNER.GR2_TXT_EX,KLS_CIST.GR1_TXT as GR1_CIST,
			 KLS_CIST.GR2_TXT as GR2_CIST,KLS_ISKL_TAR.GR4_TXT,KLS_ISKL_TAR.GR3_TXT,KLS_VZISKTXT.GR1,KLS_VZISKTXT.GR2,
			 KLS_SHABEXP.GR1_TXT_EX as GR1_TXT_SHABEX,KLS_SHABEXP.GR2_TXT_EX as GR2_TXT_SHABEX,
			 /*Прочая информация*/
			 KLS_VID_OTGR.LOAD_TYPE_ID as TIP_OTGR,KLS_VZISKTXT.ID as VZISK_ID,
			 KLS_VAGOWNER.ID as TIPV,KLS_ISKL_TAR.K_TAR,MONTH.K_TAR as MONTH_K_TAR,MONTH.IS_EXP,
			 KLS_ISKL_TAR.K_TAR_TXT,MONTH.FLG_FORMA_2 as FORMA_2, SVED.PROD_ID_NPR as KOD_NPR
			 FROM REESTR, SVED, MONTH, NAKL, KLS_CIST,KLS_VID_OTGR,KLS_ISKL_TAR,KLS_VAGOWNER,KLS_VZISKTXT,KLS_SHABEXP
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
				AND NAKL.SHABEXP_ID=KLS_SHABEXP.ID(+)
	  			AND REESTR.NUM_CIST=KLS_CIST.NUM_CIST(+)
				AND KLS_CIST.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
				AND MONTH.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR(+)
				AND MONTH.K_TAR=KLS_ISKL_TAR.K_TAR(+)
				AND MONTH.VZISK_ID=KLS_VZISKTXT.ID(+)
	  			AND ROWNUM=1
				AND NAKL.ID=p_nakl)
LOOP
	if lcur.tip_otgr=2 then
	   return '';
	end if;
/* допинформация согласно собственника */	
/* если поле TIPV будет пустым, то соответствующие переменные также будут пустыми иначе - заполненятся значениями */
	vzisk1:=lcur.vzisk1;
	vzisk2:=lcur.vzisk2;
	vzisk1_ex:=lcur.vzisk1_ex;
	vzisk2_ex:=lcur.vzisk2_ex;
	gr1_txt:=lcur.gr1_txt;
	gr2_txt:=lcur.gr2_txt;
	gr1_txt_ex:=lcur.gr1_txt_ex;
	gr2_txt_ex:=lcur.gr2_txt_ex;	 
	if lcur.tipv is null then
	   vzisk1:='Без акцепта через ТЕХ ПД';
	end if;   
/* допинформация согласно искл. тарифа */
	k_tar_txt:=lcur.k_tar_txt;
	gr3_txt:=lcur.gr3_txt;
	gr4_txt:=lcur.gr4_txt;
	vzisk3:=lcur.vzisk3;
	vzisk4:=lcur.vzisk4;
	/* если непустое поле k_tar из kls_iskl_tar значит есть соответствие в справочнике(kls_iskl_tar)*/
	if lcur.k_tar is not null then
	   vzisk1:='';
	   vzisk2:='';
	else
/* если пустое поле k_tar из kls_iskl_tar, а непустое k_tar из month значит нет соответствия в справочнике(kls_iskl_tar)*/
		if lcur.month_k_tar is not null then
		   vzisk3:='ТАРИФ НА СТ.НАЗНАЧЕНИЯ';
		   vzisk1:='';
	       vzisk2:='';
		else
			vzisk1:=lcur.vzisk1;
    		vzisk2:=lcur.vzisk2;
			if lcur.vzisk_id is not null then
			   vzisk1:=lcur.vzisk1_txt;
        	   vzisk2:=lcur.vzisk2_txt;
			   gr1_txt:=lcur.gr1;
        	   gr2_txt:=lcur.gr2;
			end if;
		end if;
	end if;
/*записи в KLS_CIST являются приоритетными*/
	if lcur.gr1_cist is not null then
	   gr1_txt:=lcur.gr1_cist; 
	end if;
	if lcur.gr2_cist is not null then
	   gr2_txt:=lcur.gr2_cist; 
	end if;
	   
    if lcur.forma_2=1 then
   	   vzisk1:='Форма N2 тариф на станции назначения';
   	   vzisk2:='';
   	   vzisk3:='';
   	   vzisk4:='';
    end if;
    if lcur.kod_npr='90000' then
       vzisk1:=Trim(vzisk1_ex);
       vzisk2:=Trim(vzisk2_ex);
    end if;
/* Для экспортных накладных записи беруться из KLS_SHABEX(шаблон экспортных накладных)*/
	if lcur.is_exp=1 then
	   gr1_txt:=lcur.gr1_txt_shabex;
	   gr2_txt:=lcur.gr2_txt_shabex;
	   gr1_txt_ex:=lcur.gr1_txt_shabex;
	   gr2_txt_ex:=lcur.gr2_txt_shabex;
	end if;  
	EXIT;/*loop*/
END LOOP;

case
	when ident='vzisk1' then return vzisk1;
	when ident='vzisk2' then return vzisk2;
	when ident='vzisk1_ex' then return vzisk1_ex;
	when ident='vzisk2_ex' then return vzisk2_ex;
	when ident='vzisk3' then return vzisk3;
	when ident='vzisk4' then return vzisk4;
	when ident='gr1_txt' then return gr1_txt;
	when ident='gr2_txt' then return gr2_txt;
	when ident='gr3_txt' then return gr3_txt;
	when ident='gr4_txt' then return gr4_txt;
	when ident='gr1_txt_ex' then return gr1_txt_ex;
	when ident='gr2_txt_ex' then return gr2_txt_ex;
end case;    

END;

FUNCTION Itog_mest(rodv NUMBER,shab_form NUMBER,p_nakl NUMBER,forma NUMBER) RETURN VARCHAR2
AS
BEGIN
if (shab_form=2) or (shab_form=5) then
   case rodv
   		when 1 then return 'ОДИН БУНКЕР';
  		when 2 then return 'ОДИН КРЫТЫЙ';
  		when 3 then return 'ОДИН ХОППЕР';
  		when 4 then return 'ОДНА ПЛАТФОРМА';
  		when 5 then return 'ОДИН ПОЛУВАГОН';
  		when 6 then return 'ОДНА ЦИСТЕРНА';
  		when 9 then return 'ОДИН КОНТЕЙНЕР';
   end case;
else
   return UPPER(FOR_NAKLPRINT.propis(LPAD(TO_CHAR(FOR_NAKLPRINT.all_cnt(p_nakl,forma)),3,'0'),0)); 
end if;
END;

FUNCTION all_cnt(p_nakl NUMBER,forma NUMBER) RETURN NUMBER
AS
  all_cnt NUMBER;
BEGIN
CASE 
	WHEN (forma=5) OR (forma=2) THEN all_cnt:=1;
	ELSE SELECT COUNT(NUM_CIST)INTO all_cnt FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
END CASE;
	RETURN all_cnt;
END;

FUNCTION propis(cc VARCHAR2, atr NUMBER) RETURN VARCHAR2
AS
  s NUMBER;
  d NUMBER;
  o NUMBER;
  Err NUMBER;
  res VARCHAR2(50);
  sto VARCHAR2(50);
  des VARCHAR2(50);
  ons VARCHAR2(50);
  ending VARCHAR2(50);
BEGIN
  S:=TO_NUMBER(SUBSTR(cc,1,1));
  D:=TO_NUMBER(SUBSTR(cc,2,1));
  O:=TO_NUMBER(SUBSTR(cc,3,1));
  if atr=1 then
    ending:='рублей';
  else if atr=2 then
          ending:='тысяч';
	   else if atr=3 then
               ending:='миллионов';
			else if atr=0 then
			     	ending:='';
				 else	
               	 	ending:='миллиардов';
				 end if;	
			end if;
	   end if;
  end if;
  if s=0 then
     sto := '';
  else if s=1 then
          sto := 'сто';
	   else if s=2 then
	           sto := 'двести';
			else if s=3 then
                    sto := 'триста';
				 else if s=4 then
                         sto := 'четыреста';
                      else if s=5 then
                              sto := 'пятьсот';
				           else if s=6 then
                                   sto := 'шестьсот';
				                else if s=7 then
                                        sto := 'семьсот';
				                     else if s=8 then
                                             sto := 'восемьсот';
				                          else
                                             sto := 'девятьсот';
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  if d=0 then
    des := '';
  else if d=1 then
          IF o = 0 Then
		     des := 'десять';
          ELSE
		     des := 'надцать';
		  END IF;
	   else if d=2 then
               des := 'двадцать';
			else if d=3 then
                    des := 'тридцать';
				 else if d=4 then
                         des := 'сорок';
					  else if d=5 then
                              des := 'пятьдесят';
						   else if d=6 then
                                   des := 'шестьдесят';
								else if d=7 then
                                        des := 'семьдесят';
									 else if d=8 then
                                             des := 'восемьдесят';
										  else
                                             des := 'девяносто';
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  if o=0 then
    ons := '';
  else if o=1 then
         IF (atr = 2) AND (d <> 1) Then
		   ons := 'одна';
         ELSE
		   ons := 'один';
		 END IF;
         if d<>1 then
           if atr=1 then
              ending:='рубль';
		   else if atr=2 then
                   ending:='тысяча';
				else if atr=3 then
                        ending:='миллион';
					 else if atr=0 then
					 	  	 ending:='';
						  else	  
                          	 ending:='миллиард';
						  end if;	 
					 end if;
  			    end if;
		   end if;
         end if;
       else if o=2 then
               IF (atr = 2) OR (d = 1) Then
			     ons := 'две';
               ELSE
			     ons := 'два';
			   END IF;
               if d<>1 then
                 if atr=1 then
                    ending:='рубля';
                 else if atr=2 then
                         ending:='тысячи';
				      else if atr=3 then
                              ending:='миллиона';
					       else if atr=0 then
						      	   ending:='';
								else   
                              	   ending:='миллиарда';
								end if;   
 					       end if;
  			          end if;
		         end if;
               end if;
			else if o=3 then
                    ons := 'три';
                    if d<>1 then
                      if atr=1 then
                         ending:='рубля';
                      else if atr=2 then
                              ending:='тысячи';
				           else if atr=3 then
                                   ending:='миллиона';
					            else if atr=0 then
									 	ending:='';
									 else	
                                   	 	ending:='миллиарда';
									 end if;	
 					            end if;
  			               end if;
		              end if;
                    end if;
 			     else if o=4 then
                         ons := 'четыр';
                         IF (d <> 1) Then
                           ons := ons || 'е';
                           if atr=1 then
                              ending:='рубля';
                           else if atr=2 then
                                   ending:='тысячи';
				                else if atr=3 then
                                        ending:='миллиона';
					                 else if atr=0 then
									 	  	 ending:='';
										  else	 	 
                                          	 ending:='миллиарда';
										  end if;	 
       					             end if;
  			                    end if;
		                   end if;
						 END IF;
    			      else if o=5 then
                              ons := 'пят';
                              IF (d <> 1) Then
							    ons := ons || 'ь';
							  END IF;
    			           else if o=6 then
                                   ons := 'шест';
                                   IF (d <> 1) Then
								     ons := ons || 'ь';
								   END IF;
                                else if o=7 then
                                        ons := 'сем';
                                        IF (d <> 1) Then
										   ons := ons || 'ь';
										END IF;
									 else if o=8 then
                                             ons := 'восем';
                                             IF (d <> 1) Then
											    ons := ons || 'ь';
											 END IF;
										  else
                                             ons := 'девят';
                                             IF (d <> 1) Then
											    ons := ons || 'ь';
											 END IF;
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  IF d = 1 Then
    res := LTRIM(RTRIM(sto || ' ' || ons || des)) || ' ';
  ELSE
    res := LTRIM(RTRIM(sto || ' ' || des || ' ' || ons)) || ' ';
  END IF;
  IF res=' ' Then
    IF atr=1 then
	  RETURN ending;
    Else
	  RETURN '';
	END IF;
  ELSE
    RETURN (res || ending);
  END IF;
END;

FUNCTION Dop_vzisk(p_nakl NUMBER,cnt NUMBER) RETURN VARCHAR2
AS
TYPE LIST_TYPE IS VARRAY (4) of VARCHAR2(50);
final_list LIST_TYPE:=list_type(null,null,null,null);
to_list LIST_TYPE:=list_type(null,null,null,null);
i INTEGER;
j INTEGER;

BEGIN
  to_list(1):=Trim(Dop_nakl(p_nakl,'vzisk1'));
  to_list(2):=Trim(Dop_nakl(p_nakl,'vzisk2'));
  to_list(3):=Trim(Dop_nakl(p_nakl,'vzisk3'));
  to_list(4):=Trim(Dop_nakl(p_nakl,'vzisk4'));
  j:=0;

  FOR i  in 1..4
  LOOP
    IF (to_list(i) is not null) then
      j:=j+1;
      final_list(j):=to_list(i);
    end if;  
  end loop;

  IF cnt>4 then
    RETURN '';
  else
  	IF (final_list(cnt) is null)then
	   final_list(cnt):='';
	end if;  
  	RETURN final_list(cnt);
  end if;
END;

FUNCTION Defi_mass(p_nakl NUMBER,RODV NUMBER,IS_RUS NUMBER,FORMA NUMBER,KOD_NPR VARCHAR2,
                   VZLIV NUMBER,DEFI_MASS NUMBER) RETURN VARCHAR2
AS
s VARCHAR2(100);
BEGIN
s:='';
if ((rodv=6) OR (rodv=1)) AND (vzliv is not null) then
    if ((forma=5)or(forma=7)) AND (nvl(is_rus,0)=0) then
      s:=s||'ЗАМЕРОМ';
    else
      if kod_npr='90000' then
        s:=s||'ПО ОБМЕРУ, РАСЧЕТНЫМ ПУТЕМ';
      else    
        s:=s||'ЗАМЕРОМ МЕТР-ШТОКОМ';    
      end if;
    end if;  
end if;
if (((rodv=1) or (rodv=6)) AND (vzliv is null)) or (rodv=2) or (rodv=5) then
    if ((forma=5)or(forma=7)) AND (nvl(is_rus,0)=0) then
      IF defi_mass=3 then  
        s:=s||'ЗА ВЕСОМ "ЛУКОЙЛ-УНП"';
      ELSE
        s:=s||'HА ВЕСАХ, +-1.5%';
      end if;
    ELSE
      IF defi_mass=3 then  
        s:=s||'ЗА ВЕСОМ ОАО "ЛУКОЙЛ-УНП"';
      ELSE
        s:=s||'HА ВАГОННЫХ ВЕСАХ "ЛУКОЙЛ-УНП", +-1.5%';
      end if;
    end if;  
end if;
RETURN s;
END;

FUNCTION Zag_plomba(forma NUMBER,p_typ NUMBER,dop NUMBER) RETURN VARCHAR2
AS
s VARCHAR2(50);
is_dop NUMBER;
BEGIN
  s:='';
  IF dop is null then
    is_dop:=0;
  ELSE
    is_dop:=1;
  end if;

  if (forma=7) AND (is_dop=0) then
    s:='-СМ.ДОП.ЛИСТ К НАКЛАДНОЙ';
  ELSE
    CASE p_typ
      when 1 then s:='2СЕВ СПРУТ-777';
      when 2 then s:='"ЛАВР-ГАРАНТ 2М"';
      when 3 then s:='"ЛАВР 2000 2СЕВ"';
      when 4 then s:='"ЛАВР 2000 3СЕВ"';
      when 5 then s:='"ЛАВР 2000 4СЕВ"';
      when 6 then s:='"ЛАВР 2000 5СЕВ"';
	  else s:='';
    END CASE;
  end if;

RETURN S;

END;

FUNCTION plomba(plomba VARCHAR2,dop NUMBER) RETURN VARCHAR2
AS
is_dop NUMBER;
BEGIN
  if dop is null then
    is_dop:=0;
  ELSE
    is_dop:=1;
  end if;
if (plomba is null) OR (plomba='Сев.0') then
   return '';
else
   return Trim(plomba);
end if;
END;
/*Параграф согласно которому закреплен груз */
FUNCTION nakl_para(rodv NUMBER, kod_npr VARCHAR2) RETURN VARCHAR2
AS
BEGIN
/*  IIF((rodv=6 or rodv=1) and .F.,IIF(LEFT(kod_npr,3)='130','30,32','30   '),IIF(rodv=2,' ',IIF(rodv=5,' ','     ')))*/
  IF((rodv=6) or (rodv=1)) and FALSE then
  	 IF SUBSTR(kod_npr,1,3)='130' then
	 	return'30,32';
	 else
	 	 return '30   ';
	 end if;
  else
  	  IF rodv=2 then
	  	return ' ';
	  else
	   IF rodv=5 then
	   	  return ' ';
	   else
	   	  return '     ';
	   end if;
	  end if; 	   
  end if;	 
END;

FUNCTION nakl_glav(rodv NUMBER, kod_npr VARCHAR2) RETURN VARCHAR2
AS
BEGIN
  IF SUBSTR(kod_npr,1,4)='2421' then
  	return '1 р 5';
  else
    IF(rodv=6) or (rodv=1) then 
		return '     ';
	else
		IF rodv=2 then
			return '       ';
		else
		   IF rodv=5 then
		   		return '     ';
		   else
		     return	'     ';
		   end if;
		end if;
	end if;
  end if;		    
END;

FUNCTION all_ves(p_nakl NUMBER, forma NUMBER) return NUMBER
as
res NUMBER;
BEGIN
CASE 
	WHEN (forma=5) OR (forma=2) THEN SELECT SUM(VES+UPAK_VES)INTO res FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
	ELSE SELECT SUM(VES)INTO res FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
END CASE;
RETURN res;
END;

FUNCTION all_brutto(p_nakl NUMBER) return NUMBER
as
res NUMBER;
BEGIN
	 SELECT SUM(ves_all) INTO res FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
	 RETURN res;
END;

FUNCTION all_tara(p_nakl NUMBER) return NUMBER
as
res NUMBER;
BEGIN
	 SELECT SUM(ves_cist) INTO res FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
	 RETURN res;
END;

/*Печать атрибутов обратной стороны */
FUNCTION sertif(p_nakl NUMBER, str_fakt VARCHAR2) return VARCHAR2
AS
s VARCHAR2(1024);
str_list VARCHAR2(255);
stor_sele VARCHAR2(255);
r1 VARCHAR2(255);
r2 VARCHAR2(255);
r3 VARCHAR2(255);
i1 INTEGER;
i2 INTEGER;
RosInsCnt NUMBER;
BEGIN
s:='';
FOR lcur IN (SELECT  
			 REESTR.FORMNAKL_ID as FORMA,KLS_CIST.VAGONTYPE_ID as RODV,KLS_FORMSHAB.IS_RUS,KLS_PROD.AV_KART,
			 SVED.PROD_ID_NPR as KOD_NPR,REESTR.UPAK_VES as BAG_VES,SVED.DEFI_MASS_ID as DEFI_MASS,KLS_DOG.DOG_NUMBER as LONG_NUM,
			 KLS_CIST.VAGOWNER_ID as TIPV,KLS_PROD.NAME_NPR as NAIM_PR,KLS_PROD.GOST_NPR as GOST,REESTR.ROSINSPL1,
			 REESTR.ROSINSPL2,KLS_PREDPR.PREDPR_NAME as SOBSTV_NAIM,MONTH.K_TAR,KLS_ISKL_TAR.K_TAR_TXT,MONTH.NOM_ZD,
			 REESTR.ID as NUM_OTGR, SVED.PASP_NUM as NUM_PASP
			 FROM REESTR, SVED, MONTH, NAKL, KLS_CIST,KLS_VAGOWNER,KLS_FORMSHAB,KLS_DOG,KLS_PROD,KLS_PREDPR,KLS_ISKL_TAR
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
	  			AND REESTR.NUM_CIST=KLS_CIST.NUM_CIST(+)
				AND KLS_CIST.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
				AND SVED.PROD_ID_NPR=KLS_PROD.ID_NPR(+)
				AND NAKL.SHABNAKL_ID=KLS_FORMSHAB.ID(+)
				AND MONTH.DOG_ID=KLS_DOG.ID(+)
				AND MONTH.NPR_SOBSTV_ID=KLS_PREDPR.ID(+)
				AND MONTH.K_TAR=KLS_ISKL_TAR.K_TAR(+)
	  			AND ROWNUM=1
				AND NAKL.ID=p_nakl)
LOOP
s:='';
RosInsCnt:=0;
IF (lcur.forma=2) or (lcur.forma=6) then
  s:=s||'ДОГОВОР ';
  if lcur.long_num is not null then
  s:=s||trim(lcur.long_num)||' ЗАДАНИЕ '||trim(lcur.nom_zd);
  end if;
  CASE  
    when (lcur.rodv=2) or (lcur.rodv=5) then s:=s||';Вагон очищен полностью,;под погрузку годен';
    when (lcur.rodv=6) or (lcur.rodv=1) then s:=s||';Вагон(котел) и арматура исправны и ;соответствуют установленным требованиям';
  END CASE;
  s:=s||';ПРОДУКТ: '||Trim(lcur.naim_pr);
  s:=s||';         '||Trim(lcur.gost);
  IF (lcur.bag_ves is not null) then
    s:=s||';Чистый вес: '||Trim(str_fakt);
  end if;    

  IF (lcur.forma=2) AND (lcur.rosinspl1 is not null) AND (Trim(lcur.rosinspl1)<>'0') then 
    s:=s||';'||'Независимый инспектор ЗАО "РОСИНСПЕКТОРАТ"'||';';
	IF(lcur.rosinspl2 is null) then
		s:=s||'пломба ';
	else
		s:=s||'пломбы ';
	end if;
	s:=s||Trim(lcur.rosinspl1);
	IF(lcur.rosinspl2 is not null) then
		s:=s||' и '||Trim(lcur.rosinspl2);
	end if;	
  end if;
  str_list:=RosInsList(p_nakl);
  /* аналогично RosInsList*/
  IF lcur.forma=6 AND NVL(str_list,'')<>'' then
    IF FOR_NAKLPRINT.RosInsCnt(p_nakl)<=7 then
      i1:=instr(',',str_list,1,1);
      i2:=instr(',',str_list,1,4);
      IF i1>0 then
        r1:=SUBSTR(str_list,1,i1-1);
        IF i2>0 then 
          r2:=SUBSTR(str_list,i1+1,i2-i1-1);  
          r3:=SUBSTR(str_list,i2+1,250);    
        ELSE
          r2:=SUBSTR(str_list,i1+1,250);  
          r3:='';
        end if;
      ELSE
        r1:=str_list;
        r2:='';
        r3:=''; 
      end if;  
      s:=s||';'||'Пломбы ЗАО "РОСИНСПЕКТОРАТ": ';
	  IF (r2<>'')then
	  	 s:=s||';'||r2;
	  end if;
	  IF (r3<>'') then
	  	 s:=s||';'||r3;
	  end if;	 
    ELSE
      s:=s||';'||'Пломбы ЗАО "РОСИНСПЕКТОРАТ": '||'СМ.ДОП.ЛИСТ К НАКЛАДНОЙ';
    end if; 
  end if;
  
  
  s:=s||';'||'Собственник груза: '||lcur.sobstv_naim;
  IF (lcur.k_tar is not null) then
    s:=s||';КИТ '||Trim(lcur.k_tar)||' '||Trim(lcur.k_tar_txt);
  end if;
end if;  
if (lcur.forma=6) or(lcur.forma=7) then
--   Групповая накладная
  s:=s||';'||'ПРИЛАГАЕТСЯ ПАСПОРТ N '||Trim(PaspList(p_nakl));
else  
-- Одиночная накладная
  s:=s||';'||'ПРИЛАГАЕТСЯ ПАСПОРТ N '||Trim(lcur.num_pasp);
end if;  
/*IF (lcur.tipv=33) AND ((lcur.forma=6) or(lcur.forma=2))
--   МНОС на внутренний рынок
--  s=s+';'+ESC_SetCond(IsPrinter)+'Инструкция МНОС о возврате порожних вагонов'+ESC_UnSetCond(IsPrinter)
end if;*/
IF (substr(lcur.kod_npr,1,3)='130') AND (lcur.rodv=5) then
--   Битум в полувагонах
  s:=s||';'||'Погрузка в соотв. с актом N 70 от 08.06.04';
  s:=s||';'||fu_fam(FOR_TEMP.GET_AS_NUM('USER_ID',null,null),0,1);
end if;
/*IF form_lst.sobs_gr4 then
  s=s+';'+SobsTitle()+' '+SobsName()
end if;*/
EXIT;
END LOOP;

RETURN s;
END;
/* список пломб Росинспектората если таковые имеются*/
FUNCTION RosInsList(p_nakl NUMBER) RETURN VARCHAR2
AS
s VARCHAR2(255);
BEGIN
s:=',';
FOR lcur IN (SELECT  
			 REESTR.ID as NUM_OTGR,REESTR.ROSINSPL1,REESTR.ROSINSPL2
			 FROM REESTR, SVED, MONTH, NAKL
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
				AND NAKL.ID=p_nakl)
LOOP
	IF (lcur.rosinspl1 is not null) AND Trim(lcur.rosinspl1)<>'0' then
      s:= s||To_char(lcur.num_otgr)||' - '||Trim(lcur.rosinspl1); 
    end if;
    IF (lcur.rosinspl2 is not null) AND Trim(lcur.rosinspl2)<>'0' then
      s:= s||' '||Trim(lcur.rosinspl2);
    end if;
    IF (lcur.rosinspl1 is not null) AND Trim(lcur.rosinspl1)<>'0' then
      s:= s||',';
    end if; 
END LOOP;
RETURN SUBSTR(s,2,LENGTH(s)-2);
END;

FUNCTION RosInsCnt(p_nakl NUMBER) RETURN NUMBER
AS
cnt NUMBER;
BEGIN
CNT:=0;
FOR lcur IN (SELECT  
			 REESTR.ROSINSPL1,REESTR.ROSINSPL2
			 FROM REESTR, SVED, MONTH, NAKL
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
				AND NAKL.ID=p_nakl)
LOOP
	IF (lcur.rosinspl1 is not null) AND Trim(lcur.rosinspl1)<>'0' then
      CNT:=CNT+1; 
    end if;
    IF (lcur.rosinspl2 is not null) AND Trim(lcur.rosinspl2)<>'0' then
      CNT:=CNT+1;
    end if;
END LOOP;
RETURN cnt;
END;

FUNCTION fu_fam(oper_id number,is_neft number,add_post number) RETURN VARCHAR2
AS
s VARCHAR(255);
p VARCHAR(255);
BEGIN
select trim(name),trim(post) into s,p from app_users where app_users.ID=oper_id;
IF is_neft=1 then
    IF add_post=1 then
      IF NLS_UPPER(s)='БИРЮКОВ Р.Е.' then
        s:='Начальник УП '||s;
      ELSE  
        IF NLS_UPPER(s)='ЗАХВАТКИНА Е.А.' then
          s:='Зам.ген.директора '||s;
        ELSE  
          s:=p||' '||s;
        end if;
      end if;
    end if;
ELSE
  IF add_post=1 then 
    s:=p||' '||s;
  end if;  
end if;
RETURN Trim(s);
END;

FUNCTION get_file_sign(oper_id number,is_neft number,add_post number) RETURN VARCHAR2
AS
s VARCHAR(255);
p VARCHAR(255);
BEGIN
select trim(file_sign) into s from app_users where app_users.ID=oper_id;
RETURN Trim(s);
END;

FUNCTION PaspList(p_nakl NUMBER) RETURN VARCHAR2
AS
s VARCHAR2(255);
BEGIN
FOR lcur IN (SELECT  
			 SVED.PASP_NUM as NUM_PASP
			 FROM REESTR, SVED, MONTH, NAKL
			 WHERE REESTR.NAKL_ID=NAKL.ID 
				AND REESTR.SVED_ID=SVED.ID
				AND SVED.NOM_ZD=MONTH.NOM_ZD
				AND NAKL.ID=p_nakl)
LOOP
    IF INSTR(','||Trim(lcur.num_pasp)||',',s)=0 then
      s:=s||Trim(lcur.num_pasp)||',';
    end if;
END LOOP;	
	return s;
END;
/*Считает вес упаковки всех цистерн входящих в накладную*/
FUNCTION bag_ves(p_nakl NUMBER) return NUMBER
AS
res NUMBER;
BEGIN
	 SELECT SUM(upak_ves) INTO res FROM REESTR WHERE reestr.NAKL_ID=p_nakl;
	 RETURN res;
END;
   
FUNCTION kol_vag(p_nakl NUMBER) RETURN NUMBER
AS
  all_cnt NUMBER;
BEGIN
	SELECT COUNT(NUM_CIST)INTO all_cnt FROM REESTR_IN WHERE reestr_in.NAKL_ID=p_nakl;
	RETURN all_cnt;
END;

FUNCTION SobsInfo_voz(p_nakl NUMBER,info VARCHAR2) return NUMBER
AS
CURSOR vagons_cur(NaklId NUMBER) IS 
	   		 SELECT  
			 	 KLS_VAGOWNER.VAGOWN_TYP_ID as TIP_SOBS,REESTR_IN.VAGOWNER_ID as TIPV
			 FROM REESTR_IN,KLS_VAGOWNER
			 WHERE REESTR_IN.VAGOWNER_ID=KLS_VAGOWNER.ID(+)
			 	   AND REESTR_IN.NAKL_ID=NaklId;
vagons_row vagons_cur%ROWTYPE;
SobsExist NUMBER;
SobsOne NUMBER;
m_tipv NUMBER;
BEGIN
   SobsExist:=0;
   SobsOne:=1;
   OPEN vagons_cur(p_nakl);
/* Необходимо задать начальное значение m_tipv, поэтому первую запись просмотрим вне цикла*/
   FETCH vagons_cur INTO vagons_row;
   if vagons_row.tipv<>3 then
	  	 SobsExist:=1;
   end if;

   m_tipv:=NVL(vagons_row.tipv,0);
   LOOP
   	  FETCH vagons_cur INTO vagons_row;
      EXIT WHEN vagons_cur%NOTFOUND;
	  if NVL(vagons_row.tipv,0)<>3 then
	  	 SobsExist:=1;
	  end if;
	  if NVL(vagons_row.tipv,0)<>m_tipv then 
      	 SobsOne:=0;
      end if;		 	 
   END LOOP;
   CLOSE vagons_cur;
   case 
		when info='SobsExist' then return SobsExist;
		when info='SobsOne' then return SobsOne;
   end case;		   
END;

END;/* PAKAGE BODY FOR_NAKLPRINT*/
/

