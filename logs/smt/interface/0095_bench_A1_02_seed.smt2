; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x41 (<= p 1)))
 (let (($x152 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x41)))
 (let (($x142 (<= p 0)))
 (let (($x51 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x142)))
 (let (($x82 (or $x51 $x152)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x82)))))))))
(check-sat)
