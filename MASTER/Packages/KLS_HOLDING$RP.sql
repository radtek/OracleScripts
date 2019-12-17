--
-- KLS_HOLDING$RP  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER."KLS_HOLDING$RP" as
  column_changed$$ RAW(1000);
  procedure rep_delete(
    "BOSS1_o" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_delete(
    column_changed$ IN RAW,
    "BOSS1_o" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_insert(
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_update(
    "BOSS1_o" IN VARCHAR2,
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_update(
    column_changed$ IN RAW,
    "BOSS1_o" IN VARCHAR2,
    "BOSS1_n" IN VARCHAR2,
    "HOLDING_NAME2_o" IN VARCHAR2,
    "HOLDING_NAME2_n" IN VARCHAR2,
    "ID3_o" IN NUMBER,
    "ID3_n" IN NUMBER,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
end "KLS_HOLDING$RP";

/

