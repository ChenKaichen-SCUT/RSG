; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let ((?x83 (- p x)))
 (let (($x145 (>= 0 ?x83)))
 (let (($x122 (and (and (and (< (- 1) p) (>= 1 p)) $x145) (< (- 4) ?x83))))
 (let (($x42 (or (and $x122 (>= 1 (+ p x))) (and (and $x122 (< 1 (+ p x))) (< 3 (+ p x))))))
 (and $x42 (not $x42)))))))
(check-sat)
