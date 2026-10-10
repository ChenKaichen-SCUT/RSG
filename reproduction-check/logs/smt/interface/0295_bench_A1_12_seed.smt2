; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x129 (<= p 1)))
 (let (($x47 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x129)))
 (let (($x36 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x36)))
 (let (($x100 (or $x52 $x47)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x100)))))))))
(check-sat)
