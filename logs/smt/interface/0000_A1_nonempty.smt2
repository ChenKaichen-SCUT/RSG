; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x51 (<= p 1)))
 (let (($x52 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x51)))
 (let (($x43 (<= p 0)))
 (let (($x44 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x43)))
 (or $x44 $x52))))))
(check-sat)
