; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x139 (<= p 1)))
 (let (($x71 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x139)))
 (let (($x108 (<= p 0)))
 (let (($x50 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x108)))
 (or $x50 $x71))))))
(check-sat)
