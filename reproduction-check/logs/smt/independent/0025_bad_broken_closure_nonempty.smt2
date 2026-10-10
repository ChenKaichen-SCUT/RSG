; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x11 (>= x 0)))
 (let (($x10 (= p 0)))
 (let (($x34 (and $x10 $x11 (<= x 1))))
 (or $x34 (and (= p 1) (>= x 4) (<= x 4)))))))
(check-sat)
