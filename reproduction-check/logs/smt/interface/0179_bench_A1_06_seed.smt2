; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x105 (<= p 1)))
 (let (($x80 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x105)))
 (let (($x72 (<= p 0)))
 (let (($x130 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x72)))
 (let (($x93 (or $x130 $x80)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x93)))))))))
(check-sat)
