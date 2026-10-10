; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x69 (<= p 0)))
 (let (($x101 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x69)))
 (let (($x62 (<= p 1)))
 (let (($x110 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x62)))
 (or $x110 $x101))))))
(check-sat)
