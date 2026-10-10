; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x110 (<= p 0)))
 (let (($x108 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x110)))
 (let (($x127 (<= p 1)))
 (let (($x49 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x127)))
 (or $x49 $x108))))))
(check-sat)
