--����஢�� �㦮� ��ᨨ � ��ᬮ�஬ ��६�����

--1) ��।����� ��ࠬ���� �㦮� ��ᨨ�
SELECT sid, serial#, UPPER(program)
FROM v$session
WHERE USERNAME='VANEEV'

-- 2) ������� ����஢��: 
--           ���� ��ࠬ���=sid ( ���ਬ�� 25)
--           ��ன ��ࠬ���=serial#  (���ਬ�� 235)
Begin
  sys.dbms_system.set_ev(25, 235, 10046, 12, '');
end;  
/

-- 3) �몫���� ����஢��
Begin
  sys.dbms_system.set_ev(25, 235, 10046, 0, '');
end;  
/