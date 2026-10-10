# condterm-benchmarks
NLe_Dir = 'experiment/condterm-benchmarks-Instrumented'
Le_Dir = 'experiment/condterm-benchmarks-Instrumented-Lexicographic'

Tmp_Dir = 'experiment/tmp'
Test_Dir = 'experiment/test'
Fixed_Seed = 888

# condterm-benchmarks
TaskInfo_Nonterm = [
        # non-terminating---from rslearn, 111 --> 96
        ('AlternDiv', ['t']),  # OK, it=3
        ('AlternDivWide', ['t']),  # OK, it=3
        ('AlternDivWidening', ['t']),  # OK, it=2
        ('AlternKonv', ['t']),  # TO, it=15
        ('Bangalore_false-termination', ['x', 'y']),  # OK, it=2
        ('Bangalore_v2_false-termination', ['x', 'y']),  # OK, it=2
        ('Bangalore_v3_false-termination', ['x', 'y']),  # OK, it=2
        ('BradleyMannaSipma-CAV2005-Fig1-modified_false-termination', ['y1', 'y2']),  # OK, it=3
        ('Cairo_nondet_false-termination', ['x']),  # BMC--errorTrace
        ('Cairo_step2_false-termination', ['x']),  # TO, it>=15
        ('ChenCookFuhsNimkarOHearn-TACAS2014-Introduction_false-termination', ['k', 'n']),  # OK, it=2
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.02_false-termination', ['x', 'y']),  # U, it=5
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.03_false-termination', ['x', 'y']),  # U, it=2
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.04_false-termination', ['x', 'y']),  # U, it=5
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.06_false-termination', ['x', 'y']),  # U, it=1--true unknown
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.11_false-termination', ['x', 'y']),  # U, it=1--true unknown
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.12_false-termination', ['x', 'y']),  # OK, it=2
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.14_false-termination', ['x', 'y']),  # U, it=2
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.15_false-termination', ['x', 'y']),  # OK, it=2
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.17_false-termination', ['x', 'y']),  # OK, it=8
        ('ChenFlurMukhopadhyay-SAS2012-Ex3.02_false-termination', ['x', 'y', 'z']),  # U, it=4
        ('ChenFlurMukhopadhyay-SAS2012-Ex3.06_false-termination', ['x', 'y', 'z']),  # U, it=4
        ('Choose', []),  # OK, it=2
        ('ChooseLife', []),  # OK, it=2
        ('ComplInterv', ['t']),  # OK, it=3
        ('ComplInterv2', ['t']),  # OK, it=3
        ('ComplInterv3', ['t']),  # OK, it=3
        ('ComplxStruc', ['t']),  # OK, it=2
        ('ConvLower', ['t']),  # OK, it=2
        ('Cousot', ['t', 'j']),  # OK, it=2
        ('DivWithoutMinus', ['x', 'y']),  # OK, it=3
        ('DoubleNeg', ['t', 'j']),  # OK, it=2
        # ('Et2', ['a', 'b']),  # U, it=5, nondet
        # ('Et4', ['b', 'c', 'a']),  # U, it=6, nondet
        ('Even', ['t']),  # OK, it=2
        ('Ex01', ['t']),  # OK, it=2
        ('Ex02', ['t']),  # OK, it=2
        ('Ex03', ['t']),  # OK, it=2
        ('Ex04', ['t']),  # OK, it=2
        ('Ex05', ['t']),  # OK, it=2
        ('Ex06', ['t']),  # OK, it=7
        ('Ex07', ['t']),  # OK, it=2
        ('Ex08', ['t']),  # OK, it=2
        ('Factorial', ['j']),  # U, it=9
        ('Fibonacci', ['n']),  # U, it=4
        ('Flip', ['_i', 'j']),  # OK, it=4
        ('Flip2', ['_i', 'j']),  # OK, it=2
        ('Gauss', ['n']),  # error
        # ('GCD', ['x', 'y']),  # U, it=5 mw(multiwhile)
        # ('GCD2', ['x', 'y']),  # U, it=3 mw
        ('Hanoi_2vars_false-termination', ['x', 'y']),  # U, it=6
        ('Hanoi_3vars_false-termination', ['x', 'y', 'z']),  # U, it=4
        ('Hanoi_plus_false-termination', ['x', 'y', 'z']),  # U, it=11
        ('Lcm', []),  # U, it=3
        ('LeikeHeizmann-WST2014-Ex5_false-termination', ['a', 'b']),  # OK, it=5
        ('LeikeHeizmann-WST2014-Ex6_false-termination', ['a', 'b']),  # OK, it=2
        ('Loop', []),  # OK, it=2
        ('Madrid_false-termination', []),  # OK, it=2
        ('Marbie1', ['t']),  # OK, it=2
        ('Marbie2', ['t']),  # OK, it=2
        ('Middle', ['t', 'j']),  # TO
        ('MirrorInterv', ['t']),  # OK, it=7
        ('MirrorIntervSim', ['t']),  # OK, it=3
        ('Mysore_false-termination', ['x', 'c']),  # OK, it=2
        ('Narrowing', ['t']),  # OK, it=3
        ('NarrowKonv', ['t']),  # OK, it=2
        ('NO_00', ['x']),  # OK, it=7
        # ('NO_01', []),  # TO  mw
        # ('NO_02', []),  # TO  mw
        # ('NO_03', []),  # U, it=2 mw
        # ('NO_04', []),  # TO mw
        ('NO_10', []),  # OK, it=2
        ('NO_12', []),  # OK, it=2
        ('NO_13', []),  # U, it=1, true unknown--original rsl need about 35s; OK, it=2 with rsl to=35s
        ('NO_21', []),  # OK, it=2
        ('NO_22', []),  # OK, it=2
        ('NO_23', []),  # OK, it=2
        ('NO_24', []),  # OK, it=2
        ('NonTermination1_false-termination', ['x']),  # OK, it=2
        # ('NonTermination2_false-termination', ['x']),  # U, it=1, true unknown  nondet
        ('NonTermination4_false-termination', []),  # OK, it=2
        ('NonTerminationSimple2_false-termination', ['x']),  # OK, it=2
        ('NonTerminationSimple3_false-termination', ['x', 'c']),  # OK, it=2
        ('NonTerminationSimple4_false-termination', ['x', 'y']),  # OK, it=2
        # ('NonTerminationSimple5_false-termination', ['x']),  # U, it=1, nondet
        ('NonTerminationSimple6_false-termination', ['x']),  # OK, it=2
        ('NonTerminationSimple7_false-termination', ['x', 'c']),  # OK, it=2
        # ('NonTerminationSimple8_false-termination', ['x']),  # U, it=4, nondet
        # ('NonTerminationSimple9_false-termination', ['x']),  # U, it=2, nondet
        # ('PastaC10', ['t', 'j']),  # U, it=3, nondet
        ('Rotation180_false-termination', ['x', 'y']),  # OK, it=2
        ('Singapore_plus_false-termination', ['x', 'y']),  # OK, it=3
        ('Singapore_v1_false-termination', ['x', 'y']),  # OK, it=2
        ('Singapore_v2_false-termination', ['x', 'y']),  # OK, it=2
        ('Sunset', ['t']),  # OK, it=3
        ('Swingers', []),  # OK, it=2
        ('TrueDiv', ['t']),  # OK, it=2
        ('TwoFloatInterv', ['t']),  # TO
        ('UpAndDown', ['t']),  # OK, it=2
        ('UpAndDownIneq', ['t']),  # OK, it=2
        ('Urban-WST2013-Fig1_false-termination', ['x']),  # OK, it=2
        ('Velroyen_false-termination', ['x']),  # OK, it=3
        ('WhileIncr', ['t']),  # OK, it=2
        ('WhileIncrPart', ['t']),  # OK, it=2
        # ('WhileNested', ['t']),  # TO mw
        # ('WhileNestedOffset', ['t']),  # TO mw
        ('WhilePart', ['t']),  # OK, it=2
        ('WhileSingle', ['t']),  # OK, it=2
        ('WhileTrue', ['t']),  # OK, it=2
        ('WhileTrue_false-termination', []),  # OK, it=2
        ('2Nested_false-termination', ['x', 'y']),  # U, it=8
]
TaskInfo_Term = [
        # terminating---from ddlterm, 170
        ('MenloPark_true-no-overflow_true-termination_true-valid-memsafety', ['x'], {'Test:Sp': lambda d: [d[0]* 99]}),  # OK, 23.2s
        ('nonlin_mod_term_4', ['x', 'y']),  # OK, 3.9
        ('c.07_true-termination_true-no-overflow', ['_i','j','k','tmp']),  # OK. 3.0
        ('trex03_false-unreach-call_true-termination', ['x1', 'x2', 'x3']), # Result: ?
        ('trex03_false-unreach-call_true-termination-modif', ['x1', 'x2', 'x3', 'd1', 'd2', 'd3']), # Result: ?
        ('trex03_false-unreach-call_true-termination-simpl', ['x1','x2','x3']), # OK
        ('3pieces_Caterina_TACAS16_modif_3', ['x','y','N']), # OK
        ('4NestedWith2Variables_false-no-overflow', ['a','b']), # OK
        ('AliasDarteFeautrierGonnord-SAS2010-speedFails4_true-termination', ['x','n','b']), # OK
        ('AliasDarteFeautrierGonnord-SAS2010-wise_true-termination_true-no-overflow', ['x','y']), # OK
        ('aviad_true-termination_true-no-overflow', ['a']), # OK
        ('aviad_true-termination_true-no-overflow-version2', ['a']), # OK
        ('aviad_true-termination_true-no-overflow-version3', ['a']), # OK
        ('b.03-no-inv_assume_true-termination_true-no-overflow', ['x','y']), # OK
        ('b.10_true-termination_true-no-overflow', ['x','y']), # OK
        ('b.11_true-termination_true-no-overflow', ['x','y']), # OK
        ('b.11_true-termination_true-no-overflow-simpl', ['x','y']), # OK
        ('BradleyMannaSipma-ICALP2005-Fig1_true-termination', ['x','y','N']), # OK
        ('c.07_true-termination_true-no-overflow-simpl', ['_i','j','k','tmp']),
        ('Cairo_true-no-overflow_true-termination_true-valid-memsafety', ['x']), # OK
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow-version3', ['x','y']), # OK
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.02_false-no-overflow', ['x']), # OK ？ rand bug by z3?
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.13_true-termination', ['x','y']), # OK
        ('ChenFlurMukhopadhyay-SAS2012-Ex4.01_false-no-overflow-simpl', ['x','y','n']), # OK
        ('CookSeeZuleger-TACAS2013-Fig8a-modified_true-termination_true-no-overflow', ['K','x']), # OK
        ('Copenhagen_disj_true_version', ['x','y','z']), # OK
        ('Copenhagen_disj_true-termination_true-valid-memsafety', ['x','y']), # OK？ Rand Problem
        ('Copenhagen_true-no-overflow_true-termination_true-valid-memsafety', ['x','y']), # OK
        ('determ_term_1', []), # determ
        ('determ_term_2', []), # determ
        ('determ_term_3', []), # determ
        ('determ_term_4', []), # determ
        ('determ_term_6', []), # determ
        ('eca_bounded_core', ['limit']), # TO now  # UNKNOWN
        ('ex1_false-no-overflow_true-termination', ['x','y']), # OK
        ('for_bounded_loop1_false-unreach-call_true-termination-simplified', ['n']), # OK
        ('Gothenburg_false-no-overflow', ['a','b','x','y'], {'Test:Eq': ['a','b']}), # OK？ Rand Problem
        ('Gothenburg_v2_false-no-overflow', ['a','b','x','y'], {'Test:Sp': lambda d: [d[0], d[0] - 1] + d[-2:]}), # OK？ Rand Problem
        ('Gothenburg_v3_false-no-overflow', ['a','b','x','y'], {'Test:Eq': ['a','b']}), # OK？ Rand Problem
        ('Gothenburg_v4_false-no-overflow', ['a','b','x','y'], {'Test:Eq': ['a','b']}), # OK？ Rand Problem (Failed seed: 777)
        ('GulwaniJainKoskinen-PLDI2009-Fig1_true-termination', ['id','maxId']), # F  # U
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig2_true-termination', ['y']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig2_true-termination-version', ['x','y']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig5_true-termination_true-no-overflow', ['x']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig5_true-termination_true-no-overflow-version', ['x']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig8_true-termination', ['x','y']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig8_true-termination-version', ['x','y']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig9_true-termination', ['x','y','z']), # OK
        ('HeizmannHoenickeLeikePodelski-ATVA2013-Fig9_true-termination-version', ['x','y','z']), # OK
        ('java_AG313_true-termination_true-no-overflow', ['x','y']), # OK
        ('Lobnya-Boolean-Reordered_true-termination_true-valid-memsafety', ['x','b']), # OK
        ('min_rf-alloca_true-termination', ['x','y']), # OK
        ('Mysore_false-no-overflow', ['c','x']), # OK
        ('nonlin_div_term_1', ['x','y']), # OK
        ('nonlin_mod_term_1', ['x','y']), # OK
        ('nonlin_mod_term_2', ['x','y']), # OK
        ('nonlin_mult_term_1', ['y']), # OK CBC
        ('nonlin_mult_term_2', ['x','y']), # OK CBC
        ('nonlin_mult_term_3', ['x','y','z']), # OK CBC
        ('nonlin_mult_term_4', ['d','b']), # OK
        ('nonlin_mult_term_6', ['d','b']), # OK
        ('nonlin_mult_term_7', ['j','b']), # OK
        ('nonlin_mult_term_8', ['x','y','z']), # OK CBC
        ('nonlin_mult_term_9', ['j','b']), # OK
        ('Parallel_true-no-overflow_true-termination_true-valid-memsafety', ['x','y']), # OK
        ('Piecewise_true-no-overflow_true-termination_true-valid-memsafety', ['_i','j']), # OK
        ('PodelskiRybalchenko-LICS2004-Fig2_true-termination-modif1', ['x','y']), # OK
        ('PodelskiRybalchenko-LICS2004-Fig2_true-termination-simpl', ['x','y']), # OK
        ('PodelskiRybalchenko-VMCAI2004-Ex1_false-no-overflow', ['_i','j']), # OK
        ('PodelskiRybalchenko-VMCAI2004-Ex1_false-no-overflow-version', ['_i','j','_i1','j1']), # OK
        ('Pure2Phase_true-termination_true-valid-memsafety', ['y','z']), # TO  # U  !!!
        ('Singapore_false-no-overflow', ['x','y']), # OK
        ('Singapore_false-no-overflow-version', ['x','y']), # OK
        ('TelAviv-Amir-Minimum-alloca_true-termination', ['x','y']), # OK
        ('term_01', ['x','y']), # OK
        ('term_02', ['x','y','z']), # OK  12.4s
        ('term_03', ['x','y','z']), # OK？ Rand Problem
        ('term_04', ['j','d']), # OK
        ('term_05', ['j','d']), # OK
        ('term_10', ['K','x','y']), # OK
        ('term_11', ['K','x','y']), # OK
        ('term_13', ['_i','j','k']), # OK
        ('term_14', ['_i','j','a','b']), # OK
        ('term_24', ['x','y','z']), # OK
        ('term_27', ['x','y']), #
        ('term_28', ['x','y']), # OK
        ('Thun_false-no-overflow', ['x','y']), # OK
        ('3pieces_Caterina_TACAS16_modif_1', ['x','y']), #  # U
        ('3pieces_Caterina_TACAS16_modif_2', ['x','y']), # U
        ('3pieces_Caterina_TACAS16', ['x','y']), # OK
        ('4NestedWith3Variables_false-no-overflow', ['q','a','b']), # U
        ('aaron3_false-no-overflow-version', ['x','y','z','tx']), # U
        ('aaron3_false-no-overflow', ['x','y','z','tx']), # OK
        ('aaron3_true-termination_true-valid-memsafety', ['x','y','z','tx']), # U
        ('AliasDarteFeautrierGonnord-SAS2010-speedpldi2_true-termination_true-no-overflow', ['n','m']), # OK
        ('AliasDarteFeautrierGonnord-SAS2010-speedpldi3_true-termination_true-no-overflow', ['n','m']), # U
        ('aviad_true-termination_true-no-overflow-version1', ['a']), # OK
        ('Ben-Amram-2010LMCS-Ex2.3-alloca_true-termination-modified1', ['x','y','z']),  # OK
        ('determ_term_5', []), # determ
        ('determ_term_7', []), # determ
        ('determ_term_8', []), # determ
        ('Et1_false-no-overflow_true-termination', ['a','b']),  # U
        ('genady_true-termination_true-no-overflow', []),  # OK
        ('AliasDarteFeautrierGonnord-SAS2010-counterex1a_false-no-overflow', ['n', 'b', 'x', 'y']), # Result: ?  # U
        ('AliasDarteFeautrierGonnord-SAS2010-cousot9_true-termination_true-no-overflow', ['j', 'N']), # Result: ?  # OK
        ('AliasDarteFeautrierGonnord-SAS2010-rsd_true-termination', ['_r']), # Result: ?  # U
        ('Ben-Amram-2010LMCS-Ex2.3-alloca_true-termination', ['x', 'y', 'z']), # Result: ?  # OK
        ('Ben-Amram-2010LMCS-Ex2.3-alloca_true-termination-modified2', ['x', 'y', 'z']), # Result: ?  # OK
        ('ChawdharyCookGulwaniSagivYang-ESOP2008-aaron12_false-no-overflow', ['x', 'y', 'z']), # Result: ?  # U
        ('ChawdharyCookGulwaniSagivYang-ESOP2008-aaron4_true-termination', ['_i', 'j', 'k', 'an', 'bn', 'tk']), # Result: ?  U
        ('ChawdharyCookGulwaniSagivYang-ESOP2008-aaron6_true-termination', ['x', 'tx', 'y', 'ty', 'n']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow', ['x']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow-version1', ['x']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow-version2', ['x']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow-version4', ['x', 'y']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex1.01_false-no-overflow-version6', ['x', 'y']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex2.06_false-no-overflow', ['x', 'y']), # Result: ?  U
        ('ChenFlurMukhopadhyay-SAS2012-Ex4.01_false-no-overflow', ['x', 'y', 'z', 'n']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex4.01_false-no-overflow-version1', ['x', 'y', 'z', 'n']), # Result: ?
        ('ChenFlurMukhopadhyay-SAS2012-Ex4.01_false-no-overflow-version2', ['x', 'y', 'z', 'n']), # Result: ?  U
        ('CookSeeZuleger-TACAS2013-Fig1_true-termination_true-no-overflow', ['x', 'y']), # Result: ?  OK
        ('CookSeeZuleger-TACAS2013-Fig7a-true-termination_true-no-overflow', ['x', 'y', 'd']), # Result: ?  OK
        ('CookSeeZuleger-TACAS2013-Fig7b-true-termination_true-no-overflow', ['x', 'y', 'z']), # Result: ?  OK, 43s
        ('GulavaniGulwani-CAV2008-Fig1a_true-termination', ['x', 'y', 'z']), # Result: ?
        ('GulwaniJainKoskinen-PLDI2009-Fig1_true-termination-version1', ['id', 'maxId']), # Result: ?  U
        ('GulwaniJainKoskinen-PLDI2009-Fig1_true-termination-version2', ['id', 'maxId']), # Result: ?  U
        ('Masse-VMCAI2014-Fig1a_true-termination', ['a', 'b']), # Result: ?  U
        ('Masse-VMCAI2014-Fig1b_true-termination', ['x']), # Result: ?
        ('Masse-VMCAI2014-Fig1b_true-termination-version-1', ['x']), # Result: ?
        ('Masse-VMCAI2014-Fig1b_true-termination-version-2', ['x']), # Result: ?
        ('McCarthyIterative_true-termination_true-no-overflow', ['x']), # Result: ?  U
        ('MenloPark_true-no-overflow_true-termination_true-valid-memsafety-modif', ['x', 'y']), # Result: ?
        ('NoriSharma-2013FSE-Fig8-true-termination', ['x', 'y', 'z']), # Result: ?  OK
        ('NoriSharma-2013FSE-Fig8-true-termination-modif', ['x', 'y', 'z']), # Result: ?  U
        ('Nyala-2lex_true-no-overflow_true-termination_true-valid-memsafety', ['x', 'y']), # Result: ?  OK
        ('Nyala-2lex_true-no-overflow_true-termination_true-valid-memsafety-version', ['x', 'y']), # Result: ?  OK
        ('PodelskiRybalchenko-LICS2004-Fig2_true-termination', ['x', 'y']), # Result: ?
        ('PodelskiRybalchenko-LICS2004-Fig2_true-termination-modif2', ['x', 'y']), # Result: ?  U
        ('PodelskiRybalchenko-TACAS2011-Fig4_true-termination_true-no-overflow', ['x', 'y']), # Result: ?  OK
        ('PodelskiRybalchenko-simpl1', ['x', 'y']), # Result: ?  OK
        ('PodelskiRybalchenko-simpl2', ['x', 'y']), # Result: ?
        ('PodelskiRybalchenko-simpl3', ['x', 'y']), # Result: ?  OK
        ('Problem00_label00_true-unreach-call-toy', []), # Result: ?
        ('Pure2Phase_false-no-overflow', ['y', 'z']), # Result: ?  U
        ('Pure3Phase_false-no-overflow', ['x', 'y', 'z']), # Result: ?  U
        ('Toulouse-BranchesToLoop-alloca_true-termination', ['x', 'y', 'z']), # Result: ?  U
        ('UrbanMine-ESOP2014-Fig3_true-termination_true-no-overflow', ['x', 'y']), # Result: ?  U
        ('genady_true-termination_true-no-overflow-version', []), # Result: ?
        ('nonlin_div_term_2', ['x', 'y']), # Result: ?
        ('nonlin_jump_over_1_term', ['x', 'y']), # Result: ?  U
        ('nonlin_mod_term_3', ['x', 'y']), # Result: ?  U
        ('nonlin_mult_term_5', ['x', 'y']), # Result: ?  U
        ('term_06', []), # Result: ?  U !!!
        ('term_07', ['x']), # Result: ?
        ('term_08', []), # Result: ?
        ('term_09', ['K', 'x', 'y']), # Result: ?
        ('term_12', []), # Result: ?
        ('term_15', ['x', 'y']), # Result: ?
        ('term_16', ['x', 'y']), # Result: ?  U
        ('term_17', []), # Result: ?
        ('term_18', []), # Result: ?
        ('term_19', ['x'], {'Test:Sp': lambda d: [d[0] * 10]}), # Result: ?  U !!!
        ('term_20', []), # Result: ?
        ('term_21', ['z']), # Result: ?  OK
        ('term_22', ['K', 'x', 'y']), # Result: ?
        ('term_23', ['x', 'y']), # Result: ?  U
        ('term_25', ['x', 'y', 'z']), # Result: ?
        ('term_26', ['x', 'y']), # Result: ?
        ('term_29', ['N']), # Result: ?  U
        ('transform_1', ['x', 'y']), # Result: ?  U
]

# Task_Info = Task_fse22
Task_Info = TaskInfo_Nonterm + TaskInfo_Term
# Task_Info = TaskInfo_Nonterm
# Task_Info = TaskInfo_Term
