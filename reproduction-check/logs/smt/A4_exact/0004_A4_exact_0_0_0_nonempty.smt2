; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x31 (and $x16 (= x 4))))
 (let (($x40 (<= x 0)))
 (let (($x36 (<= p 0)))
 (let (($x46 (and $x36 (<= (- p) 0) $x40 (<= (- x) 0))))
 (or $x46 $x31)))))))
(check-sat)
