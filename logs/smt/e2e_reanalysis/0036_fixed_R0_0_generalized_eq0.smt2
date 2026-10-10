; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (let (($x138 (and (and (<= (- x) (- 4)) (>= 4 x)) (<= (- p) (- 1)))))
 (let (($x70 (and (and (and (>= 0 x) (>= 0 (- p))) (>= 0 (- x))) (>= 0 p))))
 (let (($x43 (or $x70 (and $x138 (>= 1 p)))))
 (xor $x43 $x32))))))
(check-sat)
