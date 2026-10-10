; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x50 (<= p 0)))
 (let (($x65 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x50)))
 (let (($x44 (<= p 1)))
 (let (($x48 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x44)))
 (or $x48 $x65))))))
(check-sat)
