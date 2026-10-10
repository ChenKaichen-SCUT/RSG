; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x31 (and $x16 (= x 4))))
 (let (($x10 (= p 0)))
 (let (($x29 (and $x10 (= x 0))))
 (let (($x32 (or $x29 $x31)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and $x10 (>= x 0) (<= x 1)) $x21)))
 (and $x35 (not $x32))))))))))
(check-sat)
