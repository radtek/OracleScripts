CREATE OR REPLACE PROCEDURE pvz_pr_cr_leftnomen (
   ncompany   IN       NUMBER
)
IS
   nnomen   NUMBER (17);
   nnewrn   NUMBER (17);
   
BEGIN
   find_dicnomns_by_code (1, ncompany, 'LEFT_NOMEN', nnomen);

   IF nnomen IS NULL
   THEN
/*      p_dicnomns_modify (ncompany,
         rn                 => NULL,
         crn                => 3125744.000000,
         nomen_code         => 'LEFT_NOMEN',
         nomen_name         => 'Номенклатор для переноса остатков',
         umeas_main         => 'штк',
         umeas_alt          => NULL,
         equal              => NULL,
         sign_acnt          => 1.000000,
         sign_docs          => 1.000000,
         sgroup_code        => 'ЭТАЛОН_ГРУППЫ_ТМЦ',
         stax_group         => NULL,
         sign_umeas         => 0.000000,
         nnomen_type        => 1.000000,
         nsign_serial       => 0.000000,
         nsign_modif        => 0.000000,
         nsign_party        => 0.000000,
         ncntrndm           => 0.000000,
         nmtdrndm           => 0.000000,
         ncntrnds           => 0.000000,
         nmtdrnds           => 0.000000,
         sokdp              => '',
         nsign_set          => 0.000000,
         nsign_set_divide   => 0.000000,
         nrn_dup            => NULL,
         nwidth             => NULL,
         nheight            => NULL,
         nlength            => NULL,
         nweight            => NULL,
         nmu_size           => 1.000000,
         nmu_weight         => 1.000000,
         ntemp_from         => NULL,
         ntemp_to           => NULL,
         nhumid_from        => NULL,
         nhumid_to          => NULL,
         ncommon_pr_sign    => 0.000000,
         nnewrn
      );*/

      p_dicnomns_modify (ncompany,
         NULL,
         3125744.000000,
         'LEFT_NOMEN',
         'Номенклатор для переноса остатков',
         'штк',
         NULL,
         NULL,
         1.000000,
         1.000000,
         'ЭТАЛОН_ГРУППЫ_ТМЦ',
         NULL,
         NULL,
         0.000000,
         1.000000,
         0.000000,
         0.000000,
         0.000000,
         0.000000,
         0.000000,
         0.000000,
         0.000000,
         '',
         0.000000,
         0.000000,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         1.000000,
         1.000000,
         NULL,
         NULL,
         NULL,
         NULL,
         0.000000,
         nnewrn
      );
   END IF;
END pvz_pr_cr_leftnomen;
/

