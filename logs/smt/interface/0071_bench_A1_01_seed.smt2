; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x51 (<= p 1)))
 (let (($x95 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x51)))
 (let (($x50 (<= p 0)))
 (let (($x96 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x50)))
 (let (($x92 (or $x96 $x95)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x92)))))))))
(check-sat)
