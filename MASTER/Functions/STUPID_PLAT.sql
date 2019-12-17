--
-- STUPID_PLAT  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.STUPID_PLAT(Kod_plat IN NUMBER)
   RETURN VARCHAR2
   IS
   ret VARCHAR(100);
   BEGIN
      RET:='ничего';
      IF (kod_plat in (456)) THEN
	    RET:=('ООО "ЛУКОЙЛ-Холдинг-Сервис');
	  END IF;
      IF (kod_plat in (12,717,2794)) THEN
        RET:=('ООО "Торговый Дом ЛУКОЙЛ');
      END IF;
      IF (kod_plat in (827,828)) THEN
        RET:=('ЗАО "ЛУКОЙЛ-Нефтехим');
      END IF;
	  RETURN Ret;
    END;

/

