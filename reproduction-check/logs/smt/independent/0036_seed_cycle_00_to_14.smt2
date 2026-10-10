; benchmark generated from python API
(set-info :status unknown)
(declare-fun x_next () Int)
(declare-fun p_next () Int)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x134 (not (and (= p_next 1) (= x_next 4)))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (let (($x28 (= x 0)))
 (let (($x10 (= p 0)))
 (and $x10 $x28 $x27 $x134))))))
(check-sat)
