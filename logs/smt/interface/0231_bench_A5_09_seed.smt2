; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x136 (<= p 1)))
 (let (($x126 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x136)))
 (let (($x129 (<= p 0)))
 (let (($x65 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (let (($x135 (or $x65 $x126)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x135)))))))))
(check-sat)
