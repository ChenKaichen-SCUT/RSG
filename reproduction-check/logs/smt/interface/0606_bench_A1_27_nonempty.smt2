; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x40 (<= p 1)))
 (let (($x50 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x40)))
 (let (($x134 (<= p 0)))
 (let (($x104 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x134)))
 (or $x104 $x50))))))
(check-sat)
