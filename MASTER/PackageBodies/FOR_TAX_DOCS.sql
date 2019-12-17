--
-- FOR_TAX_DOCS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_TAX_DOCS is

FUNCTION GetUserId(pUSER_NAME varchar2) return NUMBER as
    vId number;
    vName varchar2(255);
begin
-- Проверка существования
    vName:=Trim(pUSER_NAME);
    UPDATE ISU_TAX_USER SET USER_NAME=vName WHERE USER_NAME=vName;
    IF SQL%NOTFOUND THEN
      -- Добавляем USERa
      INSERT INTO ISU_TAX_USER (USER_NAME) VALUES (vName);
    END IF;

    SELECT /*+ RULE */ ID
        INTO vId
    FROM isu_tax_user
    WHERE USER_NAME=vName;
    /*EXCEPTION
      WHEN OTHERS THEN
        IF vAdd=0 THEN
          RaiseError('Накладную нельзя отредактировать - она удалена!');
      END IF;*/ 

    RETURN vId;    
end;

FUNCTION GetContrId(pCONTR_NAME varchar2) return NUMBER as
    vId number;
    vName varchar2(255);
begin
-- Проверка существования
    vName:=Trim(pCONTR_NAME);
    UPDATE ISU_TAX_CONTR SET CONTR_NAME=vName WHERE CONTR_NAME=vName;
    IF SQL%NOTFOUND THEN
      -- Добавляем USERa
      INSERT INTO ISU_TAX_CONTR (CONTR_NAME) VALUES (vName);
    END IF;
   
 SELECT /*+ RULE */ ID
        INTO vId
    FROM isu_tax_contr
    WHERE CONTR_NAME=vName;
    /*EXCEPTION
      WHEN OTHERS THEN
        IF vAdd=0 THEN
          RaiseError('Накладную нельзя отредактировать - она удалена!');
        END IF;*/
    RETURN vId;    
end;


FUNCTION GetFileId(pFILE_NAME varchar2, pSOURCE_ID NUMBER, pUSER_ID NUMBER) return NUMBER as
    vId number;
    vName varchar2(255);
begin
-- Проверка существования
    vName:=Trim(pFILE_NAME);
    UPDATE  ISU_TAX_FILES SET FILE_NAME=vName WHERE FILE_NAME=vName;
    IF SQL%NOTFOUND THEN
      -- Добавляем новый файл
      INSERT INTO ISU_TAX_FILES (FILE_NAME,USER_ID,SOURCE_ID,UPLOAD_DATE) VALUES (vName,pUSER_ID, pSOURCE_ID,CURRENT_DATE);
    END IF;
   
 SELECT /*+ RULE */ ID
        INTO vId
    FROM isu_tax_files
    WHERE FILE_NAME=vName;
    /*EXCEPTION
      WHEN OTHERS THEN
        IF vAdd=0 THEN
          RaiseError('Накладную нельзя отредактировать - она удалена!');
        END IF;*/
    RETURN vId;    
end;

  -- Ошибка
/*PROCEDURE AddPackageRow(pId number) as
vId number;
begin
    FOR lcur IN (select Id from isu_tax_docs where parent_doc_id=pId)
    LOOP
      UPDATE isu_tax_tmp_new_package set id=lcur.id where id=lcur.id;
      if SQL%NOTFOUND then
         insert into isu_tax_tmp_new_package (id) values (lcur.Id);
      end if;   
      AddPackageRow(lcur.Id);
    END LOOP;
end;*/

PROCEDURE RaiseError (pText VARCHAR2) AS
BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
END;

FUNCTION AddDoc(pDOC_NUM VARCHAR2, pDOC_DATE DATE, pFILE_NAME VARCHAR2, pFILE_POS NUMBER, pCONTR_NAME VARCHAR2,pUSER_NAME VARCHAR2,pSOURCE_ID NUMBER)
RETURN NUMBER  AS
    vContrId    number;
    vFileId     number;
    vUserId     number;
    vDocId      number;
    vFileName   varchar2(255);                  
BEGIN
    /*IF vCNT>0 THEN
      RaiseError('Накладную нельзя удалить - есть позиции!');
    END IF;*/
    vContrId:=GetContrId(pCONTR_NAME);
    vUserId:=GetUserId(pUSER_NAME);    
    vFileId:=GetFileId(pFILE_NAME,pSOURCE_ID,vUserId);

    UPDATE isu_tax_docs set (file_id, file_pos_num)=(Select vFileId, pFILE_POS from dual) 
    WHERE file_id=vFileId and file_pos_num=pFILE_POS;
    IF SQL%NOTFOUND THEN
    -- Добавляем документ
        INSERT INTO ISU_TAX_DOCS (DOC_NUM, DOC_DATE, FILE_ID, FILE_POS_NUM, CONTRACTOR_ID)
        VALUES (pDOC_NUM, pDOC_DATE, vFileId, pFILE_POS,vContrId);
    --Во временную таблицу существующих документов добавим строки с такими же Номером, Датой и контрагентом
        --INSERT INTO ISU_TAX_EXIST (DOC_ID,REASON_ID,FILE_ID,FILE_POS_NUM) 
      --  SELECT ID,2,FILE_ID,FILE_POS_NUM FROM ISU_TAX_DOCS WHERE DOC_NUM=pDOC_NUM AND DOC_DATE=pDOC_DATE AND CONTRACTOR_ID=vContrId;      
        
    ELSE
        SELECT ID INTO vDocId FROM ISU_TAX_DOCS WHERE file_id=vFileId and file_pos_num=pFILE_POS;
--        update isu_tax_exist set(doc_id,reason_id)=(select vDocId,1 from dual);
--        IF SQL%NOTFOUND THEN
        INSERT INTO ISU_TAX_EXIST (DOC_ID,REASON_ID,FILE_ID, FILE_POS_NUM) 
        VALUES (vDocId,1,vFileId,pFILE_POS);
--        end if;          
        
    END IF;

  -- COMMIT
/*    IF pCOMMIT=1 THEN
	  COMMIT;
    END IF;*/
    RETURN 0;
END;

FUNCTION AddPackage(pPACK_NUM VARCHAR2, pPACK_DATE DATE ) RETURN NUMBER AS
 vId number;
BEGIN
    UPDATE ISU_TAX_PACKAGE set pack_num=pPACK_NUM where pack_num=pPACK_NUM and pack_date=pPACK_DATE;
    IF SQL%NOTFOUND THEN
    -- Добавляем документ
        SELECT SEQ_TAX_ID.nextval INTO vID FROM DUAL;
        INSERT INTO ISU_TAX_PACKAGE (ID,PACK_NUM, PACK_DATE)
        VALUES (vId, pPACK_NUM, pPACK_DATE);
   END IF;

  -- COMMIT
--    IF pCOMMIT=1 THEN
--	  COMMIT;
--   END IF;
    FillPackage(vId);
	RETURN vId;
END;

Procedure FillPackage(pPack_id number) as
vId NUMBER;  
begin
--UPDATE isu_tax_tmp_new_package set id=pId_Doc where id=pID_DOC;
  --if SQL%NOTFOUND then
     update isu_tax_docs set package_id=pPack_id where id in (select id from isu_tax_tmp_new_package);
--  end if;
end;

/*
function AssignParent(pDoc number, pParent_doc number) return number
   AS
vParent_rel_Id number;
vDoc_parent_rel_id number;    
begin
    select r.id into vParent_rel_id from isu_tax_docs d join isu_tax_rel r on D.DOC_REL_ID=R.ID 
    where d.id=pParent_doc;
    select r.pId into vDoc_parent_rel_id from isu_tax_docs d join isu_tax_rel r on D.DOC_REL_ID=R.ID 
    where d.id=pDoc;
    if vDoc_parent_rel_id=vParent_rel_id then
        return 1;
    else 
        return 0;
    end if;        

end;
*/
end FOR_TAX_DOCS; 
/

