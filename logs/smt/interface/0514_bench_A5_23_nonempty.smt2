; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x84 (<= p 1)))
 (let (($x80 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x84)))
 (let (($x40 (<= p 0)))
 (let (($x114 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x40)))
 (or $x114 $x80))))))
(check-sat)
