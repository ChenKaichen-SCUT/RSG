; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x11 (>= x 0)))
 (let (($x10 (= p 0)))
 (let (($x34 (and $x10 $x11 (<= x 1))))
 (let (($x35 (or $x34 $x21)))
 (let (($x32 (or (and $x10 (= x 0)) (and $x16 (= x 4)))))
 (and $x32 (not $x35))))))))))
(check-sat)
