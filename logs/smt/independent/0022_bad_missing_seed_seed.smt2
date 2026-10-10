; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x106 (and $x16 (= x 3))))
 (let (($x10 (= p 0)))
 (let (($x83 (and $x10 (= x 1))))
 (let (($x80 (or $x83 $x106)))
 (let (($x32 (or (and $x10 (= x 0)) (and $x16 (= x 4)))))
 (and $x32 (not $x80)))))))))
(check-sat)
