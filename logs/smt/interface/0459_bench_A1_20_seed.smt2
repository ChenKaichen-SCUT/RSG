; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x62 (<= p 1)))
 (let (($x37 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x62)))
 (let (($x69 (<= p 0)))
 (let (($x101 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x69)))
 (let (($x73 (or $x101 $x37)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x73)))))))))
(check-sat)
