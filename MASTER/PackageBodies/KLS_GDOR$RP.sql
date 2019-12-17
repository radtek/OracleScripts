--
-- KLS_GDOR$RP  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER."KLS_GDOR$RP" as
  procedure rep_delete(
    "GDOR_NAME1_o" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    rep_delete(
      NULL,
      "GDOR_NAME1_o",
      "ID2_o",
      "SHORT_NAME3_o",
      site_name,
      propagation_flag);
  end rep_delete;
  procedure rep_delete(
    column_changed$ IN RAW,
    "GDOR_NAME1_o" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_GDOR','REP_DELETE',6);
    DBMS_REPCAT_INTERNAL_PACKAGE.RAW_ARG(column_changed$);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("GDOR_NAME1_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID2_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("SHORT_NAME3_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_delete;
  procedure rep_insert(
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_GDOR','REP_INSERT',5);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("GDOR_NAME1_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID2_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("SHORT_NAME3_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_insert;
  procedure rep_update(
    "GDOR_NAME1_o" IN VARCHAR2,
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    rep_update(
      NULL,
      "GDOR_NAME1_o",
      "GDOR_NAME1_n",
      "ID2_o",
      "ID2_n",
      "SHORT_NAME3_o",
      "SHORT_NAME3_n",
      site_name,
      propagation_flag);
  end rep_update;
  procedure rep_update(
    column_changed$ IN RAW,
    "GDOR_NAME1_o" IN VARCHAR2,
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_GDOR','REP_UPDATE',9);
    DBMS_REPCAT_INTERNAL_PACKAGE.RAW_ARG(column_changed$);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("GDOR_NAME1_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("GDOR_NAME1_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID2_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID2_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("SHORT_NAME3_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("SHORT_NAME3_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_update;
end "KLS_GDOR$RP";

/

