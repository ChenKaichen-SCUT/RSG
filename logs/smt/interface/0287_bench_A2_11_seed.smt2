; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x36 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x36)))
 (let (($x129 (<= p 1)))
 (let (($x135 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x129)))
 (let (($x109 (or $x135 $x52)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x109)))))))))
(check-sat)
