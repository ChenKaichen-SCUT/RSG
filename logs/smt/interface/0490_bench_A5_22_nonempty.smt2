; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x85 (<= p 1)))
 (let (($x131 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x85)))
 (let (($x76 (<= p 0)))
 (let (($x69 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x76)))
 (or $x69 $x131))))))
(check-sat)
