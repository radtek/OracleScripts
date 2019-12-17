--
-- FOR_NAKLPRINT  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_NAKLPRINT
AS
/******************************************************************************
   NAME:       FOR_NAKLPRINT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27.12.2005             1. Created this package.
******************************************************************************/

/*****************************************************************************
   Для всех подпрограмм p_nakl=reestr.nakl_id или p_nakl=nakl.id 
******************************************************************************/

/*Реквизиты о погрузке вагона*/
   FUNCTION rekv_zagr (p_nakl NUMBER) RETURN VARCHAR2;
/*Выбор строки № NN из строкового выражения. Cтроки разделены ;       */
   FUNCTION StrokaN (stroka VARCHAR2,nn NUMBER,smb VARCHAR2) RETURN VARCHAR2;
   /*Возвращает параметры S1-Отметка таможни/Номер транспорта,S2-Разрешение МПС,S3-Разрешение на продукт,S4-Экспорт*/
   FUNCTION Get_S(p_nakl NUMBER, n NUMBER) RETURN VARCHAR2;
/*№ аварийной карты*/
   FUNCTION AV_KART(AV_KART NUMBER,KOD VARCHAR2,KOD_GR VARCHAR2,PASP_ID VARCHAR2) RETURN VARCHAR2;
/*Дополнительная информация под наименованием груза*/
   FUNCTION Dop_gr_inf(p_nakl NUMBER,cnt NUMBER,KOD_NPR VARCHAR2,KOD_GD VARCHAR2,DATE_OFORML DATE) RETURN VARCHAR2;
   /*Возвращает 'собственник' или 'арендатор'*/
   FUNCTION SobsTitle(p_nakl NUMBER,TIP_SOBS NUMBER) RETURN VARCHAR2;
   /*Возвращает имя собственника вагона, если его нет - '', если собственников несколько то 'см. доп лист накладной'*/
   FUNCTION SobsName(p_nakl NUMBER,VAGOWNER_NAME VARCHAR2) RETURN VARCHAR2;
   /*функция возвращает переменные SobstExist(собствееник существует) и SobstOne(собственник только 1 у всех цист.) 
   Эти переменные определяются в результате анализа всех вагонов накладных
   поэтому и пришлось вынести код в отдельную процедуру т.к. обычно достаточно
   обработать только первую запись. Info='SobstExist' или Info='SobstOne'*/
   FUNCTION SobsInfo(p_nakl NUMBER,info VARCHAR2) return BOOLEAN;
   /* Дополнителные взыскания. cnt-порядковый номер взыска*/
   FUNCTION Dop_vzisk(p_nakl NUMBER,cnt NUMBER) RETURN VARCHAR2;

/*  Функция возвращает один из пунктов дополнительной информации о грузе или взыск название которго передается через
аргумент ident:vzisk1,vzisk2,vzisk3,vzisk4,gr1_txt,gr2_txt,gr3_txt,gr4_txt.Если накладная экспортная, то в vzisk1,vzisk2
возвращаются их экспортные значения */
   FUNCTION Dop_nakl(p_nakl NUMBER, ident VARCHAR2) RETURN VARCHAR2;
   /* Возвращает значение Итого мест для одиночных накладных */
   FUNCTION Itog_mest(rodv NUMBER,shab_form NUMBER,p_nakl NUMBER,forma NUMBER) RETURN VARCHAR2;
   /* Возвращает кол-во цистерн для одиночных накладных */
   FUNCTION all_cnt(p_nakl NUMBER,forma NUMBER) RETURN NUMBER;
   /*Возвращает число прописью. Глобальная PROPIS_S немного не подходит. Это адаптироанная PROPIS_S*/
   FUNCTION propis(cc VARCHAR2, atr NUMBER) RETURN VARCHAR2;
   /* метод замера массы*/
   FUNCTION Defi_mass(p_nakl NUMBER,RODV NUMBER,IS_RUS NUMBER,FORMA NUMBER,KOD_NPR VARCHAR2,
                      VZLIV NUMBER,DEFI_MASS NUMBER) RETURN VARCHAR2;
   /* Возвращает название пломбы по типу ZPU,forma-тип накладной, dop-призн. доп.листа*/
   FUNCTION Zag_plomba(forma NUMBER,p_typ NUMBER,dop NUMBER) RETURN VARCHAR2;
   /* Возвращает номер пломбы по переданному значению reestr.plomba1 или reestr.plomba2, dop-призн. доп.листа*/
   FUNCTION plomba(plomba VARCHAR2,dop NUMBER) RETURN VARCHAR2;
   /*Параграф правил погрузки для печати на обр. стороне накладной зависит от типа вагона и НПР*/
   FUNCTION nakl_para(rodv NUMBER, kod_npr VARCHAR2) RETURN VARCHAR2;
   /*Глава правил погрузки для печати на обр. стороне накладной зависит от типа вагона и НПР*/
   FUNCTION nakl_glav(rodv NUMBER, kod_npr VARCHAR2) RETURN VARCHAR2;
   /*Считает читый вес всех цистерн входящих в накладную*/
   FUNCTION all_ves(p_nakl NUMBER, forma NUMBER) return NUMBER;
   /*Считает вес брутто всех цистерн входящих в накладную*/
   FUNCTION all_brutto(p_nakl NUMBER) return NUMBER;
   /*Считает вес всей тары(цистерн) входящих в накладную*/
   FUNCTION all_tara(p_nakl NUMBER) return NUMBER;
   /*Считает вес упаковки всех цистерн входящих в накладную*/
   FUNCTION bag_ves(p_nakl NUMBER) return NUMBER;
   /*Функция печати атрибутов обратной стороны */
   FUNCTION sertif(p_nakl NUMBER, str_fakt VARCHAR2) return VARCHAR2;
   /* список пломб Росинспектората если таковые имеются*/
   FUNCTION RosInsList(p_nakl NUMBER) RETURN VARCHAR2;
   /* Кол-во пломб Росинспектората*/
   FUNCTION RosInsCnt(p_nakl NUMBER) RETURN NUMBER;
   /*Список паспортов продуктов входящих в накладную*/
   FUNCTION PaspList(p_nakl NUMBER) RETURN VARCHAR2;
   /*Функция нереализована!!! Возвращает имя оператора УНП*/
   FUNCTION fu_fam(oper_id number,is_neft number,add_post number) RETURN VARCHAR2;
   /*Возвращает имя файла с подписью оператора*/
   FUNCTION get_file_sign(oper_id number,is_neft number,add_post number) RETURN VARCHAR2;
   /*Возвращает количество вагонов в накладной на возврат*/
   FUNCTION kol_vag(p_nakl NUMBER) RETURN NUMBER;
   /*Возвращает признак одного собственника вагона или признак существование совственника
     взависимости от значения info: info='SobsOne' или info='SobsExist'*/
   FUNCTION SobsInfo_voz(p_nakl NUMBER,info VARCHAR2) return NUMBER;
   
END for_naklprint;
/

