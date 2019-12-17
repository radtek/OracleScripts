CREATE OR REPLACE PROCEDURE MAX_CORRECT_FACEACC_DK (
   nrn          IN   NUMBER,
   saccount     IN   VARCHAR2,
   sunit        IN   VARCHAR2,
   dDate        IN   DATE,
   nPayCreate   IN   NUMBER,   --�������� ������ �� ����� ������������?
   sPayPref     IN   VARCHAR2, --������� �������
   sPayCatalog  IN   VARCHAR2, --������� �������
   dPayDate     IN   DATE,     --���� �������
   sPayTypePrih IN   VARCHAR2, --���������� �������� ���������� ����� �� �/�
   sPayTypeRash IN   VARCHAR2, --���������� �������� ���������� ����� �� �/�
   sPayTool     IN   VARCHAR2, --���������� ������
   sPayType     IN   VARCHAR2, --��� ������
   sPayJurPers  IN   VARCHAR2) --����������� ���� �������
   
IS
   nagent           NUMBER (17);
   ncompany         NUMBER (17);
   DELIMITER        VARCHAR2 (10);
   BLANK            VARCHAR2 (10);
   nCURRENT_SUM     NUMBER (17, 2);
   n_PLAN_SUM       NUMBER (17, 2);
   nfact_payed      NUMBER (17, 2);
   nplan_payed      NUMBER (17, 2);
   nacnt_remn_sum   NUMBER (17, 2);
   vREMNS           PKG_FACEACCTRADE.TFACEACC_REMNS;
   /*���������: ������ �.�. 26/05/2003*/
   vnPayCreate       NUMBER(1); --
   vsPayPref         VARCHAR2(20); --
   vsPayNumb         VARCHAR2(10); --
   vsPayCatalog      VARCHAR2(160); --
   vdPayDate         DATE; --
   vsPayTypePrih     VARCHAR2(20); --
   vsPayTypeRash     VARCHAR2(20); --
   vsPayTool         VARCHAR2(20); --
   vsPayType         VARCHAR2(20); --
   vsPayJurPers      VARCHAR2(20); --
   sAgent            VARCHAR2(20); --
   vsPayValidDocType VARCHAR2(20);
   vsPayValidDocNumb VARCHAR2(20);
   vsPayValidDocDate date;
   vsFaceNumb        VARCHAR2(20);
   SFINOPER          VARCHAR2(20);
   vnRN              number(17);
   nsumm             number(17,2);
   SCOMMENTS         VARCHAR2(240);
BEGIN


   DELIMITER := NVL (GET_OPTIONS_STR ('SeqSymb', nCOMPANY), ';');
   BLANK := NVL (GET_OPTIONS_STR ('EmptySymb', nCOMPANY), '()');
   
/*��� ��������� �� ���� �����������*/
   BEGIN
      SELECT g.agent, g.company, g.current_sum, g.plan_sum, g.fact_payed, g.plan_payed,
             a.agnabbr, d.doccode, g.valid_docnumb, g.valid_docdate, g.numb
        INTO nagent, ncompany, nCURRENT_SUM, n_PLAN_SUM, nfact_payed, nplan_payed,
             sAgent, vsPayValidDocType, vsPayValidDocNumb, vsPayValidDocDate, vsFaceNumb
        FROM faceacc g,
             agnlist a,
             doctypes d
       WHERE g.rn = nrn
         AND g.agent = a.rn
         and g.valid_doctype = d.rn
         AND g.fact_close_date IS NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN;
   END;
   /*���������� � �������� ������������ �������*/
   vnPayCreate := NVL(nPayCreate,0);
   IF vnPayCreate = 1 THEN
       vsPayPref   := NVL(sPayPref,'��');   
       P_PAYNOTES_GETNEXTNUMB(NCOMPANY, vsPayPref, SPAY_NUMB =>vsPayNumb);
       begin 
          select a.rn into vsPayCatalog from acatalog a where a.name = sPayCatalog AND A.DOCNAME = 'PayNotes';
       exception
          when NO_DATA_FOUND THEN
               P_EXCEPTION(0,'��������� ������� '||sPayCatalog||' ���������� ������� �� ����������');
       end;
       vdPayDate     := NVL(dPayDate,SYSDATE);
       vsPayTypePrih := NVL(sPayTypePrih,'�������');
       vsPayTypeRash := NVL(sPayTypeRash,'�������');
       vsPayTool     := NVL(sPayTool,'����������');
       vsPayType     := NVL(sPayType,'������');
       vsPayJurPers  := NVL(sPayJurPers,'�����������������');
                    
   END IF;
   
/* ��������� �� ������������ ��������� ���������/���������� */
   BEGIN
      SELECT SUM (b.acnt_remn_sum + b.acnt_debit_sum - b.acnt_credit_sum)
        INTO nacnt_remn_sum
        FROM dcspecs b, dicaccs acc, dicbunts un
       WHERE b.account = acc.rn
         AND b.balunit = un.rn
         AND b.open_date = dDate
         AND b.agent = nagent
         AND (
                   RTRIM (sunit) IS NULL
                OR UN.BUNIT_MNEMO LIKE sunit
                OR     INSTR (sunit, DELIMITER) <> 0
                   AND strinlike (UN.BUNIT_MNEMO, sunit, DELIMITER, BLANK) = 1)
         AND (
                   RTRIM (saccount) IS NULL
                OR acc.acc_number LIKE saccount
                OR     INSTR (saccount, DELIMITER) <> 0
                   AND strinlike (acc.acc_number, saccount, DELIMITER, BLANK) = 1)
       GROUP BY b.agent;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         /*����� ������� �� ��������*/      
         /*���� ������ ��������, �.�. ���� ��� �������� �� �.�. �������������
         ����� ������ �������� ������� �� ������� �����*/
         --vREMNS.nPLAN_PAYED := -n_PLAN_SUM;
         --vREMNS.nFACT_PAYED := -nCURRENT_SUM;
         --P_FACEACC_CORRECT_ACCOUNT (nCOMPANY, nRN, NULL, NULL, vREMNS, 1, NULL, NULL);
         
         /*������ ������ ������ �� ����� ������� ���� 0 �� ������� �����*/
         if nCURRENT_SUM = 0 then
            null;
         elsif nCURRENT_SUM < 0 then
            SFINOPER := vsPayTypePrih;
         elsif nCURRENT_SUM > 0 then
            SFINOPER := vsPayTypeRash;
         end if;
         /*SCOMMENTS := '��������� ���������-����������, �����: '||saccount||' �� �����������: '||sAgent||
         '  �� '||to_char(dDate)||' ����� �� �������!'||
         ' ������� ��  �������� ����� '||vsFaceNumb||' � ����� '||to_char(nCURRENT_SUM)||
         ' ��� ������� �������������: '||USER||' � '||to_char(sysdate,'dd.MM.yyyy HH24:MI');*/
         
         P_PAYNOTES_INSERT(	NCOMPANY            => NCOMPANY,
                          	NCRN                => vsPayCatalog,
                          	SJUR_PERS           => vsPayJurPers,
                          	SPAY_PREFIX         => vsPayPref,
                          	SPAY_NUMBER         => vsPayNumb,
                          	SPAYER              => sAgent,
                          	DPAY_DATE           => vdPayDate,
                          	NSERV_PAY           => 0,
                          	SFACEACC            => vsFaceNumb,
                          	SGRAPHPOINT         => null,
                          	SFINOPER            => SFINOPER,
                            
                          	SPAYTOOL            => vsPayTool,
                          	SVDOC_TYPE          => vsPayValidDocType,
                          	SVDOC_NUMB          => vsPayValidDocNumb,
                          	DVDOC_DATE          => vsPayValidDocDate,
                          	SFDOC_TYPE          => null,
                          	SFDOC_NUMB          => null,
                          	DFDOC_DATE          => null,
                          	SCURRENCY           => '���.',
                          	NCURR_RATE          => 1,
                          	NCURR_RATE_BASE     => 1,
                          	NCURR_RATE_ACC      => 1,
                          	NCURR_RATE_PAY_ACC  => 1,
                          	NCURR_RATE_TRD      => 1,
                          	NCURR_RATE_BASE_TRD => 1,

                          	NPAY_SUM            => abs(nCURRENT_SUM),
                          	NPAY_SUM_ACC        => abs(nCURRENT_SUM),
                          	NPAY_SUM_TRD        => 0,
                            
                          	NFINSPEC            => null,
                          	NINTRDEBT           => null,
                          	NSIGNPLAN           => 0,
                          	STAXGROUP           => null,
                          	SPAY_PLAN_PREFIX    => null,
                          	SPAY_PLAN_NUMBER    => null,
                          	NSIGNACTIVE         => 0,
                          	SPAY_TYPE           => null,
                          	STDOC_TYPE          => null,
                          	STDOC_NUMB          => null,
                          	DTDOC_DATE          => null,
                          	NTAX_SUM            => 0,
                          	NTAX_PERCENT        => 0,
                          	SCOMMENTS           => SCOMMENTS,
                          	NRN                 => vNRN);   
   return;
   END;

  /*���������� ������� �� �����*/
   --vREMNS.nPLAN_PAYED := - (n_PLAN_SUM + nacnt_remn_sum);
   --vREMNS.nFACT_PAYED := - (nCURRENT_SUM + nacnt_remn_sum);
   --P_FACEACC_CORRECT_ACCOUNT (nCOMPANY, nRN, NULL, NULL, vREMNS, 1, NULL, NULL);
 
 
  /*���� ��������� ��� ���� � �������� �������� �� ������� �����...*/  
   if (nCURRENT_SUM + nacnt_remn_sum) < 0 then
         SFINOPER := vsPayTypePrih;
   elsif (nCURRENT_SUM  + nacnt_remn_sum) > 0 then
         SFINOPER := vsPayTypeRash;
   end if;
   nsumm := nCURRENT_SUM  + nacnt_remn_sum;
   /*SCOMMENTS := '������������� ����������� ������� �������� ����� '||vsFaceNumb||' ����������: '||\*sAgent||*\
   ' �������: '||to_char(nCURRENT_SUM)||' � ���������� ���������-���������� �� ������: '||\*saccount||*\
   ' �������: '||to_char(nacnt_remn_sum)||' ����������� ���������: '||to_char(nsumm)||
   ' ����� ���������������� ������������� '||USER||' � '||to_char(sysdate,'dd.MM.yyyy HH24:MI');*/
         P_PAYNOTES_INSERT(	NCOMPANY            => NCOMPANY,
                          	NCRN                => vsPayCatalog,
                          	SJUR_PERS           => vsPayJurPers,
                          	SPAY_PREFIX         => vsPayPref,
                          	SPAY_NUMBER         => vsPayNumb,
                          	SPAYER              => sAgent,
                          	DPAY_DATE           => vdPayDate,
                          	NSERV_PAY           => 0,
                          	SFACEACC            => vsFaceNumb,
                          	SGRAPHPOINT         => null,
                          	SFINOPER            => SFINOPER,
                            
                          	SPAYTOOL            => vsPayTool,
                          	SVDOC_TYPE          => vsPayValidDocType,
                          	SVDOC_NUMB          => vsPayValidDocNumb,
                          	DVDOC_DATE          => vsPayValidDocDate,
                          	SFDOC_TYPE          => null,
                          	SFDOC_NUMB          => null,
                          	DFDOC_DATE          => null,
                          	SCURRENCY           => '���.',
                          	NCURR_RATE          => 1,
                          	NCURR_RATE_BASE     => 1,
                          	NCURR_RATE_ACC      => 1,
                          	NCURR_RATE_PAY_ACC  => 1,
                          	NCURR_RATE_TRD      => 1,
                          	NCURR_RATE_BASE_TRD => 1,

                          	NPAY_SUM            => abs(nsumm),
                          	NPAY_SUM_ACC        => abs(nsumm),
                          	NPAY_SUM_TRD        => 0,
                            
                          	NFINSPEC            => null,
                          	NINTRDEBT           => null,
                          	NSIGNPLAN           => 0,
                          	STAXGROUP           => null,
                          	SPAY_PLAN_PREFIX    => null,
                          	SPAY_PLAN_NUMBER    => null,
                          	NSIGNACTIVE         => 0,
                          	SPAY_TYPE           => null,
                          	STDOC_TYPE          => null,
                          	STDOC_NUMB          => null,
                          	DTDOC_DATE          => null,
                          	NTAX_SUM            => 0,
                          	NTAX_PERCENT        => 0,
                          	SCOMMENTS           => null,
                          	NRN                 => vNRN);   
   
   
   
END max_correct_faceacc_dk;
/

