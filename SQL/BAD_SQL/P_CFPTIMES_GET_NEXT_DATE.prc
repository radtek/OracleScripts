CREATE OR REPLACE procedure       P_CFPTIMES_GET_NEXT_DATE
(
  nPRN  in  number,
  dNEXT out date
)
as
  dBEGIN  date;
  dEND    date;
begin
  parus.P_CFPTIMES_GET_INTERVAL(nPRN, dBEGIN, dEND);
  dNEXT := dEND + 1;
end;
/

