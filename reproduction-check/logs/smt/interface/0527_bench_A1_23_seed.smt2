; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x36 (<= p 1)))
 (let (($x40 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x36)))
 (let (($x104 (<= p 0)))
 (let (($x121 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x104)))
 (let (($x133 (or $x121 $x40)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x133)))))))))
(check-sat)
