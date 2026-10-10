; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x131 (<= p 1)))
 (let (($x46 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x131)))
 (let (($x65 (<= p 0)))
 (let (($x139 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x65)))
 (let (($x105 (or $x139 $x46)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x105)))))))))
(check-sat)
