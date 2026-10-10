; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun x_next () Int)
(declare-fun p () Int)
(declare-fun p_next () Int)
(assert
 (let (($x95 (or (and (distinct p_next (- 1 p)) true) (and (distinct x_next (- 4 x)) true))))
 (let (($x27 (and (= p_next (- 1 p)) (= x_next (- 4 x)))))
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x22 (or (and (= p 0) (>= x 0) (<= x 2)) $x21)))
 (and $x22 $x27 $x95)))))))
(check-sat)
