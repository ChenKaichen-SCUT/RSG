; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x20 (<= x 4)))
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) $x20)))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x138 (and (and (<= (- x) (- 4)) (>= 4 x)) (<= (- p) (- 1)))))
 (let (($x70 (and (and (and (>= 0 x) (>= 0 (- p))) (>= 0 (- x))) (>= 0 p))))
 (let (($x43 (or $x70 (and $x138 (>= 1 p)))))
 (xor $x43 $x35)))))))))
(check-sat)
