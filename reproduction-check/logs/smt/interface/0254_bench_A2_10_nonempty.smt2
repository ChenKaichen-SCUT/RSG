; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x106 (<= p 0)))
 (let (($x129 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x106)))
 (let (($x139 (<= p 1)))
 (let (($x45 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x139)))
 (or $x45 $x129))))))
(check-sat)
