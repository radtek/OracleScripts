--
-- KLS_GDOR$RP  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER."KLS_GDOR$RP" as
  column_changed$$ RAW(1000);
  procedure rep_delete(
    "GDOR_NAME1_o" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_delete(
    column_changed$ IN RAW,
    "GDOR_NAME1_o" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_insert(
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_update(
    "GDOR_NAME1_o" IN VARCHAR2,
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
  procedure rep_update(
    column_changed$ IN RAW,
    "GDOR_NAME1_o" IN VARCHAR2,
    "GDOR_NAME1_n" IN VARCHAR2,
    "ID2_o" IN NUMBER,
    "ID2_n" IN NUMBER,
    "SHORT_NAME3_o" IN VARCHAR2,
    "SHORT_NAME3_n" IN VARCHAR2,
    site_name IN VARCHAR2,
    propagation_flag IN CHAR);
end "KLS_GDOR$RP";

/

