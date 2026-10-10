; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x129 (<= p 1)))
 (let (($x51 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x129)))
 (let (($x63 (<= p 0)))
 (let (($x69 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x63)))
 (or $x69 $x51))))))
(check-sat)
