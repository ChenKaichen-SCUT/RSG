; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x53 (<= p 0)))
 (let (($x114 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x53)))
 (let (($x139 (<= p 1)))
 (let (($x45 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x139)))
 (or $x45 $x114))))))
(check-sat)
