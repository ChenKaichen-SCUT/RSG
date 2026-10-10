; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x132 (<= p 0)))
 (let (($x114 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x132)))
 (let (($x41 (<= p 1)))
 (let (($x52 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x41)))
 (or $x52 $x114))))))
(check-sat)
