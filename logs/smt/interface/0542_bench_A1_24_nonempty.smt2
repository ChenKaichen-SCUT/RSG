; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x133 (<= p 1)))
 (let (($x130 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x133)))
 (let (($x121 (<= p 0)))
 (let (($x54 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x121)))
 (or $x54 $x130))))))
(check-sat)
