; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x139 (<= p 1)))
 (let (($x96 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x139)))
 (let (($x106 (<= p 0)))
 (let (($x129 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x106)))
 (let (($x108 (or $x129 $x96)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x108)))))))))
(check-sat)
