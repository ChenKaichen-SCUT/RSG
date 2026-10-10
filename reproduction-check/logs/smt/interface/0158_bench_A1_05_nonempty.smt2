; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x139 (<= p 1)))
 (let (($x39 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x139)))
 (let (($x53 (<= p 0)))
 (let (($x114 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x53)))
 (or $x114 $x39))))))
(check-sat)
