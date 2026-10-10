; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x119 (<= p 0)))
 (let (($x93 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x119)))
 (let (($x127 (<= p 1)))
 (let (($x85 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x127)))
 (or $x85 $x93))))))
(check-sat)
