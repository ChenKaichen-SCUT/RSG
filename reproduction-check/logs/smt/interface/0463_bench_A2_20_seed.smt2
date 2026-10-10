; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x69 (<= p 0)))
 (let (($x101 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x69)))
 (let (($x62 (<= p 1)))
 (let (($x142 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x62)))
 (let (($x41 (or $x142 $x101)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x41)))))))))
(check-sat)
