; benchmark generated from python API
(set-info :status unknown)
(declare-fun x_alternative () Int)
(declare-fun x_next () Int)
(declare-fun p_alternative () Int)
(declare-fun p_next () Int)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x48 (or (and (distinct p_next p_alternative) true) (and (distinct x_next x_alternative) true))))
 (let (($x90 (and (= p_alternative (- 1 p)) (= x_alternative (- 4 x)))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (and $x27 $x90 $x48)))))
(check-sat)
