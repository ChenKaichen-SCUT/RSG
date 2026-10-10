; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x78 (and (and (<= (- (+ p x)) (- 4)) (>= 1 p)) (>= 3 (- (- p x))))))
 (let (($x55 (and (and (>= 1 (+ p x)) (>= 0 (- p x))) (>= 0 (- p)))))
 (let (($x103 (or $x55 $x78)))
 (let ((?x83 (- p x)))
 (let (($x145 (>= 0 ?x83)))
 (let (($x122 (and (and (and (< (- 1) p) (>= 1 p)) $x145) (< (- 4) ?x83))))
 (let (($x42 (or (and $x122 (>= 1 (+ p x))) (and (and $x122 (< 1 (+ p x))) (< 3 (+ p x))))))
 (and $x42 (not $x103))))))))))
(check-sat)
