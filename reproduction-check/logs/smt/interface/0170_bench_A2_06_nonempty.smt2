; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x139 (<= p 0)))
 (let (($x72 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x139)))
 (let (($x55 (<= p 1)))
 (let (($x53 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x55)))
 (or $x53 $x72))))))
(check-sat)
