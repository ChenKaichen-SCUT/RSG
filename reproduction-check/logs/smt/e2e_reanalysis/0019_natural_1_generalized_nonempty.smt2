; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let ((?x40 (- p x)))
 (let (($x97 (<= ?x40 (- 2))))
 (let (($x98 (>= 1 p)))
 (let (($x106 (and (and (and (>= 2 (- ?x40)) (<= (- p) (- 1))) $x98) $x97)))
 (let (($x104 (and (and (and (<= (- x) (- 1)) (>= 1 x)) (>= 0 p)) (>= 0 (- p)))))
 (or $x104 $x106)))))))
(check-sat)
