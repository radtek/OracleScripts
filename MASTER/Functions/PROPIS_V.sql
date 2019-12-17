--
-- PROPIS_V  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.PROPIS_V(cc VARCHAR2, atr NUMBER, all_cc VARCHAR2)
  RETURN VARCHAR2 IS
  s NUMBER;
  d NUMBER;
  o NUMBER;
  Err NUMBER;
  res VARCHAR2(50);
  sto VARCHAR2(50);
  des VARCHAR2(50);
  ons VARCHAR2(50);
  ending VARCHAR2(50);
BEGIN
  S:=TO_NUMBER(SUBSTR(cc,1,1));
  D:=TO_NUMBER(SUBSTR(cc,2,1));
  O:=TO_NUMBER(SUBSTR(cc,3,1));
  if atr=1 then
    ending:='( ' || all_cc || ' ) тонн';
  else if atr=2 then
          ending:='тыс€ч';
	   else if atr=3 then
               ending:='миллионов';
			else
               ending:='миллиардов';
			end if;
	   end if;
  end if;
  if s=0 then
     sto := '';
  else if s=1 then
          sto := 'сто';
	   else if s=2 then
	           sto := 'двести';
			else if s=3 then
                    sto := 'триста';
				 else if s=4 then
                         sto := 'четыреста';
                      else if s=5 then
                              sto := 'п€тьсот';
				           else if s=6 then
                                   sto := 'шестьсот';
				                else if s=7 then
                                        sto := 'семьсот';
				                     else if s=8 then
                                             sto := 'восемьсот';
				                          else
                                             sto := 'дев€тьсот';
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  if d=0 then
    des := '';
  else if d=1 then
          IF o = 0 Then
		     des := 'дес€ть';
          ELSE
		     des := 'надцать';
		  END IF;
	   else if d=2 then
               des := 'двадцать';
			else if d=3 then
                    des := 'тридцать';
				 else if d=4 then
                         des := 'сорок';
					  else if d=5 then
                              des := 'п€тьдес€т';
						   else if d=6 then
                                   des := 'шестьдес€т';
								else if d=7 then
                                        des := 'семьдес€т';
									 else if d=8 then
                                             des := 'восемьдес€т';
										  else
                                             des := 'дев€носто';
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  if o=0 then
    ons := '';
  else if o=1 then
         IF (atr = 2) AND (d <> 1) Then
		   ons := 'одна';
         ELSE
		   ons := 'один';
		 END IF;
         if d<>1 then
           if atr=1 then
              ending:='( ' || all_cc || ' ) тонна';
		   else if atr=2 then
                   ending:='тыс€ча';
				else if atr=3 then
                        ending:='миллион';
					 else
                        ending:='миллиард';
					 end if;
  			    end if;
		   end if;
         end if;
       else if o=2 then
               IF (atr = 2) OR (d = 1) Then
			     ons := 'две';
               ELSE
			     ons := 'два';
			   END IF;
               if d<>1 then
                 if atr=1 then
                    ending:='( ' || all_cc || ' ) тонны';
                 else if atr=2 then
                         ending:='тыс€чи';
				      else if atr=3 then
                              ending:='миллиона';
					       else
                              ending:='миллиарда';
 					       end if;
  			          end if;
		         end if;
               end if;
			else if o=3 then
                    ons := 'три';
                    if d<>1 then
                      if atr=1 then
                         ending:='( ' || all_cc || ' ) тонны';
                      else if atr=2 then
                              ending:='тыс€чи';
				           else if atr=3 then
                                   ending:='миллиона';
					            else
                                   ending:='миллиарда';
 					            end if;
  			               end if;
		              end if;
                    end if;
 			     else if o=4 then
                         ons := 'четыр';
                         IF (d <> 1) Then
                           ons := ons || 'е';
                           if atr=1 then
                              ending:='( ' || all_cc || ' ) тонны';
                           else if atr=2 then
                                   ending:='тыс€чи';
				                else if atr=3 then
                                        ending:='миллиона';
					                 else
                                        ending:='миллиарда';
       					             end if;
  			                    end if;
		                   end if;
						 END IF;
    			      else if o=5 then
                              ons := 'п€т';
                              IF (d <> 1) Then
							    ons := ons || 'ь';
							  END IF;
    			           else if o=6 then
                                   ons := 'шест';
                                   IF (d <> 1) Then
								     ons := ons || 'ь';
								   END IF;
                                else if o=7 then
                                        ons := 'сем';
                                        IF (d <> 1) Then
										   ons := ons || 'ь';
										END IF;
									 else if o=8 then
                                             ons := 'восем';
                                             IF (d <> 1) Then
											    ons := ons || 'ь';
											 END IF;
										  else
                                             ons := 'дев€т';
                                             IF (d <> 1) Then
											    ons := ons || 'ь';
											 END IF;
										  end if;
  								     end if;
							    end if;
  			  		       end if;
				      end if;
			     end if;
		    end if;
	   end if;
  end if;
  IF d = 1 Then
    res := LTRIM(RTRIM(sto || ' ' || ons || des)) || ' ';
  ELSE
    res := LTRIM(RTRIM(sto || ' ' || des || ' ' || ons)) || ' ';
  END IF;
  IF res=' ' Then
    IF atr=1 then
	  RETURN ending;
    Else
	  RETURN '';
	END IF;
  ELSE
    RETURN (res || ending);
  END IF;
END;

/

