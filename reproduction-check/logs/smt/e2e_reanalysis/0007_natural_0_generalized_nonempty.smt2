; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x126 (and (and (>= 3 (- (- p x))) (>= 1 p)) (<= (- x) (- 4)))))
 (let (($x118 (and (and (>= 0 (- x)) (>= 0 (+ p x))) (>= 0 (- p)))))
 (or $x118 $x126))))
(check-sat)
