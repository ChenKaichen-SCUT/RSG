; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x78 (<= p 0)))
 (let (($x59 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x78)))
 (let (($x72 (<= p 1)))
 (let (($x152 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x72)))
 (or $x152 $x59))))))
(check-sat)
