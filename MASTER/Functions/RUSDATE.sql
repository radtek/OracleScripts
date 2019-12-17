--
-- RUSDATE  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.RusDate(date1 IN DATE)
  RETURN VARCHAR2 IS
  mm_txt VARCHAR2 (20);
  mm NUMBER;
  dd VARCHAR2(2);
  yy VARCHAR2(4);
BEGIN
  mm:=to_number(to_char(date1,'mm'));
  dd:=to_char(date1,'dd');
  yy:=to_char(date1,'yyyy');
--  if to_number(dd)<10 then
--  	 dd:=substr(dd,2,1);
--  end if;
  If mm=1 then
     mm_txt:=' €нвар€ ';
  else if mm=2 then
          mm_txt:=' феврал€ ';
       else if mm=3 then
               mm_txt:=' марта ';
            else if mm=4 then
                    mm_txt:=' апрел€ ';
                 else if mm=5 then
                         mm_txt:=' ма€ ';
                      else if mm=6 then
                              mm_txt:=' июн€ ';
                           else if mm=7 then
                                   mm_txt:=' июл€ ';
                                else if mm=8 then
                                        mm_txt:=' августа ';
                                     else if mm=9 then
                                             mm_txt:=' сент€бр€ ';
                                          else if mm=10 then
                                                  mm_txt:=' окт€бр€ ';
                                               else if mm=11 then
                                                       mm_txt:=' но€бр€ ';
                                                    else
                                                       mm_txt:=' декабр€ ';
                                                    end if;
                                               end if;
                                          end if;
                                     end if;
                                end if;
                           end if;
                      end if;
                 end if;
            end if;
       end if;
  end if;
  RETURN (dd || mm_txt || yy || ' г.');
END;

/

