; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x93 (<= p 1)))
 (let (($x129 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x93)))
 (let (($x44 (<= p 0)))
 (let (($x56 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x44)))
 (or $x56 $x129))))))
(check-sat)
