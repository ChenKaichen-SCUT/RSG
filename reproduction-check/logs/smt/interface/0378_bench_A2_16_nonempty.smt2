; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x129 (<= p 0)))
 (let (($x95 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (let (($x130 (<= p 1)))
 (let (($x93 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x130)))
 (or $x93 $x95))))))
(check-sat)
