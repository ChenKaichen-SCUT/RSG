; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x62 (<= p 1)))
 (let (($x37 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x62)))
 (let (($x69 (<= p 0)))
 (let (($x101 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x69)))
 (or $x101 $x37))))))
(check-sat)
