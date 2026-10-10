; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x138 (and (and (<= (- x) (- 4)) (>= 4 x)) (<= (- p) (- 1)))))
 (let (($x70 (and (and (and (>= 0 x) (>= 0 (- p))) (>= 0 (- x))) (>= 0 p))))
 (let (($x43 (or $x70 (and $x138 (>= 1 p)))))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x43)))))))
(check-sat)
