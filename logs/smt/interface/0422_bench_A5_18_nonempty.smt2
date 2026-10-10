; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x136 (<= p 1)))
 (let (($x46 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x136)))
 (let (($x56 (<= p 0)))
 (let (($x115 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x56)))
 (or $x115 $x46))))))
(check-sat)
