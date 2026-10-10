; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let ((?x83 (- p x)))
 (let (($x145 (>= 0 ?x83)))
 (let (($x122 (and (and (and (< (- 1) p) (>= 1 p)) $x145) (< (- 4) ?x83))))
 (let (($x42 (or (and $x122 (>= 1 (+ p x))) (and (and $x122 (< 1 (+ p x))) (< 3 (+ p x))))))
 (xor $x42 $x35)))))))))
(check-sat)
