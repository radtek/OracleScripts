-- �������� ���� �������� � ��������� �������� �������� TEST
alter session set create_stored_outlines = TEST;


-- ��������� ������������ ������ 

select  /*+ RULE */ /*+ ORDERED */
               i.document rnSDC,
               o.document rnTIC
              from
               DOCINPT  I,
               DOCLINKS L,
               DOCOUTPT O
              where
               i.document=:b1
               and I.UNITCODE = 'SheepDirectToConsumers'
               and L.IN_DOC   = I.RN
               and L.OUT_DOC  = O.RN
               and O.UNITCODE = 'GoodsTransInvoicesToConsumers'

-- ��������� ���������� ������ 

select  /*+ ORDERED */
               i.document rnSDC,
               o.document rnTIC
              from
               DOCINPT  I,
               DOCLINKS L,
               DOCOUTPT O
              where
               i.document=:b1
               and I.UNITCODE = 'SheepDirectToConsumers'
               and L.IN_DOC   = I.RN
               and L.OUT_DOC  = O.RN
               and O.UNITCODE = 'GoodsTransInvoicesToConsumers'
			   
-- ��������� ���� �������� ��������			   
alter session set create_stored_outlines = false;

-- ����������� ������ ��������� �������� ��������
select ol_name, sql_text from outln.ol$ where category = 'TEST'

-- ������������� �������
alter outline SYS_OUTLINE_040511154953828 rename to SO_ORIG;

alter outline SYS_OUTLINE_040511154949765 rename to SO_FIX;

-- ������ ���������
select ol_name, hint#, hint_text from outln.ol$hints
  where category = 'TEST'
  order by ol_name desc, hint#;

-- ������ ������� ���������
update outln.ol$hints
set ol_name = 
	decode(
		ol_name,
			'SO_FIX','SO_ORIG',
			'SO_ORIG','SO_FIX'
	)
where ol_name in ('SO_ORIG','SO_FIX');    

update outln.ol$ ol1
set hintcount = (
	select	hintcount 
	from	ol$ ol2
	where	ol2.ol_name in ('SO_ORIG',' SO_FIX')
	and	ol2.ol_name != ol1.ol_name
	)
where
	ol1.ol_name in ('SO_ORIG','SO_FIX');
  

-- �������� �������
drop outline SO_FIX;

-- ��������������� ������������ ������ � ��������� � ���������
alter outline SO_ORIG change category to PRODUCTIVE;
alter outline SO_ORIG rename to SO_LINKS1;


	


drop outline LINKS1_WITH_RULE;

			   