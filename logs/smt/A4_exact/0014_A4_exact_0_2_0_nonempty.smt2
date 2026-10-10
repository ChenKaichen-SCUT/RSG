; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x31 (and $x16 (= x 4))))
 (let (($x13 (<= x 2)))
 (let (($x36 (<= p 0)))
 (let (($x106 (and $x36 (<= (- p) 0) $x13 (<= (- x) 0))))
 (or $x106 $x31)))))))
(check-sat)
