; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x71 (<= p 0)))
 (let (($x54 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x71)))
 (let (($x38 (<= p 1)))
 (let (($x83 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x38)))
 (let (($x52 (or $x83 $x54)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x52)))))))))
(check-sat)
