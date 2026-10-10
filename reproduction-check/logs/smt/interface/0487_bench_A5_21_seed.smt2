; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x85 (<= p 1)))
 (let (($x131 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x85)))
 (let (($x76 (<= p 0)))
 (let (($x69 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x76)))
 (let (($x111 (or $x69 $x131)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x111)))))))))
(check-sat)
