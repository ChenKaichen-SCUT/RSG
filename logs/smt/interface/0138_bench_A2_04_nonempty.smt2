; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x129 (<= p 0)))
 (let (($x37 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (let (($x108 (<= p 1)))
 (let (($x106 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x108)))
 (or $x106 $x37))))))
(check-sat)
