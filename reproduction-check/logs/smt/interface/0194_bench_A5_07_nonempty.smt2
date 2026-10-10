; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x127 (<= p 1)))
 (let (($x69 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x127)))
 (let (($x110 (<= p 0)))
 (let (($x108 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x110)))
 (or $x108 $x69))))))
(check-sat)
