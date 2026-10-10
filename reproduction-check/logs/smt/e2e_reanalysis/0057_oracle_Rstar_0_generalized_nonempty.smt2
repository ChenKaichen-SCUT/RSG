; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x116 (and (and (and (>= 1 p) (<= (- p) (- 1))) (>= 4 x)) (<= (- x) (- 3)))))
 (let (($x100 (and (and (and (>= 0 p) (>= 0 (- p))) (>= 1 x)) (>= 0 (- x)))))
 (or $x100 $x116))))
(check-sat)
