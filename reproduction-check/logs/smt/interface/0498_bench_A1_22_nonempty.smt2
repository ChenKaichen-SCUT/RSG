; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x40 (<= p 1)))
 (let (($x132 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x40)))
 (let (($x131 (<= p 0)))
 (let (($x113 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x131)))
 (or $x113 $x132))))))
(check-sat)
