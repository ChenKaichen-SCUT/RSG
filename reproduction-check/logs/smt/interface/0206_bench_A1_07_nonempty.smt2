; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x127 (<= p 1)))
 (let (($x45 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x127)))
 (let (($x119 (<= p 0)))
 (let (($x93 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x119)))
 (or $x93 $x45))))))
(check-sat)
