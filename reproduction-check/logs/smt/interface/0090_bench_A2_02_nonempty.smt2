; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x142 (<= p 0)))
 (let (($x51 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x142)))
 (let (($x41 (<= p 1)))
 (let (($x145 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x41)))
 (or $x145 $x51))))))
(check-sat)
