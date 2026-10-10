; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x152 (<= p 1)))
 (let (($x58 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x152)))
 (let (($x77 (<= p 0)))
 (let (($x78 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x77)))
 (or $x78 $x58))))))
(check-sat)
