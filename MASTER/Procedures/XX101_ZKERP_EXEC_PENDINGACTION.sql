--
-- XX101_ZKERP_EXEC_PENDINGACTION  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Xx101_Zkerp_Exec_Pendingaction IS
  vFLG_DOP_CIST NUMBER;
  vBILL_POS_ID NUMBER;
  vMinDate DATE;
  vMaxDate DATE;
  vNomZd VARCHAR2(16);
  vID NUMBER;
  vSvedID VARCHAR2(9);
  vPaspID VARCHAR2(9);
  v_dat DATE;
  vTexPdID NUMBER;
  vExpedID NUMBER;
  vGrotpID NUMBER;
BEGIN
     
  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
      FROM ARH_DATE WHERE ARH_DATE.TABLENAME='MONTH';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

  vMinDate:=TO_DATE('31.12.2049','dd.mm.yyyy');
  vMaxDate:=TO_DATE('31.12.1899','dd.mm.yyyy');
  -- Перебор поставок
  FOR lcur IN (
   SELECT * FROM XX101_ZKERP_TO_KVIT B
--------------------------------------------------------------------------------      
-- Сергей Антонов 06.10.2008     
-- xx101_zkerp_data z,
-- WHERE propagatestatus IS NULL  AND (date_otgr>=TO_DATE('01.04.2008','dd.mm.yyyy') or actioncode=2)     
------------------------------------------------------------------------------      
              ORDER BY filename,TO_NUMBER(filerownum)
              )
               
               
  LOOP
    IF lcur.date_otgr<vMinDate THEN
      vMinDate:=lcur.date_otgr;
    END IF;
    IF lcur.date_otgr>vMaxDate THEN
      vMaxDate:=lcur.date_otgr;
    END IF;
      
    -- признак внепланового вагона
--    IF lcur.DATE_OTGR>=to_date('01.01.2008','dd.mm.yyyy') then
      -- проставляем признак внеплановых вагонов (с 01.01.2008)
--      vFLG_DOP_CIST:=0;
--      BEGIN
--        select 1 into vFLG_DOP_CIST from kvit_vneplan
--         where kvit_vneplan.NUM_KVIT=lcur.NUM_KVIT
--           and kvit_vneplan.NOM_Z=lcur.NOM_ETRAN
--           and kvit_vneplan.IS_VNEPLAN=1
--      exception
--        when others then
--          vFLG_DOP_CIST:=0;
--      end;       
--    else
      vFLG_DOP_CIST:=lcur.FLG_DOP_CIST;
--    end if;    
    
    -- значения по умолчанию
    vBILL_POS_ID:=1; 

    -- определяем наличие поставки
    vID:=lcur.id;
    BEGIN
      SELECT id INTO vID FROM KVIT WHERE id=lcur.id;
    EXCEPTION 
      WHEN OTHERS THEN
        vID:=0;
    END;        

    -- определяем наличие сведения
    vSvedID:=trim(lcur.sved_id);
    BEGIN
      SELECT id INTO vSvedID FROM SVED WHERE id=trim(lcur.sved_id);
    EXCEPTION 
      WHEN OTHERS THEN
        vSvedID:='';
    END;        

    -- добавляем паспорт
    vPaspID:=trim(lcur.pasp_id);

    IF vPaspID||' '<>' ' THEN
      UPDATE KLS_PASP SET
      (pasp_num,
       rez_num,
       pasp_date,
       prod_id_npr,
       mesto_id,
       date_vir,
       pasp_typ
      )=
      (SELECT 
       lcur.pasp_num,
       '?',
       lcur.date_otgr,
       lcur.prod_id_npr,
       lcur.mesto_id,
       lcur.date_otgr,
       1
       FROM dual
      ) 
      WHERE id=trim(vPaspID);  

      IF SQL%NOTFOUND THEN
        INSERT INTO KLS_PASP  
        (ID,
         pasp_num,
         rez_num,
         pasp_date,
         prod_id_npr,
         mesto_id,
         date_vir,
         pasp_typ
        )
        VALUES 
        (lcur.pasp_id,
         lcur.pasp_num,
         '?',
         lcur.date_otgr,
         lcur.prod_id_npr,
         lcur.mesto_id,
         lcur.date_otgr,
         1
        ); 
        
        vPaspID:=trim(lcur.pasp_id);
      END IF;
    END IF;
      
    -- определяем реквизиты из разнарядки
    vNomZD:=trim(lcur.nom_zd);
    BEGIN
      SELECT nom_zd,tex_pd_id,exped_id,grotp_id INTO vNomZD,vTexPdID,vExpedID,vGrotpID FROM MONTH WHERE nom_zd=trim(lcur.nom_zd);
    EXCEPTION 
      WHEN OTHERS THEN
        vNomZD:='';
    END;        
    
    ----------------------------
    -- ОБРАБОТКА
    ----------------------------
    IF lcur.actioncode=2 THEN
      -- удаление поставки
      DELETE FROM KVIT A WHERE id=vID;

--------------------------------------------------------------------------------      
-- Сергей Антонов 06.10.2008       
      -- флаг обработки  
--      UPDATE XX101_ZKERP_DATA A SET A.PROPAGATESTATUS=1 WHERE a.filename=lcur.filename AND a.filerownum=lcur.filerownum;
--      COMMIT;
--------------------------------------------------------------------------------      
     ELSE
      -- добавление/изменение сведения
      IF trim(lcur.sved_id)||' '<>' ' THEN
        UPDATE SVED SET 
          (FLG_OPERDATA,
           SVED_NUM,
           SVED_DATE,
           DATE_OFORML,
           PASP_ID,
           PROD_ID_NPR,
           MESTO_ID,
           DATE_EDIT
          )= 
          (SELECT
           0,
           lcur.sved_num,
           lcur.date_otgr,
           lcur.date_oforml,
           lcur.pasp_id,
           lcur.prod_id_npr,
           lcur.MESTO_ID,
           lcur.date_oforml
           FROM dual) 
        WHERE id=trim(vSvedID);
      
        IF SQL%NOTFOUND THEN
          -- добавляем сведение
          INSERT INTO SVED  
          (ID,
           FLG_OPERDATA,
           SVED_NUM,
           SVED_DATE,
           DATE_OFORML,
           PASP_ID,
           PROD_ID_NPR,
           MESTO_ID,
           DATE_EDIT
          )
          VALUES 
          (lcur.sved_ID,         
           0,
           lcur.sved_num,
           lcur.date_otgr,
           lcur.date_oforml,
           lcur.pasp_id,
           lcur.prod_id_npr,
           lcur.MESTO_ID,
           lcur.date_oforml
          ); 
       
          vSvedID:=trim(lcur.sved_id);
        END IF; --добавление сведения        
      END IF;
      
      -- добавление/изменение поставки
      UPDATE KVIT SET 
        (FLG_OPERDATA,
         MESTO_ID,
         nom_zd,
         prod_id_npr,
         tex_pd_id,
         num_cist,
         date_otgr,
         ves,
         ves_brutto,
         ves_ed,
         kol_ed,
         tarif,
         tarif_orig,
         num_kvit,
         date_kvit,
         flg_dop_cist,
         flg_vag_klient,
         vagowner_id,
         vagontype_id,
         kalibr_id,
         ves_cist,
         plomba1,
         plomba2,
         vzliv,
         temper,
         fakt_pl,
         shabexp_id,
         exped_id,
         vetka_otp_id,
         sved_id,
         date_oforml,
         sved_num,
         pasp_id,
         num_dover,
         perer_id,
         date_edit,
         JKCOMMIT,
         grotp_id,
         capacity,
         poddons,
         bill_pos_id,
         ttn_id,
         date_dover,
         fio_driver,
         axes,
         defi_mass_id,
         volume
        )= 
        (SELECT
         0,
         lcur.MESTO_ID,
         lcur.nom_zd,
         lcur.prod_id_npr,
         vTexPdID,
         lcur.num_cist,
         lcur.date_otgr,
         lcur.ves,
         lcur.ves_brutto,
         lcur.ves_ed,
         lcur.kol_ed,
         lcur.tarif,
         lcur.tarif,
         Ora_Val(lcur.num_kvit),
         lcur.date_kvit,
         vflg_dop_cist,
         0,
         lcur.vagowner_id,
         lcur.vagontype_id,
         lcur.kalibr_id,
         lcur.ves_cist,
         lcur.plomba1,
         lcur.plomba2,
         lcur.vzliv,
         lcur.temper,
         lcur.fakt_pl,
         lcur.shabexp_id,
         vExpedID,
         lcur.vetka_otp_id,
         lcur.sved_id,
         lcur.date_oforml,
         lcur.sved_num,
         lcur.pasp_id,
         lcur.num_dover,
         8,
         lcur.date_oforml,
         1,
         vGrotpID,
         lcur.capacity,
         lcur.poddons,
         vBill_pos_id,
         lcur.ttn_id,
         lcur.date_dover,
         lcur.fio_driver,
         lcur.axes,
         1,
         lcur.volume
         FROM dual) 
      WHERE id=vID;
      
      IF SQL%NOTFOUND THEN
        -- добавляем поставку
        INSERT INTO KVIT  
        (ID,
         FLG_OPERDATA,
         MESTO_ID,
         nom_zd,
         prod_id_npr,
         tex_pd_id,
         num_cist,
         date_otgr,
         ves,
         ves_brutto,
         ves_ed,
         kol_ed,
         tarif,
         tarif_orig,
         num_kvit,
         date_kvit,
         flg_dop_cist,
         flg_vag_klient,
         vagowner_id,
         vagontype_id,
         kalibr_id,
         ves_cist,
         plomba1,
         plomba2,
         vzliv,
         temper,
         fakt_pl,
         shabexp_id,
         exped_id,
         vetka_otp_id,
         sved_id,
         date_oforml,
         sved_num,
         pasp_id,
         num_dover,
         perer_id,
         date_edit,
         JKCOMMIT,
         grotp_id,
         capacity,
         poddons,
         bill_pos_id,
         ttn_id,
         date_dover,
         fio_driver,
         axes,
         defi_mass_id,
         volume
        )
        VALUES 
        (lcur.ID,         
         0,
         lcur.MESTO_ID,
         lcur.nom_zd,
         lcur.prod_id_npr,
         vTexPdID,
         lcur.num_cist,
         lcur.date_otgr,
         lcur.ves,
         lcur.ves_brutto,
         lcur.ves_ed,
         lcur.kol_ed,
         lcur.tarif,
         lcur.tarif,
         Ora_Val(lcur.num_kvit),
         lcur.date_kvit,
         vflg_dop_cist,
         0,
         lcur.vagowner_id,
         lcur.vagontype_id,
         lcur.kalibr_id,
         lcur.ves_cist,
         lcur.plomba1,
         lcur.plomba2,
         lcur.vzliv,
         lcur.temper,
         lcur.fakt_pl,
         lcur.shabexp_id,
         vExpedID,
         lcur.vetka_otp_id,
         lcur.sved_id,
         lcur.date_oforml,
         lcur.sved_num,
         lcur.pasp_id,
         lcur.num_dover,
         8,
         lcur.date_oforml,
         1,
         vGrotpID,
         lcur.capacity,
         lcur.poddons,
         vBill_pos_id,
         lcur.ttn_id,
         lcur.date_dover,
         lcur.fio_driver,
         lcur.axes,
         1,
         lcur.volume
        ); 
        
        vID:=lcur.id;
      END IF; --добавление поставки        
   
--------------------------------------------------------------------------------      
-- Сергей Антонов 06.10.2008        
--      UPDATE XX101_ZKERP_DATA A SET A.PROPAGATESTATUS=1 WHERE a.filename=lcur.filename AND a.filerownum=lcur.filerownum;
--      COMMIT;   
--------------------------------------------------------------------------------      
    END IF; -- добавление/изменение/удаление  
--------------------------------------------------------------------------------      
-- Сергей Антонов 06.10.2008 

    -- флаг обработки
    UPDATE XX101_ZKERP_DATA A SET A.PROPAGATESTATUS=1 WHERE a.filename=lcur.filename AND a.filerownum=lcur.filerownum;
    UPDATE XX101_ZKERP_DATA A SET A.PROPAGATESTATUS=0 WHERE a.waybillid=lcur.waybillid AND 
                                                            a.waybillrowid=lcur.waybillrowid and 
                                                            a.propagatestatus IS NULL;
    COMMIT;                                                                 
--------------------------------------------------------------------------------          
  END LOOP;
  
  -- пересчитать факт
  For_Zakaz.FillFact(0,TRUNC(vMinDate,'MONTH'),LAST_DAY(vMaxDate));
  for_zakaz.FillFactThisMonth;
  
  UPDATE SVED SET (SVED_VES, SVED_CNT)=
    (SELECT SUM(ves_brutto),COUNT(*) FROM KVIT WHERE KVIT.sved_id=SVED.id GROUP BY KVIT.sved_id)
  WHERE EXISTS (SELECT NULL FROM KVIT WHERE KVIT.sved_id=SVED.id)
    AND sved_date BETWEEN vMinDate AND vMaxDate;
      
  COMMIT;                                

END Xx101_Zkerp_Exec_Pendingaction; 
/

