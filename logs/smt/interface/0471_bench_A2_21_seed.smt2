; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x69 (<= p 0)))
 (let (($x101 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x69)))
 (let (($x62 (<= p 1)))
 (let (($x110 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x62)))
 (let (($x59 (or $x110 $x101)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x59)))))))))
(check-sat)
