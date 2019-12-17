--
-- RUSMONTH  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.RusMonth(date1 IN DATE)
  RETURN VARCHAR2 IS
  mm_txt VARCHAR2 (20);
  mm NUMBER;
  yy VARCHAR2(4);
BEGIN
  mm:=to_number(to_char(date1,'mm'));
  yy:=to_char(date1,'yyyy');
  If mm=1 then
     mm_txt:=' Январь ';
  else if mm=2 then
          mm_txt:=' Февраль ';
       else if mm=3 then
               mm_txt:=' Март ';
            else if mm=4 then
                    mm_txt:=' Апрель ';
                 else if mm=5 then
                         mm_txt:=' Май ';
                      else if mm=6 then
                              mm_txt:=' Июнь ';
                           else if mm=7 then
                                   mm_txt:=' Июль ';
                                else if mm=8 then
                                        mm_txt:=' Август ';
                                     else if mm=9 then
                                             mm_txt:=' Сентябрь ';
                                          else if mm=10 then
                                                  mm_txt:=' Октябрь ';
                                               else if mm=11 then
                                                       mm_txt:=' Ноябрь ';
                                                    else
                                                       mm_txt:=' Декабрь ';
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
  RETURN (mm_txt || yy || ' г.');
END;

/

