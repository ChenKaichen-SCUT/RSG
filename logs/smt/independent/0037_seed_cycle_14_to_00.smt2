; benchmark generated from python API
(set-info :status unknown)
(declare-fun x_next () Int)
(declare-fun p_next () Int)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x93 (not (and (= p_next 0) (= x_next 0)))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (let (($x30 (= x 4)))
 (let (($x16 (= p 1)))
 (and $x16 $x30 $x27 $x93))))))
(check-sat)
