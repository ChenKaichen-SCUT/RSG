; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x131 (<= p 0)))
 (let (($x113 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x131)))
 (let (($x40 (<= p 1)))
 (let (($x99 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x40)))
 (or $x99 $x113))))))
(check-sat)
