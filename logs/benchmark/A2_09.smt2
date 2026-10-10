(set-option :produce-unsat-cores true)
(set-option :print-success false)
(set-info :smt-lib-version 2.0)
(set-option :produce-models true)
(set-option :AUTO_CONFIG false)
(set-option :MODEL.V2 true)
(set-option :smt.PHASE_SELECTION 0)
(set-option :smt.RESTART_STRATEGY 0)
(set-option :smt.RESTART_FACTOR |1.5|)
(set-option :smt.ARITH.RANDOM_INITIAL_VALUE true)
(set-option :smt.CASE_SPLIT 3)
(set-option :smt.DELAY_UNITS true)
(set-option :NNF.SK_HACK true)
(set-option :smt.MBQI false)
(set-option :smt.QI.EAGER_THRESHOLD 100)
(set-option :smt.QI.COST |"(+ weight generation)"|)
(set-option :TYPE_CHECK true)
(set-option :smt.BV.REFLECT true)
; done setting options


(declare-fun tickleBool (Bool) Bool)
(assert (and (tickleBool true) (tickleBool false)))
(declare-fun %lbl%+117 () Bool)
(declare-fun p@1 () Int)
(declare-fun x@1 () Int)
(declare-fun x@2 () Int)
(declare-fun p@2 () Int)
(declare-fun %lbl%@390 () Bool)
(declare-fun MLHoudiniConstant2 () Bool)
(declare-fun %lbl%+119 () Bool)
(declare-fun %lbl%+115 () Bool)
(declare-fun %lbl%+282 () Bool)
(declare-fun MLHoudiniConstant1 () Bool)
(declare-fun %lbl%+109 () Bool)
(declare-fun %lbl%@216 () Bool)
(declare-fun MLHoudiniConstant0 () Bool)
(declare-fun p () Int)
(declare-fun x () Int)
(declare-fun %lbl%+202 () Bool)
(define-fun mainMacro () Bool (let ((anon4_LoopBody_correct (=> (! (and %lbl%+117 true) :lblpos +117) (=> (or
(and
(= p@1 0)
(<= 0 x@1)
(<= x@1 2))
(and
(= p@1 1)
(<= 3 x@1)
(<= x@1 4))) (=> (and
(= x@2 (- 4 x@1))
(= p@2 (- 1 p@1))) (and
(! (or %lbl%@390 (=> true MLHoudiniConstant2)) :lblneg @390)
(=> (=> true MLHoudiniConstant2) true)))))))
(let ((anon4_LoopDone_correct (=> (! (and %lbl%+119 true) :lblpos +119) true)))
(let ((anon4_LoopHead_correct (=> (! (and %lbl%+115 true) :lblpos +115) (=> (! (and %lbl%+282 MLHoudiniConstant1) :lblpos +282) (and
anon4_LoopDone_correct
anon4_LoopBody_correct)))))
(let ((anon0_correct (=> (! (and %lbl%+109 true) :lblpos +109) (and
(! (or %lbl%@216 (=> true (=> MLHoudiniConstant0 (or
(and
(= p 0)
(<= 0 x)
(<= x 2))
(and
(= p 1)
(<= 3 x)
(<= x 4)))))) :lblneg @216)
(=> (=> true (=> MLHoudiniConstant0 (or
(and
(= p 0)
(<= 0 x)
(<= x 2))
(and
(= p 1)
(<= 3 x)
(<= x 4))))) anon4_LoopHead_correct)))))
(let ((PreconditionGeneratedEntry_correct (=> (! (and %lbl%+202 true) :lblpos +202) anon0_correct)))
PreconditionGeneratedEntry_correct))))))
(declare-fun b1 (Int Int) Bool)
(assert (or
true
(b1 p x)))
(assert (or
true
(b1 p@1 x@1)))
(assert (or
true
(b1 p@2 x@2)))
(declare-fun %lbl%+99 () Bool)
(declare-fun p@1@@0 () Int)
(declare-fun x@1@@0 () Int)
(declare-fun x@2@@0 () Int)
(declare-fun p@2@@0 () Int)
(declare-fun %lbl%@561 () Bool)
(declare-fun MLHoudiniConstant5 () Bool)
(declare-fun %lbl%+101 () Bool)
(declare-fun %lbl%+97 () Bool)
(declare-fun %lbl%+453 () Bool)
(declare-fun MLHoudiniConstant4 () Bool)
(declare-fun %lbl%+95 () Bool)
(declare-fun %lbl%@443 () Bool)
(declare-fun MLHoudiniConstant3 () Bool)
(declare-fun %lbl%+432 () Bool)
(define-fun main_instrumentedMacro () Bool (let ((anon3_LoopBody_correct (=> (! (and %lbl%+99 true) :lblpos +99) (=> (or
(and
(= p@1@@0 0)
(<= 0 x@1@@0)
(<= x@1@@0 2))
(and
(= p@1@@0 1)
(<= 3 x@1@@0)
(<= x@1@@0 4))) (=> (and
(= x@2@@0 (- 4 x@1@@0))
(= p@2@@0 (- 1 p@1@@0))) (and
(! (or %lbl%@561 (=> true MLHoudiniConstant5)) :lblneg @561)
(=> (=> true MLHoudiniConstant5) true)))))))
(let ((anon3_LoopDone_correct (=> (! (and %lbl%+101 true) :lblpos +101) true)))
(let ((anon3_LoopHead_correct (=> (! (and %lbl%+97 true) :lblpos +97) (=> (! (and %lbl%+453 MLHoudiniConstant4) :lblpos +453) (and
anon3_LoopDone_correct
anon3_LoopBody_correct)))))
(let ((anon0_correct@@0 (=> (! (and %lbl%+95 true) :lblpos +95) (and
(! (or %lbl%@443 (=> true MLHoudiniConstant3)) :lblneg @443)
(=> (=> true MLHoudiniConstant3) anon3_LoopHead_correct)))))
(let ((PreconditionGeneratedEntry_correct@@0 (=> (! (and %lbl%+432 true) :lblpos +432) anon0_correct@@0)))
PreconditionGeneratedEntry_correct@@0))))))
(declare-fun p@0 () Int)
(declare-fun x@0 () Int)
(assert (or
true
(b1 p@0 x@0)))
(assert (or
true
(b1 p@1@@0 x@1@@0)))
(assert (or
true
(b1 p@2@@0 x@2@@0)))
(declare-fun %lbl%+122 () Bool)
(declare-fun %lbl%+596 () Bool)
(declare-fun MLHoudiniConstant6 () Bool)
(declare-fun x@0@@0 () Int)
(declare-fun p@0@@0 () Int)
(declare-fun %lbl%@626 () Bool)
(declare-fun %lbl%+591 () Bool)
(define-fun main_helper_1Macro () Bool (let ((anon_helper_pre_1_correct (=> (! (and %lbl%+122 true) :lblpos +122) (=> (! (and %lbl%+596 MLHoudiniConstant6) :lblpos +596) (=> (and
(= x@0@@0 (- 4 x))
(= p@0@@0 (- 1 p))) (and
(! (or %lbl%@626 (=> true (not (or
(and
(= p@0@@0 0)
(<= 0 x@0@@0)
(<= x@0@@0 2))
(and
(= p@0@@0 1)
(<= 3 x@0@@0)
(<= x@0@@0 4)))))) :lblneg @626)
(=> (=> true (not (or
(and
(= p@0@@0 0)
(<= 0 x@0@@0)
(<= x@0@@0 2))
(and
(= p@0@@0 1)
(<= 3 x@0@@0)
(<= x@0@@0 4))))) true)))))))
(let ((PreconditionGeneratedEntry_correct@@1 (=> (! (and %lbl%+591 true) :lblpos +591) anon_helper_pre_1_correct)))
PreconditionGeneratedEntry_correct@@1)))
(assert (or
true
(b1 p x)))
(declare-fun %lbl%+128 () Bool)
(declare-fun %lbl%+689 () Bool)
(declare-fun MLHoudiniConstant7 () Bool)
(declare-fun x@0@@1 () Int)
(declare-fun p@0@@1 () Int)
(declare-fun x@1@@1 () Int)
(declare-fun p@1@@1 () Int)
(declare-fun %lbl%@741 () Bool)
(declare-fun %lbl%+680 () Bool)
(define-fun main_helper_2Macro () Bool (let ((anon_helper_pre_2_correct (=> (! (and %lbl%+128 true) :lblpos +128) (=> (! (and %lbl%+689 MLHoudiniConstant7) :lblpos +689) (=> (and
(= x@0@@1 (- 4 x))
(= p@0@@1 (- 1 p))
(= x@1@@1 (- 4 x@0@@1))
(= p@1@@1 (- 1 p@0@@1))) (and
(! (or %lbl%@741 (=> true (not (or
(and
(= p@1@@1 0)
(<= 0 x@1@@1)
(<= x@1@@1 2))
(and
(= p@1@@1 1)
(<= 3 x@1@@1)
(<= x@1@@1 4)))))) :lblneg @741)
(=> (=> true (not (or
(and
(= p@1@@1 0)
(<= 0 x@1@@1)
(<= x@1@@1 2))
(and
(= p@1@@1 1)
(<= 3 x@1@@1)
(<= x@1@@1 4))))) true)))))))
(let ((PreconditionGeneratedEntry_correct@@2 (=> (! (and %lbl%+680 true) :lblpos +680) anon_helper_pre_2_correct)))
PreconditionGeneratedEntry_correct@@2)))
(assert (or
true
(b1 p x)))
(declare-fun %lbl%+136 () Bool)
(declare-fun %lbl%+808 () Bool)
(declare-fun MLHoudiniConstant8 () Bool)
(declare-fun x@0@@2 () Int)
(declare-fun p@0@@2 () Int)
(declare-fun x@1@@2 () Int)
(declare-fun p@1@@2 () Int)
(declare-fun x@2@@1 () Int)
(declare-fun p@2@@1 () Int)
(declare-fun %lbl%@882 () Bool)
(declare-fun %lbl%+795 () Bool)
(define-fun main_helper_3Macro () Bool (let ((anon_helper_pre_3_correct (=> (! (and %lbl%+136 true) :lblpos +136) (=> (! (and %lbl%+808 MLHoudiniConstant8) :lblpos +808) (=> (and
(= x@0@@2 (- 4 x))
(= p@0@@2 (- 1 p))) (=> (and
(= x@1@@2 (- 4 x@0@@2))
(= p@1@@2 (- 1 p@0@@2))
(= x@2@@1 (- 4 x@1@@2))
(= p@2@@1 (- 1 p@1@@2))) (and
(! (or %lbl%@882 (=> true (not (or
(and
(= p@2@@1 0)
(<= 0 x@2@@1)
(<= x@2@@1 2))
(and
(= p@2@@1 1)
(<= 3 x@2@@1)
(<= x@2@@1 4)))))) :lblneg @882)
(=> (=> true (not (or
(and
(= p@2@@1 0)
(<= 0 x@2@@1)
(<= x@2@@1 2))
(and
(= p@2@@1 1)
(<= 3 x@2@@1)
(<= x@2@@1 4))))) true))))))))
(let ((PreconditionGeneratedEntry_correct@@3 (=> (! (and %lbl%+795 true) :lblpos +795) anon_helper_pre_3_correct)))
PreconditionGeneratedEntry_correct@@3)))
(assert (or
true
(b1 p x)))
(declare-fun %lbl%+146 () Bool)
(declare-fun %lbl%+953 () Bool)
(declare-fun MLHoudiniConstant9 () Bool)
(declare-fun x@0@@3 () Int)
(declare-fun p@0@@3 () Int)
(declare-fun x@1@@3 () Int)
(declare-fun p@1@@3 () Int)
(declare-fun x@2@@2 () Int)
(declare-fun p@2@@2 () Int)
(declare-fun x@3 () Int)
(declare-fun p@3 () Int)
(declare-fun %lbl%@1049 () Bool)
(declare-fun %lbl%+936 () Bool)
(define-fun main_helper_4Macro () Bool (let ((anon_helper_pre_4_correct (=> (! (and %lbl%+146 true) :lblpos +146) (=> (! (and %lbl%+953 MLHoudiniConstant9) :lblpos +953) (=> (and
(= x@0@@3 (- 4 x))
(= p@0@@3 (- 1 p))
(= x@1@@3 (- 4 x@0@@3))
(= p@1@@3 (- 1 p@0@@3))
(= x@2@@2 (- 4 x@1@@3))
(= p@2@@2 (- 1 p@1@@3))
(= x@3 (- 4 x@2@@2))
(= p@3 (- 1 p@2@@2))) (and
(! (or %lbl%@1049 (=> true (not (or
(and
(= p@3 0)
(<= 0 x@3)
(<= x@3 2))
(and
(= p@3 1)
(<= 3 x@3)
(<= x@3 4)))))) :lblneg @1049)
(=> (=> true (not (or
(and
(= p@3 0)
(<= 0 x@3)
(<= x@3 2))
(and
(= p@3 1)
(<= 3 x@3)
(<= x@3 4))))) true)))))))
(let ((PreconditionGeneratedEntry_correct@@4 (=> (! (and %lbl%+936 true) :lblpos +936) anon_helper_pre_4_correct)))
PreconditionGeneratedEntry_correct@@4)))
(assert (or
true
(b1 p x)))
(push 1)
(set-option :smt.core.minimize true)
(declare-fun GeneralizeRSPredicate_1_1 () Bool)
(declare-fun GeneralizeRSPredicate_1_2 () Bool)
(declare-fun GeneralizeRSPredicate_1_3 () Bool)
(declare-fun GeneralizeRSPredicate_1_4 () Bool)
(assert (not (=> (and
(=> MLHoudiniConstant0 (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x) (- 0 4))))
(and
(<= p 0)
(<= (- 0 p) 0)
(<= x 0)
(<= (- 0 x) 0))))
(=> (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x) (- 0 4))))
(and
(<= p 0)
(<= (- 0 p) 0)
(<= x 0)
(<= (- 0 x) 0))) MLHoudiniConstant0)
(=> MLHoudiniConstant1 (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p@1 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p@1) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x@1 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x@1) (- 0 4))))
(and
(<= p@1 0)
(<= (- 0 p@1) 0)
(<= x@1 0)
(<= (- 0 x@1) 0))))
(=> (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p@1 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p@1) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x@1 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x@1) (- 0 4))))
(and
(<= p@1 0)
(<= (- 0 p@1) 0)
(<= x@1 0)
(<= (- 0 x@1) 0))) MLHoudiniConstant1)
(=> MLHoudiniConstant2 (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p@2 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p@2) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x@2 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x@2) (- 0 4))))
(and
(<= p@2 0)
(<= (- 0 p@2) 0)
(<= x@2 0)
(<= (- 0 x@2) 0))))
(=> (or
(and
(=> GeneralizeRSPredicate_1_1 (<= p@2 1))
(=> GeneralizeRSPredicate_1_2 (<= (- 0 p@2) (- 0 1)))
(=> GeneralizeRSPredicate_1_3 (<= x@2 4))
(=> GeneralizeRSPredicate_1_4 (<= (- 0 x@2) (- 0 4))))
(and
(<= p@2 0)
(<= (- 0 p@2) 0)
(<= x@2 0)
(<= (- 0 x@2) 0))) MLHoudiniConstant2)) mainMacro)))
(check-sat GeneralizeRSPredicate_1_1 GeneralizeRSPredicate_1_2 GeneralizeRSPredicate_1_3 GeneralizeRSPredicate_1_4 )
(get-unsat-core)
(pop 1)
(push 1)
(set-option :smt.core.minimize true)
(declare-fun GeneralizeRSInterval_1_pred1_int1 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int1 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int1 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int1 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int2 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int3 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int4 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int5 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int6 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int7 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int8 () Bool)
(declare-fun GeneralizeRSInterval_1_pred1_int9 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int2 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int3 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int4 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int5 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int6 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int7 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int8 () Bool)
(declare-fun GeneralizeRSInterval_1_pred2_int9 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int2 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int3 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int4 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int5 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int6 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int7 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int8 () Bool)
(declare-fun GeneralizeRSInterval_1_pred3_int9 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int2 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int3 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int4 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int5 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int6 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int7 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int8 () Bool)
(declare-fun GeneralizeRSInterval_1_pred4_int9 () Bool)
(assert (not (=> (and
GeneralizeRSInterval_1_pred1_int1
GeneralizeRSInterval_1_pred2_int1
GeneralizeRSInterval_1_pred3_int1
GeneralizeRSInterval_1_pred4_int1
(=> MLHoudiniConstant0 (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x) 16)
(<= (- 0 x) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x) 6)
(<= (- 0 x) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x) 4)
(<= (- 0 x) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x) 2)
(<= (- 0 x) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x) 0)
(<= (- 0 x) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x) (- 0 2))
(<= (- 0 x) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x) (- 0 3))
(<= (- 0 x) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x) (- 0 4))
(<= (- 0 x) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x 24)
(<= x 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x 14)
(<= x 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x 12)
(<= x 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x 10)
(<= x 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x 8)
(<= x 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x 6)
(<= x 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x 5)
(<= x 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x 4)
(<= x 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p) 19)
(<= (- 0 p) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p) 9)
(<= (- 0 p) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p) 7)
(<= (- 0 p) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p) 5)
(<= (- 0 p) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p) 3)
(<= (- 0 p) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p) 1)
(<= (- 0 p) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p) 0)
(<= (- 0 p) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p) (- 0 1))
(<= (- 0 p) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p 21)
(<= p 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p 11)
(<= p 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p 9)
(<= p 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p 7)
(<= p 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p 5)
(<= p 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p 3)
(<= p 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p 2)
(<= p 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p 1)
(<= p 2)))))
(and
(<= p 0)
(<= (- 0 p) 0)
(<= x 0)
(<= (- 0 x) 0))))
(=> (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x) 16)
(<= (- 0 x) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x) 6)
(<= (- 0 x) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x) 4)
(<= (- 0 x) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x) 2)
(<= (- 0 x) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x) 0)
(<= (- 0 x) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x) (- 0 2))
(<= (- 0 x) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x) (- 0 3))
(<= (- 0 x) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x) (- 0 4))
(<= (- 0 x) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x 24)
(<= x 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x 14)
(<= x 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x 12)
(<= x 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x 10)
(<= x 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x 8)
(<= x 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x 6)
(<= x 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x 5)
(<= x 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x 4)
(<= x 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p) 19)
(<= (- 0 p) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p) 9)
(<= (- 0 p) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p) 7)
(<= (- 0 p) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p) 5)
(<= (- 0 p) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p) 3)
(<= (- 0 p) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p) 1)
(<= (- 0 p) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p) 0)
(<= (- 0 p) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p) (- 0 1))
(<= (- 0 p) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p 21)
(<= p 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p 11)
(<= p 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p 9)
(<= p 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p 7)
(<= p 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p 5)
(<= p 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p 3)
(<= p 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p 2)
(<= p 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p 1)
(<= p 2)))))
(and
(<= p 0)
(<= (- 0 p) 0)
(<= x 0)
(<= (- 0 x) 0))) MLHoudiniConstant0)
(=> MLHoudiniConstant1 (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x@1)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x@1) 16)
(<= (- 0 x@1) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x@1) 6)
(<= (- 0 x@1) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x@1) 4)
(<= (- 0 x@1) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x@1) 2)
(<= (- 0 x@1) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x@1) 0)
(<= (- 0 x@1) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x@1) (- 0 2))
(<= (- 0 x@1) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x@1) (- 0 3))
(<= (- 0 x@1) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x@1) (- 0 4))
(<= (- 0 x@1) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x@1))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x@1 24)
(<= x@1 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x@1 14)
(<= x@1 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x@1 12)
(<= x@1 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x@1 10)
(<= x@1 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x@1 8)
(<= x@1 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x@1 6)
(<= x@1 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x@1 5)
(<= x@1 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x@1 4)
(<= x@1 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p@1)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p@1) 19)
(<= (- 0 p@1) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p@1) 9)
(<= (- 0 p@1) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p@1) 7)
(<= (- 0 p@1) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p@1) 5)
(<= (- 0 p@1) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p@1) 3)
(<= (- 0 p@1) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p@1) 1)
(<= (- 0 p@1) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p@1) 0)
(<= (- 0 p@1) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p@1) (- 0 1))
(<= (- 0 p@1) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p@1))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p@1 21)
(<= p@1 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p@1 11)
(<= p@1 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p@1 9)
(<= p@1 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p@1 7)
(<= p@1 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p@1 5)
(<= p@1 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p@1 3)
(<= p@1 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p@1 2)
(<= p@1 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p@1 1)
(<= p@1 2)))))
(and
(<= p@1 0)
(<= (- 0 p@1) 0)
(<= x@1 0)
(<= (- 0 x@1) 0))))
(=> (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x@1)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x@1) 16)
(<= (- 0 x@1) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x@1) 6)
(<= (- 0 x@1) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x@1) 4)
(<= (- 0 x@1) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x@1) 2)
(<= (- 0 x@1) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x@1) 0)
(<= (- 0 x@1) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x@1) (- 0 2))
(<= (- 0 x@1) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x@1) (- 0 3))
(<= (- 0 x@1) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x@1) (- 0 4))
(<= (- 0 x@1) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x@1))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x@1 24)
(<= x@1 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x@1 14)
(<= x@1 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x@1 12)
(<= x@1 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x@1 10)
(<= x@1 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x@1 8)
(<= x@1 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x@1 6)
(<= x@1 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x@1 5)
(<= x@1 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x@1 4)
(<= x@1 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p@1)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p@1) 19)
(<= (- 0 p@1) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p@1) 9)
(<= (- 0 p@1) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p@1) 7)
(<= (- 0 p@1) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p@1) 5)
(<= (- 0 p@1) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p@1) 3)
(<= (- 0 p@1) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p@1) 1)
(<= (- 0 p@1) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p@1) 0)
(<= (- 0 p@1) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p@1) (- 0 1))
(<= (- 0 p@1) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p@1))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p@1 21)
(<= p@1 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p@1 11)
(<= p@1 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p@1 9)
(<= p@1 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p@1 7)
(<= p@1 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p@1 5)
(<= p@1 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p@1 3)
(<= p@1 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p@1 2)
(<= p@1 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p@1 1)
(<= p@1 2)))))
(and
(<= p@1 0)
(<= (- 0 p@1) 0)
(<= x@1 0)
(<= (- 0 x@1) 0))) MLHoudiniConstant1)
(=> MLHoudiniConstant2 (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x@2)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x@2) 16)
(<= (- 0 x@2) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x@2) 6)
(<= (- 0 x@2) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x@2) 4)
(<= (- 0 x@2) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x@2) 2)
(<= (- 0 x@2) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x@2) 0)
(<= (- 0 x@2) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x@2) (- 0 2))
(<= (- 0 x@2) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x@2) (- 0 3))
(<= (- 0 x@2) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x@2) (- 0 4))
(<= (- 0 x@2) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x@2))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x@2 24)
(<= x@2 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x@2 14)
(<= x@2 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x@2 12)
(<= x@2 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x@2 10)
(<= x@2 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x@2 8)
(<= x@2 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x@2 6)
(<= x@2 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x@2 5)
(<= x@2 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x@2 4)
(<= x@2 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p@2)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p@2) 19)
(<= (- 0 p@2) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p@2) 9)
(<= (- 0 p@2) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p@2) 7)
(<= (- 0 p@2) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p@2) 5)
(<= (- 0 p@2) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p@2) 3)
(<= (- 0 p@2) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p@2) 1)
(<= (- 0 p@2) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p@2) 0)
(<= (- 0 p@2) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p@2) (- 0 1))
(<= (- 0 p@2) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p@2))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p@2 21)
(<= p@2 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p@2 11)
(<= p@2 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p@2 9)
(<= p@2 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p@2 7)
(<= p@2 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p@2 5)
(<= p@2 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p@2 3)
(<= p@2 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p@2 2)
(<= p@2 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p@2 1)
(<= p@2 2)))))
(and
(<= p@2 0)
(<= (- 0 p@2) 0)
(<= x@2 0)
(<= (- 0 x@2) 0))))
(=> (or
(and
(=> GeneralizeRSInterval_1_pred1_int1 (>= 46 (- 0 x@2)))
(=> GeneralizeRSInterval_1_pred1_int2 (not (and
(> (- 0 x@2) 16)
(<= (- 0 x@2) 46))))
(=> GeneralizeRSInterval_1_pred1_int3 (not (and
(> (- 0 x@2) 6)
(<= (- 0 x@2) 16))))
(=> GeneralizeRSInterval_1_pred1_int4 (not (and
(> (- 0 x@2) 4)
(<= (- 0 x@2) 6))))
(=> GeneralizeRSInterval_1_pred1_int5 (not (and
(> (- 0 x@2) 2)
(<= (- 0 x@2) 4))))
(=> GeneralizeRSInterval_1_pred1_int6 (not (and
(> (- 0 x@2) 0)
(<= (- 0 x@2) 2))))
(=> GeneralizeRSInterval_1_pred1_int7 (not (and
(> (- 0 x@2) (- 0 2))
(<= (- 0 x@2) 0))))
(=> GeneralizeRSInterval_1_pred1_int8 (not (and
(> (- 0 x@2) (- 0 3))
(<= (- 0 x@2) (- 0 2)))))
(=> GeneralizeRSInterval_1_pred1_int9 (not (and
(> (- 0 x@2) (- 0 4))
(<= (- 0 x@2) (- 0 3)))))
(=> GeneralizeRSInterval_1_pred2_int1 (>= 54 x@2))
(=> GeneralizeRSInterval_1_pred2_int2 (not (and
(> x@2 24)
(<= x@2 54))))
(=> GeneralizeRSInterval_1_pred2_int3 (not (and
(> x@2 14)
(<= x@2 24))))
(=> GeneralizeRSInterval_1_pred2_int4 (not (and
(> x@2 12)
(<= x@2 14))))
(=> GeneralizeRSInterval_1_pred2_int5 (not (and
(> x@2 10)
(<= x@2 12))))
(=> GeneralizeRSInterval_1_pred2_int6 (not (and
(> x@2 8)
(<= x@2 10))))
(=> GeneralizeRSInterval_1_pred2_int7 (not (and
(> x@2 6)
(<= x@2 8))))
(=> GeneralizeRSInterval_1_pred2_int8 (not (and
(> x@2 5)
(<= x@2 6))))
(=> GeneralizeRSInterval_1_pred2_int9 (not (and
(> x@2 4)
(<= x@2 5))))
(=> GeneralizeRSInterval_1_pred3_int1 (>= 49 (- 0 p@2)))
(=> GeneralizeRSInterval_1_pred3_int2 (not (and
(> (- 0 p@2) 19)
(<= (- 0 p@2) 49))))
(=> GeneralizeRSInterval_1_pred3_int3 (not (and
(> (- 0 p@2) 9)
(<= (- 0 p@2) 19))))
(=> GeneralizeRSInterval_1_pred3_int4 (not (and
(> (- 0 p@2) 7)
(<= (- 0 p@2) 9))))
(=> GeneralizeRSInterval_1_pred3_int5 (not (and
(> (- 0 p@2) 5)
(<= (- 0 p@2) 7))))
(=> GeneralizeRSInterval_1_pred3_int6 (not (and
(> (- 0 p@2) 3)
(<= (- 0 p@2) 5))))
(=> GeneralizeRSInterval_1_pred3_int7 (not (and
(> (- 0 p@2) 1)
(<= (- 0 p@2) 3))))
(=> GeneralizeRSInterval_1_pred3_int8 (not (and
(> (- 0 p@2) 0)
(<= (- 0 p@2) 1))))
(=> GeneralizeRSInterval_1_pred3_int9 (not (and
(> (- 0 p@2) (- 0 1))
(<= (- 0 p@2) 0))))
(=> GeneralizeRSInterval_1_pred4_int1 (>= 51 p@2))
(=> GeneralizeRSInterval_1_pred4_int2 (not (and
(> p@2 21)
(<= p@2 51))))
(=> GeneralizeRSInterval_1_pred4_int3 (not (and
(> p@2 11)
(<= p@2 21))))
(=> GeneralizeRSInterval_1_pred4_int4 (not (and
(> p@2 9)
(<= p@2 11))))
(=> GeneralizeRSInterval_1_pred4_int5 (not (and
(> p@2 7)
(<= p@2 9))))
(=> GeneralizeRSInterval_1_pred4_int6 (not (and
(> p@2 5)
(<= p@2 7))))
(=> GeneralizeRSInterval_1_pred4_int7 (not (and
(> p@2 3)
(<= p@2 5))))
(=> GeneralizeRSInterval_1_pred4_int8 (not (and
(> p@2 2)
(<= p@2 3))))
(=> GeneralizeRSInterval_1_pred4_int9 (not (and
(> p@2 1)
(<= p@2 2)))))
(and
(<= p@2 0)
(<= (- 0 p@2) 0)
(<= x@2 0)
(<= (- 0 x@2) 0))) MLHoudiniConstant2)) mainMacro)))
(check-sat GeneralizeRSInterval_1_pred1_int2 GeneralizeRSInterval_1_pred1_int3 GeneralizeRSInterval_1_pred1_int4 GeneralizeRSInterval_1_pred1_int5 GeneralizeRSInterval_1_pred1_int6 GeneralizeRSInterval_1_pred1_int7 GeneralizeRSInterval_1_pred1_int8 GeneralizeRSInterval_1_pred1_int9 GeneralizeRSInterval_1_pred2_int2 GeneralizeRSInterval_1_pred2_int3 GeneralizeRSInterval_1_pred2_int4 GeneralizeRSInterval_1_pred2_int5 GeneralizeRSInterval_1_pred2_int6 GeneralizeRSInterval_1_pred2_int7 GeneralizeRSInterval_1_pred2_int8 GeneralizeRSInterval_1_pred2_int9 GeneralizeRSInterval_1_pred3_int2 GeneralizeRSInterval_1_pred3_int3 GeneralizeRSInterval_1_pred3_int4 GeneralizeRSInterval_1_pred3_int5 GeneralizeRSInterval_1_pred3_int6 GeneralizeRSInterval_1_pred3_int7 GeneralizeRSInterval_1_pred3_int8 GeneralizeRSInterval_1_pred3_int9 GeneralizeRSInterval_1_pred4_int2 GeneralizeRSInterval_1_pred4_int3 GeneralizeRSInterval_1_pred4_int4 GeneralizeRSInterval_1_pred4_int5 GeneralizeRSInterval_1_pred4_int6 GeneralizeRSInterval_1_pred4_int7 GeneralizeRSInterval_1_pred4_int8 GeneralizeRSInterval_1_pred4_int9 )
(get-unsat-core)
(pop 1)
(push 1)
(set-option :smt.core.minimize true)
(declare-fun GeneralizeRSPredicate_2_1 () Bool)
(declare-fun GeneralizeRSPredicate_2_2 () Bool)
(declare-fun GeneralizeRSPredicate_2_3 () Bool)
(declare-fun GeneralizeRSPredicate_2_4 () Bool)
(assert (not (=> (and
(=> MLHoudiniConstant0 (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p) 0))
(=> GeneralizeRSPredicate_2_3 (<= x 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x) 0)))
(and
(<= x 4)
(<= (- 0 p) (- 0 1))
(<= (- 0 x) (- 0 4))
(<= p 1))))
(=> (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p) 0))
(=> GeneralizeRSPredicate_2_3 (<= x 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x) 0)))
(and
(<= x 4)
(<= (- 0 p) (- 0 1))
(<= (- 0 x) (- 0 4))
(<= p 1))) MLHoudiniConstant0)
(=> MLHoudiniConstant1 (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p@1 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p@1) 0))
(=> GeneralizeRSPredicate_2_3 (<= x@1 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x@1) 0)))
(and
(<= x@1 4)
(<= (- 0 p@1) (- 0 1))
(<= (- 0 x@1) (- 0 4))
(<= p@1 1))))
(=> (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p@1 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p@1) 0))
(=> GeneralizeRSPredicate_2_3 (<= x@1 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x@1) 0)))
(and
(<= x@1 4)
(<= (- 0 p@1) (- 0 1))
(<= (- 0 x@1) (- 0 4))
(<= p@1 1))) MLHoudiniConstant1)
(=> MLHoudiniConstant2 (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p@2 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p@2) 0))
(=> GeneralizeRSPredicate_2_3 (<= x@2 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x@2) 0)))
(and
(<= x@2 4)
(<= (- 0 p@2) (- 0 1))
(<= (- 0 x@2) (- 0 4))
(<= p@2 1))))
(=> (or
(and
(=> GeneralizeRSPredicate_2_1 (<= p@2 0))
(=> GeneralizeRSPredicate_2_2 (<= (- 0 p@2) 0))
(=> GeneralizeRSPredicate_2_3 (<= x@2 0))
(=> GeneralizeRSPredicate_2_4 (<= (- 0 x@2) 0)))
(and
(<= x@2 4)
(<= (- 0 p@2) (- 0 1))
(<= (- 0 x@2) (- 0 4))
(<= p@2 1))) MLHoudiniConstant2)) mainMacro)))
(check-sat GeneralizeRSPredicate_2_1 GeneralizeRSPredicate_2_2 GeneralizeRSPredicate_2_3 GeneralizeRSPredicate_2_4 )
(get-unsat-core)
(pop 1)
(push 1)
(set-option :smt.core.minimize true)
(declare-fun GeneralizeRSInterval_2_pred1_int1 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int1 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int1 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int1 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int2 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int3 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int4 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int5 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int6 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int7 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int8 () Bool)
(declare-fun GeneralizeRSInterval_2_pred1_int9 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int2 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int3 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int4 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int5 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int6 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int7 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int8 () Bool)
(declare-fun GeneralizeRSInterval_2_pred2_int9 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int2 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int3 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int4 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int5 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int6 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int7 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int8 () Bool)
(declare-fun GeneralizeRSInterval_2_pred3_int9 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int2 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int3 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int4 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int5 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int6 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int7 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int8 () Bool)
(declare-fun GeneralizeRSInterval_2_pred4_int9 () Bool)
(assert (not (=> (and
GeneralizeRSInterval_2_pred1_int1
GeneralizeRSInterval_2_pred2_int1
GeneralizeRSInterval_2_pred3_int1
GeneralizeRSInterval_2_pred4_int1
(=> MLHoudiniConstant0 (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x) 20)
(<= (- 0 x) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x) 10)
(<= (- 0 x) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x) 8)
(<= (- 0 x) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x) 6)
(<= (- 0 x) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x) 4)
(<= (- 0 x) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x) 2)
(<= (- 0 x) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x) 1)
(<= (- 0 x) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x) 0)
(<= (- 0 x) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x 20)
(<= x 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x 10)
(<= x 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x 8)
(<= x 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x 6)
(<= x 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x 4)
(<= x 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x 2)
(<= x 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x 1)
(<= x 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x 0)
(<= x 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p) 20)
(<= (- 0 p) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p) 10)
(<= (- 0 p) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p) 8)
(<= (- 0 p) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p) 6)
(<= (- 0 p) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p) 4)
(<= (- 0 p) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p) 2)
(<= (- 0 p) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p) 1)
(<= (- 0 p) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p) 0)
(<= (- 0 p) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p 20)
(<= p 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p 10)
(<= p 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p 8)
(<= p 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p 6)
(<= p 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p 4)
(<= p 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p 2)
(<= p 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p 1)
(<= p 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p 0)
(<= p 1)))))
(and
(<= x 4)
(<= (- 0 p) (- 0 1))
(<= (- 0 x) (- 0 4))
(<= p 1))))
(=> (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x) 20)
(<= (- 0 x) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x) 10)
(<= (- 0 x) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x) 8)
(<= (- 0 x) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x) 6)
(<= (- 0 x) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x) 4)
(<= (- 0 x) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x) 2)
(<= (- 0 x) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x) 1)
(<= (- 0 x) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x) 0)
(<= (- 0 x) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x 20)
(<= x 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x 10)
(<= x 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x 8)
(<= x 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x 6)
(<= x 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x 4)
(<= x 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x 2)
(<= x 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x 1)
(<= x 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x 0)
(<= x 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p) 20)
(<= (- 0 p) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p) 10)
(<= (- 0 p) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p) 8)
(<= (- 0 p) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p) 6)
(<= (- 0 p) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p) 4)
(<= (- 0 p) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p) 2)
(<= (- 0 p) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p) 1)
(<= (- 0 p) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p) 0)
(<= (- 0 p) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p 20)
(<= p 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p 10)
(<= p 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p 8)
(<= p 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p 6)
(<= p 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p 4)
(<= p 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p 2)
(<= p 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p 1)
(<= p 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p 0)
(<= p 1)))))
(and
(<= x 4)
(<= (- 0 p) (- 0 1))
(<= (- 0 x) (- 0 4))
(<= p 1))) MLHoudiniConstant0)
(=> MLHoudiniConstant1 (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x@1)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x@1) 20)
(<= (- 0 x@1) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x@1) 10)
(<= (- 0 x@1) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x@1) 8)
(<= (- 0 x@1) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x@1) 6)
(<= (- 0 x@1) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x@1) 4)
(<= (- 0 x@1) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x@1) 2)
(<= (- 0 x@1) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x@1) 1)
(<= (- 0 x@1) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x@1) 0)
(<= (- 0 x@1) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x@1))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x@1 20)
(<= x@1 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x@1 10)
(<= x@1 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x@1 8)
(<= x@1 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x@1 6)
(<= x@1 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x@1 4)
(<= x@1 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x@1 2)
(<= x@1 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x@1 1)
(<= x@1 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x@1 0)
(<= x@1 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p@1)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p@1) 20)
(<= (- 0 p@1) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p@1) 10)
(<= (- 0 p@1) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p@1) 8)
(<= (- 0 p@1) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p@1) 6)
(<= (- 0 p@1) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p@1) 4)
(<= (- 0 p@1) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p@1) 2)
(<= (- 0 p@1) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p@1) 1)
(<= (- 0 p@1) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p@1) 0)
(<= (- 0 p@1) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p@1))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p@1 20)
(<= p@1 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p@1 10)
(<= p@1 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p@1 8)
(<= p@1 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p@1 6)
(<= p@1 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p@1 4)
(<= p@1 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p@1 2)
(<= p@1 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p@1 1)
(<= p@1 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p@1 0)
(<= p@1 1)))))
(and
(<= x@1 4)
(<= (- 0 p@1) (- 0 1))
(<= (- 0 x@1) (- 0 4))
(<= p@1 1))))
(=> (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x@1)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x@1) 20)
(<= (- 0 x@1) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x@1) 10)
(<= (- 0 x@1) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x@1) 8)
(<= (- 0 x@1) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x@1) 6)
(<= (- 0 x@1) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x@1) 4)
(<= (- 0 x@1) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x@1) 2)
(<= (- 0 x@1) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x@1) 1)
(<= (- 0 x@1) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x@1) 0)
(<= (- 0 x@1) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x@1))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x@1 20)
(<= x@1 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x@1 10)
(<= x@1 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x@1 8)
(<= x@1 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x@1 6)
(<= x@1 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x@1 4)
(<= x@1 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x@1 2)
(<= x@1 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x@1 1)
(<= x@1 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x@1 0)
(<= x@1 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p@1)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p@1) 20)
(<= (- 0 p@1) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p@1) 10)
(<= (- 0 p@1) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p@1) 8)
(<= (- 0 p@1) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p@1) 6)
(<= (- 0 p@1) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p@1) 4)
(<= (- 0 p@1) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p@1) 2)
(<= (- 0 p@1) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p@1) 1)
(<= (- 0 p@1) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p@1) 0)
(<= (- 0 p@1) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p@1))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p@1 20)
(<= p@1 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p@1 10)
(<= p@1 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p@1 8)
(<= p@1 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p@1 6)
(<= p@1 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p@1 4)
(<= p@1 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p@1 2)
(<= p@1 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p@1 1)
(<= p@1 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p@1 0)
(<= p@1 1)))))
(and
(<= x@1 4)
(<= (- 0 p@1) (- 0 1))
(<= (- 0 x@1) (- 0 4))
(<= p@1 1))) MLHoudiniConstant1)
(=> MLHoudiniConstant2 (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x@2)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x@2) 20)
(<= (- 0 x@2) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x@2) 10)
(<= (- 0 x@2) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x@2) 8)
(<= (- 0 x@2) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x@2) 6)
(<= (- 0 x@2) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x@2) 4)
(<= (- 0 x@2) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x@2) 2)
(<= (- 0 x@2) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x@2) 1)
(<= (- 0 x@2) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x@2) 0)
(<= (- 0 x@2) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x@2))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x@2 20)
(<= x@2 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x@2 10)
(<= x@2 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x@2 8)
(<= x@2 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x@2 6)
(<= x@2 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x@2 4)
(<= x@2 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x@2 2)
(<= x@2 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x@2 1)
(<= x@2 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x@2 0)
(<= x@2 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p@2)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p@2) 20)
(<= (- 0 p@2) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p@2) 10)
(<= (- 0 p@2) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p@2) 8)
(<= (- 0 p@2) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p@2) 6)
(<= (- 0 p@2) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p@2) 4)
(<= (- 0 p@2) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p@2) 2)
(<= (- 0 p@2) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p@2) 1)
(<= (- 0 p@2) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p@2) 0)
(<= (- 0 p@2) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p@2))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p@2 20)
(<= p@2 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p@2 10)
(<= p@2 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p@2 8)
(<= p@2 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p@2 6)
(<= p@2 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p@2 4)
(<= p@2 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p@2 2)
(<= p@2 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p@2 1)
(<= p@2 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p@2 0)
(<= p@2 1)))))
(and
(<= x@2 4)
(<= (- 0 p@2) (- 0 1))
(<= (- 0 x@2) (- 0 4))
(<= p@2 1))))
(=> (or
(and
(=> GeneralizeRSInterval_2_pred1_int1 (>= 50 (- 0 x@2)))
(=> GeneralizeRSInterval_2_pred1_int2 (not (and
(> (- 0 x@2) 20)
(<= (- 0 x@2) 50))))
(=> GeneralizeRSInterval_2_pred1_int3 (not (and
(> (- 0 x@2) 10)
(<= (- 0 x@2) 20))))
(=> GeneralizeRSInterval_2_pred1_int4 (not (and
(> (- 0 x@2) 8)
(<= (- 0 x@2) 10))))
(=> GeneralizeRSInterval_2_pred1_int5 (not (and
(> (- 0 x@2) 6)
(<= (- 0 x@2) 8))))
(=> GeneralizeRSInterval_2_pred1_int6 (not (and
(> (- 0 x@2) 4)
(<= (- 0 x@2) 6))))
(=> GeneralizeRSInterval_2_pred1_int7 (not (and
(> (- 0 x@2) 2)
(<= (- 0 x@2) 4))))
(=> GeneralizeRSInterval_2_pred1_int8 (not (and
(> (- 0 x@2) 1)
(<= (- 0 x@2) 2))))
(=> GeneralizeRSInterval_2_pred1_int9 (not (and
(> (- 0 x@2) 0)
(<= (- 0 x@2) 1))))
(=> GeneralizeRSInterval_2_pred2_int1 (>= 50 x@2))
(=> GeneralizeRSInterval_2_pred2_int2 (not (and
(> x@2 20)
(<= x@2 50))))
(=> GeneralizeRSInterval_2_pred2_int3 (not (and
(> x@2 10)
(<= x@2 20))))
(=> GeneralizeRSInterval_2_pred2_int4 (not (and
(> x@2 8)
(<= x@2 10))))
(=> GeneralizeRSInterval_2_pred2_int5 (not (and
(> x@2 6)
(<= x@2 8))))
(=> GeneralizeRSInterval_2_pred2_int6 (not (and
(> x@2 4)
(<= x@2 6))))
(=> GeneralizeRSInterval_2_pred2_int7 (not (and
(> x@2 2)
(<= x@2 4))))
(=> GeneralizeRSInterval_2_pred2_int8 (not (and
(> x@2 1)
(<= x@2 2))))
(=> GeneralizeRSInterval_2_pred2_int9 (not (and
(> x@2 0)
(<= x@2 1))))
(=> GeneralizeRSInterval_2_pred3_int1 (>= 50 (- 0 p@2)))
(=> GeneralizeRSInterval_2_pred3_int2 (not (and
(> (- 0 p@2) 20)
(<= (- 0 p@2) 50))))
(=> GeneralizeRSInterval_2_pred3_int3 (not (and
(> (- 0 p@2) 10)
(<= (- 0 p@2) 20))))
(=> GeneralizeRSInterval_2_pred3_int4 (not (and
(> (- 0 p@2) 8)
(<= (- 0 p@2) 10))))
(=> GeneralizeRSInterval_2_pred3_int5 (not (and
(> (- 0 p@2) 6)
(<= (- 0 p@2) 8))))
(=> GeneralizeRSInterval_2_pred3_int6 (not (and
(> (- 0 p@2) 4)
(<= (- 0 p@2) 6))))
(=> GeneralizeRSInterval_2_pred3_int7 (not (and
(> (- 0 p@2) 2)
(<= (- 0 p@2) 4))))
(=> GeneralizeRSInterval_2_pred3_int8 (not (and
(> (- 0 p@2) 1)
(<= (- 0 p@2) 2))))
(=> GeneralizeRSInterval_2_pred3_int9 (not (and
(> (- 0 p@2) 0)
(<= (- 0 p@2) 1))))
(=> GeneralizeRSInterval_2_pred4_int1 (>= 50 p@2))
(=> GeneralizeRSInterval_2_pred4_int2 (not (and
(> p@2 20)
(<= p@2 50))))
(=> GeneralizeRSInterval_2_pred4_int3 (not (and
(> p@2 10)
(<= p@2 20))))
(=> GeneralizeRSInterval_2_pred4_int4 (not (and
(> p@2 8)
(<= p@2 10))))
(=> GeneralizeRSInterval_2_pred4_int5 (not (and
(> p@2 6)
(<= p@2 8))))
(=> GeneralizeRSInterval_2_pred4_int6 (not (and
(> p@2 4)
(<= p@2 6))))
(=> GeneralizeRSInterval_2_pred4_int7 (not (and
(> p@2 2)
(<= p@2 4))))
(=> GeneralizeRSInterval_2_pred4_int8 (not (and
(> p@2 1)
(<= p@2 2))))
(=> GeneralizeRSInterval_2_pred4_int9 (not (and
(> p@2 0)
(<= p@2 1)))))
(and
(<= x@2 4)
(<= (- 0 p@2) (- 0 1))
(<= (- 0 x@2) (- 0 4))
(<= p@2 1))) MLHoudiniConstant2)) mainMacro)))
(check-sat GeneralizeRSInterval_2_pred1_int2 GeneralizeRSInterval_2_pred1_int3 GeneralizeRSInterval_2_pred1_int4 GeneralizeRSInterval_2_pred1_int5 GeneralizeRSInterval_2_pred1_int6 GeneralizeRSInterval_2_pred1_int7 GeneralizeRSInterval_2_pred1_int8 GeneralizeRSInterval_2_pred1_int9 GeneralizeRSInterval_2_pred2_int2 GeneralizeRSInterval_2_pred2_int3 GeneralizeRSInterval_2_pred2_int4 GeneralizeRSInterval_2_pred2_int5 GeneralizeRSInterval_2_pred2_int6 GeneralizeRSInterval_2_pred2_int7 GeneralizeRSInterval_2_pred2_int8 GeneralizeRSInterval_2_pred2_int9 GeneralizeRSInterval_2_pred3_int2 GeneralizeRSInterval_2_pred3_int3 GeneralizeRSInterval_2_pred3_int4 GeneralizeRSInterval_2_pred3_int5 GeneralizeRSInterval_2_pred3_int6 GeneralizeRSInterval_2_pred3_int7 GeneralizeRSInterval_2_pred3_int8 GeneralizeRSInterval_2_pred3_int9 GeneralizeRSInterval_2_pred4_int2 GeneralizeRSInterval_2_pred4_int3 GeneralizeRSInterval_2_pred4_int4 GeneralizeRSInterval_2_pred4_int5 GeneralizeRSInterval_2_pred4_int6 GeneralizeRSInterval_2_pred4_int7 GeneralizeRSInterval_2_pred4_int8 GeneralizeRSInterval_2_pred4_int9 )
(get-unsat-core)
