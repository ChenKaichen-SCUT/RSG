; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x130 (<= p 1)))
 (let (($x58 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x130)))
 (let (($x129 (<= p 0)))
 (let (($x95 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (let (($x122 (or $x95 $x58)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x122)))))))))
(check-sat)
