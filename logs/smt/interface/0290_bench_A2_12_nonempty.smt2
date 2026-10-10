; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x36 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x36)))
 (let (($x129 (<= p 1)))
 (let (($x135 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x129)))
 (or $x135 $x52))))))
(check-sat)
