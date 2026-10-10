; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let ((?x40 (- p x)))
 (let (($x97 (<= ?x40 (- 2))))
 (let (($x77 (and (and (and (< (- 1) p) (>= 1 p)) (< 0 p)) $x97)))
 (let (($x132 (>= 1 x)))
 (let (($x79 (and (and (and (< (- 1) p) (>= 1 p)) (>= 0 p)) $x132)))
 (or (and $x79 (< 0 x)) (and $x77 (< (- 3) ?x40)))))))))
(check-sat)
