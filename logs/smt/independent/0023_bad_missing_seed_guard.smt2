; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x11 (>= x 0)))
 (let (($x10 (= p 0)))
 (let (($x14 (and $x10 $x11 (<= x 2))))
 (let (($x22 (or $x14 $x21)))
 (let (($x80 (or (and $x10 (= x 1)) (and $x16 (= x 3)))))
 (and $x80 (not $x22))))))))))
(check-sat)
