; benchmark generated from python API
(set-info :status unknown)
(declare-fun x_next () Int)
(declare-fun p_next () Int)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x52 (and (= p_next 1) (= x_next 3))))
 (let (($x103 (and (= p_next 0) (= x_next 1))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (let (($x80 (or (and (= p 0) (= x 1)) (and (= p 1) (= x 3)))))
 (and $x80 $x27 (not (or $x103 $x52))))))))
(check-sat)
