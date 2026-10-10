; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x37 (<= p 1)))
 (let (($x53 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x37)))
 (let (($x75 (<= p 0)))
 (let (($x54 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x75)))
 (or $x54 $x53))))))
(check-sat)
