; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x108 (<= p 1)))
 (let (($x122 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x108)))
 (let (($x129 (<= p 0)))
 (let (($x37 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (or $x37 $x122))))))
(check-sat)
