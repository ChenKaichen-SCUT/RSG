; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x10 (= p 0)))
 (let (($x121 (and $x10 (= x 2))))
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and $x10 (>= x 0) (<= x 1)) $x21)))
 (let (($x22 (or (and $x10 (>= x 0) (<= x 2)) $x21)))
 (let (($x65 (and $x22 (not $x35))))
 (xor $x65 $x121)))))))))
(check-sat)
