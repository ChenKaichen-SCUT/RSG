; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x204 (and (and (and (>= 1 p) (< (- 1) p)) (< 0 p)) (<= (- p x) (- 2)))))
 (let (($x95 (>= 1 x)))
 (let (($x39 (and (and (and (>= 1 p) (< (- 1) p)) (>= 0 p)) $x95)))
 (or (and $x39 (< (- 1) x)) (and $x204 (< (- 4) (- p x))))))))
(check-sat)
