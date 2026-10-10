; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x54 (<= p 1)))
 (let (($x78 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x54)))
 (let (($x106 (<= p 0)))
 (let (($x104 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x106)))
 (let (($x93 (or $x104 $x78)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x93)))))))))
(check-sat)
