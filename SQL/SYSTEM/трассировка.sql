--Трассировка чужой сессии с просмотром переменных

--1) Определить параметры чужой сессиий
SELECT sid, serial#, UPPER(program)
FROM v$session
WHERE USERNAME='VANEEV'

-- 2) Включить трассировку: 
--           первый параметр=sid ( например 25)
--           второй параметр=serial#  (например 235)
Begin
  sys.dbms_system.set_ev(25, 235, 10046, 12, '');
end;  
/

-- 3) Выключить трассировку
Begin
  sys.dbms_system.set_ev(25, 235, 10046, 0, '');
end;  
/