/* ==============================================================================
              10.Остатки по товарным запасам и журналу складских операций
   ============================================================================== */
PROCEDURE FILL_GOODSSUPPLY_OST (nSOURCE_ID NUMBER DEFAULT 10) IS
  cond TB_SNP_STORE_COND_PSV%ROWTYPE; /* Условия отбора */
  SQLText VARCHAR2(2000); /* Динамический запрос */
  vUSER VARCHAR2(100);
  dCurDate DATE;
  dPrevDate DATE;
BEGIN

  vUSER:=NLS_UPPER(SYS_CONTEXT('USERENV','OS_USER'));
  /* ---------------------------------------------------------------
               Условия отбора
  ------------------------------------------------------------------ */
  BEGIN
	SELECT * INTO cond FROM TB_SNP_STORE_COND_PSV WHERE USER_ID = vUSER;
  EXCEPTION
	WHEN OTHERS THEN
	  RETURN;
  END;

  /* -------------------------------------------------------
                  Очистить временную таблицу
  ---------------------------------------------------------- */
  IF cond.RUNMODE=0 THEN
    EMPTY_TEMP_STORE(nSOURCE_ID,cond.STORE_RN);
  END IF;

  /* --------------------------------------------------------------
            Остатки по товарным запасам и журналу складских операций
  ----------------------------------------------------------------- */

  -- Список складов
  FOR lcur IN (SELECT ds.nRN as STORE_RN
                     FROM vaneev.v_dicstore_psv ds  
                    WHERE ds.NO_WORK=0
					  AND ds.SDEP_READY LIKE NVL(cond.DEP_CODE,'%') -- Штатное подразделение 
					  AND ds.nSTORE_TYPE=DECODE(NVL(cond.STORE_TYPE,-1),-1,ds.nSTORE_TYPE,cond.STORE_TYPE) -- Тип склада
					  AND ds.sNUMB=DECODE(NVL(cond.STORE_RN,0),0,ds.sNUMB,cond.STORE_RN) -- Склад
					  AND ds.IS_AUTO=DECODE(NVL(cond.IS_AUTO,-1),-1,ds.IS_AUTO,cond.IS_AUTO) -- Автоматизированный
                  ) LOOP

     -- Формируем запрос
     SQLText:='INSERT  INTO TB_SNP_STORE_OST_PSV (USER_ID, SOURCE_ID, '||
	           '  STORE_RN, NOMEN_RN, GOODSPARTY_RN, LAST_DAY, TIP_LAST_DAY, SM_NUMBER, SM_BEGIN, SM_END, '||
		       '  PRICE, BEGIN_VOLUME, BEGIN_MASSA, END_VOLUME_FACT, END_MASSA_FACT, END_VOLUME_SALE, END_MASSA_SALE, ' ||
		       '  END_FULL, END_WATER) ' ||
               'SELECT  ' ||
		       ' :USER_ID, :SOURCE_ID, ' ||
               ' :STORE_RN, ' ||
               ' NOMEN_RN, ' ||
		       ' NULL as GOODSPARTY_RN, ' ||
               ' :LAST_DAY,  '||
               ' 2 as TIP_LAST_DAY,  '||
               ' NULL as SM_NUMBER, ' ||
               ' NULL as SM_BEGIN, ' ||
               ' NULL as SM_END, ' ||
		       ' 0 as PRICE, ' ||
               ' DECODE(:IS_BEGIN,1,VOLUME) as BEGIN_VOLUME,  ' ||
               ' DECODE(:IS_BEGIN,1,MASSA)  as BEGIN_MASSA,   ' ||
               ' DECODE(:IS_BEGIN,0,VOLUME) as END_VOLUME_FACT,  ' ||
               ' DECODE(:IS_BEGIN,0,MASSA) as END_MASSA_FACT,   ' ||
               ' DECODE(:IS_BEGIN,0,VOLUME) as END_VOLUME_SALE,  ' ||
               ' DECODE(:IS_BEGIN,0,MASSA) as END_MASSA_SALE, ' ||
               ' 0 as END_FULL, ' ||
               ' 0 as END_WATER ' ||
               'FROM ( '||
			   '      SELECT dn.RN as NOMEN_RN, ' ||
               '        SUM(F_GOODSSUPPLYONDATE_REST(GP.COMPANY, S.RN, :dDATE, ''QUANT'')) as VOLUME,  ' ||
               '        SUM(F_GOODSSUPPLYONDATE_REST(GP.COMPANY, S.RN, :dDATE, ''QUANTALT'')) as MASSA   ' ||
			   '       FROM GOODSPARTIES GP, GOODSSUPPLY S, NOMMODIF NM, DICNOMNS dn ';

    SQLText:=SQLText ||
               '      WHERE S.PRN = GP.RN and GP.NOMMODIF = NM.RN and NM.PRN = dn.RN ' ||
               '        AND dn.CRN IN (72822846,506436) ' ||
  	           '        AND and S.STORE = :STORE_RN '; 
		   
    -- Группа н/пр
    IF cond.GROUP_RN<>0 THEN
	  SQLText:=SQLText || ' AND dn.GROUP_CODE='||TO_CHAR(cond.GROUP_RN);
	END IF;
	-- Н/пр
    IF cond.NOMEN_RN<>0 THEN
	  SQLText:=SQLText || ' AND dn.RN='||TO_CHAR(cond.NOMEN_RN);
    END IF;

    SQLText:=SQLText ||
           '       GROUP BY dn.RN) ';
	 				  
	-- Перебираем дни в обратном порядке
	FOR i IN 0..(cond.End_Date-cond.Beg_Date) LOOP  			  
	  dCurDate:=cond.End_Date-i;
	  dPrevDate:=cond.End_Date-i-1;
	   
      -- Остатки на начало дня
      EXECUTE IMMEDIATE SQLText USING vUSER,nSOURCE_ID,lcur.STORE_RN,
  	    dCurDate,1,1,1,1,1,1,dPrevDate,dPrevDate,lcur.STORE_RN;
      COMMIT;

      -- Остатки на конец дня
      EXECUTE IMMEDIATE SQLText USING vUSER,nSOURCE_ID,lcur.STORE_RN,
  	    dCurDate,0,0,0,0,0,0,dCurDate,dCurDate,lcur.STORE_RN;
      COMMIT;

	  IF cond.ByDay<>1 THEN 
	    -- Только последнюю смену 
	    EXIT; 
	  END IF;
    END LOOP;
  END LOOP;
  COMMIT;	

END;
