; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x38 (<= p 1)))
 (let (($x56 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x38)))
 (let (($x71 (<= p 0)))
 (let (($x54 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x71)))
 (let (($x118 (or $x54 $x56)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x118)))))))))
(check-sat)
