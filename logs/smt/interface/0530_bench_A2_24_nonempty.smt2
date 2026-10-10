; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x104 (<= p 0)))
 (let (($x121 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x104)))
 (let (($x36 (<= p 1)))
 (let (($x108 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x36)))
 (or $x108 $x121))))))
(check-sat)
