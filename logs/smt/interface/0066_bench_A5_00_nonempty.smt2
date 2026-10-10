; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x51 (<= p 1)))
 (let (($x95 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x51)))
 (let (($x50 (<= p 0)))
 (let (($x96 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x50)))
 (or $x96 $x95))))))
(check-sat)
