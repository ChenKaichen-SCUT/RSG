; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x78 (and (and (<= (- (+ p x)) (- 4)) (>= 1 p)) (>= 3 (- (- p x))))))
 (let (($x55 (and (and (>= 1 (+ p x)) (>= 0 (- p x))) (>= 0 (- p)))))
 (or $x55 $x78))))
(check-sat)
