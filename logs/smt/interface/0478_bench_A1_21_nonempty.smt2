; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x89 (<= p 1)))
 (let (($x152 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x89)))
 (let (($x101 (<= p 0)))
 (let (($x85 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x101)))
 (or $x85 $x152))))))
(check-sat)
