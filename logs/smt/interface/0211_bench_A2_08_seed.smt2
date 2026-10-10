; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x119 (<= p 0)))
 (let (($x93 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x119)))
 (let (($x127 (<= p 1)))
 (let (($x85 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x127)))
 (let (($x49 (or $x85 $x93)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x49)))))))))
(check-sat)
