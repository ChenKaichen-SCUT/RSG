; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x116 (<= p 1)))
 (let (($x55 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x116)))
 (let (($x143 (<= p 0)))
 (let (($x129 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x143)))
 (let (($x65 (or $x129 $x55)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x65)))))))))
(check-sat)
