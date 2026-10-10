; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x78 (<= p 0)))
 (let (($x116 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x78)))
 (let (($x131 (<= p 1)))
 (let (($x46 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x131)))
 (let (($x56 (or $x46 $x116)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x56)))))))))
(check-sat)
