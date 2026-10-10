; benchmark generated from python API
(set-info :status unknown)
(declare-fun x_next () Int)
(declare-fun p_next () Int)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x65 (and (= p_next 1) (= x_next 4))))
 (let (($x67 (and (= p_next 0) (= x_next 0))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 $x27 (not (or $x67 $x65))))))))
(check-sat)
