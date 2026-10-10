; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x142 (<= p 0)))
 (let (($x51 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x142)))
 (let (($x41 (<= p 1)))
 (let (($x145 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x41)))
 (let (($x52 (or $x145 $x51)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x52)))))))))
(check-sat)
