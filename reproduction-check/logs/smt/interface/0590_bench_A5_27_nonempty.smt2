; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x72 (<= p 1)))
 (let (($x56 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x72)))
 (let (($x78 (<= p 0)))
 (let (($x59 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x78)))
 (or $x59 $x56))))))
(check-sat)
