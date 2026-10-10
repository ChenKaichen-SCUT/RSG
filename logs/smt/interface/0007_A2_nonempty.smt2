; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x51 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x51)))
 (let (($x44 (<= p 1)))
 (let (($x45 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x44)))
 (or $x45 $x52))))))
(check-sat)
