; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x95 (<= p 1)))
 (let (($x53 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x95)))
 (let (($x54 (<= p 0)))
 (let (($x49 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x54)))
 (let (($x78 (or $x49 $x53)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x78)))))))))
(check-sat)
