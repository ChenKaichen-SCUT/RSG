; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x130 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x130)))
 (let (($x45 (<= p 1)))
 (let (($x90 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x45)))
 (let (($x116 (or $x90 $x52)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x116)))))))))
(check-sat)
