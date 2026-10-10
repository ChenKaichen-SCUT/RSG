; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x135 (<= p 1)))
 (let (($x58 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x135)))
 (let (($x51 (<= p 0)))
 (let (($x36 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x51)))
 (or $x36 $x58))))))
(check-sat)
