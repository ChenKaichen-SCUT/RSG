; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x45 (<= p 1)))
 (let (($x132 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x45)))
 (let (($x57 (<= p 0)))
 (let (($x93 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x57)))
 (let (($x75 (or $x93 $x132)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x75)))))))))
(check-sat)
