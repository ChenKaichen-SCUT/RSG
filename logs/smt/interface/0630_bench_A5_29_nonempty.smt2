; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x56 (<= p 1)))
 (let (($x99 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x56)))
 (let (($x57 (<= p 0)))
 (let (($x63 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x57)))
 (or $x63 $x99))))))
(check-sat)
