; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun x_next () Int)
(declare-fun p () Int)
(declare-fun p_next () Int)
(assert
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (xor $x27 $x27)))
(check-sat)
