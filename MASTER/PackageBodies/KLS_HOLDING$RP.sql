--
-- KLS_HOLDING$RP  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER."KLS_HOLDING$RP" as
  procedure rep_delete(
    "BOSS1_o" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    rep_delete(
      NULL,
      "BOSS1_o",
      "HOLDING_NAME2_o",
      "ID3_o",
      site_name,
      propagation_flag);
  end rep_delete;
  procedure rep_delete(
    column_changed$ IN RAW,
    "BOSS1_o" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_HOLDING','REP_DELETE',6);
    DBMS_REPCAT_INTERNAL_PACKAGE.RAW_ARG(column_changed$);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("BOSS1_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("HOLDING_NAME2_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID3_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_delete;
  procedure rep_insert(
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_HOLDING','REP_INSERT',5);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("BOSS1_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("HOLDING_NAME2_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID3_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_insert;
  procedure rep_update(
    "BOSS1_o" IN VARCHAR2,
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    rep_update(
      NULL,
      "BOSS1_o",
      "BOSS1_n",
      "HOLDING_NAME2_o",
      "HOLDING_NAME2_n",
      "ID3_o",
      "ID3_n",
      site_name,
      propagation_flag);
  end rep_update;
  procedure rep_update(
    column_changed$ IN RAW,
    "BOSS1_o" IN VARCHAR2,
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR) is
  begin
    DBMS_REPCAT_INTERNAL_PACKAGE.CALL(
      'MASTER','KLS_HOLDING','REP_UPDATE',9);
    DBMS_REPCAT_INTERNAL_PACKAGE.RAW_ARG(column_changed$);
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("BOSS1_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("BOSS1_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("HOLDING_NAME2_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG("HOLDING_NAME2_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID3_o");
    DBMS_REPCAT_INTERNAL_PACKAGE.NUMBER_ARG("ID3_n");
    DBMS_REPCAT_INTERNAL_PACKAGE.VARCHAR2_ARG(site_name);
    DBMS_REPCAT_INTERNAL_PACKAGE.CHAR_ARG(propagation_flag);
  end rep_update;
end "KLS_HOLDING$RP";

/

